<ul class="contact-info">
	{% if store.whatsapp %}
		<li class="contact-item">{% include "snipplets/svg/whatsapp.tpl" with {svg_custom_class: "icon-inline icon-lg icon-w contact-item-icon"} %}<a href="{{ store.whatsapp }}" class="contact-link">{{ store.whatsapp |trim('https://wa.me/') }}</a></li>
	{% endif %}
	{% if store.phone %}
		<li class="contact-item">{% include "snipplets/svg/phone.tpl" with {svg_custom_class: "icon-inline icon-lg icon-w contact-item-icon"} %}<a href="tel:{{ store.phone }}" class="contact-link">{{ store.phone }}</a></li>
	{% endif %}
	{% if store.email %}
		<li class="contact-item">{% include "snipplets/svg/email.tpl" with {svg_custom_class: "icon-inline icon-lg icon-w contact-item-icon"} %}<a href="mailto:{{ store.email }}" class="contact-link">{{ store.email }}</a></li>
	{% endif %}
	{% if store.address and not is_order_cancellation %}
		<li class="contact-item">{% include "snipplets/svg/map-marker-alt.tpl" with {svg_custom_class: "icon-inline icon-lg icon-w contact-item-icon"} %}{{ store.address }}</li>
	{% endif %}
	{% if store.blog %}
		<li class="contact-item">{% include "snipplets/svg/comments.tpl" with {svg_custom_class: "icon-inline icon-lg icon-w contact-item-icon"} %}<a target="_blank" href="{{ store.blog }}" class="contact-link">{{ "Visita nuestro Blog!" | translate }}</a></li>
	{% endif %}
</ul>