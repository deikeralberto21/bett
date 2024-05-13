<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml" xmlns:og="http://opengraphprotocol.org/schema/" lang="{% for language in languages %}{% if language.active %}{{ language.lang }}{% endif %}{% endfor %}">
    <head>
        <link rel="preconnect" href="{{ store_resource_hints }}" />
        <link rel="dns-prefetch" href="{{ store_resource_hints }}" />
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>{{ page_title }}</title>
        <meta name="description" content="{{ page_description }}" />
        <meta name="keywords" content="veterinaria, mascotas, perros, gatos, alimentos para mascotas, accesorios para mascotas, juguetes para mascotas">
        {% if settings.fb_admins %}
            <meta property="fb:admins" content="{{ settings.fb_admins }}" />
        {% endif %}
        {% if store_fb_app_id %}
        <meta property="fb:app_id" content="{{ store_fb_app_id }}" />
        {% elseif not store.has_custom_domain %}
        <meta property="fb:app_id" content="{{ fb_app.id }}" />
        {% endif %}

        {# Preload of first image of Slider to improve LCP #}
        {% if template == 'home'%}
            {% snipplet 'preload-images.tpl' %}
        {% endif %}

        {# OG tags to control how the page appears when shared on social networks. See http://ogp.me/ #}

        {% snipplet "metas/general-og.tpl" %}

        {# Twitter tags to control how the page appears when shared on Twitter. See https://dev.twitter.com/cards/markup #}
        {% if template == 'product' %}
            {# Twitter #}
            {% snipplet "metas/twitter-product.tpl" %}
            {# Facebook #}
            {% snipplet "metas/facebook-product-og.tpl" %}
        {% elseif template == 'category' %}
            {# Facebook #}
            {% snipplet "metas/facebook-category-og.tpl" %}
        {% endif %}

        {#/*============================================================================
            #CSS and fonts
        ==============================================================================*/#}

        {# Critical CSS needed to show first elements of store while CSS async is loading #}

        <style>
            {# Font families #}

            {% if params.preview %}

                {# If page is loaded from customization page on the admin, load all fonts #}

                @import url('https://fonts.googleapis.com/css?family=Muli:400,700|Lato:400,700|Open+Sans:400,700|Lora:400,700|Slabo+27px|Playfair+Display:400,700|Droid+Sans:400,700|Montserrat:400,700|Nunito:400,700|Fredoka+One');

            {% else %}

                {# If page is NOT loaded from customization only load saved fonts #}

                {# Get only the saved fonts on settings #}

                @import url('{{ [settings.font_headings, settings.font_rest] | google_fonts_url('400, 700') | raw  }}');

            {% endif %}


            {% include "static/css/style-critical.tpl" %}
        </style>

        {# Colors and fonts used from settings.txt and defined on theme customization #}

        {{ 'css/style-colors.scss.tpl' | static_url | static_inline }}

        {# Load async styling not mandatory for first meaningfull paint #}

        {% include "static/js/load-css-async.tpl" %}

        {# Loads custom CSS added from Advanced Settings on the admin´s theme customization screen #}

        <style>
            {{ settings.css_code | raw }}
        </style>

        {#/*============================================================================
            #Javascript: Needed before HTML loads
        ==============================================================================*/#}

        {# Defines if async JS will be used by using script_tag(true) #}

        {% set async_js = true %}

        {# Defines the usage of jquery loaded below, if nojquery = true is deleted it will fallback to jquery 1.5 #}

        {% set nojquery = true %}

        {# Jquery async by adding script_tag(true) #}

        {% if load_jquery %}

            {{ '//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js' | script_tag(true) }}

        {% endif %}

        {# Loads private Tiendanube JS #}

        {% head_content %}

        {# Structured data to provide information for Google about the page content #}

        {% include 'snipplets/structured_data/webpage-structured-data.tpl' %}
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script src='https://kit.fontawesome.com/a076d05399.js' crossorigin='anonymous'></script>
    </head>
    <body {% if settings.head_fix %}class="js-head-offset head-offset"{% endif %}>
    <div class="navmobiloContainer">
  <div class="navMObilo" style="position: relative;/*! top: 0; *//*! background-color: aqua; */height: 100%;width: 100%;display: flex;align-items: center;justify-content: space-evenly;list-style: none;color: white;margin: 0;">
    
  <a href="https://beethovenvillavo.com/alimentos3">
    <div>
      <ion-icon class="ion" name="fast-food"></ion-icon>
      Alimentos
      </div>
  </a>
  <a href="https://beethovenvillavo.com/accesorios11">
    <div>
      <ion-icon class="ion" name="glasses"></ion-icon>
      Accesorios
      </div>
  </a>
  <a href="https://beethovenvillavo.com/higiene-principal/">
    <div>
      <ion-icon class="ion" name="cut"></ion-icon>
      Higiene
      </div>
  </a>
  <a href="https://beethovenvillavo.com/farmacia11">
    <div>
      <ion-icon class="ion" name="bandage"></ion-icon>
      Farmacia
      </div>
  </a>
  <a href="https://beethovenvillavo.com/marcas1">
    <div>
      <ion-icon class="ion" name="at-circle-outline"></ion-icon>
      Marcas
      </div>
  </a>
  </div>
</div>
        {# Facebook comments on product page #}

        {% if template == 'product' %}

            {# Facebook comment box JS #}
            {% if settings.show_product_fb_comment_box %}
                {{ fb_js }}
            {% endif %}

            {# Pinterest share button JS #}
            {{ pin_js }}

        {% endif %}

        {# Facebook account login and register #}

        {% if template == 'account.login' or template == 'account.register' %}
            {{ fb_js }}
            <script>
                function loginFacebook() {
                    LS.ready.then(function(){
                        LS.facebookLogin(FB, function(status, hasEmail) {
                            if (status === 'connected') {
                                if (hasEmail) {
                                    window.location = "{{ store.url }}/account/facebook_login/";
                                } else {
                                    jQueryNuvem('#login-form').prepend(
                                            "<div class=\"alert alert-danger\">{{ 'Tienes que compartír tu e-mail.' | translate }}</div>");
                                }
                            } else {
                                jQueryNuvem('#login-form').prepend(
                                        "<div class=\"alert alert-danger\">{{ 'Debes completar el login.' | translate }}</div>");
                            }
                        });
                    });
                }
            </script>
        {% endif %}

        {# Back to admin bar #}

        {{back_to_admin}}

        {# Header = Advertising + Nav + Logo + Search + Ajax Cart #}

        {% snipplet "header/header.tpl" %}

        {# Page content #}

        {% if template != 'home' or (template == 'home' and settings.slider is empty) %}

        <div class="mt-4">

        {% endif %}

            {% template_content %}

        {% if template != 'home' or (template == 'home' and settings.slider and settings.slider is not empty) %}

        </div>

        {% endif %}

        {# WhatsApp chat button #}

        {% snipplet "whatsapp-chat.tpl" %}

        {# Footer #}

        {% snipplet "footer/footer.tpl" %}

        {% if store.has_free_shipping_progress and (cart.free_shipping.cart_has_free_shipping or cart.free_shipping.min_price_free_shipping.min_price) %}

            {# Minimum used for free shipping progress messages. Located on header so it can be accesed everywhere with shipping calculator active or inactive #}

            <span class="js-ship-free-min hidden" data-pricemin="{{ cart.free_shipping.min_price_free_shipping.min_price_raw }}"></span>
            <span class="js-cart-subtotal hidden" data-priceraw="{{ cart.subtotal }}"></span>
        {% endif %}

        {#/*============================================================================
            #Javascript: Needed after HTML loads
        ==============================================================================*/#}

        {# Javascript used in the store #}

        <script type="text/javascript">

            {# Libraries that do NOT depend on other libraries, e.g: Jquery #}

            {% include "static/js/external-no-dependencies.js.tpl" %}

            {# LS.ready.then function waits to Jquery and private Tiendanube JS to be loaded before executing what´s inside #}

            LS.ready.then(function(){

                {# Libraries that requires Jquery to work #}

                {% include "static/js/external.js.tpl" %}

                {# Specific store JS functions: product variants, cart, shipping, etc #}

                {% if store.useStoreJsV2() %}
                    {% include "static/js/store-v2.js.tpl" %}
                {% else %}
                    {% include "static/js/store.js.tpl" %}
                {% endif %}
            });
        </script>

        {# Google reCAPTCHA on register page #}

        {% if template == 'account.register' %}
            {% if not store.hasContactFormsRecaptcha() %}
                {{ '//www.google.com/recaptcha/api.js' | script_tag(true) }}
            {% endif %}
            <script type="text/javascript">
                var recaptchaCallback = function() {
                    jQueryNuvem('.js-recaptcha-button').prop('disabled', false);
                };
            </script>
        {% endif %}

        {# Google survey JS for Tiendanube Survey #}

        {% include "static/js/google-survey.js.tpl" %}

        {# Store external codes added from admin #}

        {{ component('assorted-js', {}) }}
    </body>
</html>
