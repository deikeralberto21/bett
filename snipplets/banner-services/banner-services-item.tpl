<div class="service-item-container col-md swiper-slide p-0 px-md-3">
    <div class="service-item mx-4 mx-md-0">
        {% if banner_services_url %}
            <a href="{{ banner_services_url | setting_url }}">
        {% endif %}
        <div class="row align-items-center">
            <div class="col-auto">
                {% if banner_services_icon == 'shipping' %}
                    {% include "snipplets/svg/shipping-circle.tpl" with {svg_custom_class: "icon-inline icon-5x svg-icon-text"} %}
                {% elseif banner_services_icon == 'card' %}
                    {% include "snipplets/svg/credit-card-circle.tpl" with {svg_custom_class: "icon-inline icon-5x svg-icon-text"} %}
                {% elseif banner_services_icon == 'security' %}
                    {% include "snipplets/svg/security-circle.tpl" with {svg_custom_class: "icon-inline icon-5x svg-icon-text"} %}
                {% elseif banner_services_icon == 'returns' %}
                    {% include "snipplets/svg/returns-circle.tpl" with {svg_custom_class: "icon-inline icon-5x svg-icon-text"} %}
                {% elseif banner_services_icon == 'whatsapp' %}
                    {% include "snipplets/svg/whatsapp-circle.tpl" with {svg_custom_class: "icon-inline icon-5x svg-icon-text"} %}
                {% elseif banner_services_icon == 'promotions' %}
                    {% include "snipplets/svg/promotions-circle.tpl" with {svg_custom_class: "icon-inline icon-5x svg-icon-text"} %}
                {% elseif banner_services_icon == 'hand' %}
                    {% include "snipplets/svg/clean-hands-circle.tpl" with {svg_custom_class: "icon-inline icon-5x svg-icon-text"} %}
                {% elseif banner_services_icon == 'home' %}
                    {% include "snipplets/svg/stay-home-circle.tpl" with {svg_custom_class: "icon-inline icon-5x svg-icon-text"} %}
                {% elseif banner_services_icon == 'office' %}
                    {% include "snipplets/svg/home-office-circle.tpl" with {svg_custom_class: "icon-inline icon-5x svg-icon-text"} %}
                {% elseif banner_services_icon == 'cash' %}
                    {% if store.country == 'BR' %}
                        {% include "snipplets/svg/barcode-circle.tpl" with {svg_custom_class: "icon-inline icon-5x svg-icon-text"} %}
                    {% else %}
                        {% include "snipplets/svg/cash-circle.tpl" with {svg_custom_class: "icon-inline icon-5x svg-icon-text"} %}
                    {% endif %}
                {% endif %}
            </div>
            <div class="col p-0">
                <h3 class="h5 m-0">{{ banner_services_title }}</h3>
                <p class="m-0">{{ banner_services_description }}</p>
            </div>
        </div>
        {% if banner_services_url %}
            </a>
        {% endif %}
    </div>
</div>
