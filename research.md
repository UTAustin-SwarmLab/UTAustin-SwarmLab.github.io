---
title: Research themes
permalink: /research/
eyebrow: Research
lede: "We build learning, reasoning, and verification for fleets of robots and AI agents, in five themes: swarm coordination and fleet learning, edge–cloud systems for embodied AI, neuro-symbolic video understanding, trustworthy and verifiable machine learning, and time-series generation and forecasting."
---
{%- comment -%}
  Data: _data/themes.yml (order, text, representative keys) + `themes` field in the bib (first slug = primary).
  Lab era = year >= 2021, "Before Swarm Lab" = year < 2021, `other` = Earlier & other work.
  Entry markup comes from _layouts/bib.html. `representative` keys must be lab-era papers whose primary theme is this theme.
{%- endcomment -%}
<div class="research">
  <nav class="research-index" aria-label="Research themes">
    <ol class="research-index__list">
      {%- for t in site.data.themes %}
      <li><a class="research-index__link" href="#{{ t.slug }}"><span class="research-index__num">0{{ forloop.index }}</span>{{ t.name }}</a></li>
      {%- endfor %}
      <li class="research-index__more"><a class="research-index__link" href="#before-swarm-lab">Before Swarm Lab</a></li>
      <li class="research-index__more"><a class="research-index__link" href="#other-work">Earlier &amp; other work</a></li>
    </ol>
  </nav>

  <div class="research__main">
    {%- for t in site.data.themes %}
    {%- capture n_lab %}{% bibliography_count --query @*[themes^={{ t.slug }}, year>=2021] %}{% endcapture %}
    {%- assign n = n_lab | plus: 0 %}
    <section class="theme-section theme-section--{{ t.slug }}" id="{{ t.slug }}" aria-labelledby="{{ t.slug }}-title">
      {% include theme_art.html slug=t.slug class="theme-section__art" %}

      <header class="theme-section__head">
        <p class="eyebrow">Theme 0{{ forloop.index }}</p>
        <h2 class="theme-section__title" id="{{ t.slug }}-title">{{ t.name }}</h2>
        <p class="theme-section__headline">{{ t.headline }}</p>
        <p class="theme-section__blurb">{{ t.blurb }}</p>
      </header>

      {%- comment -%} Selected = the theme's `representative` keys (most relevant, top venues); the rest of the lab-era papers are collapsed. {%- endcomment -%}
      {%- assign sel = "" %}{%- assign excl = "" %}
      {%- for k in t.representative %}
        {%- unless forloop.first %}{% assign sel = sel | append: " || " %}{% endunless %}
        {%- assign sel = sel | append: "key=" | append: k %}
        {%- assign excl = excl | append: ", key!=" | append: k %}
      {%- endfor %}
      <h3 class="theme-section__label">Selected papers <span class="theme-section__count">{{ n }} {% if n == 1 %}paper{% else %}papers{% endif %} since 2021</span></h3>
      {% bibliography --group_by none --query @*[{{ sel }}] %}
      {%- assign rest = n | minus: t.representative.size %}
      {%- if rest > 0 %}
      <details class="more">
        <summary class="more__summary"><span class="more__closed">Show {{ rest }} more</span><span class="more__open">Show fewer</span></summary>
        {% bibliography --group_by none --query @*[themes^={{ t.slug }}, year>=2021{{ excl }}] %}
      </details>
      {%- endif %}
    </section>
    {%- endfor %}

    <section class="theme-section theme-section--archive" id="before-swarm-lab" aria-labelledby="before-title">
      <header class="theme-section__head">
        <p class="eyebrow">Archive</p>
        <h2 class="theme-section__title" id="before-title">Before Swarm Lab</h2>
        <p class="theme-section__blurb">Sandeep's work before the lab began in 2021, grouped by the theme it fed into.</p>
      </header>
      {%- for t in site.data.themes %}
      {%- capture n_old %}{% bibliography_count --query @*[themes^={{ t.slug }}, year<2021] %}{% endcapture %}
      {%- assign m = n_old | plus: 0 %}
      {%- if m > 0 %}
      <details class="more more--archive">
        <summary class="more__summary"><span class="more__name">{{ t.name }}</span><span class="theme-section__count">{{ m }} {% if m == 1 %}paper{% else %}papers{% endif %}</span></summary>
        {% bibliography --group_by none --query @*[themes^={{ t.slug }}, year<2021] %}
      </details>
      {%- endif %}
      {%- endfor %}
    </section>

    <section class="theme-section theme-section--archive" id="other-work" aria-labelledby="other-title">
      <header class="theme-section__head">
        <p class="eyebrow">Archive</p>
        <h2 class="theme-section__title" id="other-title">Earlier &amp; other work</h2>
        <p class="theme-section__blurb">Papers that sit outside the five themes.</p>
      </header>
      {% bibliography --group_by none --query @*[themes^=other] %}
    </section>
  </div>
</div>

<script>
/* Progressive enhancement: highlight the index link of the section being read. */
(function () {
  if (!('IntersectionObserver' in window)) return;
  var links = [].slice.call(document.querySelectorAll('.research-index__link'));
  var map = {};
  links.forEach(function (a) { map[a.getAttribute('href').slice(1)] = a; });
  var first = links.length ? links[0].getAttribute('href').slice(1) : '';
  var io = new IntersectionObserver(function (entries) {
    entries.forEach(function (e) {
      /* scrolled back above the first section: nothing is current */
      if (!e.isIntersecting) { if (e.boundingClientRect.top > 0 && e.target.id === first) links.forEach(function (a) { a.removeAttribute('aria-current'); }); return; }
      links.forEach(function (a) { a.removeAttribute('aria-current'); });
      var a = map[e.target.id];
      if (a) {
        a.setAttribute('aria-current', 'true');
        var bar = a.closest('.research-index');
        if (bar && bar.scrollWidth > bar.clientWidth) bar.scrollTo({ left: a.offsetLeft - 16 });
      }
    });
  }, { rootMargin: '-25% 0px -65% 0px' });
  Object.keys(map).forEach(function (id) { var s = document.getElementById(id); if (s) io.observe(s); });
})();
</script>
