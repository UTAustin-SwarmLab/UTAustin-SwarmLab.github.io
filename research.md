---
title: Research themes
permalink: /research/
eyebrow: Research
lede: We build learning, reasoning, and verification for fleets of robots and AI agents, in five themes. Each paper is listed under its primary theme; the same papers can be filtered by secondary theme on the publications page.
---
{%- comment -%}
  Data: _data/themes.yml (order, text, representative keys) + `themes` field in the bib (first slug = primary).
  Lab era = year >= 2021, "Before Swarm Lab" = year < 2021, `other` = Earlier & other work.
  Entry markup comes from _layouts/bib.html; the compact "representative" cards use an inline template (-T).
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
      <svg class="theme-section__art" viewBox="0 0 240 160" aria-hidden="true" focusable="false">
        {%- case t.slug %}
        {%- when 'swarm' %}
        <g stroke="currentColor" stroke-width="1" opacity=".35"><path d="M30 120 70 60M70 60 130 80M70 60 110 20M130 80 110 20M130 80 170 130M30 120 130 80M170 130 215 70M130 80 215 70M110 20 190 35M190 35 215 70"/></g>
        <g fill="currentColor" opacity=".55"><circle cx="30" cy="120" r="4"/><circle cx="130" cy="80" r="4"/><circle cx="170" cy="130" r="4"/><circle cx="215" cy="70" r="4"/><circle cx="110" cy="20" r="4"/><circle cx="190" cy="35" r="4"/></g>
        <circle cx="70" cy="60" r="7" fill="var(--accent)"/><circle cx="70" cy="60" r="14" fill="none" stroke="var(--accent)" opacity=".3"/>
        {%- when 'edge' %}
        <g fill="none" stroke="currentColor" stroke-width="1" opacity=".4"><path d="M120 30V70M120 70 60 110M120 70 180 110M120 70V120M60 110 30 140M60 110 90 140M180 110 150 140M180 110 210 140"/></g>
        <g fill="currentColor" opacity=".55"><circle cx="60" cy="110" r="4"/><circle cx="180" cy="110" r="4"/><circle cx="120" cy="120" r="4"/><circle cx="30" cy="140" r="3"/><circle cx="90" cy="140" r="3"/><circle cx="150" cy="140" r="3"/><circle cx="210" cy="140" r="3"/></g>
        <rect x="96" y="14" width="48" height="26" rx="13" fill="none" stroke="var(--accent)" stroke-width="1.5"/><circle cx="120" cy="70" r="7" fill="var(--accent)"/>
        {%- when 'neurosymbolic' %}
        <g fill="none" stroke="currentColor" stroke-width="1" opacity=".4"><rect x="20" y="95" width="50" height="38" rx="4"/><rect x="82" y="95" width="50" height="38" rx="4"/><rect x="144" y="95" width="50" height="38" rx="4"/><path d="M45 95V70M107 95V70M169 95V70M45 70H169M107 70V40"/></g>
        <g fill="currentColor" opacity=".55"><circle cx="45" cy="70" r="3.5"/><circle cx="107" cy="70" r="3.5"/><circle cx="169" cy="70" r="3.5"/></g>
        <circle cx="107" cy="34" r="7" fill="var(--accent)"/><circle cx="107" cy="34" r="14" fill="none" stroke="var(--accent)" opacity=".3"/>
        {%- when 'trust' %}
        <path d="M120 16 188 40V82C188 114 158 138 120 148 82 138 52 114 52 82V40Z" fill="none" stroke="currentColor" stroke-width="1.2" opacity=".4"/>
        <path d="M120 36 170 54V82C170 104 148 122 120 130 92 122 70 104 70 82V54Z" fill="none" stroke="currentColor" stroke-width="1" opacity=".25"/>
        <path d="M98 82 114 98 145 64" fill="none" stroke="var(--accent)" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round"/>
        {%- when 'timeseries' %}
        <g stroke="currentColor" stroke-width="1" opacity=".3"><path d="M20 130H220M20 130V20"/></g>
        <path d="M20 100C40 100 45 60 65 60S85 108 105 108 125 48 145 48 165 92 185 92 205 70 220 70" fill="none" stroke="currentColor" stroke-width="1.4" opacity=".5"/>
        <path d="M145 48C165 48 165 92 185 92S205 70 220 70" fill="none" stroke="var(--accent)" stroke-width="2.4" stroke-dasharray="1 5" stroke-linecap="round"/>
        <circle cx="145" cy="48" r="5" fill="var(--accent)"/>
        {%- endcase %}
      </svg>

      <header class="theme-section__head">
        <p class="eyebrow">Theme 0{{ forloop.index }}</p>
        <h2 class="theme-section__title" id="{{ t.slug }}-title">{{ t.name }}</h2>
        <p class="theme-section__headline">{{ t.headline }}</p>
        <p class="theme-section__blurb">{{ t.blurb }}</p>
      </header>

      {%- if t.representative %}
      <h3 class="theme-section__label">Representative papers</h3>
      <div class="reps">
        {%- for k in t.representative %}
        {% bibliography --group_by none -T <a class="rep" href="{{ entry.url | default: entry.arxiv | default: entry.pdf | default: entry.project }}"><span class="rep__meta"><span class="rep__venue">{{ entry.venue_short }}</span><span class="rep__award">{{ entry.award }}</span></span><span class="rep__title">{{ entry.title }}</span></a> --query @*[key={{ k }}] %}
        {%- endfor %}
      </div>
      {%- endif %}

      <h3 class="theme-section__label">All papers since 2021 <span class="theme-section__count">{{ n }} {% if n == 1 %}paper{% else %}papers{% endif %}</span></h3>
      {% bibliography --group_by none --max 6 --query @*[themes^={{ t.slug }}, year>=2021] %}
      {%- if n > 6 %}
      {%- assign rest = n | minus: 6 %}
      <details class="more">
        <summary class="more__summary"><span class="more__closed">Show {{ rest }} more</span><span class="more__open">Show fewer</span></summary>
        {% bibliography --group_by none --offset 6 --query @*[themes^={{ t.slug }}, year>=2021] %}
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
