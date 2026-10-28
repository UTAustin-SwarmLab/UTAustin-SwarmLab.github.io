---
title: Lab life
eyebrow: Lab life
lede: Conferences, trips and moments from around the Swarm Lab.
permalink: /lab_pictures/
---

<ul class="album-grid">
{%- for album in site.lab_pictures %}
  {%- assign stem = album.avatar | split: "." | first %}
  {%- assign count = album.content | split: "<img" | size | minus: 1 %}
  <li class="album-card">
    <a class="album-card__link" href="{{ site.baseurl }}{{ album.url }}">
      <span class="album-card__media">
        <img src="{{ site.baseurl }}/images/lab_pictures/web/{{ stem }}.webp" width="800" height="600" loading="lazy" decoding="async" alt="">
      </span>
      <span class="album-card__body">
        <span class="album-card__name">{{ album.name }}</span>
        <span class="album-card__meta">{{ album.location }} <span aria-hidden="true">&middot;</span> {{ count }} photo{% if count != 1 %}s{% endif %}</span>
      </span>
    </a>
  </li>
{%- endfor %}
</ul>

<p class="album-note">Looking for the people in these photos? Meet them on the <a href="/people/">People page</a>.</p>
