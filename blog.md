---
title: Blog
eyebrow: Blog
lede: Plain-language write-ups of our papers, by the students who wrote them.
permalink: /blog/
---

{%- assign blog_posts = site.posts | where_exp: "p", "p.categories contains 'blog'" -%}
{%- assign by_year = blog_posts | group_by_exp: "p", "p.date | date: '%Y'" -%}

<div class="post-timeline">
{%- for group in by_year %}
  <section class="post-year" aria-labelledby="year-{{ group.name }}">
    <h2 class="post-year__title" id="year-{{ group.name }}">{{ group.name }} <span class="post-year__count">{{ group.items | size }}</span></h2>
    <ol class="post-list">
    {%- for post in group.items %}
      <li class="post-item">
        <time class="post-item__date" datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%b %-d" }}</time>
        <div class="post-item__body">
          <h3 class="post-item__title"><a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a></h3>
          {%- if post.description != "" and post.description %}
          <p class="post-item__desc">{{ post.description }}</p>
          {%- endif %}
        </div>
      </li>
    {%- endfor %}
    </ol>
  </section>
{%- endfor %}
</div>
