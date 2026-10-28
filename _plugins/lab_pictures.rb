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
          { 'file' => file, 'stem' => stem, 'src' => src,
            'web' => File.exist?(File.join(site.source, webp)) ? webp : src }
        end
        photos[folder] = list unless list.empty?
      end
      site.data['lab_photos'] = photos

      albums = site.collections['lab_pictures']&.docs || []
      covered = []
      albums.each do |doc|
        folder = doc.data['folder'] || doc.data['avatar'].to_s.split('/').first
        doc.data['folder'] = folder
        covered << folder
        doc.data['avatar_src'] = cover(site, folder, doc.data['avatar'], photos)
      end

      (photos.keys - covered).each do |folder|
        page = PageWithoutAFile.new(site, site.source, "lab_pictures/#{folder}", 'index.html')
        page.content = ''
        page.data.merge!('layout' => 'albums', 'title' => folder.tr('_-', '  ').split.map(&:capitalize).join(' '), 'folder' => folder,
                         'auto_album' => true, 'avatar_src' => cover(site, folder, nil, photos))
        site.pages << page
      end
    end

    private

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
