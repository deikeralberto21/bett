{# Cookie validation #}

{% if show_cookie_banner and not params.preview %}
    <div id="cookies-notification" class="js-notification js-notification-cookie-banner notification notification-fixed-bottom notification-above notification-primary col-12 col-lg-6 offset-lg-3 opacity-90" style="display: none;">
        <div class="mb-4">{{ 'Al navegar por este sitio <strong>aceptás el uso de cookies</strong> para agilizar tu experiencia de compra.' | translate }}</div>
        <div class="text-center mb-3">
            <a href="#" class="js-notification-close js-acknowledge-cookies btn btn-secondary btn-medium invert" id="cookies-notification-button" data-amplitude-event-name="cookie_banner_acknowledge_click">{{ "Entendido" | translate }}</a>
        </div>
    </div>
{% endif %}

{# Quick login when store is not AR #}

{% if show_quick_login and not customer and store.country != 'AR' and template == 'home' %}
    <div class="js-notification js-notification-quick-login notification notification-fixed-bottom notification-primary col-12 col-lg-4 offset-lg-4 opacity-90" style="display: none;">
        <div class="container">
            <div class="row my-1">
                <div class="col p-0">
                    <div class="mb-3 mr-2">{{ '<strong>¡Comprá más rápido</strong> y seguí tus pedidos!' | translate }}</div>
                    <a data-toggle="#quick-login" class="js-modal-open btn btn-secondary btn-small invert">{{ "Iniciá sesión" | translate }}</a>
                </div>
                <div class="col-auto p-0">
                    <a class="js-notification-close js-dismiss-quicklogin mr-1" href="#">
                        {% include "snipplets/svg/times.tpl" with {svg_custom_class: "icon-inline svg-icon-invert icon-lg"} %}
                    </a>
                </div>
            </div>
        </div>
    </div>
{% endif %}

{# Success notification for quick login (all countries) #}

{% if show_quick_login and customer and just_logged_in  %}
    <div class="js-notification js-notification-quick-login js-quick-login-success notification notification-fixed-bottom notification-primary col-12 col-lg-4 offset-lg-4 opacity-90">
         <div class="container">
            <div class="row">
                <div class="col">
                    {% include "snipplets/svg/heart.tpl" with {svg_custom_class: "icon-inline icon-lg svg-icon-invert mr-2"} %}
                    <span>
                        {% set customer_short_name = customer.name|split(' ')|slice(0, 1)|join %} 
                        {{ "<strong>¡Hola, {1}!</strong> Ya podés seguir con tu compra" | t(customer_short_name) }}
                    </span> 
                </div>
                <div class="col-auto">
                    <a class="js-notification-close mr-1" href="#">
                        {% include "snipplets/svg/times.tpl" with {svg_custom_class: "icon-inline svg-icon-invert icon-lg pull-left"} %}
                    </a>
                </div>
            </div>
        </div>
    </div>
{% endif %}

{% if show_order_cancellation %}
    <div class="js-notification js-notification-order-cancellation notification notification-fixed-bottom notification-tertiary col-lg-4 offset-lg-4" style="display:none;" data-url="{{ status_page_url }}">
        <div class="container">
            <div class="row">
                <div class="col">
                    <a href="{{ store.contact_url }}?order_cancellation=true"><strong class="text-primary">{{ "Botón de arrepentimiento" | translate }}</strong></a>
                    <a class="js-notification-close js-notification-order-cancellation-close ml-3" href="#">
                        {% include "snipplets/svg/times.tpl" with {svg_custom_class: "icon-inline svg-icon-primary icon-lg"} %}
                    </a>
                </div>
            </div>
        </div>
    </div>
{% endif %}
{% if order_notification and status_page_url %}
    <div class="js-notification js-notification-status-page notification notification-primary" style="display:none;" data-url="{{ status_page_url }}">
        <div class="container">
            <div class="row">
                <div class="col">
                    <a href="{{ status_page_url }}"><strong>{{ "Seguí acá" | translate }}</strong> {{ "tu última compra" | translate }}</a>
                    <a class="js-notification-close js-notification-status-page-close ml-3" href="#">
                        {% include "snipplets/svg/times.tpl" with {svg_custom_class: "icon-inline svg-icon-text icon-lg"} %}
                    </a>
                </div>
            </div>
        </div>
    </div>
{% endif %}

{% if add_to_cart %}
    <div class="js-alert-added-to-cart notification-floating notification-hidden {% if add_to_cart_fixed %}notification-fixed{% endif %}" style="display: none;">
        <div class="notification notification-primary notification-cart position-relative {% if not add_to_cart_mobile %}col-12 float-right{% endif %}">
            <div class="js-cart-notification-arrow-up notification-arrow-up"></div>
            <div class="js-cart-notification-close notification-close">
                {% include "snipplets/svg/times.tpl" with {svg_custom_class: "icon-inline icon-2x  svg-icon-primary notification-icon"} %}
            </div>
            <div class="js-cart-notification-item row" data-store="cart-notification-item">
                <div class="col-2 pr-0 notification-img">
                    <img src="" class="js-cart-notification-item-img img-fluid" />
                    {% include "snipplets/svg/check-circle-filled.tpl" with {svg_custom_class: "icon-inline icon-sm  svg-icon-primary"} %}
                </div>
                <div class="col-10 text-left">
                    <div class="mb-1 mr-4">
                        <span class="js-cart-notification-item-name"></span>
                        <span class="js-cart-notification-item-variant-container" style="display: none;">
                            (<span class="js-cart-notification-item-variant"></span>)
                        </span>
                    </div>
                    <div class="mb-1">
                        <span class="js-cart-notification-item-quantity"></span>
                        <span> x </span>
                        <span class="js-cart-notification-item-price"></span>
                    </div>
                    <strong>{{ '¡Agregado al carrito con éxito!' | translate }}</strong>
                </div>
            </div>
            <div class="divider my-3"></div>
            <div class="row text-primary h5 font-weight-normal mb-3">
                <span class="col-auto text-left ml-2">
                    <strong>{{ "Total" | translate }}</strong> 
                    (<span class="js-cart-widget-amount">
                        {{ "{1}" | translate(cart.items_count ) }} 
                    </span>
                    <span class="js-cart-counts-plural" style="display: none;">
                        {{ 'productos' | translate }}):
                    </span>
                    <span class="js-cart-counts-singular" style="display: none;">
                        {{ 'producto' | translate }}):
                    </span>

                </span>
                <strong class="js-cart-total col text-right mr-2">{{ cart.total | money }}</strong>
            </div>
            <a href="#" class="js-modal-open js-cart-notification-close js-fullscreen-modal-open btn btn-primary btn-medium w-100 d-inline-block" data-toggle="#modal-cart" data-modal-url="modal-fullscreen-cart">
                {{'Ver carrito' | translate }}
            </a>
        </div>
    </div>
{% endif %}
