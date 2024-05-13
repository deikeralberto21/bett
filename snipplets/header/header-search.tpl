<form class="js-search-container js-search-form search-container" action="{{ store.search_url }}" method="get">
	<div class="form-group m-0">
        <input class="js-search-input form-control search-input" autocomplete="off" type="search" name="q" placeholder="{{ '¿Qué estás buscando?' | translate }}" aria-label="{{ '¿Qué estás buscando?' | translate }}" />
        <button type="submit" class="btn search-input-submit" value="{{ 'Buscar' | translate }}" aria-label="{{ 'Buscar' | translate }}">
            {% include "snipplets/svg/search.tpl" with {svg_custom_class: "icon-inline icon-2x"} %}
        </button>
	</div>
</form>
<div class="js-search-suggest search-suggest">
    {# AJAX container for search suggestions #}
</div>
