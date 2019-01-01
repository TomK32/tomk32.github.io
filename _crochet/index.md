---
title: 'Thomas häkelt'
index: true
---
<section id="posts">
  <h2>Häkel Projekte und Vorlagen</h2>
  <ul>
    {% for post in site.crochet %}
    {% unless post.index %}
      <li class="post">
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
        <small class="meta">{{ post.date | date_to_long_string }}</small>
      </li>
    {% endunless %}
    {% endfor %}
  </ul>
</section>
