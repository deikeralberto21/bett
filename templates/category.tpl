{% set has_filters_available = products and has_filters_enabled and (filter_categories is not empty or product_filters is not empty) %}

{# Only remove this if you want to take away the theme onboarding advices #}
{% set show_help = not has_products %}
{% paginate by 12 %}

{% if not show_help %}

{% set category_banner = (category.images is not empty) or ("banner-products.jpg" | has_custom_image) %}
{% if category_banner %}
    {% include 'snipplets/category-banner.tpl' %}
{% endif %}
<section class="container {% if not category.description %}d-md-none{% endif %}">
	<div class="row">
		{% if category.description and category_banner %}
			<div class="category-banner-header background-main">
		{% endif %}
			<div class="col-12 d-md-none">
			</div>
			<div class="col">
				{% embed "snipplets/page-header.tpl" %}
					{% block page_header_text %}{{ category.name }}{% endblock page_header_text %}
				{% endembed %}
				<!-- CRoquetas -->
				<div style="width: 100%;display:flex;justify-content:center;gap:10px">
					{% if category.name == 'CACHORRO' %}
						<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/cachorros/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/alimentos2/cachorros1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'ADULTO' %}
						<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/adultos/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/alimentos2/adultos1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'SENIOR' %}
						<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/senior-7/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/alimentos2/senior-71/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'SOBRES' %}
						<a href="https://beethovenvillavo.com/perros/alimentos1/alimento-humedo/pouches-y-latas/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/alimentos2/alimento-humedo2/pouches-y-latas-alimento-humedo/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'LATAS' %}
						<a href="https://beethovenvillavo.com/perros/alimentos1/alimento-humedo/latas2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/alimentos2/alimento-humedo2/latas1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'MEDICADOS' %}
						<a href="https://beethovenvillavo.com/dieta-blanda-medicada" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/medicados2" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'JUGUETES' %}
						<a href="https://beethovenvillavo.com/gatos/accesorios2/juguetes1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/accesorios2/juguetes2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'COLLARES, ARNES E INDUMENTARIA' %}
						<a href="https://beethovenvillavo.com/perros/accesorios1/collares-e-indumentaria/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/accesorios2/collares-y-pecheras/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'CEPILLOS / CORTAUÑAS' %}
						<a href="https://beethovenvillavo.com/perros/accesorios1/cepillos-y-cortaunas/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/accesorios2/cepillos-y-deslanadores1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'ANTIPULGAS Y GARRAPATAS' %}
						<a href="https://beethovenvillavo.com/perros/farmacia2/antipulgas-y-garrapatas2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/farmacia1/antipulgas-y-garrapatas1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'DESPARASITANTES / PURGANTES' %}
						<a href="https://beethovenvillavo.com/perros/farmacia2/desparasitantes-purgantes2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/farmacia1/desparasitantes-purgantes1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'PARA BAÑO' %}
						<a href="https://beethovenvillavo.com/perros/higiene-y-cuidados/para-bano/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/limpieza-higiene-y-cuidados/para-bano1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'ENSEÑANZA' %}
						<a href="https://beethovenvillavo.com/perros/higiene-y-cuidados/ensenanza1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/limpieza-higiene-y-cuidados/ensenanza2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'SALUD ORAL' %}
						<a href="https://beethovenvillavo.com/perros/higiene-y-cuidados/salud-oral1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/limpieza-higiene-y-cuidados/salud-oral2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'OREJAS' %}
						<a href="https://beethovenvillavo.com/perros/higiene-y-cuidados/orejas1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/limpieza-higiene-y-cuidados/orejas2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'DIGESTIVAS' %}
						<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/gastrointestinal/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/gastrointestinal2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'RENAL / URINARIAS' %}
						<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/renal-urinary/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/renal-urinary2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'HEPATICAS' %}
						<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/hepatico/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/hepatico2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'SOBREPESO / DIABETES' %}
						<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/obesidad/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/obesidad2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'OTRAS PATOLOGIAS' %}
						<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/otros/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/otros2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'ALERGIAS' %}
						<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/alergias/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/alergias2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'DENTALES' %}
						<a href="https://beethovenvillavo.com/dentales1" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/dentales2" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'GALLETAS' %}
						<a href="https://beethovenvillavo.com/galletas-y-huesos?mpage=2" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/galletas1" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					{% if category.name == 'NATURALES' %}
						<a href="https://beethovenvillavo.com/opciones-naturales" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">PERROS</a>
						<a href="https://beethovenvillavo.com/naturales1" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03">GATOS</a>	
					{% endif %}
					</div>
					<!-- MARcas -->
					
					
			</div>
		{% if category.description and category_banner %}
			</div>
		{% endif %}
	</div>
	
