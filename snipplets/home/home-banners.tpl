<section class="section-banners-home" data-store="banner-home-categories">
    <div class="container{% if settings.banners_full %}-fluid{% endif %}">
        <div class="row">
            {% set num_banners = 0 %}
            {% for banner in ['banner_01', 'banner_02', 'banner_03'] %}
                {% set banner_show = attribute(settings,"#{banner}_show") %}
                {% set banner_title = attribute(settings,"#{banner}_title") %}
                {% set has_banner =  banner_show and (banner_title or banner_description or "#{banner}.jpg" | has_custom_image) %}
                {% if has_banner %}
                    {% set num_banners = num_banners + 1 %}
                {% endif %}
            {% endfor %}

            {% for banner in ['banner_01', 'banner_02', 'banner_03'] %}
                {% set banner_show = attribute(settings,"#{banner}_show") %}
                {% set banner_image = "#{banner}.jpg" | has_custom_image %}
                {% set banner_title = attribute(settings,"#{banner}_title") %}
                {% set banner_description = attribute(settings,"#{banner}_description") %}
                {% set banner_url = attribute(settings,"#{banner}_url") %}
                {% set has_banner =  banner_show and (banner_title or banner_description or banner_image) %}
                {% set has_banner_text =  banner_title or banner_description %}
                {% if has_banner %}
                    <div class="col-md-{% if num_banners == 1 %}6 offset-md-3{% elseif num_banners == 2 %}6{% elseif num_banners == 3 %}4{% endif %}">
                        <div class="textbanner{% if settings.theme_rounded %} box-rounded textbanner-shadow{% endif %}">
                            {% if banner_url %}
                                <a class="textbanner-link" href="{{ banner_url | setting_url }}"{% if banner_title %} title="{{ banner_title }}" aria-label="{{ banner_title }}"{% else %} title="{{ 'Banner de' | translate }} {{ store.name }}" aria-label="{{ 'Banner de' | translate }} {{ store.name }}"{% endif %}>
                            {% endif %}
                            {% if banner_image %}
                                <div class="textbanner-image{% if has_banner_text and textoverimage %} overlay{% endif %}">
                                    <img class="textbanner-image-background lazyautosizes lazyload blur-up-huge" src="{{ "#{banner}.jpg" | static_url | settings_image_url('tiny') }}" data-srcset="{{ "#{banner}.jpg" | static_url | settings_image_url('large') }} 480w, {{ "#{banner}.jpg" | static_url | settings_image_url('huge') }} 640w" data-sizes="auto" data-expand="-10" {% if banner_title %}alt="{{ banner_title }}"{% else %}alt="{{ 'Banner de' | translate }} {{ store.name }}"{% endif %} />
                                </div>
                            {% endif %}
                            {% if has_banner_text %}
                                <div class="textbanner-text{% if textoverimage %} over-image{% endif %}{% if settings.theme_rounded %} textbanner-text-primary{% endif %}">
                                    {% if banner_title %}
                                        <div class="h2">{{ banner_title }}</div>
                                    {% endif %}
                                    {% if banner_description %}
                                        <div class="textbanner-paragraph">{{ banner_description }}</div>
                                    {% endif %}
                                </div>
                            {% endif %}
                            {% if banner_url %}
                                </a>
                            {% endif %}
                        </div>
                    </div>
                {% endif %}
            {% endfor %}
            <div class="col-md-4">
                <div class="textbanner box-rounded textbanner-shadow">
                <a class="textbanner-link" href="" title="Banner de BEETHOVEN PET CARE VILLAVICENCIO " aria-label="Banner de BEETHOVEN PET CARE VILLAVICENCIO ">
                <div class="textbanner-image">
                <img class="textbanner-image-background lazyautosizes blur-up-huge lazyloaded" src="{{ 'images/ACCESORIO.png' | static_url }}">
                </div>
                </a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="textbanner box-rounded textbanner-shadow">
                <a class="textbanner-link" href="" title="Banner de BEETHOVEN PET CARE VILLAVICENCIO " aria-label="Banner de BEETHOVEN PET CARE VILLAVICENCIO ">
                <div class="textbanner-image">
                <img class="textbanner-image-background lazyautosizes blur-up-huge lazyloaded" src="{{ 'images/LIMPIEZA.png' | static_url }}">
                </div>
                </a>
                </div>
            </div>

            <div class="col-md-4">
            <div class="textbanner box-rounded textbanner-shadow">
            <a class="textbanner-link" href="" title="Banner de BEETHOVEN PET CARE VILLAVICENCIO " aria-label="Banner de BEETHOVEN PET CARE VILLAVICENCIO ">
            <div class="textbanner-image">
            <img class="textbanner-image-background lazyautosizes blur-up-huge lazyloaded" src="{{ 'images/limpi.png' | static_url }}">
            </div>
            </a>
            </div>
            </div>
        </div>
    </div>
</section>
