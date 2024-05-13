{# Only remove this if you want to take away the theme onboarding advices #}

{% if not params.preview %}
	{% if is_theme_draft %}
		{% set admin_link = '/admin/themes/settings/draft/' %}
	{% else %}
		{% set admin_link = '/admin/themes/settings/active/' %}
	{% endif %}
{% endif %}

{# Slider that work as example #}

<section class="js-home-slider-container section-slider">
	<div class="js-home-empty-slider nube-slider-home swiper-container" style="visibility:hidden; height:0;">
		<div class="swiper-wrapper">
			<div class="swiper-slide slide-container">
				<div class="slider-slide slider-slide-empty"></div>
			</div>
			<div class="swiper-slide slide-container">
				<div class="slider-slide slider-slide-empty"></div>
			</div>
			<div class="swiper-slide slide-container">
				<div class="slider-slide slider-slide-empty"></div>
			</div>
		</div>
		<div class="placeholder-overlay placeholder-slider transition-soft">
            <div class="placeholder-info">
                {% include "snipplets/svg/edit.tpl" with {svg_custom_class: "icon-inline icon-3x"} %}
                <div class="placeholder-description font-small-xs">
                    {{ "Podés subir imágenes principales desde" | translate }} <strong>"{{ "Carrusel de imágenes" | translate }}"</strong>
                </div>
                {% if not params.preview %}
                    <a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-secondary btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
                {% endif %}
            </div>
        </div>
		<div class="js-swiper-empty-home-prev swiper-button-prev d-none d-md-block svg-circle svg-circle-big svg-icon-text{% if settings.icons_solid %} svg-solid{% endif %}">{% include "snipplets/svg/chevron-left.tpl" with {svg_custom_class: "icon-inline icon-2x mr-1"} %}</div>
	    <div class="js-swiper-empty-home-next swiper-button-next d-none d-md-block svg-circle svg-circle-big svg-icon-text{% if settings.icons_solid %} svg-solid{% endif %}">{% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: "icon-inline icon-2x ml-1"} %}</div>
	</div>
	{% snipplet 'placeholders/home-slider-placeholder.tpl' %}
</section>

{# Informative banners that work as examples #}

<section class="section-informative-banners">
	<div class="container">
		<div class="row">
			<div class="js-informative-banners swiper-container">
				<div class="swiper-wrapper">
					{% include 'snipplets/defaults/help_banner_services_item.tpl' with {'help_item_1': true} %}
					{% include 'snipplets/defaults/help_banner_services_item.tpl' with {'help_item_2': true} %}
					{% include 'snipplets/defaults/help_banner_services_item.tpl' with {'help_item_3': true} %}
					{% include 'snipplets/defaults/help_banner_services_item.tpl' with {'help_item_4': true} %}
				</div>
				<div class="js-informative-banners-pagination service-pagination swiper-pagination swiper-pagination-black"></div>
			</div>
		</div>
	</div>
</section>

{# Categories banners that work as examples #}

<section class="section-banners-home">
    <div class="container">
        <div class="row">
            <div class="col-md">
                <div class="textbanner{% if settings.theme_rounded %} box-rounded{% endif %}">
                    <div class="textbanner-image overlay textbanner-image-empty">
                    </div>
                    <div class="textbanner-text{% if settings.theme_rounded %} textbanner-text-primary{% endif %}">
                        <div class="h2">{{ "Categoría" | translate }}</div>
                    </div>
                    <div class="placeholder-overlay transition-soft">
			            <div class="placeholder-info">
			                {% include "snipplets/svg/edit.tpl" with {svg_custom_class: "icon-inline icon-3x"} %}
			                <div class="placeholder-description font-small-xs">
			                    {{ "Podés destacar categorías de tu tienda desde" | translate }} <strong>"{{ "Banners de categorías" | translate }}"</strong>
			                </div>
			                {% if not params.preview %}
			                    <a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-secondary btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
			                {% endif %}
			            </div>
			        </div>
                </div>
            </div>
            <div class="col-md">
                <div class="textbanner{% if settings.theme_rounded %} box-rounded{% endif %}">
                    <div class="textbanner-image overlay textbanner-image-empty">
                    </div>
                    <div class="textbanner-text{% if settings.theme_rounded %} textbanner-text-primary{% endif %}">
                        <div class="h2">{{ "Categoría" | translate }}</div>
                    </div>
                    <div class="placeholder-overlay transition-soft">
			            <div class="placeholder-info">
			                {% include "snipplets/svg/edit.tpl" with {svg_custom_class: "icon-inline icon-3x"} %}
			                <div class="placeholder-description font-small-xs">
			                    {{ "Podés destacar categorías de tu tienda desde" | translate }} <strong>"{{ "Banners de categorías" | translate }}"</strong>
			                </div>
			                {% if not params.preview %}
			                    <a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-secondary btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
			                {% endif %}
			            </div>
			        </div>
                </div>
            </div>
            <div class="col-md">
                <div class="textbanner{% if settings.theme_rounded %} box-rounded{% endif %}">
                    <div class="textbanner-image overlay textbanner-image-empty">
                    </div>
                    <div class="textbanner-text{% if settings.theme_rounded %} textbanner-text-primary{% endif %}">
                        <div class="h2">{{ "Categoría" | translate }}</div>
                    </div>
                    <div class="placeholder-overlay transition-soft">
			            <div class="placeholder-info">
			                {% include "snipplets/svg/edit.tpl" with {svg_custom_class: "icon-inline icon-3x"} %}
			                <div class="placeholder-description font-small-xs">
			                    {{ "Podés destacar categorías de tu tienda desde" | translate }} <strong>"{{ "Banners de categorías" | translate }}"</strong>
			                </div>
			                {% if not params.preview %}
			                    <a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-secondary btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
			                {% endif %}
			            </div>
			        </div>
                </div>
            </div>
        </div>
    </div>
</section>

{# Products featured that work as examples #}

<section class="section-featured-home">
	<div class="container">
		<div class="row">
		    <div class="col-12 text-center">
		    	<h3 class="h1">{{ "Destacados" | translate }}</h3>
		    </div>
		    <div class="col-12 p-0">
				<div class="js-swiper-featured-demo swiper-container swiper-products p-md-1">
	                <div class="swiper-wrapper">
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_1': true}  %}
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_2': true}  %}
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_3': true}  %}
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_4': true}  %}
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_5': true}  %}
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_6': true}  %}
	                </div>
	            </div>
		    </div>
		</div>
	</div>
	<div class="js-swiper-featured-demo-prev swiper-button-prev d-none d-md-block svg-circle svg-circle-big svg-icon-text{% if settings.icons_solid %} svg-solid{% endif %}">{% include "snipplets/svg/chevron-left.tpl" with {svg_custom_class: "icon-inline icon-2x mr-1"} %}</div>
    <div class="js-swiper-featured-demo-next swiper-button-next d-none d-md-block svg-circle svg-circle-big svg-icon-text{% if settings.icons_solid %} svg-solid{% endif %}">{% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: "icon-inline icon-2x ml-1"} %}</div>
</section>

{# Slider brands that work as examples #}

<section class="section-brands-home">
	<div class="container">
		<div class="row">
			<div class="col p-0 px-md-3">
				<div class="js-swiper-brands swiper-container">
				    <div class="swiper-wrapper">
		                <div class="swiper-slide slide-container">
	                		{% include "snipplets/svg/help/help-logo.tpl" with {svg_custom_class: "icon-inline icon-4x brand-image svg-icon-text"} %}
		            	</div>
		            	<div class="swiper-slide slide-container">
	                		{% include "snipplets/svg/help/help-logo.tpl" with {svg_custom_class: "icon-inline icon-4x brand-image svg-icon-text"} %}
		            	</div>
		            	<div class="swiper-slide slide-container">
	                		{% include "snipplets/svg/help/help-logo.tpl" with {svg_custom_class: "icon-inline icon-4x brand-image svg-icon-text"} %}
		            	</div>
		            	<div class="swiper-slide slide-container">
	                		{% include "snipplets/svg/help/help-logo.tpl" with {svg_custom_class: "icon-inline icon-4x brand-image svg-icon-text"} %}
		            	</div>
		            	<div class="swiper-slide slide-container">
	                		{% include "snipplets/svg/help/help-logo.tpl" with {svg_custom_class: "icon-inline icon-4x brand-image svg-icon-text"} %}
		            	</div>
		            	<div class="swiper-slide slide-container">
	                		{% include "snipplets/svg/help/help-logo.tpl" with {svg_custom_class: "icon-inline icon-4x brand-image svg-icon-text"} %}
		            	</div>
		            	<div class="swiper-slide slide-container">
	                		{% include "snipplets/svg/help/help-logo.tpl" with {svg_custom_class: "icon-inline icon-4x brand-image svg-icon-text"} %}
		            	</div>
				    </div>
				</div>
			</div>
		</div>
	</div>
	<div class="placeholder-overlay placeholder-slider transition-soft">
        <div class="placeholder-info">
            {% include "snipplets/svg/edit.tpl" with {svg_custom_class: "icon-inline icon-3x"} %}
            <div class="placeholder-description font-small-xs">
                {{ "Podés subir logos para el" | translate }} </br><strong>"{{ "Carrusel de marcas" | translate }}"</strong>
            </div>
            {% if not params.preview %}
                <a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-secondary btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
            {% endif %}
        </div>
    </div>
	<div class="js-swiper-brands-prev swiper-button-prev d-none d-md-block svg-circle svg-circle-big svg-icon-text{% if settings.icons_solid %} svg-solid{% endif %}">{% include "snipplets/svg/chevron-left.tpl" with {svg_custom_class: "icon-inline icon-2x mr-1"} %}</div>
    <div class="js-swiper-brands-next swiper-button-next d-none d-md-block svg-circle svg-circle-big svg-icon-text{% if settings.icons_solid %} svg-solid{% endif %}">{% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: "icon-inline icon-2x ml-1"} %}</div>
</section>

{# Products featured that work as examples #}

<section class="section-featured-home">
	<div class="container">
		<div class="row">
		    <div class="col-12 text-center">
		    	<h3 class="h1">{{ "Novedades" | translate }}</h3>
		    </div>
		    <div class="col-12 p-0">
	            <div class="js-swiper-featured-demo swiper-container swiper-products p-md-1">
	                <div class="swiper-wrapper">
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_6': true}  %}
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_7': true}  %}
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_8': true}  %}
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_6': true}  %}
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_4': true}  %}
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_5': true}  %}
	                </div>
	            </div>
	        </div>
		</div>
	</div>
	<div class="js-swiper-featured-demo-prev swiper-button-prev d-none d-md-block svg-circle svg-circle-big svg-icon-text{% if settings.icons_solid %} svg-solid{% endif %}">{% include "snipplets/svg/chevron-left.tpl" with {svg_custom_class: "icon-inline icon-2x mr-1"} %}</div>
    <div class="js-swiper-featured-demo-next swiper-button-next d-none d-md-block svg-circle svg-circle-big svg-icon-text{% if settings.icons_solid %} svg-solid{% endif %}">{% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: "icon-inline icon-2x ml-1"} %}</div>
</section>

{# Promotional banners that work as examples #}

<section class="section-banners-home">
    <div class="container">
        <div class="row">
            <div class="col-md">
                <div class="textbanner{% if settings.theme_rounded %} box-rounded{% endif %}">
                    <div class="textbanner-image overlay textbanner-image-empty">
                    </div>
                    <div class="textbanner-text over-image">
                        <div class="h2">{{ "Promoción" | translate }}</div>
                        <div class="btn btn-secondary btn-small invert mt-3">{{ "Link" | translate }}</div>
                    </div>
                    <div class="placeholder-overlay transition-soft">
			            <div class="placeholder-info">
			                {% include "snipplets/svg/edit.tpl" with {svg_custom_class: "icon-inline icon-3x"} %}
			                <div class="placeholder-description font-small-xs">
			                    {{ "Podés mostrar tus promociones desde" | translate }} <strong>"{{ "Banners promocionales" | translate }}"</strong>
			                </div>
			                {% if not params.preview %}
			                    <a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-secondary btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
			                {% endif %}
			            </div>
			        </div>
                </div>
            </div>
            <div class="col-md">
                <div class="textbanner{% if settings.theme_rounded %} box-rounded{% endif %}">
                    <div class="textbanner-image overlay textbanner-image-empty">
                    </div>
                    <div class="textbanner-text over-image">
                        <div class="h2">{{ "Promoción" | translate }}</div>
                        <div class="btn btn-secondary btn-small invert mt-3">{{ "Link" | translate }}</div>
                    </div>
                    <div class="placeholder-overlay transition-soft">
			            <div class="placeholder-info">
			                {% include "snipplets/svg/edit.tpl" with {svg_custom_class: "icon-inline icon-3x"} %}
			                <div class="placeholder-description font-small-xs">
			                    {{ "Podés mostrar tus promociones desde" | translate }} <strong>"{{ "Banners promocionales" | translate }}"</strong>
			                </div>
			                {% if not params.preview %}
			                    <a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-secondary btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
			                {% endif %}
			            </div>
			        </div>
                </div>
            </div>
            <div class="col-md">
                <div class="textbanner{% if settings.theme_rounded %} box-rounded{% endif %}">
                    <div class="textbanner-image overlay textbanner-image-empty">
                    </div>
                    <div class="textbanner-text over-image">
                        <div class="h2">{{ "Promoción" | translate }}</div>
                        <div class="btn btn-secondary btn-small invert mt-3">{{ "Link" | translate }}</div>
                    </div>
                    <div class="placeholder-overlay transition-soft">
			            <div class="placeholder-info">
			                {% include "snipplets/svg/edit.tpl" with {svg_custom_class: "icon-inline icon-3x"} %}
			                <div class="placeholder-description font-small-xs">
			                    {{ "Podés mostrar tus promociones desde" | translate }} <strong>"{{ "Banners promocionales" | translate }}"</strong>
			                </div>
			                {% if not params.preview %}
			                    <a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-secondary btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
			                {% endif %}
			            </div>
			        </div>
                </div>
            </div>
        </div>
    </div>
</section>

{# Products featured that work as examples #}

<section class="section-featured-home">
	<div class="container">
		<div class="row">
	        <div class="col-12 text-center">
		    	<h3 class="h1">{{ "Ofertas" | translate }}</h3>
		    </div>
		    <div class="col-12 p-0">
	            <div class="js-swiper-featured-demo swiper-container swiper-products p-md-1">
	                <div class="swiper-wrapper">
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_3': true}  %}
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_4': true}  %}
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_5': true}  %}
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_6': true}  %}
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_7': true}  %}
	                	{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_8': true}  %}
	                </div>
	            </div>
	        </div>
		</div>
	</div>
	<div class="js-swiper-featured-demo-prev swiper-button-prev d-none d-md-block svg-circle svg-circle-big svg-icon-text{% if settings.icons_solid %} svg-solid{% endif %}">{% include "snipplets/svg/chevron-left.tpl" with {svg_custom_class: "icon-inline icon-2x mr-1"} %}</div>
    <div class="js-swiper-featured-demo-next swiper-button-next d-none d-md-block svg-circle svg-circle-big svg-icon-text{% if settings.icons_solid %} svg-solid{% endif %}">{% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: "icon-inline icon-2x ml-1"} %}</div>
</section>

{# Instagram feed that work as examples #}

<section class="section-instafeed-home">
	<div class="container">
		<div class="row">
			<div class="col-12 text-center">
				<div class="instafeed-title">
					{% include "snipplets/svg/instagram.tpl" with {svg_custom_class: "icon-inline icon-3x svg-icon-text"} %}
					<h3 class="h1 instafeed-user">{{ 'Instagram' | translate }}</h3>
				</div>
			</div>
		</div>
	</div>
	<div id="instafeed" class="row no-gutters position-relative">
		{% include 'snipplets/defaults/help_instagram.tpl' with {'help_item_1': true} %}
		{% include 'snipplets/defaults/help_instagram.tpl' with {'help_item_2': true} %}
		{% include 'snipplets/defaults/help_instagram.tpl' with {'help_item_1': true} %}
		{% include 'snipplets/defaults/help_instagram.tpl' with {'help_item_2': true} %}
		{% include 'snipplets/defaults/help_instagram.tpl' with {'help_item_1': true} %}
		{% include 'snipplets/defaults/help_instagram.tpl' with {'help_item_2': true} %}
		<div class="placeholder-overlay transition-soft">
            <div class="placeholder-info">
                {% include "snipplets/svg/edit.tpl" with {svg_custom_class: "icon-inline icon-3x"} %}
                <div class="placeholder-description font-small-xs">
                    {{ "Podés mostrar tus últimas novedades desde" | translate }} <strong>"{{ "Publicaciones de Instagram" | translate }}"</strong>
                </div>
                {% if not params.preview %}
                    <a href="{{ admin_link }}#instatheme=redes-sociales" class="btn-secondary btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
                {% endif %}
            </div>
        </div>
	</div>
</section>

{# Video that work as examples #}

<section class="section-video-home">
	<div class="container-fluid p-0">
		<div class="row no-gutters">
			<div class="col-12 text-center">
				<h2 class="h1">{{ "Video" | translate }}</h2>
				<div class="js-video-home embed-responsive embed-responsive-16by9">
					<div class="js-play-button video-player">
						<div class="video-player-icon">{% include "snipplets/svg/play.tpl" with {svg_custom_class: "icon-inline icon-lg ml-2 svg-icon-invert"} %}</div>
					</div>
					{% include "snipplets/svg/help/help-video.tpl" %}
					<div class="placeholder-overlay transition-soft">
	                <div class="placeholder-info">
		                    {% include "snipplets/svg/edit.tpl" with {svg_custom_class: "icon-inline icon-3x"} %}
		                    <div class="placeholder-description font-small-xs">
		                        {{ "Podés subir tu video de YouTube o Vimeo desde" | translate }} <strong>"{{ "Video" | translate }}"</strong>
		                    </div>
		                    {% if not params.preview %}
		                        <a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-secondary btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
		                    {% endif %}
		                </div>
		            </div>
				</div>
			</div>
		</div>
	</div>
</section>
