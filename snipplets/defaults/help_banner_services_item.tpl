<div class="service-item-container col-md swiper-slide p-0 px-md-3">
    <div class="service-item mx-4 mx-md-0">
    	<div class="row align-items-center">
		    {% if help_item_1 %}
		    	<div class="col-auto">
		    		{% include "snipplets/svg/shipping-circle.tpl" with {svg_custom_class: "icon-inline icon-5x svg-icon-text"} %}
		    	</div>
		    	<div class="col p-0">
		        	<h3 class="h5 m-0">{{ "Medios de envío" | translate }}</h3>
		    	</div>
		    {% elseif help_item_2 %}
		    	<div class="col-auto">
		    		{% include "snipplets/svg/credit-card-circle.tpl" with {svg_custom_class: "icon-inline icon-5x svg-icon-text"} %}
		    	</div>
		    	<div class="col p-0">
		        	<h3 class="h5 m-0">{{ "Tarjetas de crédito" | translate }}</h3>
		        </div>
		    {% elseif help_item_3 %}
		    	<div class="col-auto">
		    		{% include "snipplets/svg/whatsapp-circle.tpl" with {svg_custom_class: "icon-inline icon-5x svg-icon-text"} %}
		    	</div>
		    	<div class="col p-0">
		        	<h3 class="h5 m-0">{{ "WhatsApp" | translate }}</h3>
		        </div>
		    {% elseif help_item_4 %}
		    	<div class="col-auto">
		    		{% include "snipplets/svg/security-circle.tpl" with {svg_custom_class: "icon-inline icon-5x svg-icon-text"} %}
		    	</div>
		    	<div class="col p-0">
		        	<h3 class="h5 m-0">{{ "Sitio seguro" | translate }}</h3>
		        </div>
		    {% endif %}
		</div>
    </div>
</div>