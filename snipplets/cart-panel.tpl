<div class="js-ajax-cart-list cart-row">
    {# Cart panel items #}
    {% if cart.items %}
      {% for item in cart.items %}
        {% include "snipplets/cart-item-ajax.tpl" %}
      {% endfor %}
    {% endif %}
</div>
<div class="js-empty-ajax-cart cart-row" {% if cart.items_count > 0 %}style="display:none;"{% endif %}>
 	{# Cart panel empty #}
    <div class="alert alert-info" data-component="cart.empty-message">{{ "El carrito de compras está vacío." | translate }} </div>
</div>
<div id="error-ajax-stock" style="display: none;">
	<div class="alert alert-warning">
     	{{ "¡Uy! No tenemos más stock de este producto para agregarlo al carrito. Si querés podés" | translate }}<a href="{{ store.products_url }}" class="btn-link ml-1">{{ "ver otros acá" | translate }}</a>
    </div>
</div>
  <div style="display: flex;flex-direction:column;gap:5px;background-color:black;color:yellow;justify-content:center;align-items:center;text-align:center">
    <div style="display: flex;gap:5px;">
      <ion-icon style="fill: yellow;font-size:1.8em" name="alert-circle-sharp"></ion-icon>
      <h3 style="color:yellow">WARNING<h3>
    </div>
    <p>ESTAS A PUNTO DE COMPRAR EN 
      VILLAVICENCIO, PARA CAMBIAR A BOGOTA
      POR FAVOR CLICK AQUI</p>
    <a href="https://beethovenpetcare.com" style="border: none; border-radius:10px; background-color: #fdcc03; padding: 10px; width: max-content; font-family: 'Fredoka One', sans-serif; font-size:1.2em; color:white;">CAMBIAR</a>
  </div>
<div class="cart-row">
    {% include "snipplets/cart-totals.tpl" %}
</div>

