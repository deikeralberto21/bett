{% set newsletter_contact_error = contact.type == 'newsletter' and not contact.success %}

{% if settings.news_show %}
    <section class="section-newsletter-home bg-primary">
        <div class="container-fluid">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6 text-center">
                    <div class="js-newsletter newsletter">
                        <div class="mb-4 text-uppercase">{{ 'Newsletter' | translate }}</div>
                        {% if settings.news_title %}
                            <h3 class="h1 mb-4">{{ settings.news_title }}</h3>
                        {% endif %}
                        {% if settings.news_text %}
                            <p>{{ settings.news_text }}</p>
                        {% endif %}
                    
                        {% if contact and contact.type == 'newsletter' %}
                            {% if contact.success %}
                                <div class="alert alert-success">{{ "¡Gracias por suscribirte! A partir de ahora vas a recibir nuestras novedades en tu email" | translate }}</div>
                            {% else %}
                                <div class="alert alert-danger">{{ "Necesitamos tu email para enviarte nuestras novedades." | translate }}</div>
                            {% endif %}
                        {% endif %}

                        <form class="mt-5" method="post" action="/winnie-pooh" onsubmit="this.setAttribute('action', '');" data-store="newsletter-form">
                            <div class="input-append">
                              
                                {% embed "snipplets/forms/form-input.tpl" with{input_for: 'email', type_email: true, input_name: 'email', input_id: 'email', input_placeholder: 'Email' | translate, input_custom_class: "form-control-big", input_aria_label: 'Email' | translate } %}
                                {% endembed %}

                            <div class="winnie-pooh" style="display: none;">
                                <label for="winnie-pooh-newsletter">{{ "No completar este campo" | translate }}</label>
                                <input id="winnie-pooh-newsletter" type="text" name="winnie-pooh"/>
                            </div>
                            <input type="hidden" name="name" value="{{ "Sin nombre" | translate }}" />
                            <input type="hidden" name="message" value="{{ "Pedido de inscripción a newsletter" | translate }}" />
                            <input type="hidden" name="type" value="newsletter" />
                            <input type="submit" name="contact" class="btn newsletter-btn" value="{{ "Enviar" | translate }}" />
                            {% include "snipplets/svg/arrow-right.tpl" with {svg_custom_class: "icon-inline newsletter-btn svg-icon-primary"} %}
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>
{% endif %}