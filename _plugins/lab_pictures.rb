# frozen_string_literal: true

# lab_pictures.rb: the Lab life albums follow the image folders, so a new photo shows up without
# editing any HTML.
#
#   images/lab_pictures/<folder>/*.{jpg,jpeg,png,webp}   one folder = one album
#   The "web" folder (WebP copies from scripts/optimize_images.py) is skipped, and so are files whose
#   name ends in "-tn" (thumbnails).
#
# It sets:
#   site.data['lab_photos'][<folder>]  list of {'file', 'stem', 'src', 'web'} sorted by file name.
#     'src' is the original path; 'web' is images/lab_pictures/web/<folder>/<stem>.webp when that copy
#     exists, otherwise the original (so a photo shows even before its WebP copy is made).
#   album.data['folder']  for each _lab_pictures/*.md, from its `folder:` (or the folder of its avatar).
#   album.data['avatar_src']  web path of the album cover (the avatar, or the first photo).
#
# A folder without a _lab_pictures/*.md album gets a generated page at /lab_pictures/<folder>/
# (layout "albums", title = the folder name in words, data 'auto_album' = true). _layouts/albums.html lists, after an
# album's hand-written content, every photo of its folder that the content does not mention yet.
#
# Home photo strip: site.data['lab_ticker'] = every album photo that is not in the hand-written `ticker:`
# list of index.html (new uploads first, captioned "<album>, <city>"), followed by that list. Each item has
# 'src' (relative to images/lab_pictures/), 'w', 'h', 'alt', 'cap'. Image sizes are read from the files.

require 'jekyll'

module Jekyll
  class LabPicturesGenerator < Generator
    safe true
    priority :high

    ROOT = 'images/lab_pictures'
    EXTS = %w[.jpg .jpeg .png .webp].freeze

    def generate(site)
      photos = {}
      Dir.glob(File.join(site.source, ROOT, '*')).sort.each do |dir|
        next unless File.directory?(dir)

        folder = File.basename(dir)
        next if folder == 'web'

        list = Dir.children(dir).sort.filter_map do |file|
          ext = File.extname(file)
          stem = File.basename(file, ext)
          next unless EXTS.include?(ext.downcase) && !stem.end_with?('-tn')

          src = "#{ROOT}/#{folder}/#{file}"
          webp = "#{ROOT}/web/#{folder}/#{stem}.webp"
          web = File.exist?(File.join(site.source, webp)) ? webp : src
          w, h = image_size(File.join(site.source, web))
          { 'file' => file, 'stem' => stem, 'src' => src, 'web' => web, 'w' => w, 'h' => h }
        end
        photos[folder] = list unless list.empty?
      end
      site.data['lab_photos'] = photos

      albums = site.collections['lab_pictures']&.docs || []
      covered = []
      names = {}
      albums.each do |doc|
        folder = doc.data['folder'] || doc.data['avatar'].to_s.split('/').first
        doc.data['folder'] = folder
        covered << folder
        doc.data['avatar_src'] = cover(site, folder, doc.data['avatar'], photos)
        names[folder] = [doc.data['title'] || doc.data['name'], doc.data['location']]
      end

      (photos.keys - covered).each do |folder|
        page = PageWithoutAFile.new(site, site.source, "lab_pictures/#{folder}", 'index.html')
        page.content = ''
        page.data.merge!('layout' => 'albums', 'title' => folder.tr('_-', '  ').split.map(&:capitalize).join(' '), 'folder' => folder,
                         'auto_album' => true, 'avatar_src' => cover(site, folder, nil, photos))
        site.pages << page
        names[folder] = [page.data['title'], nil]
      end

      site.data['lab_ticker'] = ticker(site, photos, names)
    end

    private

    # The hand-written strip from index.html's front matter, preceded by every other album photo.
    def ticker(site, photos, names)
      home = site.pages.find { |pg| pg.url == '/' }
      curated = (home&.data&.fetch('ticker', nil) || []).map { |t| t.transform_keys(&:to_s) }
      listed = curated.map { |t| t['src'] }
      extra = photos.flat_map do |folder, list|
        album, location = names[folder]
        cap = [album, location.to_s.split(',').first].compact.reject(&:empty?).join(', ')
        list.filter_map do |ph|
          rel = ph['web'].delete_prefix("#{ROOT}/")
          next if listed.include?(rel) || ph['w'].nil?

          { 'src' => rel, 'w' => ph['w'], 'h' => ph['h'], 'alt' => "Photo from #{album}", 'cap' => cap }
        end
      end
      extra + curated
    end

    # [width, height] from a JPEG, PNG or WebP header, or nil.
    def image_size(path)
      File.open(path, 'rb') do |f|
        head = f.read(30).to_s
        if head.start_with?("\x89PNG".b)
          head[16, 8].unpack('NN')
        elsif head[0, 4] == 'RIFF' && head[8, 4] == 'WEBP'
          case head[12, 4]
          when 'VP8 ' then head[26, 4].unpack('vv').map { |v| v & 0x3fff }
          when 'VP8L'
            b = head[21, 4].unpack1('V')
            [(b & 0x3fff) + 1, ((b >> 14) & 0x3fff) + 1]
          when 'VP8X' then [head[24, 3], head[27, 3]].map { |v| "#{v}\0".unpack1('V') + 1 }
          end
        elsif head.start_with?("\xFF\xD8".b)
          jpeg_size(f)
        end
      end
    rescue StandardError
      nil
    end

    def jpeg_size(f)
      f.seek(2)
      while (b = f.read(1))
        next unless b.ord == 0xFF

        m = f.read(1)&.ord
        m = f.read(1)&.ord while m == 0xFF
        return nil unless m
        next if m == 0x01 || (0xD0..0xD8).cover?(m)

        len = f.read(2)&.unpack1('n') or return nil
        if (0xC0..0xCF).cover?(m) && ![0xC4, 0xC8, 0xCC].include?(m)
          f.read(1)
          h, w = f.read(4).unpack('nn')
          return [w, h]
        end
        f.seek(len - 2, IO::SEEK_CUR)
      end
      nil
    end

    # Web path of an album cover: the avatar's WebP copy if it exists, else the avatar, else the first photo.
    def cover(site, folder, avatar, photos)
      if avatar && !avatar.to_s.empty?
        stem = avatar.sub(/\.[^.]+\z/, '')
        webp = "#{ROOT}/web/#{stem}.webp"
        return File.exist?(File.join(site.source, webp)) ? webp : "#{ROOT}/#{avatar}"
      end
      photos[folder]&.first&.fetch('web')
    end
  end
end
