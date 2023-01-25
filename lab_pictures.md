---
title: Lab Pictures
permalink: /lab_pictures/
---

{% assign photos = site.lab_pictures %}

<div class="content list labpictures">
  {% for i in photos %}
      <div class="list-item-people">
        <p class="list-post-title">
          {% if i.avatar %}
            <a href="{{ site.baseurl }}{{ i.url }}"><img class="profile-thumbnail" src="{{site.baseurl}}/images/lab_pictures/{{i.avatar}}"></a>
          {% else %}
            <!-- <a href="{{ site.baseurl }}{{ profile.url }}"><img class="profile-thumbnail" src="{{site.baseurl}}/images/lab_pictures/lenna.jpeg"></a> -->
            <a href="{{ site.baseurl }}{{ profile.url }}"><img class="profile-thumbnail" src="http://evansheline.com/wp-content/uploads/2011/02/facebook-Storm-Trooper.jpg"></a>
          {% endif %}
        <a class="name" href="{{ site.baseurl }}{{ i.url }}">{{ i.name }}</a>
        </p>
      </div>
  {% endfor %}
</div>
<hr>

<br>

