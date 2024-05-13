{% set has_main_slider = settings.slider and settings.slider is not empty %}
{% set has_mobile_slider = settings.toggle_slider_mobile and settings.slider_mobile and settings.slider_mobile is not empty %}

{% if not mobile %}
<div class="js-home-main-slider-container {% if not has_main_slider %}hidden{% endif %}">
{% endif %}
	<div class="{% if mobile %}js-home-mobile-slider{% else %}js-home-main-slider{% endif %}-visibility {% if has_main_slider and has_mobile_slider %}{% if mobile %}d-md-none{% else %}d-none d-md-block{% endif %}{% elseif not settings.toggle_slider_mobile and mobile %}hidden{% endif %} {% if not settings.slider_full %} mt-4{% endif %} mb-4">
		<div class="container{% if settings.slider_full %}-fluid{% endif %}">
			<div class="row">
				<div class="col section-slider{% if settings.slider_full %} p-0{% endif %}">
					<div class="js-home-slider{% if mobile %}-mobile{% endif %} nube-slider-home swiper-container{% if settings.theme_rounded and not settings.slider_full %} box-rounded{% endif %} swiper-container-horizontal">
						<div class="swiper-wrapper">
							{% if mobile %}
								{% set slider = settings.slider_mobile %}
							{% else %}
								{% set slider = settings.slider %}
							{% endif %}
							{% for slide in slider %}
								<div class="swiper-slide slide-container">
									{% if slide.link %}
										<a href="{{ slide.link | setting_url }}" aria-label="{{ 'Carrusel' | translate }} {{ loop.index }}">
									{% endif %}	
									{% set has_text =  slide.title or slide.description or slide.button %}
									<div class="slider-slide">

										{% set apply_lazy_load = not (loop.first and ((has_main_slider and not has_mobile_slider) or (has_mobile_slider and mobile))) %}

										{% if apply_lazy_load %}
											{% set slide_src = slide.image | static_url | settings_image_url('tiny') %}
										{% else %}
											{% set slide_src = slide.image | static_url | settings_image_url('large') %}
										{% endif %}

										<img 
											{% if slide.width and slide.height %} width="{{ slide.width }}" height="{{ slide.height }}" {% endif %}
											src="{{ slide_src }}"
											{% if apply_lazy_load %}data-sizes="auto" data-{% endif %}srcset="{{ slide.image | static_url | settings_image_url('original') }} 1024w, {{ slide.image | static_url | settings_image_url('1080p') }} 1920w"  
											class="slider-image {% if apply_lazy_load %}swiper-lazy blur-up-huge{% endif %}" alt="{{ 'Carrusel' | translate }} {{ loop.index }}"
										/>

										{% if has_text %}
											<div class="swiper-text swiper-{{ slide.color }}">	
												{% if slide.description %}
													<div class="swiper-description mb-3">{{ slide.description }}</div>
												{% endif %}
												{% if slide.title %}
													<div class="swiper-title">{{ slide.title }}</div>
												{% endif %}
												{% if slide.button and slide.link %}
													<div class="btn btn-primary btn-small swiper-btn mt-4 px-4">{{ slide.button }}</div>
												{% endif %}
											</div>
										{% endif %}
									</div>
									{% if slide.link %}
										</a>
									{% endif %}
								</div>
							{% endfor %}
						</div>
						<div class="js-swiper-home-control js-swiper-home-pagination{% if mobile %}-mobile{% endif %} swiper-pagination swiper-pagination-bullets d-block">
							{% if slider | length > 1 and not params.preview %}
								{% for slide in slider %}
									<span class="swiper-pagination-bullet"></span>
								{% endfor %}
							{% endif %}
						</div>
						<div class="js-swiper-home-control js-swiper-home-prev{% if mobile %}-mobile{% endif %} swiper-button-prev d-none d-md-block svg-circle svg-circle-big svg-icon-text{% if settings.icons_solid %} svg-solid{% endif %}">{% include "snipplets/svg/chevron-left.tpl" with {svg_custom_class: "icon-inline icon-2x mr-1"} %}</div>
						<div class="js-swiper-home-control js-swiper-home-next{% if mobile %}-mobile{% endif %} swiper-button-next d-none d-md-block svg-circle svg-circle-big svg-icon-text{% if settings.icons_solid %} svg-solid{% endif %}">{% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: "icon-inline icon-2x ml-1"} %}</div>
					</div>
				</div>
			</div>
		</div>
	</div>
{% if not mobile %}
</div>
{% endif %}