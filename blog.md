---
title: blog
permalink: /blog/
---

<head>
  <!-- MathJax configuration -->
  <script type="text/x-mathjax-config">
    MathJax.Hub.Config({
    TeX: {
      equationNumbers: {
        autoNumber: "AMS"
      }
    },
      tex2jax: {
        inlineMath: [['$','$'], ['\\(','\\)']],
        processEscapes: true,
      }
    });
  </script>
  <!-- Load MathJax -->
  <script type="text/javascript" async 
          src="https://cdn.jsdelivr.net/npm/mathjax@2.7.5/MathJax.js?config=TeX-MML-AM_CHTML">
  </script>
</head>

# **Blog Posts**

<div class="content list">
  {% for post in site.posts %}
    {% if post.categories contains 'blog' %}
    <div class="list-item">
      <p class="list-post-title">
        <a href="{{ post.url | prepend: site.baseurl }}">
            <div class="row">
                <!-- <div class="col-sm-4">
                    <img src="/{% if post.header-img %}{{ post.header-img }}{% else %}{{ site.header-img }}{% endif %}">
                </div> -->
                <div class="col-md-12">
                    <h3 class="post-title">
                        {{ post.title }}
                    </h3>
                    <p class="list-post-title">
                      Posted on {{ post.date | date: "%B %-d, %Y" }}
                    </p>
                    <p class="list-detail" >
                      {{ post.content | strip_html | truncatewords:30 }}
                    </p>
                </div>
            </div>
            <hr/>
        </a>
      </p>
    </div>
    {% endif %}
  {% endfor %}
</div>
