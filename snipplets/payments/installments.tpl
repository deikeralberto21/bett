{% if product %}
  {% set hasDiscount = product.maxPaymentDiscount.value > 0 %}

  {# Product installments #}

  {% if product.show_installments and product.display_price %}

    {% set installments_info_base_variant = product.installments_info %}
    {% set installments_info = product.installments_info_from_any_variant %}

    {# If product detail installments, include container with "see installments" link #}

    {% if product_detail and ( installments_info or hasDiscount ) %}
      <div data-toggle="#installments-modal" data-modal-url="modal-fullscreen-payments" class="js-modal-open js-fullscreen-modal-open js-product-payments-container row mb-4" {% if (not product.get_max_installments) and (not product.get_max_installments(false)) %}style="display: none;"{% endif %}>
    {% endif %}

    {% set product_can_show_installments = product.show_installments and product.display_price and product.get_max_installments.installment > 1 %}

    {% if product_can_show_installments %}
      {% set max_installments_without_interests = product.get_max_installments(false) %}
      {% set max_installments_with_interests = product.get_max_installments %}

      {% set has_no_interest_payments = max_installments_without_interests and max_installments_without_interests.installment > 1 %}

      {% if has_no_interest_payments %}
        {% set card_icon_color = 'svg-icon-accent' %}
      {% else %}
        {% set card_icon_color = 'svg-icon-text' %}
      {% endif %}

      {# If NOT product detail, just include installments alone without link or container #}
      {% if not hidden_product_installments %}
        <span class="js-max-installments-container js-max-installments {% if product_detail %}col-12 mb-2{% else %}item-installments{% endif %}">
          {% if product_detail %}
            <span class="float-left mr-2">
              {% include "snipplets/svg/credit-card.tpl" with {svg_icon_underline: true, svg_custom_class : "icon-inline " ~ card_icon_color ~ " icon-lg"} %}
            </span>
          {% endif %}
          {% if product_detail %}
          <span class="d-table">
          {% endif %}

          {% if has_no_interest_payments %}
            <span class="js-max-installments">
              {% if product_detail %}

                {# Accent color used on product detail #}

                {{ "<span class='text-accent font-weight-bold'><span class='js-installment-amount installment-amount'>{1}</span> cuotas sin interés</span> de <span class='js-installment-price installment-price'>{2}</span>" | t(max_installments_without_interests.installment, max_installments_without_interests.installment_data.installment_value_cents | money) }}
              {% else %}
                {{ "<span class='js-installment-amount installment-amount font-weight-bold'>{1}</span> cuotas sin interés de <span class='js-installment-price installment-price font-weight-bold'>{2}</span>" | t(max_installments_without_interests.installment, max_installments_without_interests.installment_data.installment_value_cents | money) }}
              {% endif %}
            </span>
          {% else %}
            {% if store.country != 'AR' or product_detail %}
              {% set max_installments_with_interests = product.get_max_installments %}
              {% if max_installments_with_interests %}
                <span class="js-max-installments">{{ "<span class='js-installment-amount installment-amount font-weight-bold'>{1}</span> cuotas de <span class='js-installment-price installment-price font-weight-bold'>{2}</span>" | t(max_installments_with_interests.installment, max_installments_with_interests.installment_data.installment_value_cents | money) }}</span>
              {% else %}
                <span class="js-max-installments" style="display: none;">
                  {% if product.max_installments_without_interests %}
                    {% if product_detail %}

                      {# Accent color used on product detail #}

                      {{ "<span class='text-accent font-weight-bold'><span class='js-installment-amount installment-amount'>{1}</span> cuotas sin interés</span> de <span class='js-installment-price installment-price'>{2}</span>" | t(null, null) }}
                    {% else %}
                      {{ "<span class='js-installment-amount installment-amount font-weight-bold'>{1}</span> cuotas sin interés de <span class='js-installment-price installment-price font-weight-bold'>{2}</span>" | t(null, null) }}
                    {% endif %}
                  {% else %}
                    {{ "<span class='js-installment-amount installment-amount font-weight-bold'>{1}</span> cuotas de <span class='js-installment-price installment-price font-weight-bold'>{2}</span>" | t(null, null) }}
                  {% endif %}
                </span>
              {% endif %}
            {% endif %}
          {% endif %}

          {% if product_detail %}
          </span>
          {% endif %}
        </span>
      {% endif %}
    {% endif %}

    {# Max Payment Discount #}

    {% if product_detail and hasDiscount %}
      <span class="col-12 mb-2">
        <span class="float-left mr-2">
          {% include "snipplets/svg/money-bill.tpl" with {svg_icon_underline: true, svg_custom_class : "icon-inline svg-icon-accent icon-lg"} %}
        </span>
        <span><strong class="text-accent">{{ product.maxPaymentDiscount.value }}% {{'de descuento' | translate }}</strong> {{'pagando con' | translate }} {{ product.maxPaymentDiscount.paymentProviderName }}</span>
      </span>
      {% if not installments_info %}
        </div>
      {% endif %}
    {% endif %}

    {% if product_detail and installments_info %}
      <a id="btn-installments" class="btn-link btn-link-primary font-small col mt-1" {% if (not product.get_max_installments) and (not product.get_max_installments(false)) %}style="display: none;"{% endif %}>
        <span class="d-table">
          {% if not hasDiscount and not settings.product_detail_installments %}
            {% include "snipplets/svg/credit-card.tpl" with {svg_custom_class : "icon-inline icon-lg svg-icon-primary mr-1"} %}
            {{ "Ver medios de pago" | translate }}
          {% else %}
            {{ "Ver más detalles" | translate }}
          {% endif %}
        </span>
      </a>
    </div>
    {% endif %}

  {% endif %}
{% else %}

  {# Cart installments #}

  {% if cart.installments.max_installments_without_interest > 1 %}
    {% set installment =  cart.installments.max_installments_without_interest  %}
    {% set total_installment = cart.total %}
    {% set interest = false %}
    {% set interest_value = 0 %}
  {% else %}
    {% set installment = cart.installments.max_installments_with_interest  %}
    {% set total_installment = (cart.total * (1 + cart.installments.interest)) %}
    {% set interest = true %}
    {% set interest_value = cart.installments.interest %}
  {% endif %}
  <div {% if installment < 2 or ( store.country == 'AR' and interest == true ) %} style="display: none;" {% endif %} data-interest="{{ interest_value }}" data-cart-installment="{{ installment }}" class="js-installments-cart-total text-right {% if interest == false %}text-accent font-weight-bold{% endif %}">
    {{ 'O hasta' | translate }}
    {% if interest == true %}
      {{ "<strong class='js-cart-installments-amount'>{1}</strong> cuotas de <strong class='js-cart-installments installment-price'>{2}</strong>" | t(installment, (total_installment / installment) | money) }}
    {% else %}
      {{ "<span class='js-cart-installments-amount'>{1}</span> cuotas sin interés de <span class='js-cart-installments installment-price'>{2}</span>" | t(installment, (total_installment / installment) | money) }}
    {% endif %}
  </div>

{% endif %}