</section>

<section class="js-category-controls-prev category-controls-sticky-detector"></section>
<section class="js-category-controls category-controls container visible-when-content-ready">
	<div style="width: 100%;display:flex;justify-content:space-between;align-items:center;margin-bottom:5px;gap:5px;">
		{% if category.name == 'AGILITY GOLD' %}
		<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/marcas-perro/agility-gold/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
		<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/marcas-gato/agility-gold2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == 'BIRBO' %}
			<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/marcas-perro/ver-mas1/birbo-perro/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/marcas-gato/birbo-gato/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == 'CHUNKY' %}
			<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/marcas-perro/chunky-italcan/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/marcas-gato/chunky1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == 'CHURU' %}
			<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/marcas-perro/ver-mas1/churu1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/marcas-gato/ver-mas4/churu2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == 'EQUILIBRIO' %}
			<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/marcas-perro/equilibrio1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/marcas-gato/equilibrio3/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == 'EXCELLENT' %}
			<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/marcas-perro/excellent-purina/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/marcas-gato/excellent1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == 'EVOLVE' %}
			<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/marcas-perro/evolve1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/marcas-gato/evolve2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == 'FORMULA NATURAL' %}
			<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/marcas-perro/formula-natural1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/marcas-gato/formula-natural2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == 'HILLS' %}
			<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/marcas-perro/hills1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/marcas-gato/hills3/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == 'MONELLO' %}
			<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/marcas-perro/monello1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/marcas-gato/monello2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == 'N&D' %}
			<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/marcas-perro/ver-mas1/n-d/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/marcas-gato/ver-mas4/nd1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == 'NULO' %}
			<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/marcas-perro/ver-mas1/nulo/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/marcas-gato/ver-mas4/nulo1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == 'NUPEC' %}
			<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/marcas-perro/nupec1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/marcas-gato/nupec2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == 'ORIJEN & ACANA' %}
			<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/marcas-perro/orijen-acana1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/marcas-gato/orijen-acana2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == 'PRO PLAN' %}
			<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/marcas-perro/pro-plan1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/marcas-gato/pro-plan3/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == 'ROYAL CANIN' %}
			<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/marcas-perro/royal-canin1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/marcas-gato/royal-canin3/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == 'TASTE OF THE WILD' %}
			<a href="https://beethovenvillavo.com/perros/alimentos1/alimentos/marcas-perro/taste-of-the-wild1/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/marcas-gato/taste-of-the-wild2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == 'VET LIFE' %}
			<a href="https://beethovenvillavo.com/vet-life3/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/marcas3/vet-life2/" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
			
		{% if category.name == '' %}
			<a href="" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">PERROS</a>
			<a href="" style="padding: 10px 15px;border-radius:15px;color:white;font-style:bold;text-align:center;background:#fdcc03;width:50%;">GATOS</a>	
		{% endif %}
	</div>
	<div class="row align-items-center mb-md-5">
		<div class="{% if products %}col-9{% else %}col-12{% endif %} d-none d-md-block">
			<div class="row">
				<div class="col-auto align-self-center">
				</div>
				<div class="visible-when-content-ready col text-right">
					{% include "snipplets/grid/filters.tpl" with {applied_filters: true} %}
				</div>
			</div>
		</div>
		<div class="visible-when-content-ready col-6 col-md-3 d-md-none">
		{% if has_filters_available %}
			<a href="#" class="js-modal-open js-fullscreen-modal-open btn-default" data-toggle="#nav-filters" data-modal-url="modal-fullscreen-filters" data-component="filter-button">
				<div class="row align-items-center">
					<div class="col font-weight-bold">
						{{ 'Filtrar' | t }}
					</div>
					<div class="col text-right">
						{% include "snipplets/svg/filter.tpl" with { svg_custom_class: "icon-inline"} %}
					</div>
				</div>
			</a>
			{% embed "snipplets/modal.tpl" with{modal_id: 'nav-filters', modal_class: 'filters', modal_position: 'right', modal_transition: 'slide', modal_header: true, modal_width: 'full', modal_mobile_full_screen: 'true' } %}
				{% block modal_head %}
					{{'Filtros ' | translate }}
				{% endblock %}
				{% block modal_body %}
					{% include "snipplets/grid/categories.tpl" with {mobile: true} %}
				   	{% include "snipplets/grid/filters.tpl" with {mobile: true} %}
					<div class="js-filters-overlay filters-overlay" style="display: none;">
						<div class="filters-updating-message">
							<h3 class="js-applying-filter" style="display: none;">{{ 'Aplicando filtro...' | translate }}</h3>
							<h3 class="js-removing-filter" style="display: none;">{{ 'Borrando filtro...' | translate }}</h3>
						</div>
					</div>
				{% endblock %}
			{% endembed %}

		{% endif %}
		</div>
		{% if products %}
			<div class="{% if has_filters_available %}col-6{% else %}col-8 offset-2 offset-md-0{% endif %} col-md-3">
				{% include 'snipplets/grid/sort-by.tpl' %}
			</div>
		{% endif %} 
	</div>
