{% if template == 'home' %}
    <h1 class="h3 m-0">
{% endif %}
<div id="logo" class="logo-img-container {% if not has_logo %}hidden{% endif %}">
    {% set logo_dimensions = store.logo_dimensions() %}
    {% set width = logo_dimensions ? logo_dimensions.width : null %}
    {% set height = logo_dimensions ? logo_dimensions.height : null %}
    {{ store.logo('medium') | img_tag(store.name, {class: 'logo-img  transition-soft', width: width, height: height})}}
</div>
<div id="no-logo" class="logo-text-container {% if has_logo %} hidden{% endif %}">
    <a class="logo-text h5 h3-md">{{ store.name }}</a>
</div>
{% if template == 'home' %}
    </h1>
{% endif %}