---
title: People
permalink: /people/
---

{% assign people_sorted = site.people | sort: 'title' %}
{% assign role_array = "pi|postdoc|gradstudent|undergrad|researchstaff|visiting|others|alumni" | split: "|" %}

{% for role in role_array %}

{% assign people_in_role = people_sorted | where: 'position', role %}

<!-- Skip section if there's nobody -->
{% if people_in_role.size == 0 %}
  {% continue %}
{% endif %}

<div class="pos_header">
{% if role == 'postdoc' %}
<h3>Postdoctoral Fellows</h3>
 {% elsif role == 'pi' %}
<h3>Principal Investigator</h3>
 {% elsif role == 'gradstudent' %}
<h3>Graduate Students</h3>
{% elsif role == 'undergrad' %}
<h3>Undergraduate Students</h3>
 {% elsif role == 'others' %}
 {% elsif role == 'researchstaff' %}
<h3>Research Staff</h3>
 {% elsif role == 'visiting' %}
<h3>Visiting Scholars</h3>
 {% elsif role == 'others' %}
<h3>Honorary Members</h3>
 {% elsif role == 'alumni' %}
<h3>Alumni</h3>
{% endif %}
</div>

{% if role != 'alumni' %}
<div class="content list people">
  {% for profile in people_sorted %}
    {% if profile.position contains role %}
      <div class="list-item-people">
        <p class="list-post-title">
          {% if profile.avatar %}
            <a href="{{ site.baseurl }}{{ profile.url }}"><img class="profile-thumbnail" src="{{site.baseurl}}/images/people/{{profile.avatar}}"></a>
          {% else %}
            <a href="{{ site.baseurl }}{{ profile.url }}"><img class="profile-thumbnail" src="http://evansheline.com/wp-content/uploads/2011/02/facebook-Storm-Trooper.jpg"></a>
          {% endif %}
          <a class="name" text-align=center href="{{ site.baseurl }}{{ profile.url }}">{{ profile.name }}</a>
        </p>
      </div>
    {% endif %}
  {% endfor %}
</div>
<hr>

{% else %}

<br>

| Name | Time at SwarmLab | Where they went |
| :------------- |:-------------| :-----------|
|Sharachchandra Bhat| 2021-2023 | Tesla|
|Pranav Kasibhatla| 2023-2024 |Columbia University|
|Sundar Sripada V. S.| 2022-2023 | UT Austin|
{% endif %}
{% endfor %}