</section>

<div class="container visible-when-content-ready d-md-none">
	{% include "snipplets/grid/filters.tpl" with {mobile: true, applied_filters: true} %}
</div>

<section class="category-body">
	<div class="container">
		<div class="row">
			{% if has_filters_available %} 
				<div class="col col-md-2 d-none pr-0 d-md-block visible-when-content-ready">
					{% if filter_categories is not empty %}
						{% include "snipplets/grid/categories.tpl" %}
					{% endif %}
					{% if product_filters is not empty %}	   
						{% include "snipplets/grid/filters.tpl" %}
					{% endif %}
				</div>
			{% endif %}
			<div class="col" data-store="category-grid-{{ category.id }}">
				{% if products %}
					<div class="js-product-table row">
						{% include 'snipplets/product_grid.tpl' %}
					</div>
					{% if pages.current == 1 and not pages.is_last %}
						<div class="text-center mt-5 mb-5">
							<a class="js-load-more btn btn-primary">
								<span class="js-load-more-spinner pull-left m-right-quarter" style="display:none;">{% include "snipplets/svg/circle-notch.tpl" with {svg_custom_class: "icon-inline icon-spin"} %}</span>
								{{ 'Mostrar más productos' | t }}
							</a>
						</div>
						<div id="js-infinite-scroll-spinner" class="mt-5 mb-5 text-center w-100" style="display:none">
							{% include "snipplets/svg/circle-notch.tpl" with {svg_custom_class: "icon-inline icon-3x svg-icon-text icon-spin"} %} 
						</div>
					{% endif %}
				{% else %}
					<h6 class="text-center mt-5" data-component="filter.message">
						{{(has_filters_enabled ? "No tenemos resultados para tu búsqueda. Por favor, intentá con otros filtros." : "Próximamente") | translate}}
					</h6>
				{% endif %}
			</div>
		</div>
	</div>
</section>
{% elseif show_help %}
	{# Category Placeholder #}
	{% include 'snipplets/defaults/show_help_category.tpl' %}
{% endif %}