# frozen_string_literal: true

# bib_news.rb: builds site.data['news_all'], one date-sorted news list made of
#   (1) the manual items in _data/news.yml and
#   (2) every BibTeX entry in the scholar bibliography that has a `news = {YYYY-MM-DD}` field.
#
# BibTeX fields read (all optional):
#   news       = {2026-10-04}   date of the news item; an entry without it produces nothing
#   news_text  = {...}          HTML sentence; overrides the generated one
#   venue_short, journal, booktitle   used in the generated sentence
#   website, project, url, pdf        first non-empty one is the link target (in that order)
#
# Item schema (string keys, so Liquid can read them):
#   'date'     Date
#   'details'  HTML string
#   'type'     'paper' for bib items, otherwise the news.yml value (default 'news')
#   'key'      BibTeX key (bib items; or the news.yml `key:` when present)
#   'featured' true (only when set in news.yml)
#
# Ordering: newest first. Equal dates keep source order: news.yml items first (file order),
# then bib items (bib file order).
# Dedup: a news.yml item with `key: <bibkey>` is dropped when that bib entry has a valid `news`
# field (the bib-generated item wins). A news.yml item without `key`, or whose key has no
# bib `news`, is always kept. site.data['news'] is never modified.
#
# It also exposes site.data['lab_authors'] (lowercase "<first initial> <last word>" of every _people
# entry, e.g. "s chinchali") so that _layouts/bib.html can bold lab members.

require 'date'
require 'cgi'
require 'bibtex'
require 'jekyll'

module Jekyll
  module BibNews
    LINK_FIELDS = %i[website project url pdf].freeze

    module_function

    # Plain text of a BibTeX value: LaTeX braces and escapes removed, whitespace collapsed.
    def clean(value)
      value.to_s.gsub(/\\([&%_#$])/, '\1').delete('{}').gsub(/\s+/, ' ').strip
    end

    def field(entry, name)
      return nil unless entry.field?(name)

      v = clean(entry[name])
      v.empty? ? nil : v
    end

    def parse_date(str)
      return nil unless str.to_s.match?(/\A\d{4}-\d{2}-\d{2}\z/)

      Date.strptime(str.to_s, '%Y-%m-%d')
    rescue ArgumentError
      nil
    end

    def generated_details(entry)
      title = CGI.escapeHTML(field(entry, :title) || entry.key)
      url = LINK_FIELDS.map { |f| field(entry, f) }.compact.first
      title_html = url ? %(<a href="#{CGI.escapeHTML(url)}">#{title}</a>) : title
      venue = field(entry, :venue_short) || field(entry, :journal) || field(entry, :booktitle)
      venue ? "New paper #{title_html} accepted to #{CGI.escapeHTML(venue)}!" : "New paper #{title_html}!"
    end

    # Items for the bib entries that carry a valid `news` date, in bib order.
    def bib_items(bib_path, logger = Jekyll.logger)
      return [] unless bib_path && File.file?(bib_path)

      items = []
      BibTeX.parse(File.read(bib_path)).each do |entry|
        next unless entry.respond_to?(:field?) && entry.field?(:news)

        raw = clean(entry[:news])
        date = parse_date(raw)
        if date.nil?
          logger.warn 'bib_news:', "#{entry.key}: invalid news date #{raw.inspect} (want YYYY-MM-DD), skipped"
          next
        end
        text = entry.field?(:news_text) ? entry[:news_text].to_s.gsub(/\s+/, ' ').strip : ''
        items << { 'date' => date,
                   'details' => text.empty? ? generated_details(entry) : text,
                   'type' => 'paper', 'key' => entry.key.to_s }
      end
      items
    end

    def news_date(item, logger)
      d = item['date']
      return d if d.is_a?(Date)

      Date.parse(d.to_s)
    rescue ArgumentError
      logger.warn 'bib_news:', "news.yml item has an unreadable date #{d.inspect}; sorted last"
      Date.new(0)
    end

    # Merge news.yml items (array of hashes, may be nil) with bib items; see the header for the rules.
    def merge(news_yml, bib_items, logger = Jekyll.logger)
      bib_keys = bib_items.map { |i| i['key'] }
      manual = Array(news_yml).map do |item|
        i = item.dup
        i['type'] ||= 'news'
        i
      end
      manual.reject! { |i| i['key'] && bib_keys.include?(i['key'].to_s) }
      manual.each { |i| i['date'] = news_date(i, logger) }
      (manual + bib_items).each_with_index.sort_by { |item, idx| [-item['date'].jd, idx] }.map(&:first)
    end

    # Lowercase "first last" for every person in the people collection.
    def lab_authors(site)
      coll = site.collections['people']
      return [] unless coll

      coll.docs.map do |doc|
        parts = doc.data['name'].to_s.downcase.split
        parts.empty? ? nil : "#{parts.first[0]} #{parts.last.delete('.')}"
      end.compact.uniq
    end

    class Generator < Jekyll::Generator
      safe true
      priority :low

      def generate(site)
        scholar = site.config['scholar'] || {}
        bib = File.join(site.source, scholar['source'] || '_bibliography', scholar['bibliography'] || 'references.bib')
        items = BibNews.bib_items(bib)
        site.data['news_all'] = BibNews.merge(site.data['news'], items)
        site.data['lab_authors'] = BibNews.lab_authors(site)
      end
    end
  end
end
