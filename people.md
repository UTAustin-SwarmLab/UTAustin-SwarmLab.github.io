---
layout: page
eyebrow: The lab
title: People
lede: Students and researchers working on learning, reasoning, and verification for fleets of robots and AI agents.
permalink: /people/
---

{%- assign everyone = site.people | sort_natural: "name" -%}

{%- comment -%} Principal investigator {%- endcomment -%}
{%- assign pis = everyone | where: "position", "pi" -%}
{%- for pi in pis -%}
{%- assign pi_stem = pi.avatar | split: "." | first %}
<section class="people-section pi-card" aria-labelledby="pi-heading" data-reveal>
  <div class="pi-card__media">
    {%- if pi.avatar %}
    <img src="{{ site.baseurl }}/images/people/web/{{ pi_stem }}.webp" width="480" height="480" decoding="async" alt="Portrait of {{ pi.name }}">
    {%- endif %}
  </div>
  <div class="pi-card__body">
    <p class="eyebrow" id="pi-heading">Principal investigator</p>
    <h2 class="pi-card__name"><a href="{{ site.baseurl }}{{ pi.url | remove: "index.html" }}">{{ pi.name }}</a></h2>
    {%- if pi.role %}<p class="pi-card__role">{{ pi.role }}, UT Austin</p>{% endif %}
    {%- if pi.interests %}<p class="pi-card__interests">Research interests: {{ pi.interests }}.</p>{% endif %}
    <ul class="person__links">
      {%- if pi.scholar %}<li><a href="{{ pi.scholar }}" rel="noopener" aria-label="{{ pi.name }}: Google Scholar"><svg class="icon" aria-hidden="true"><use href="#i-scholar"/></svg></a></li>{% endif %}
      {%- if pi.website %}<li><a href="{{ pi.website }}" rel="noopener" aria-label="{{ pi.name }}: website"><svg class="icon" aria-hidden="true"><use href="#i-link"/></svg></a></li>{% endif %}
      {%- if pi.email %}<li><a href="mailto:{{ pi.email }}" aria-label="Email {{ pi.name }}"><svg class="icon" aria-hidden="true"><use href="#i-mail"/></svg></a></li>{% endif %}
    </ul>
    <p><a class="btn btn--secondary" href="{{ site.baseurl }}{{ pi.url | remove: "index.html" }}">Full profile <svg class="icon" aria-hidden="true"><use href="#i-arrow-right"/></svg></a></p>
  </div>
</section>
{%- endfor -%}

{%- comment -%} Current members; the first sections are filled by position and degree {%- endcomment -%}
{%- assign grads = everyone | where: "position", "gradstudent" -%}
{%- assign phds = grads | where: "degree", "phd" -%}
{%- assign other_grads = grads | where_exp: "p", "p.degree != 'phd'" -%}
{%- assign ugrads = everyone | where: "position", "undergrad" -%}
{%- assign students = other_grads | concat: ugrads -%}
{%- assign postdocs = everyone | where: "position", "postdoc" -%}
{%- assign staff = everyone | where: "position", "researchstaff" -%}
{%- assign visiting = everyone | where: "position", "visiting" -%}
{%- assign honorary = everyone | where: "position", "others" -%}

{%- capture sections -%}postdocs|Postdoctoral fellows;phds|PhD students;students|Students;staff|Research staff;visiting|Visiting scholars;honorary|Honorary members{%- endcapture -%}
{%- assign section_list = sections | split: ";" -%}
{%- for s in section_list -%}
  {%- assign key = s | split: "|" | first -%}
  {%- assign heading = s | split: "|" | last -%}
  {%- case key -%}
    {%- when "postdocs" -%}{%- assign group = postdocs -%}
    {%- when "phds" -%}{%- assign group = phds -%}
    {%- when "students" -%}{%- assign group = students -%}
    {%- when "staff" -%}{%- assign group = staff -%}
    {%- when "visiting" -%}{%- assign group = visiting -%}
    {%- when "honorary" -%}{%- assign group = honorary -%}
  {%- endcase -%}
  {%- if group.size > 0 %}
<section class="people-section" aria-labelledby="sec-{{ key }}" data-reveal>
  <div class="section-header">
    <p class="eyebrow">Current</p>
    <h2 id="sec-{{ key }}">{{ heading }}</h2>
  </div>
  <div class="people-grid">
    {%- for person in group %}
    {% include person_card.html p=person %}
    {%- endfor %}
  </div>
</section>
  {%- endif -%}
{%- endfor -%}

{%- comment -%} Alumni: newest first, then by name {%- endcomment -%}
{%- assign alumni = everyone | where: "position", "alumni" -%}
{%- if alumni.size > 0 %}
{%- assign end_years = alumni | map: "end_year" | uniq | sort | reverse %}
<section class="people-section" aria-labelledby="sec-alumni" data-reveal>
  <div class="section-header">
    <p class="eyebrow">Alumni</p>
    <h2 id="sec-alumni">Where they went next</h2>
  </div>
  <div class="alumni-grid">
    {%- for y in end_years %}
    {%- for a in alumni %}{% if a.end_year == y %}
    {% include person_card.html p=a variant="alumni" %}
    {%- endif %}{% endfor %}
    {%- endfor %}
    {%- for a in alumni %}{% unless a.end_year %}
    {% include person_card.html p=a variant="alumni" %}
    {%- endunless %}{% endfor %}
  </div>
</section>
{%- endif %}

<section class="people-section people-life" aria-labelledby="sec-life" data-reveal>
  <div class="people-life__text">
    <p class="eyebrow">Lab life</p>
    <h2 id="sec-life">Beyond the lab bench</h2>
    <p>Conferences, field days, and group outings with the Swarm Lab.</p>
    <p><a class="btn btn--secondary" href="{{ site.baseurl }}/lab_pictures/">See lab pictures <svg class="icon" aria-hidden="true"><use href="#i-arrow-right"/></svg></a></p>
  </div>
  <ul class="people-life__strip">
    <li><img src="{{ site.baseurl }}/images/lab_pictures/web/corl2022/DSC03166.webp" width="1600" height="1067" loading="lazy" decoding="async" alt="Swarm Lab members at CoRL 2022 in Devonport, New Zealand"></li>
    <li><img src="{{ site.baseurl }}/images/lab_pictures/web/rss2022/IMG_0828.webp" width="1049" height="787" loading="lazy" decoding="async" alt="Swarm Lab members in Times Square during RSS 2022"></li>
    <li><img src="{{ site.baseurl }}/images/lab_pictures/web/rss2022/IMG_0909.webp" width="1600" height="1200" loading="lazy" decoding="async" alt="Swarm Lab members at RSS 2022 with the New York skyline behind them"></li>
  </ul>
</section>
