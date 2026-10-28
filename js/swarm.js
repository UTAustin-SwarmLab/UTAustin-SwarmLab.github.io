/* Hero swarm: boids with a few orange leaders and thin neighbor edges (echoes the lab logo's network graph).
   Paused offscreen / in background tabs / on request; a settled still frame under prefers-reduced-motion. */
(function () {
  'use strict';
  var box = document.querySelector('[data-swarm]');
  if (!box) return;
  var cv = box.querySelector('canvas'), ctx = cv && cv.getContext('2d');
  if (!ctx) return;
  var btn = box.querySelector('[data-swarm-toggle]');
  var mq = window.matchMedia('(prefers-reduced-motion: reduce)');
  var css = getComputedStyle(document.documentElement);
  var v = function (n, f) { return css.getPropertyValue(n).trim() || f; };
  var COL = { agent: v('--text-faint', '#a8a29e'), lead: v('--accent', '#bf5700'), edge: v('--signal', '#2fa55a') };
  var W = 0, H = 0, dpr = 1, A = [], nLead = 3, raf = 0, last = 0, T = 0, seen = true, userPaused = false, ptr = null;
  var R = 70, TAU = Math.PI * 2;

  function seed(n) {
    A = [];
    for (var i = 0; i < n; i++) {
      var a = Math.random() * TAU;
      A.push({ x: Math.random() * W, y: Math.random() * H, vx: Math.cos(a), vy: Math.sin(a), lead: i < nLead, ph: Math.random() * TAU, fa: 0.5 + Math.random() * 0.5 });
    }
  }

  function resize() {
    var r = box.getBoundingClientRect(), w = Math.round(r.width), h = Math.round(r.height);
    if (!w || !h || (w === W && h === H)) return;
    var sx = W ? w / W : 1, sy = H ? h / H : 1;
    W = w; H = h; dpr = Math.min(window.devicePixelRatio || 1, 2);
    cv.width = W * dpr; cv.height = H * dpr;
    var n = Math.max(48, Math.min(110, Math.round(W * H / 2800)));
    nLead = n < 70 ? 3 : n < 95 ? 4 : 5;
    if (!A.length) seed(n); else A.forEach(function (a) { a.x *= sx; a.y *= sy; });
    if (A.length !== n) seed(n);
    if (!running()) draw();
  }

  function step(dt) {
    T += dt * 0.0035;
    var i, j, a, b, dx, dy, d, n, sx, sy, vx, vy, cx, cy, sp, m = 36, k = 0.045 * dt;
    for (i = 0; i < A.length; i++) {
      a = A[i]; n = 0; sx = sy = vx = vy = cx = cy = 0;
      for (j = 0; j < A.length; j++) {
        if (i === j) continue;
        b = A[j]; dx = b.x - a.x; dy = b.y - a.y; d = dx * dx + dy * dy;
        if (d < R * R) {
          n++; vx += b.vx; vy += b.vy; cx += dx; cy += dy;
          if (d < 1156 && d > 0) { d = Math.sqrt(d); sx -= dx / d * (34 - d) / 34; sy -= dy / d * (34 - d) / 34; }
        }
      }
      if (a.lead) {
        var p = i * 1.7;
        dx = W * (0.5 + 0.36 * Math.sin(T * (0.8 + a.fa * 0.4) + p)) - a.x;
        dy = H * (0.5 + 0.34 * Math.sin(T * (0.6 + a.fa * 0.5) + p * 1.3 + a.ph)) - a.y;
        d = Math.hypot(dx, dy) || 1;
        a.vx += dx / d * k * 1.2; a.vy += dy / d * k * 1.2;
      } else {
        if (n) { a.vx += ((vx / n - a.vx) * 0.5 + cx / n * 0.006 + sx * 2.2) * k; a.vy += ((vy / n - a.vy) * 0.5 + cy / n * 0.006 + sy * 2.2) * k; }
        var best = 1e9, L = null;
        for (j = 0; j < nLead; j++) { dx = A[j].x - a.x; dy = A[j].y - a.y; d = dx * dx + dy * dy; if (d < best) { best = d; L = A[j]; } }
        if (L && best < 300 * 300) { d = Math.sqrt(best) || 1; a.vx += (L.x - a.x) / d * k * 0.3; a.vy += (L.y - a.y) / d * k * 0.3; }
        a.vx += (Math.random() - 0.5) * 0.07 * dt; a.vy += (Math.random() - 0.5) * 0.07 * dt;
      }
      if (ptr) {
        dx = ptr.x - a.x; dy = ptr.y - a.y; d = Math.hypot(dx, dy);
        if (d < 230 && d > 8) { a.vx += dx / d * k * 0.5; a.vy += dy / d * k * 0.5; }
      }
      if (a.x < m) a.vx += k * 2; else if (a.x > W - m) a.vx -= k * 2;
      if (a.y < m) a.vy += k * 2; else if (a.y > H - m) a.vy -= k * 2;
      sp = Math.hypot(a.vx, a.vy);
      var max = a.lead ? 1.25 : 1.05, min = 0.45;
      if (sp > max) { a.vx *= max / sp; a.vy *= max / sp; } else if (sp < min) { a.vx *= min / (sp || 1); a.vy *= min / (sp || 1); }
    }
    for (i = 0; i < A.length; i++) { A[i].x += A[i].vx * dt; A[i].y += A[i].vy * dt; }
  }

  function draw() {
    var i, j, a, b, d, al;
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    ctx.clearRect(0, 0, W, H);
    ctx.lineWidth = 1; ctx.strokeStyle = COL.edge;
    for (i = 0; i < A.length; i++) {
      a = A[i];
      for (j = i + 1; j < A.length; j++) {
        b = A[j]; d = Math.hypot(b.x - a.x, b.y - a.y);
        if (d < R * 0.9) {
          al = (1 - d / (R * 0.9)) * ((a.lead || b.lead) ? 0.7 : 0.45);
          ctx.globalAlpha = al; ctx.beginPath(); ctx.moveTo(a.x, a.y); ctx.lineTo(b.x, b.y); ctx.stroke();
        }
      }
    }
    ctx.globalAlpha = 1;
    for (i = A.length - 1; i >= 0; i--) {
      a = A[i];
      var s = a.lead ? 9 : 6, ang = Math.atan2(a.vy, a.vx), c = Math.cos(ang), n = Math.sin(ang);
      if (a.lead) {
        ctx.globalAlpha = 0.28; ctx.strokeStyle = COL.lead;
        ctx.beginPath(); ctx.arc(a.x, a.y, 15, 0, TAU); ctx.stroke(); ctx.globalAlpha = 1;
      }
      ctx.fillStyle = a.lead ? COL.lead : COL.agent;
      ctx.beginPath();
      ctx.moveTo(a.x + c * s, a.y + n * s);
      ctx.lineTo(a.x - c * s * 0.6 - n * s * 0.55, a.y - n * s * 0.6 + c * s * 0.55);
      ctx.lineTo(a.x - c * s * 0.6 + n * s * 0.55, a.y - n * s * 0.6 - c * s * 0.55);
      ctx.closePath(); ctx.fill();
    }
    ctx.strokeStyle = COL.edge;
    box.classList.add('is-live');
  }

  function running() { return !!raf; }
  function should() { return seen && !document.hidden && !userPaused && !mq.matches; }
  function loop(t) {
    raf = 0;
    if (!should()) { last = 0; return; }
    var dt = last ? Math.min((t - last) / 16.67, 2.5) : 1;
    last = t; step(dt); draw();
    raf = requestAnimationFrame(loop);
  }
  function sync() {
    if (should()) { if (!raf) raf = requestAnimationFrame(loop); }
    else { if (raf) cancelAnimationFrame(raf); raf = 0; last = 0; }
  }
  function settle() { for (var i = 0; i < 260; i++) step(1); draw(); }
  function applyMotionPref() {
    box.classList.toggle('is-static', mq.matches);
    if (mq.matches) { sync(); settle(); } else sync();
  }

  resize();
  if ('ResizeObserver' in window) new ResizeObserver(resize).observe(box);
  else window.addEventListener('resize', resize);
  if ('IntersectionObserver' in window) new IntersectionObserver(function (e) { seen = e[0].isIntersecting; sync(); }).observe(box);
  document.addEventListener('visibilitychange', sync);
  (mq.addEventListener ? mq.addEventListener.bind(mq, 'change') : mq.addListener.bind(mq))(applyMotionPref);
  window.addEventListener('pointermove', function (e) {
    if (e.pointerType === 'touch') return;
    var r = cv.getBoundingClientRect(), x = e.clientX - r.left, y = e.clientY - r.top;
    ptr = x > -80 && y > -80 && x < r.width + 80 && y < r.height + 80 ? { x: x, y: y } : null;
  }, { passive: true });
  if (btn) btn.addEventListener('click', function () {
    userPaused = !userPaused;
    btn.setAttribute('aria-pressed', userPaused ? 'true' : 'false');
    btn.querySelector('.label').textContent = userPaused ? 'Play' : 'Pause';
    sync();
  });
  for (var w = 0; w < 120; w++) step(1);  // start from an organized state, not uniform noise
  applyMotionPref();
})();
