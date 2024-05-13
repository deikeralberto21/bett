{% if thumb %}
	{% set svg_size = 'icon-xs ml-1' %}
{% else %}
	{% set svg_size = 'icon-lg ml-2' %}
{% endif %}

{% if product_modal %}

	{# Product video modal wrapper #}

	<div id="product-video-modal" class="js-product-video-modal product-video" style="display: none;">
{% endif %}
		<div class="{% if not thumb %}js-video{% endif %} {% if product_video and not product_modal %}js-video-product{% endif %} embed-responsive embed-responsive-16by9 {% if settings.theme_rounded %} box-rounded{% endif %} visible-when-content-ready">
			{% if thumb %}
				<div class="video-player">
			{% else %}
				{% if product_modal_trigger %}

					{# Open modal in mobile with product video inside #}

					<a href="#product-video-modal" data-fancybox="product-gallery" class="js-play-button video-player d-block d-md-none">
						<div class="video-player-icon">{% include "snipplets/svg/play.tpl" with {svg_custom_class: "icon-inline icon-xs ml-1 svg-icon-invert " ~ svg_size ~ ""} %}</div>
					</a>
				{% endif %}
				<a href="#" class="js-play-button video-player {% if product_modal_trigger %}d-none d-md-block{% endif %}">
			{% endif %}
					<div class="video-player-icon {% if thumb %}video-player-icon-small{% endif %}">{% include "snipplets/svg/play.tpl" with {svg_custom_class: "icon-inline icon-xs ml-1 svg-icon-invert " ~ svg_size ~ ""} %}</div>
			{% if thumb %}
				</div>
			{% else %}
				</a>
			{% endif %}

			{# Video thumbnail #}
			
			<div class="js-video-image">
				<img src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="" class="lazyload video-image fade-in" alt="{{ 'Video de' | translate }} {% if template != 'product' %}{{ product.name }}{% else %}{{ store.name }}{% endif %}" style="display: none;">
				<div class="placeholder-fade">
				</div>
			</div>
		</div>

		{% if not thumb %}
			
			{# Empty iframe component: will be filled with JS on play button click #}

			{% if template == 'home' %}
				{% set video_url = settings.video_embed %}
			{% elseif template == 'product' and product.video_url %}
				{% set video_url = product.video_url %}
			{% endif %}

			<div class="js-video-iframe embed-responsive embed-responsive-16by9 {% if settings.theme_rounded %} box-rounded{% endif %}" style="display: none;" data-video-color="{{ settings.primary_color | trim('#') }}" data-video-url="{{ video_url }}">
			</div>
		{% endif %}
{% if product_modal %}
	</div>
{% endif %}