---
title: Lab life
eyebrow: Lab life
lede: Conferences, trips and moments from around the Swarm Lab.
permalink: /lab_pictures/
---

<ul class="album-grid">
{%- comment -%} Albums = _lab_pictures/*.md plus a generated page for every other photo folder (_plugins/lab_pictures.rb) {%- endcomment -%}
{%- assign auto_albums = site.pages | where: "auto_album", true %}
{%- assign albums = site.lab_pictures | concat: auto_albums %}
{%- for album in albums %}
  {%- assign photos = site.data.lab_photos[album.folder] %}
  {%- if photos %}{% assign count = photos.size %}{% else %}{% assign count = album.content | split: "<img" | size | minus: 1 %}{% endif %}
  <li class="album-card">
    <a class="album-card__link" href="{{ site.baseurl }}{{ album.url | remove: "index.html" }}">
      <span class="album-card__media">
        <img src="{{ site.baseurl }}/{{ album.avatar_src }}" width="800" height="600" loading="lazy" decoding="async" alt="">
      </span>
      <span class="album-card__body">
        <span class="album-card__name">{{ album.title | default: album.name }}</span>
        <span class="album-card__meta">{% if album.location %}{{ album.location }} <span aria-hidden="true">&middot;</span> {% endif %}{{ count }} photo{% if count != 1 %}s{% endif %}</span>
      </span>
    </a>
  </li>
{%- endfor %}
</ul>

<p class="album-note">Looking for the people in these photos? Meet them on the <a href="/people/">People page</a>.</p>
