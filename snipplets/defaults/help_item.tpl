{# /*============================================================================
  #Item grid
==============================================================================*/

#Properties

#Slide Item

#}

{% set slide_item = slide_item | default(false) %}
{% set columns = settings.grid_columns %}

{% if slide_item %}
    <div class="swiper-slide{% if settings.theme_rounded %} p-3{% endif %}">
{% endif %}
{% if settings.theme_rounded %}
    <div class="{% if not slide_item %} {% if columns == 1 %}col-12 col-md-6 col-lg-4{% else %}col-6 col-md-4 col-lg-3{% endif %}{% endif %}">
        <div class="item item-rounded item-product box-rounded p-0">
{% else %}
    <div class="{% if not slide_item %} {% if columns == 1 %}col-12 col-md-6 col-lg-4{% else %}col-6 col-md-4 col-lg-3{% endif %}{% endif %} item item-product">
{% endif %}
    <div class="item-image">
        <div class="p-relative">
            <a href="{{ store.url }}/product/example" title="{{ "Producto de ejemplo" | translate }}">
                {% if help_item_1 %}
                    {% include "snipplets/svg/help/help-product-1.tpl" %}
                {% elseif help_item_2 %}
                    {% include "snipplets/svg/help/help-product-2.tpl" %}
                {% elseif help_item_3 %}
                    {% include "snipplets/svg/help/help-product-3.tpl" %}
                {% elseif help_item_4 %}
                    {% include "snipplets/svg/help/help-product-4.tpl" %}
                {% elseif help_item_5 %}
                    {% include "snipplets/svg/help/help-product-5.tpl" %}
                {% elseif help_item_6 %}
                    {% include "snipplets/svg/help/help-product-6.tpl" %}
                {% elseif help_item_7 %}
                    {% include "snipplets/svg/help/help-product-7.tpl" %}
                {% elseif help_item_8 %}
                    {% include "snipplets/svg/help/help-product-8.tpl" %}
                {% endif %}
            </a>
            {% if help_item_1 %}
                <div class="labels">
                    <div class="label label-primary label-circle">{{ "20% OFF" | translate }}</div>
                </div>
            {% elseif help_item_2 %}
                <div class="labels">
                    <div class="label label-primary">{{ "Envío gratis" | translate }}</div>
                </div>
            {% elseif help_item_3 %}
                <div class="labels">
                    <div class="label label-primary label-circle">{{ "35% OFF" | translate }}</div>
                </div>
            {% elseif help_item_7 %}
                <div class="labels">
                    <div class="label label-primary label-circle">{{ "20% OFF" | translate }}</div>
                </div>
            {% endif %}
        </div>
    </div>
    <div class="item-description py-4">
        <a href="{{ store.url }}/product/example" title="{{ "Producto de ejemplo" | translate }}" class="item-link">
            <div class="item-name mb-1">{{ "Producto de ejemplo" | translate }}</div>
            <div class="item-price-container mb-1">
                {% if help_item_1 %}
                    {% if store.country == 'BR' %}
                        <span id="compare_price_display" class="js-compare-price-display price-compare">
                            {{"120000" | money }}
                        </span>
                        <span id="price_display" class="js-price-display item-price font-weight-bold">
                            {{"9600" | money }}
                        </span>
                    {% else %}
                        <span id="compare_price_display" class="js-compare-price-display price-compare">
                            {{"1200000" | money }}
                        </span>
                        <span id="price_display" class="js-price-display item-price font-weight-bold">
                            {{"96000" | money }}
                        </span>
                    {% endif %}
                {% elseif help_item_2 %}
                    {% if store.country == 'BR' %}
                        <span id="price_display" class="js-price-display item-price font-weight-bold">
                            {{"68000" | money }}
                        </span>
                    {% else %}
                        <span id="price_display" class="js-price-display item-price font-weight-bold">
                            {{"680000" | money }}
                        </span>
                    {% endif %}
                {% elseif help_item_3 %}
                    {% if store.country == 'BR' %}
                        <span id="compare_price_display" class="js-compare-price-display price-compare">
                            {{"28000" | money }}
                        </span>
                        <span id="price_display" class="js-price-display item-price font-weight-bold">
                            {{"18200" | money }}
                        </span>
                    {% else %}
                        <span id="compare_price_display" class="js-compare-price-display price-compare">
                            {{"280000" | money }}
                        </span>
                        <span id="price_display" class="js-price-display item-price font-weight-bold">
                            {{"182000" | money }}
                        </span>
                    {% endif %}
                {% elseif help_item_4 %}
                    {% if store.country == 'BR' %}
                        <span id="price_display" class="js-price-display item-price font-weight-bold">
                            {{"32000" | money }}
                        </span>
                    {% else %}
                        <span id="price_display" class="js-price-display item-price font-weight-bold">
                            {{"320000" | money }}
                        </span>
                    {% endif %}
                {% elseif help_item_5 %}
                    {% if store.country == 'BR' %}
                        <span id="price_display" class="js-price-display item-price font-weight-bold">
                            {{"24900" | money }}
                        </span>
                    {% else %}
                        <span id="price_display" class="js-price-display item-price font-weight-bold">
                            {{"249000" | money }}
                        </span>
                    {% endif %}
                {% elseif help_item_6 %}
                    {% if store.country == 'BR' %}
                        <span id="price_display" class="js-price-display item-price font-weight-bold">
                            {{"42000" | money }}
                        </span>
                    {% else %}
                        <span id="price_display" class="js-price-display item-price font-weight-bold">
                            {{"420000" | money }}
                        </span>
                    {% endif %}
                {% elseif help_item_7 %}
                    {% if store.country == 'BR' %}
                        <span id="compare_price_display" class="js-compare-price-display price-compare">
                            {{"46000" | money }}
                        </span>
                        <span id="price_display" class="js-price-display item-price font-weight-bold">
                            {{"36800" | money }}
                        </span>
                    {% else %}
                        <span id="compare_price_display" class="js-compare-price-display price-compare">
                            {{"460000" | money }}
                        </span>
                        <span id="price_display" class="js-price-display item-price font-weight-bold">
                            {{"368000" | money }}
                        </span>
                    {% endif %}
                {% elseif help_item_8 %}
                    {% if store.country == 'BR' %}
                        <span id="price_display" class="js-price-display item-price font-weight-bold">
                            {{"12200" | money }}
                        </span>
                    {% else %}
                        <span id="price_display" class="js-price-display item-price font-weight-bold">
                            {{"122000" | money }}
                        </span>
                    {% endif %}
                {% endif %}
            </div>
        </a>
        {% include 'snipplets/payments/installments.tpl' %}
    </div>
</div>
{% if settings.theme_rounded %}
    </div>
{% endif %}
{% if slide_item %}
    </div>
{% endif %}