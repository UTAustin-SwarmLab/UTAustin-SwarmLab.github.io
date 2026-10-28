---
layout: page
title: News
eyebrow: Lab news
lede: Papers, awards and milestones from the lab, newest first.
permalink: /news/
---
{%- assign news_items = site.data.news_all | default: site.data.news -%}
{%- assign news_groups = news_items | group_by_exp: 'item', "item.date | date: '%Y'" -%}
{%- assign type_order = 'award,paper,people,defense,talk,media' | split: ',' -%}

<div class="news-filter" id="news-filter" role="group" aria-label="Filter news by type" hidden>
  <button type="button" class="chip" data-type="all" aria-pressed="true">All <span class="news-filter__count">{{ news_items | size }}</span></button>
  {%- for t in type_order %}
  {%- assign n = news_items | where: 'type', t | size -%}
  {%- if n > 0 %}
  <button type="button" class="chip" data-type="{{ t }}" aria-pressed="false">{{ t | capitalize }} <span class="news-filter__count">{{ n }}</span></button>
  {%- endif -%}
  {%- endfor %}
</div>

{%- for group in news_groups %}
<section class="news-year" aria-labelledby="y{{ group.name }}">
  <h2 class="news-year__title" id="y{{ group.name }}">{{ group.name }} <span class="news-year__count">{{ group.items | size }}</span></h2>
  {% include news_list.html items=group.items %}
</section>
{%- endfor %}

<p class="news-empty" id="news-empty" hidden>No news of this type yet.</p>

<script>
(function () {
  var bar = document.getElementById('news-filter');
  if (!bar) return;
  var chips = bar.querySelectorAll('.chip');
  var items = document.querySelectorAll('.news-item');
  var years = document.querySelectorAll('.news-year');
  var empty = document.getElementById('news-empty');
  bar.hidden = false;
  function apply(type) {
    chips.forEach(function (c) { c.setAttribute('aria-pressed', String(c.dataset.type === type)); });
    items.forEach(function (li) { li.hidden = type !== 'all' && li.dataset.type !== type; });
    var any = false;
    years.forEach(function (y) {
      var shown = y.querySelectorAll('.news-item:not([hidden])').length;
      y.hidden = shown === 0;
      y.querySelector('.news-year__count').textContent = shown;
      if (shown) any = true;
    });
    empty.hidden = any;
    try { history.replaceState(null, '', type === 'all' ? location.pathname : '#' + type); } catch (e) {}
  }
  chips.forEach(function (c) { c.addEventListener('click', function () { apply(c.dataset.type); }); });
  var h = location.hash.slice(1);
  if (h && bar.querySelector('[data-type="' + h + '"]')) apply(h);
})();
</script>
