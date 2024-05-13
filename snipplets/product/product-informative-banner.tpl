{% for banner in ['product_informative_banner_01', 'product_informative_banner_02', 'product_informative_banner_03'] %}
    {% set product_banner_show = attribute(settings,"#{banner}_show") %}
    {% set product_informative_banner_icon = attribute(settings,"#{banner}_icon") %}
    {% set product_informative_banner_title = attribute(settings,"#{banner}_title") %}
    {% set product_informative_banner_description = attribute(settings,"#{banner}_description") %}
    {% set product_informative_banner_url = attribute(settings,"#{banner}_url") %}
    {% set product_informative_banner_link_text = attribute(settings,"#{banner}_link_text") %}
    {% set has_product_informative_banner =  product_banner_show and (product_informative_banner_title or product_informative_banner_description) %}
    {% if has_product_informative_banner %}
        <div class="form-row mb-4 {% if loop.first %}mt-4 {% if store.branches %}pt-2{% endif %}{% endif %}">
            {% if product_informative_banner_icon != 'none' %}
                <div class="col-1 col-md-auto form-label">
                    {% if product_informative_banner_icon == 'security' %}
                        {% include "snipplets/svg/security.tpl" with {svg_custom_class: "icon-inline icon-lg svg-icon-text align-text-bottom"} %}
                    {% elseif product_informative_banner_icon == 'returns' %}
                        {% include "snipplets/svg/returns.tpl" with {svg_custom_class: "icon-inline icon-lg svg-icon-text align-text-bottom"} %}
                    {% elseif product_informative_banner_icon == 'delivery' %}
                        {% include "snipplets/svg/delivery.tpl" with {svg_custom_class: "icon-inline icon-lg svg-icon-text align-text-bottom"} %}
                    {% elseif product_informative_banner_icon == 'whatsapp' %}
                        {% include "snipplets/svg/whatsapp.tpl" with {svg_custom_class: "icon-inline icon-lg svg-icon-text align-text-bottom"} %}
                    {% elseif product_informative_banner_icon == 'cash' %}
                        {% include "snipplets/svg/cash.tpl" with {svg_custom_class: "icon-inline icon-lg svg-icon-text align-text-bottom"} %}
                    {% endif %}
                </div>
            {% endif %}
            <div class="{% if product_informative_banner_icon == 'none' %}col-12{% else %}col-11{% endif %} form-label">
                {% if product_informative_banner_title %}
                    <div class="mb-1 font-weight-bold">{{ product_informative_banner_title }}</div>
                {% endif %}
                {% if product_informative_banner_description %}
                    <div>{{ product_informative_banner_description }}</div> 
                {% endif %}
            </div>
        </div>
    {% endif %}
{% endfor %}