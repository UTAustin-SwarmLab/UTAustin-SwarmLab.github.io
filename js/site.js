/* Swarm Lab site enhancements. Everything here is optional: the site works without JS. */
(function () {
  'use strict';
  var doc = document;
  var reduced = window.matchMedia('(prefers-reduced-motion: reduce)');

  /* Header hairline appears after the page scrolls. */
  var header = doc.getElementById('site-header');
  if (header) {
    var onScroll = function () { header.classList.toggle('is-scrolled', window.scrollY > 4); };
    onScroll();
    window.addEventListener('scroll', onScroll, { passive: true });
  }

  /* Close the mobile menu after following an in-page link or pressing Escape (popover handles Escape natively). */
  var nav = doc.getElementById('site-nav');
  if (nav && nav.hidePopover) {
    nav.addEventListener('click', function (e) {
      if (e.target.closest('a') && nav.matches(':popover-open')) nav.hidePopover();
    });
  }

  /* [data-reveal]: one-time fade/translate. Elements are only hidden after the first scroll, and only
     if they are still below the fold, so screenshots, print and no-JS never see missing content. */
  var items = [].slice.call(doc.querySelectorAll('[data-reveal]'));
  if (items.length && 'IntersectionObserver' in window) {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (en) {
        if (en.isIntersecting) { en.target.classList.remove('is-hidden'); io.unobserve(en.target); }
      });
    }, { rootMargin: '0px 0px -6% 0px' });
    var arm = function () {
      if (reduced.matches) return;
      items.forEach(function (el) {
        if (el.getBoundingClientRect().top > window.innerHeight * 0.94) { el.classList.add('is-hidden'); io.observe(el); }
      });
    };
    ['scroll', 'wheel', 'touchmove', 'keydown'].forEach(function (t) {
      window.addEventListener(t, arm, { once: true, passive: true });
    });
  }

  /* Lab-life ticker: play/pause control (WCAG 2.2.2). CSS also pauses on hover and focus. */
  doc.querySelectorAll('[data-ticker-toggle]').forEach(function (btn) {
    var ticker = doc.getElementById(btn.getAttribute('aria-controls'));
    if (!ticker) return;
    btn.addEventListener('click', function () {
      var paused = ticker.classList.toggle('is-paused');
      btn.setAttribute('aria-pressed', paused ? 'true' : 'false');
      btn.querySelector('.label').textContent = paused ? 'Play' : 'Pause';
    });
  });
})();
