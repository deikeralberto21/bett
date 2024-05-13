<div class="js-cart-item {% if item.product.is_non_shippable %}js-cart-item-non-shippable{% else %}js-cart-item-shippable{% endif %} {% if cart_page %}row align-items-md-center{% else %}cart-item form-row{% endif %}" data-item-id="{{ item.id }}" data-store="cart-item-{{ item.product.id }}" data-component="cart.line-item">

  {% set show_free_shipping_label = item.product.free_shipping and not (cart.free_shipping.cart_has_free_shipping or cart.free_shipping.min_price_free_shipping.min_price) %}

  {# Cart item image #}
  <div class="{% if cart_page %}col-3 col-md-1{% else %}col-2{% endif %}">
    <a href="{{ item.url }}">
      <img src="{{ item.featured_image | product_image_url('medium') }}" class="img-fluid{% if settings.theme_rounded %} box-rounded-small{% endif %}" />
    </a>
  </div>
  <div class="{% if cart_page %}col-9 col-md-10 pl-0 pl-md-3{% else %}col-10 d-flex align-items-center{% endif %}">
    <div class="{% if cart_page %}row align-items-md-center{% else %}w-100{% endif %}">
      {# Cart item name #}
      <h6 class="{% if cart_page %}col-10 col-md-5 h4-md font-weight-normal mb-3 mb-md-0{% else %}cart-item-name{% endif %}" data-component="line-item.name">
        <a href="{{ item.url }}" data-component="name.short-name">
          {{ item.short_name }}
        </a>
        <small data-component="name.short-variant-name">{{ item.short_variant_name }}</small>
        {% if show_free_shipping_label %}
          <div class="my-1">
            <span class="label label-accent label-small font-smallest">{{ "Envío gratis" | translate }}</span>
          </div>
        {% endif %}
      </h6>

      {% if cart_page %}
        {% set cart_quantity_class = 'float-md-none m-auto ' %}
      {% else %}
        {% set cart_quantity_class = 'float-left ' %}
      {% endif %}

      {# Cart item quantity controls #}
      <div class="cart-item-quantity {% if cart_page %}col-7 col-md-3 text-center{% endif %}" data-component="line-item.subtotal">
        {% embed "snipplets/forms/form-input.tpl" with{
          type_number: true, 
          input_value: item.quantity, 
          input_name: 'quantity[' ~ item.id ~ ']', 
          input_data_attr: 'item-id',
          input_data_val: item.id,
          input_group_custom_class: cart_quantity_class ~ 'form-quantity cart-item-quantity small mb-0', 
          input_custom_class: 'js-cart-quantity-input text-center h6', 
          input_label: false, input_append_content: true, 
          data_component: 'quantity.value',
          form_control_container_custom_class: 'col'} %}
            {% block input_prepend_content %}
            <div class="row m-0 align-items-center ">
              <span class="js-cart-quantity-btn form-quantity-icon btn" onclick="LS.minusQuantity({{ item.id }}{% if not cart_page %}, true{% endif %})" data-component="quantity.minus">
                {% include "snipplets/svg/minus.tpl" with {svg_custom_class: "icon-inline icon-w-12 svg-icon-primary"} %}
              </span>
            {% endblock input_prepend_content %}
            {% block input_append_content %}
              
              {# Always place this spinner before the quantity input #}
        
              <span class="js-cart-input-spinner cart-item-spinner" style="display: none;">
                {% include "snipplets/svg/circle-notch.tpl" with {svg_custom_class: "icon-inline icon-spin svg-icon-primary"} %}
              </span>

              <span class="js-cart-quantity-btn form-quantity-icon btn" onclick="LS.plusQuantity({{ item.id }}{% if not cart_page %}, true{% endif %})" data-component="quantity.plus">
                {% include "snipplets/svg/plus.tpl" with {svg_custom_class: "icon-inline icon-w-12 svg-icon-primary"} %}
              </span>
            </div>
            {% endblock input_append_content %}
        {% endembed %}
      </div>

      {% if cart_page %}
        {# Cart item unit price #}
        <h4 class="cart-item-subtotal-short col-2 mb-0 mt-2 text-center font-weight-normal d-none d-md-block" data-line-item-id="{{ item.id }}">{{ item.unit_price | money }}</h4>
      {% endif %}

      {# Cart item subtotal #}
      <h5 class="js-cart-item-subtotal {% if cart_page %}col-5 col-md-2 text-right text-md-center mb-0 mt-2 h4-md{% else %}cart-item-subtotal h6{% endif %}" data-line-item-id="{{ item.id }}" data-component="subtotal.value" data-component-value={{ item.subtotal | money }}'>{{ item.subtotal | money }}</h5>
    </div>
  </div>

  {# Cart item delete #}
  <div class="cart-item-delete {% if cart_page %}position-relative-md col-auto col-md-1{% else %}col-1{% endif %} text-right" >
    <button type="button" class="btn {% if cart_page %}h6 h5-md mb-0{% endif %}" onclick="LS.removeItem({{ item.id }}{% if not cart_page %}, true{% endif %})" data-component="line-item.remove">
      {% include "snipplets/svg/trash-alt.tpl" with {svg_custom_class: "icon-inline svg-icon-text icon-lg"} %}
    </button>
  </div>

  {% if cart_page %}
    <div class="col-12"><div class="divider"></div></div>
  {% endif %}
</div>