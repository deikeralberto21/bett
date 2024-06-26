<section class="section-banners-home">
    <div class="container{% if settings.banner_promotional_full %}-fluid{% endif %}">
        <div id="containerBannerV2" class="containerBannerV2">
            {% set num_banners = 0 %}
            {% set in = 1%}
            {% for banner in ['banner_promotional_01', 'banner_promotional_02'] %}
                {% set banner_show = attribute(settings,"#{banner}_show") %}
                {% set banner_title = attribute(settings,"#{banner}_title") %}
                {% set has_banner =  banner_show and (banner_title or "#{banner}.jpg" | has_custom_image) %}
                {% if has_banner %}
                    {% set num_banners = num_banners + 1 %}
                {% endif %}
            {% endfor %}
            {% for banner in ['banner_promotional_01', 'banner_promotional_02', 'banner_promotional_03'] %}
                {% set banner_show = attribute(settings,"#{banner}_show") %}
                {% set banner_image = "#{banner}.jpg" | has_custom_image %}
                {% set banner_title = attribute(settings,"#{banner}_title") %}
                {% set banner_button_text = attribute(settings,"#{banner}_button") %}
                {% set banner_url = attribute(settings,"#{banner}_url") %}
                {% set has_banner =  banner_show and (banner_title or banner_image) %}
                {% set has_banner_text =  banner_title or banner_button_text %}
                {% if has_banner %}
                    <div class="col-md-12">
                        <div class="textbanner{% if settings.theme_rounded %} box-rounded textbanner-shadow{% endif %}">
                            {% if banner_url %}
                                    {% if in == 1 %}
                                         <a class="textbanner-link" href="{{ banner_url | setting_url }}"{% if banner_title %} title="{{ banner_title }}" aria-label="{{ banner_title }}"{% else %} title="{{ 'Banner de' | translate }} {{ store.name }}" aria-label="{{ 'Banner de' | translate }} {{ store.name }}"{% endif %}>
                                    {% endif %}
                                    {% if in == 2 %}
                                         <a class="textbanner-link" href="https://linktr.ee/beeth0ven"{% if banner_title %} title="{{ banner_title }}" aria-label="{{ banner_title }}"{% else %} title="{{ 'Banner de' | translate }} {{ store.name }}" aria-label="{{ 'Banner de' | translate }} {{ store.name }}"{% endif %}>
                                    {% endif %}
                                    {% if in == 3 %}
                                         <a class="textbanner-link" href="https://beethovenvillavo.com/marcas1/"{% if banner_title %} title="{{ banner_title }}" aria-label="{{ banner_title }}"{% else %} title="{{ 'Banner de' | translate }} {{ store.name }}" aria-label="{{ 'Banner de' | translate }} {{ store.name }}"{% endif %}>
                                    {% endif %}
                                    {% if in == 4 %}
                                         <a class="textbanner-link" href="https://beethovenpetcare.site.agendapro.com/co/sucursal/140110"{% if banner_title %} title="{{ banner_title }}" aria-label="{{ banner_title }}"{% else %} title="{{ 'Banner de' | translate }} {{ store.name }}" aria-label="{{ 'Banner de' | translate }} {{ store.name }}"{% endif %}>
                                    {% endif %}

                            {% endif %}
                                <div class="textbanner-image{% if has_banner_text and textoverimage %} overlay{% endif %}">
                                    {% if banner_image %}
                                        <img class="textbanner-image-background lazyautosizes lazyload blur-up-huge" src="{{ "#{banner}.jpg" | static_url | settings_image_url('tiny') }}" data-srcset="{{ "#{banner}.jpg" | static_url | settings_image_url('large') }} 480w, {{ "#{banner}.jpg" | static_url | settings_image_url('huge') }} 640w" data-sizes="auto" data-expand="-10" {% if banner_title %}alt="{{ banner_title }}"{% else %}alt="{{ 'Banner de' | translate }} {{ store.name }}"{% endif %} />
                                    {% endif %}
                                    {% if has_banner_text %}
                                        <div class="textbanner-text{% if textoverimage %} over-image{% endif %}">
                                            {% if banner_title %}
                                                <div class="h2">{{ banner_title }}</div>
                                            {% endif %}
                                            {% if banner_url and banner_button_text %}
                                                <div class="btn btn-secondary btn-small invert mt-3">{{ banner_button_text }}</div>
                                            {% endif %}
                                        </div>
                                    {% endif %}
                                </div>
                            {% if banner_url %}
                                </a>
                            {% endif %}
                        </div>
                    </div>
                {% endif %}
                {% set in = in + 1 %}
            {% endfor %}
            <div class="col-md-12">
                <div class="textbanner box-rounded textbanner-shadow">
                <a class="textbanner-link" href="https://beethovenpetcare.site.agendapro.com/co/sucursal/140110" title="Banner de BEETHOVEN PET CARE VILLAVICENCIO " aria-label="Banner de BEETHOVEN PET CARE VILLAVICENCIO ">
                <div class="textbanner-image">
                <img src="{{ 'images/cita.png' | static_url }}" class="textbanner-image-background lazyautosizes blur-up-huge lazyloaded"/>
                </div>
                </a>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    var contenedor = document.querySelector('#containerBannerV2')
    if(window.innerWidth <=767){
        contenedor.classList.toggle('containerBannerMovil')
        contenedor.classList.toggle('containerBannerV2')
    }
    window.addEventListener('resize',()=>{
        if(window.innerWidth <=767){
            contenedor.classList.remove('containerBannerV2')
            contenedor.classList.add('containerBannerMovil')
        }else{
            contenedor.classList.remove('containerBannerMovil')
            contenedor.classList.add('containerBannerV2')

        }   
    })

</script>
