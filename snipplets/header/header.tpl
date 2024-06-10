{# Site Overlay #}
<div class="js-overlay site-overlay" style="display: none;"></div>


{# Header #}

{% set show_transparent_head = template == 'home' and settings.head_transparent and settings.slider and not settings.slider is empty %}

<header class="js-head-main head-main head-{{ settings.head_background }} {% if settings.head_fix %}head-fix{% endif %} transition-soft" data-store="head">

    {# Topbar = Social + Advertising + Language #}

    {% set has_social_network = store.facebook or store.twitter or store.pinterest or store.instagram or store.tiktok or store.youtube %}
    {% set has_languages = languages | length > 1 %}
    {% set has_ad_bar = settings.ad_bar and settings.ad_text %}
    {% set show_topbar =  has_ad_bar or has_social_network or has_languages %}
    {% if show_topbar %}
        <section class="js-topbar section-topbar {% if not has_ad_bar %}d-none d-md-block{% endif %}">
            <div class="container-fluid">
                <div class="row">
                    <div class="col text-left d-none d-md-block">
                        {% include "snipplets/social/social-links.tpl" %}
                    </div>
                        {% snipplet "header/header-advertising.tpl" %}
                    <div class="col text-right d-none d-md-block">
                        {% include "snipplets/navigation/navigation-lang.tpl" %}
                    </div>
                </div>
            </div>
        </section>
    {% endif %}
	<div class="container-fluid {% if settings.head_utility == 'searchbox' %}pb-3 pb-md-0{% endif %}">
		<div class="{% if not settings.head_fix %}js-nav-logo-bar{% endif %} row no-gutters align-items-center">

            {# Menu icon for all mobile combinations except when categories are exposed and logo is centered #}
            {% if settings.head_utility == 'searchbox' or settings.head_utility == 'icons' or (settings.logo_position_mobile == 'left' and settings.head_utility == 'categories') %}
                <div class="col-auto {% if settings.logo_position_mobile == 'left' %}order-last ml-2{% else %}text-left{% endif %} d-block d-md-none">
                    <a href="#" class="js-modal-open utilities-link utilities-item" data-toggle="#nav-hamburger" aria-label="{{ 'Menú' | translate }}" data-component="menu-button">
                        {% include "snipplets/svg/bars.tpl" with {svg_custom_class: "icon-inline icon-2x"}%}
                    </a>
                    <a href="https://beethovenvillavo.com/" style="font-size:2em;">
                        <ion-icon name="home"></ion-icon>
                    </a>
                    {% if store.country == 'AR'%}
                        {# Notification icon for quick login on AR stores #}
                        <div class="js-quick-login-badge badge badge-overlap swing" style="display: none;"></div>
                    {% endif %}
                </div>
            {% endif %}

            {# Search icon ued for mobile when categories are exposed #}
            {% if settings.head_utility == 'categories' or (settings.head_utility == 'categories' and settings.logo_position_mobile == 'left') or settings.head_utility == 'icons' %}
                <div class="col-auto {% if settings.logo_position_mobile == 'left' or (settings.logo_position_mobile == 'center' and settings.head_utility == 'icons') %}order-2 {% if not (settings.logo_position_mobile == 'center' and settings.head_utility == 'icons') %}ml-2{% endif %}{% else %}text-left{% endif %} d-block d-md-none">
                    <a href="#" class="js-modal-open utilities-link utilities-item" data-toggle="#nav-search" aria-label="{{ 'Buscador' | translate }}">
                        {% include "snipplets/svg/search.tpl" with {svg_custom_class: "icon-inline icon-2x"} %}
                    </a>
                </div>
            {% endif %}

            {# Logo for mobile and desktop #}

			<div class="{% if settings.logo_position_desktop == 'center' %}{% if settings.icons_size_desktop == 'big' %}col-md-6 col-lg-6{% else %}col-md-4 col-lg-4{% endif %}{% else %}col-md-3 col-lg-3{% endif %} {% if settings.logo_position_mobile == 'left' %}col text-left{% else %}col text-center{% endif %} {% if settings.logo_position_desktop == 'center' %}text-md-center {% if settings.icons_size_desktop == 'small' %}offset-md-1{% endif %} order-md-2{% else %}text-md-left{% endif %}">
                {% snipplet "header/header-logo.tpl" %}
            </div>

            {# Desktop Search, used on mobile when setting is set to show "big search" #}

            <div class="{% if settings.head_utility == 'searchbox' %}col-12 order-last order-md-0{% else %}col-6 d-none d-md-block{% endif %} text-center {% if settings.logo_position_desktop == 'center' %}col-md-3 col-lg-3 order-md-1{% elseif settings.icons_size_desktop == 'small' and settings.logo_position_desktop == 'left' %}col-md-6 col-lg-5{% else %}col-md-6 col-lg-6{% endif %}">
                {% snipplet "header/header-search.tpl" %}
            </div>

            {# Utility icons: Help, Account and Cart (also used on mobile) #}

			<div class="col-auto {% if settings.logo_position_mobile == 'left' %}order-3{% elseif settings.logo_position_mobile == 'center' and settings.head_utility == 'icons' %}order-last{% endif %} {% if settings.icons_size_desktop == 'small' %}col-md-4 col-lg-4{% else %}col-md-3 col-lg-3{% endif %} text-right {% if settings.logo_position_desktop == 'center' %}order-md-3{% endif %}">
                {% snipplet "header/header-utilities.tpl" %}
                {% if settings.head_fix and settings.ajax_cart %}
                    <div class="d-none d-md-block">
                        {% include "snipplets/notification.tpl" with {add_to_cart: true} %}
                    </div>
                {% endif %}
            </div>
            {% if settings.logo_position_mobile == 'left' and not settings.head_utility == 'searchbox' %}
                <div class="col-auto d-md-none order-last">
                    <a href="#" class="js-modal-open utilities-link utilities-item" data-toggle="#nav-hamburger" aria-label="{{ 'Menú' | translate }}" data-component="menu-button">
                        {% include "snipplets/svg/bars.tpl" with {svg_custom_class: "icon-inline icon-2x"}%}
                    </a>
                </div>
            {% endif %}
		</div>
        {% if settings.head_fix and settings.ajax_cart %}
            <div class="d-md-none">
                {% include "snipplets/notification.tpl" with {add_to_cart: true, add_to_cart_mobile: true} %}
            </div>
        {% endif %}

        {# Mobile row for exposed categories #}
        <div class="row align-items-center nav-row {% if settings.head_utility == 'searchbox' %}d-none d-md-block{% endif %}">
            {% if settings.head_utility == 'categories' %}

                {# Menu icon inline with categories when when categories are exposed and logo is centered #}
                {% if settings.logo_position_mobile == 'center' %}
                    <div class="col-2 d-block d-md-none p-0 text-center">
                        <a href="#" class="js-modal-open utilities-link utilities-item" data-toggle="#nav-hamburger" aria-label="{{ 'Menú' | translate }}" data-component="menu-button">
                            {% include "snipplets/svg/bars.tpl" with {svg_custom_class: "icon-inline icon-2x"}%}
                        </a>
                        {% if store.country == 'AR'%}
                            {# Notification icon for quick login on AR stores#}
                            <div class="js-quick-login-badge badge badge-overlap swing" style="display: none;"></div>
                        {% endif %}
                    </div>
                {% endif %}
                <div class="col-{% if settings.logo_position_mobile == 'left' %}12{% else %}10{% endif %} nav-categories-container d-block d-md-none p-0">
                    {% snipplet "navigation/navigation-categories.tpl" %}
                </div>
            {% endif %}
            <div class="col text-center p-0 d-none d-md-block">{% snipplet "navigation/navigation.tpl" %}</div>
        </div>

	</div>    
    {% include "snipplets/notification.tpl" with {order_notification: true} %}
</header>

{# Show cookie validation message #}

{% include "snipplets/notification.tpl" with {show_cookie_banner: true} %}

{# Add notification for quick login cancellation #}

{% if template == 'home' or template == 'product' %}
    {% include "snipplets/notification.tpl" with {show_quick_login: true} %}
{% endif %}

{# Add notification for order cancellation #}

{% if store.country == 'AR' and template == 'home' and status_page_url %}
    {% include "snipplets/notification.tpl" with {show_order_cancellation: true} %}
{% endif %}

{# Add to cart notification for non fixed header #}

{% if not settings.head_fix and settings.ajax_cart %}
    {% include "snipplets/notification.tpl" with {add_to_cart: true, add_to_cart_fixed: true} %}
{% endif %}

{# Quick login modal #}

{% embed "snipplets/modal.tpl" with{modal_id: 'quick-login', modal_class: 'bottom modal-centered-small', modal_position: 'center', modal_transition: 'slide', modal_header: false, modal_footer: false, modal_width: 'centered', modal_zindex_top: true, modal_close_class: 'float-right mr-0'} %}
    {% block modal_body %}
        <div class="text-center h5 mt-3">{{ "¡Qué bueno verte de nuevo!" | translate }}</div>
        <div class="text-center p-2">{{ "Iniciá sesión para comprar más rápido y ver todos tus pedidos." | translate }}</div>
        {% embed "snipplets/forms/form.tpl" with{form_id: 'quick-login-form', form_action: '/account/login/', submit_custom_class: 'btn-block', submit_text: 'Iniciar sesión' | translate, data_store: 'account-login' } %}
            {% block form_body %}
                {% embed "snipplets/forms/form-input.tpl" with{type_hidden: true, input_value: current_url, input_name: 'redirect_to'} %}{% endembed %}
                {% embed "snipplets/forms/form-input.tpl" with{type_hidden: true, input_value: 'quick-login', input_name: 'from'} %}{% endembed %}
                {% embed "snipplets/forms/form-input.tpl" with{input_for: 'email', type_email: true, input_value: result.email, input_name: 'email', input_custom_class: 'js-account-input', input_label_text: 'Email' | translate } %}{% endembed %}
                {% embed "snipplets/forms/form-input.tpl" with{input_for: 'password', type_password: true, input_name: 'password', input_custom_class: 'js-account-input', input_help: true, input_help_link: store.customer_reset_password_url, input_link_class: 'btn-link-primary font-small float-right mb-4 mt-3n', input_label_text: 'Contraseña' | translate } %}{% endembed %}
            {% endblock %}
        {% endembed %}
    {% endblock %}
{% endembed %}

{# Hamburger panel #}

{% embed "snipplets/modal.tpl" with {modal_id: 'nav-hamburger',modal_class: 'nav-hamburger head-'~ settings.head_background ~ ' modal-docked-small', modal_position: 'left', modal_transition: 'fade', modal_width: 'full', modal_topbar: true, modal_fixed_footer: true, modal_footer: true, modal_footer_class: 'p-0' } %}
    {% block modal_topbar %}
        {% snipplet "navigation/navigation-topbar.tpl" %}
    {% endblock %}
    {% block modal_body %}
        {% include "snipplets/navigation/navigation-panel.tpl" with {primary_links: true} %}
    {% endblock %}
    {% block modal_foot %}
        {% include "snipplets/navigation/navigation-panel.tpl" %}
    {% endblock %}
{% endembed %}
{# Notifications #}

{# Modal Search #}

{% embed "snipplets/modal.tpl" with{modal_id: 'nav-search',modal_class: 'nav-search', modal_position: 'left', modal_transition: 'slide', modal_width: 'docked-md', modal_header: true } %}
    {% block modal_head %}
            {% block page_header_text %}{{ "Buscar" | translate }}{% endblock page_header_text %}
    {% endblock %}
    {% block modal_body %}
        {% snipplet "header/header-search.tpl" %}
    {% endblock %}
{% endembed %}

{% if not store.is_catalog and settings.ajax_cart and template != 'cart' %}           

    {# Cart Ajax #}

    {% embed "snipplets/modal.tpl" with{modal_id: 'modal-cart', modal_position: 'right', modal_transition: 'slide', modal_width: 'docked-md', modal_form_action: store.cart_url, modal_form_class: 'js-ajax-cart-panel', modal_header: true, modal_mobile_full_screen: true, modal_form_hook: 'cart-form', data_component:'cart' } %}
        {% block modal_head %}
            {% block page_header_text %}{{ "Carrito de Compras" | translate }}{% endblock page_header_text %}
        {% endblock %}
        {% block modal_body %}
            {% snipplet "cart-panel.tpl" %}
        {% endblock %}
    {% endembed %}

{% endif %}
