{% if store.whatsapp %}
    <a id="whatsapp-icon" href="{{ store.whatsapp }}" target="_blank" class="js-btn-fixed-bottom btn-whatsapp" aria-label="{{ 'Comunicate por WhatsApp' | translate }}">
        {% include "snipplets/svg/whatsapp.tpl" with {'chat' : true} %}
    </a>
{% endif %}
