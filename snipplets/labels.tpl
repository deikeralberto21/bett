{% if product.compare_at_price > product.price %}
{% set price_discount_percentage = ((product.compare_at_price) - (product.price)) * 100 / (product.compare_at_price) %}
{% endif %}

{% if color %}
  {% set show_labels = settings.product_color_variants %}
{% else %}
  {% set show_labels = not product.has_stock or product.free_shipping or product.compare_at_price or product.promotional_offer %}
{% endif %}

{% set has_multiple_slides = product.images_count > 1 or product.video_url %}


<div class="{% if product.video_url and product %}js-labels-group{% endif %} labels {% if product_detail and has_multiple_slides %}labels-product-slider{% endif %}" data-store="product-item-labels">
  {% if show_labels %}
    {% if not product.has_stock %}
      <div class="{% if product_detail or color %}js-stock-label {% endif %}label label-default">{{ "Validar stock" | translate }}</div>
    {% else %}
      {% if product_detail or color %}
        <div class="js-stock-label label label-default" {% if product.has_stock %}style="display:none;"{% endif %}>{{ "Validar stock" | translate }}</div>
      {% endif %}
      {% if product.compare_at_price or product.promotional_offer %}
        <div class="{% if not product.promotional_offer and product %}js-offer-label{% endif %} label label-accent {% if not product.promotional_offer %}label-circle{% endif %}" {% if (not product.compare_at_price and not product.promotional_offer) or not product.display_price %}style="display:none;"{% endif %} data-store="product-item-{% if product.compare_at_price %}offer{% else %}promotion{% endif %}-label">
          {% if product.promotional_offer.script.is_percentage_off %}
            {{ product.promotional_offer.parameters.percent * 100 }}% OFF
          {% elseif product.promotional_offer.script.is_discount_for_quantity %}
            <div>{{ product.promotional_offer.selected_threshold.discount_decimal_percentage * 100 }}% OFF</div>
            <div class="font-smallest">{{ "Comprando {1} o más" | translate(product.promotional_offer.selected_threshold.quantity) }}</div>
          {% elseif product.promotional_offer %}
            {% if store.country == 'BR' %}
              {{ "Leve {1} Pague {2}" | translate(product.promotional_offer.script.quantity_to_take, product.promotional_offer.script.quantity_to_pay) }}
            {% else %}
              {{ product.promotional_offer.script.type }} 
            {% endif %}
          {% else %}
            <span class="js-offer-percentage">
              {{ price_discount_percentage |round }}</span>% OFF
          {% endif %}
        </div>
      {% endif %}
      {% if product.free_shipping %}
        <div class="label label-accent">{{ "Envío gratis" | translate }}</div>
      {% endif %}
    {% endif %}
  {% endif %}
</div>
<span class="hidden" data-store="stock-product-{{ product.id }}-{% if product.has_stock %}{% if product.stock %}{{ product.stock }}{% else %}infinite{% endif %}{% else %}0{% endif %}"></span>