---
title: Lab Pictures
permalink: /lab_pictures/
---

{% assign photos = site.lab_pictures %}

<div class="content list labpictures">
  {% for i in photos %}
      <div class="list-item-people">
        <p class="list-post-title">
          {% if profile.avatar %}
            <a href="{{ site.baseurl }}{{ profile.url }}"><img class="profile-thumbnail" src="{{site.baseurl}}/images/lab_pictures/{{profile.avatar}}"></a>
          {% else %}
            <a href="{{ site.baseurl }}{{ profile.url }}"><img class="profile-thumbnail" src="http://evansheline.com/wp-content/uploads/2011/02/facebook-Storm-Trooper.jpg"></a>
          {% endif %}
        </p>
      </div>
  {% endfor %}
</div>
<hr>

<br>

