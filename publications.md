---
title: Publications
permalink: /publications/
eyebrow: Publications
lede: Papers from the Swarm Lab and from Sandeep's earlier work. Filter by research theme, or search titles, authors, and venues.
---
<div class="publications" id="publications">
  <p class="pubs-scholar">For metrics and citations, see Sandeep's <a href="https://scholar.google.com/citations?user=262ASa4AAAAJ&amp;hl=en">Google Scholar profile</a>.</p>

  <div class="pubs-filters" data-pubs-filters hidden>
    <label class="visually-hidden" for="pubs-search">Search publications</label>
    <input id="pubs-search" class="pubs-search" type="search" placeholder="Search title, author, venue" autocomplete="off">
    <div class="pubs-chips" role="group" aria-label="Filter by research theme">
      <button type="button" class="chip" data-theme="" aria-pressed="true">All</button>
      {%- for t in site.data.themes %}
      <button type="button" class="chip" data-theme="{{ t.slug }}" aria-pressed="false">{{ t.name }}</button>
      {%- endfor %}
      <button type="button" class="chip" data-theme="other" aria-pressed="false">Earlier &amp; other</button>
    </div>
    <p class="pubs-count" role="status" aria-live="polite"></p>
  </div>

  {% bibliography %}

  <p class="pubs-empty" hidden>No publications match. <button type="button" class="pubs-reset">Clear filters</button></p>
</div>

<script>
/* Progressive enhancement: without JS the filters stay hidden and every paper is listed. */
(function () {
  var root = document.getElementById('publications');
  var bar = root.querySelector('[data-pubs-filters]');
  var pubs = [].slice.call(root.querySelectorAll('.pub'));
  if (!bar || !pubs.length) return;
  var input = bar.querySelector('.pubs-search');
  var chips = [].slice.call(bar.querySelectorAll('.chip'));
  var count = bar.querySelector('.pubs-count');
  var empty = root.querySelector('.pubs-empty');
  var groups = [].slice.call(root.querySelectorAll('h3.bibliography')).map(function (h) {
    return { head: h, list: h.nextElementSibling, label: h.textContent.trim() };
  });
  var theme = '', query = '';
  bar.hidden = false;

  function apply() {
    var terms = query.toLowerCase().split(/\s+/).filter(Boolean), shown = 0;
    pubs.forEach(function (p) {
      var themes = ' ' + (p.dataset.themes || '') + ' ';
      var text = p.dataset.search || '';
      var ok = (!theme || themes.indexOf(' ' + theme + ' ') > -1) &&
               terms.every(function (t) { return text.indexOf(t) > -1; });
      p.closest('li').hidden = !ok;
      if (ok) shown++;
    });
    groups.forEach(function (g) {
      var n = g.list ? g.list.querySelectorAll('li:not([hidden])').length : 0;
      g.head.hidden = g.list.hidden = !n;
      g.head.textContent = g.label + ' (' + n + ')';
    });
    count.textContent = (theme || terms.length ? shown + ' of ' + pubs.length : pubs.length) + ' publications';
    empty.hidden = shown > 0;
    chips.forEach(function (c) { c.setAttribute('aria-pressed', String(c.dataset.theme === theme)); });
    var q = new URLSearchParams();
    if (theme) q.set('theme', theme);
    if (query) q.set('q', query);
    history.replaceState(null, '', location.pathname + (q.toString() ? '?' + q : '') + location.hash);
  }

  input.addEventListener('input', function () { query = input.value.trim(); apply(); });
  chips.forEach(function (c) { c.addEventListener('click', function () { theme = c.dataset.theme; apply(); }); });
  empty.querySelector('.pubs-reset').addEventListener('click', function () { theme = query = input.value = ''; apply(); });

  var params = new URLSearchParams(location.search);
  theme = params.get('theme') || '';
  query = input.value = params.get('q') || '';
  apply();
})();
</script>
