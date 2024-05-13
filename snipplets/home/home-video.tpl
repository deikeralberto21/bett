{% if settings.video_embed %}
    <section class="section-video-home" data-store="video-home">
        <div class="container{% if settings.video_full %}-fluid p-0{% endif %}">
            <div class="row no-gutters">
                {% if settings.video_title or settings.video_text %}
                    <div class="col-md-8 offset-md-2 text-center">
                        {% if settings.video_title %}
                            <h2 class="h1{% if settings.theme_rounded %} text-primary{% endif %}">{{ settings.video_title }}</h2>
                        {% endif %}
                        {% if settings.video_text %}
                            <p class="mb-5">{{ settings.video_text }}</p>
                        {% endif %}
                    </div>
                {% endif %}
                <div class="col-12">
                    {% include 'snipplets/video-item.tpl' %}
                </div>
            </div>
        </div>
    </section>
{% endif %}