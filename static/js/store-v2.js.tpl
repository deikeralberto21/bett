{#/*============================================================================
    #Specific store JS functions: product variants, cart, shipping, etc
==============================================================================*/#}

{#/*============================================================================

	Table of Contents

	#Lazy load
	#Notifications and tooltips
	#Modals
	#Tabs
	#Cards
	#Accordions
    #Pop Ups
        // Cat or Dog Pop Up
        // WhatsApp Pop Up
        // Beethoven App Pop Up
	#Header and nav
		// Header
        // Breadcrumbs
        // Hide Breadcrumbs
        // Hide Account
        // Hide Top Sections and Add Icons
        // Change colors menu nav and footer
        // Change link WhatsApp
        // Add title and button to the brand carrousel
        // Postal Code
        // Adjust sections 
		// Utilities
		// Nav
        // Nav Bottom
		// Search suggestions
	#Sliders
		// Home slider
		// Products slider
		// Brand slider
		// Product related
		// Banner services slider
        // Home Banner
	#Social
		// Youtube or Vimeo video
		// Instagram feed
	#Product grid
        // Secondary image on mouseover
        // Fixed category controls
        // Navigation Buttons
        // Brand Carousel
		// Filters
		// Sort by
		// Infinite scroll
		// Quickshop
	#Product detail functions
		// Installments
		// Change Variant
		// Submit to contact form
		// Product labels on variant change
		// Color and size variants change
		// Custom mobile variants change
		// Submit to contact
		// Product slider
		// Pinterest sharing
		// Add to cart
		// Product quantity
	#Cart
		// Toggle cart 
		// Add to cart
		// Cart quantitiy changes
		// Empty cart alert
	#Shipping calculator
		// Select and save shipping function
		// Calculate shipping function
		// Calculate shipping by submit
		// Shipping and branch click
		// Select shipping first option on results
		// Toggle branches link
		// Toggle more shipping options
		// Calculate shipping on page load
		// Shipping provinces
		// Change store country
    #Brands Page
	#Forms
	#Footer
	#Empty placeholders
    #Extras

==============================================================================*/#}

// Move to our_content
window.urls = {
    "shippingUrl": "{{ store.shipping_calculator_url | escape('js') }}"
}


{#/*============================================================================
  #Lazy load
==============================================================================*/ #}

document.addEventListener('lazybeforeunveil', function(e){
    if ((e.target.parentElement) && (e.target.nextElementSibling)) {
        var parent = e.target.parentElement;
        var sibling = e.target.nextElementSibling;
        if (sibling.classList.contains('js-lazy-loading-preloader')) {
            sibling.style.display = 'none';
            parent.style.display = 'block';
        }
    }
});


window.lazySizesConfig = window.lazySizesConfig || {};
lazySizesConfig.hFac = 0.4;


DOMContentLoaded.addEventOrExecute(() => {
	{#/*============================================================================
	  #Notifications and tooltips
	==============================================================================*/ #}

    {# /* // Close notification and tooltip */ #}

    jQueryNuvem(".js-notification-close, .js-tooltip-close").on( "click", function(e) {
        e.preventDefault();
        jQueryNuvem(e.currentTarget).closest(".js-notification, .js-tooltip").hide();
        jQueryNuvem(".js-quick-login-badge").hide();
    });

    {# Notifications variables #}

    var $notification_order_cancellation = jQueryNuvem(".js-notification-order-cancellation");
    var $notification_status_page = jQueryNuvem(".js-notification-status-page");
    var $quick_login_notification = jQueryNuvem(".js-notification-quick-login");
    var $fixed_bottom_button = jQueryNuvem(".js-btn-fixed-bottom");
    
	{# /* // Follow order status notification */ #}
    
    if ($notification_status_page.length > 0){
        if (LS.shouldShowOrderStatusNotification($notification_status_page.data('url'))){
            $notification_status_page.show();
        };
        jQueryNuvem(".js-notification-status-page-close").on( "click", function(e) {
            e.preventDefault();
            LS.dontShowOrderStatusNotificationAgain($notification_status_page.data('url'));
        });
    }

    {# /* // Order cancellation notification */ #}

    if ($notification_order_cancellation.length > 0){
        if (LS.shouldShowOrderCancellationNotification($notification_order_cancellation.data('url'))){

            {% if not params.preview %}
                {# Show order cancellation notification only if cookie banner is not visible #}

                if (window.cookieNotificationService.isAcknowledged()) {
            {% endif %}
                    $notification_order_cancellation.show();
            {% if not params.preview %}
                }
            {% endif %}
            
            $fixed_bottom_button.css("marginBottom", "40px");

            {% if store.country == 'AR' and template == 'home' and status_page_url %}
                {# If cancellation order notification move quick login #}
                $quick_login_notification.css("bottom" , "40px");
            {% endif %}
        };
        jQueryNuvem(".js-notification-order-cancellation-close").on( "click", function(e) {
            e.preventDefault();
            LS.dontShowOrderCancellationNotification($notification_order_cancellation.data('url'));
            $quick_login_notification.css("bottom" , "0px");
        });
    }

    {# /* // Cart notification: Dismiss notification */ #}

    jQueryNuvem(".js-cart-notification-close").on("click", function(){
        jQueryNuvem(".js-alert-added-to-cart").removeClass("notification-visible").addClass("notification-hidden");
        setTimeout(function(){
            jQueryNuvem('.js-cart-notification-item-img').attr('src', '');
            jQueryNuvem(".js-alert-added-to-cart").hide();
        },2000);
    });

    {% if not settings.head_fix %}

        {# /* // Add to cart notification on non fixed header */ #}

        var topBarHeight = jQueryNuvem(".js-topbar").outerHeight();
        var logoBarHeight = jQueryNuvem(".js-nav-logo-bar").outerHeight();
        var searchBarHeight = jQueryNuvem(".js-search-container").outerHeight();
        if (window.innerWidth > 768) {
            var fixedNotificationPosition = topBarHeight + logoBarHeight; 
        }else{
            var fixedNotificationPosition = logoBarHeight - searchBarHeight; 
        }
        var $addedToCartNotification = jQueryNuvem(".js-alert-added-to-cart");
        var $addedToCartNotificationArrow = $addedToCartNotification.find(".js-cart-notification-arrow-up");

        $addedToCartNotification.css("top", fixedNotificationPosition.toString() + 'px').css("marginTop", "-10px");

        !function () {
            window.addEventListener("scroll", function (e) {
                if (window.pageYOffset == 0) {
                    $addedToCartNotification.css("top" , fixedNotificationPosition.toString() + 'px');
                    $addedToCartNotificationArrow.css("visibility" , "visible");
                } else {
                    $addedToCartNotification.css("top" , "20px");
                    $addedToCartNotificationArrow.css("visibility" , "hidden");
                }
            });
        }();

    {% endif %}

    {# /* // Quick Login notification */ #}

    {% if not customer and template == 'home' %}

        {# Show quick login messages if it is returning customer #}

        setTimeout(function(){
            if (cookieService.get('returning_customer') && LS.shouldShowQuickLoginNotification()) {
                {% if store.country == 'AR' %}
                    jQueryNuvem(".js-quick-login-badge").fadeIn();
                    jQueryNuvem(".js-login-tooltip").show();
                    jQueryNuvem(".js-login-tooltip-desktop").show().addClass("visible");
                {% else %}
                    $quick_login_notification.fadeIn();
                {% endif %}
                return;
            }
            
        },500);

    {% endif %}

    {# Dismiss quick login notifications #}

    jQueryNuvem(".js-dismiss-quicklogin").on( "click", function(e) {
        LS.dontShowQuickLoginNotification();
    });


    setTimeout(function(){
        jQueryNuvem(".js-quick-login-success").fadeOut();
    },8000);

    {% if not params.preview %}

        {# /* // Cookie banner notification */ #}

        restoreNotifications = function(){

            // Whatsapp button position
            if (window.innerWidth < 768) {
                $fixed_bottom_button.css("marginBottom", "10px");
            }

            {# Restore notifications when Cookie Banner is closed #}

            var show_order_cancellation = ($notification_order_cancellation.length > 0) && (LS.shouldShowOrderCancellationNotification($notification_order_cancellation.data('url')));

            {% if store.country == 'AR' %}
                {# Order cancellation #}
                if (show_order_cancellation){
                    $notification_order_cancellation.show();
                    $fixed_bottom_button.css("marginBottom", "40px");
                }
            {% endif %}
        };

        if (!window.cookieNotificationService.isAcknowledged()) {
            jQueryNuvem(".js-notification-cookie-banner").show();

            {# Whatsapp button position #}
            if (window.innerWidth < 768) {
                $fixed_bottom_button.css("marginBottom", "120px");
            }
        }

        jQueryNuvem(".js-acknowledge-cookies").on( "click", function(e) {
            window.cookieNotificationService.acknowledge();
            restoreNotifications();
        });

    {% endif %}

    {#/*============================================================================
      #Modals
    ==============================================================================*/ #}

    {# Full screen mobile modals back events #}

    if (window.innerWidth < 768) {

        {# Clean url hash function #}

        cleanURLHash = function(){
            const uri = window.location.toString();
            const clean_uri = uri.substring(0, uri.indexOf("#"));
            window.history.replaceState({}, document.title, clean_uri);
        };

        {# Go back 1 step on browser history #}

        goBackBrowser = function(){
            cleanURLHash();
            history.back();
        };

        {# Clean url hash on page load: All modals should be closed on load #}

        if(window.location.href.indexOf("modal-fullscreen") > -1) {
            cleanURLHash();
        }

        {# Open full screen modal and url hash #}

        jQueryNuvem(document).on("click", ".js-fullscreen-modal-open", function(e) {
            e.preventDefault();
            var modal_url_hash = jQueryNuvem(this).data("modalUrl");
            window.location.hash = modal_url_hash;
        });

        {# Close full screen modal: Remove url hash #}

        jQueryNuvem(document).on("click", ".js-fullscreen-modal-close", function(e) {
            e.preventDefault();
            goBackBrowser();
        });

        {# Hide panels or modals on browser backbutton #}

        window.onhashchange = function() {
            if(window.location.href.indexOf("modal-fullscreen") <= -1) {

                {# Close opened modal #}

                if(jQueryNuvem(".js-fullscreen-modal").hasClass("modal-show")){

                    {# Remove body lock only if a single modal is visible on screen #}

                    if(jQueryNuvem(".js-modal.modal-show").length == 1){
                        jQueryNuvem("body").removeClass("overflow-none");
                    }
                    var $opened_modal = jQueryNuvem(".js-fullscreen-modal.modal-show");
                    var $opened_modal_overlay = $opened_modal.prev();

                    $opened_modal.removeClass("modal-show");
                    setTimeout(() => $opened_modal.hide(), 500);
                    $opened_modal_overlay.fadeOut(500);

                }
            }
        }

    }

    jQueryNuvem(document).on("click", ".js-modal-open", function(e) {
        e.preventDefault(); 
        var modal_id = jQueryNuvem(this).data('toggle');
        var $overlay_id = jQueryNuvem('.js-modal-overlay[data-modal-id="' + modal_id + '"]');
        if (jQueryNuvem(modal_id).hasClass("modal-show")) {
            let modal = jQueryNuvem(modal_id).removeClass("modal-show");
            setTimeout(() => modal.hide(), 500);
        } else {
            {# Lock body scroll if there is no modal visible on screen #}
            
            if(!jQueryNuvem(".js-modal.modal-show").length){
                jQueryNuvem("body").addClass("overflow-none");
            }
            $overlay_id.fadeIn(400);
            jQueryNuvem(modal_id).detach().appendTo("body");
            $overlay_id.detach().insertBefore(modal_id);
            jQueryNuvem(modal_id).show().addClass("modal-show");
        }             
    });

    jQueryNuvem(document).on("click", ".js-modal-close", function(e) {
        e.preventDefault();  

        {# Remove body lock only if a single modal is visible on screen #}

        if(jQueryNuvem(".js-modal.modal-show").length == 1){
            jQueryNuvem("body").removeClass("overflow-none");
        }
        var $modal = jQueryNuvem(this).closest(".js-modal");
        var modal_id = $modal.attr('id');
        var $overlay_id = jQueryNuvem('.js-modal-overlay[data-modal-id="#' + modal_id + '"]');
        $modal.removeClass("modal-show");
        setTimeout(() => $modal.hide(), 500);
        $overlay_id.fadeOut(500);
        
        {# Close full screen modal: Remove url hash #}

        if ((window.innerWidth < 768) && (jQueryNuvem(this).hasClass(".js-fullscreen-modal-close"))) {
            goBackBrowser();
        }
    });

    jQueryNuvem(document).on("click", ".js-modal-overlay", function(e) {
        e.preventDefault();

        {# Remove body lock only if a single modal is visible on screen #}

        if(jQueryNuvem(".js-modal.modal-show").length == 1){
            jQueryNuvem("body").removeClass("overflow-none");
        }

        var modal_id = jQueryNuvem(this).data('modalId');
        let modal = jQueryNuvem(modal_id).removeClass("modal-show");
        setTimeout(() => modal.hide(), 500);
        jQueryNuvem(this).fadeOut(500);
    });

    {% if template == 'home' and settings.home_promotional_popup %}

        {# /* // Home popup and newsletter popup */ #}

        jQueryNuvem('#news-popup-form').on("submit", function () {
            jQueryNuvem(".js-news-spinner").show();
            jQueryNuvem(".js-news-send, .js-news-popup-submit").hide();
            jQueryNuvem(".js-news-popup-submit").prop("disabled", true);
        });

        LS.newsletter('#news-popup-form-container', '#home-modal', '{{ store.contact_url | escape('js') }}', function (response) {
            jQueryNuvem(".js-news-spinner").hide();
            jQueryNuvem(".js-news-send, .js-news-popup-submit").show();
            var selector_to_use = response.success ? '.js-news-popup-success' : '.js-news-popup-failed';
            let newPopupAlert = jQueryNuvem(this).find(selector_to_use).fadeIn(100);
            setTimeout(() => newPopupAlert.fadeOut(500), 4000);
            if (jQueryNuvem(".js-news-popup-success").css("display") == "block") {
                setTimeout(function () {
                    jQueryNuvem('[data-modal-id="#home-modal"]').fadeOut(500);
                    let homeModal = jQueryNuvem("#home-modal").removeClass("modal-show");
                    setTimeout(() => homeModal.hide(), 500);
                }, 2500);
            }
            jQueryNuvem(".js-news-popup-submit").prop("disabled", false);
        });


        var callback_show = function(){
            jQueryNuvem('.js-modal-overlay[data-modal-id="#home-modal"]').fadeIn(500);
            jQueryNuvem("#home-modal").detach().appendTo("body").show().addClass("modal-show");
        }
        var callback_hide = function(){
            jQueryNuvem('.js-modal-overlay[data-modal-id="#home-modal"]').fadeOut(500);
            let homeModal = jQueryNuvem("#home-modal").removeClass("modal-show");
            setTimeout(() => homeModal.hide(), 500);
        }
        LS.homePopup({
            selector: "#home-modal",
            timeout: 10000
        }, callback_hide, callback_show);

    {% endif %}

    {#/*============================================================================
      #Tabs
    ==============================================================================*/ #}

    var $tab_open = jQueryNuvem('.js-tab');

    $tab_open.on("click", function (e) {
        e.preventDefault(); 
        var $tab_container = jQueryNuvem(e.currentTarget).closest(".js-tab-container");
        $tab_container.find(".js-tab, .js-tab-panel").removeClass("active");
        jQueryNuvem(e.currentTarget).addClass("active");
        var tab_to_show = jQueryNuvem(e.currentTarget).find(".js-tab-link").attr("href");
        $tab_container.find(tab_to_show).addClass("active");    
    });

    {#/*============================================================================
      #Cards
    ==============================================================================*/ #}
    jQueryNuvem(document).on("click", ".js-card-collapse-toggle", function(e) {
        e.preventDefault();
        jQueryNuvem(this).toggleClass('active');
        jQueryNuvem(this).closest(".js-card-collapse").toggleClass('active');
    });

    {#/*============================================================================
      #Accordions
    ==============================================================================*/ #}
    jQueryNuvem(document).on("click", ".js-accordion-toggle", function(e) {
        e.preventDefault();
        if(jQueryNuvem(this).hasClass("js-accordion-show-only")){
            jQueryNuvem(this).hide();
        }else{
            jQueryNuvem(this).find(".js-accordion-toggle-inactive").toggle();
            jQueryNuvem(this).find(".js-accordion-toggle-active").toggle();
        }
        jQueryNuvem(this).prev(".js-accordion-container").slideToggle();
    });

    
    {#/*============================================================================
    #Pop Ups
    ==============================================================================*/ #}

    {# /* // Cat or Dog Pop Up */ #}

    /*if(window.location.href === "https://beethovenvillavo.com/") {
        let body = document.body;
        let adCatDog = document.createElement('div');
        adCatDog.classList.add('ad');
        let overlay = document.createElement('div');
        overlay.classList.add('overlay');

        let adTitle = document.createElement('h2');
        adTitle.innerHTML = 'BIENVENID@ A LA #FAMILIABEETHOVEN TE INTERESAN PRODUCTOS PARA:';
        adCatDog.appendChild(adTitle);

        let adButtons = document.createElement('div');

        let closeButton = document.createElement('span');
        closeButton.innerHTML = 'x';
        closeButton.classList.add('close-btn');
        closeButton.onclick = function() {
            adCatDog.classList.remove('show');
            overlay.classList.remove('show');
        };
        adCatDog.appendChild(closeButton);

        let dogButton = document.createElement('button');
        dogButton.innerHTML = 'Perro';
        dogButton.onclick = function() {
            window.location.href = 'https://beethovenvillavo.com/perros/';
        };
        adButtons.appendChild(dogButton);

        let catButton = document.createElement('button');
        catButton.innerHTML = 'Gato';
        catButton.onclick = function() {
            window.location.href = 'https://beethovenvillavo.com/gatos/';
        };
        adButtons.appendChild(catButton);

        adCatDog.appendChild(adButtons);
        body.insertBefore(adCatDog, body.firstChild);

        body.insertBefore(overlay, body.firstChild);

        adCatDog.classList.add('show');
        overlay.classList.add('show');
    }*/

    {# /* // Cat or Dog Pop Up */ #}

    // Change of brand carousel
    /*if (window.location.href == "https://beethovenvillavo.com/" && window.innerWidth < 768) {
        (function() {
            let section = document.querySelector('.section-brands-home');
            let brandCarousel = document.createElement('div');
            brandCarousel.classList.add('brand-carousel-container')
            
            brandCarousel.innerHTML = `
            <button class="carousel-left-btn"><p>&#8249;</p></button>
            <div class="brand-carousel">
                <div class="brands">
                    <img src="https://laikapp.s3.amazonaws.com/dev_images_categories/AGILITY_GOLD_CIRCULO_OK2.png" alt="Agility Gold"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/agility-gold1/'">
                    <img src="https://nupec.com/wp-content/uploads/2020/06/images.png" alt="Nupec"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/nupec/'">
                    <img src="https://www.laika.com.uy/media/catalog/category/max.png" alt="Max"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/max1/'">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbl5jqXwarJux5wx2vXi7thOJ7WgeoXxAw8iFfPj_jkVdreyLdepa631bPKLPm8uUjoN4&usqp=CAU" alt="Naturalis"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/max1/'">
                    <img src="https://s3.us-east-1.amazonaws.com/laikapp/images_categories/chunky_circulo3.png" alt="Chunky"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/chunky/'">
                    <img src="https://picosyplumas.co/wp-content/uploads/2020/04/Logo-Monello.png" alt="Monello"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/monello/'">
                    <img src="https://mex.mars.com/sites/g/files/jydpyr316/files/2019-03/Logos_BUSINESS_SEGMENTS_23.png" alt="Royal Canin"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/royal-canin/'">
                    <img src="https://uxt-cf-images.mediazs.com/w4bhfqu0yxyq/pAFdxb9hJrgI55GNkamCa/e1bb3ec3b41a768f90677b9a08082538/logo_Hills1000x1000.jpg?fm=jpg&fl=progressive&w=300&q=85" alt="Hill's"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/hills/'">
                    <img src="https://s3.us-east-1.amazonaws.com/laikapp/images_categories/vet_life_circulo2.png" alt="Vet Life"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/vet-life/'">
                    <img src="data:image/png;base64,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" alt="Pro Plan"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/pro-plan/'">
                    <img src="https://exiagricola.net/tienda/wp-content/uploads/2017/07/logo-equilibrio.jpg" alt="Equilibrio"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/equilibrio/'">
                    <img src="https://royalpet.pe/wp-content/uploads/2021/05/purina-excellent-logo-EFA929CAF8-seeklogo.com_.png" alt="Excellent Purina"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/excellent/'">
                    <img src="https://cdn.shopify.com/s/files/1/0435/6374/5433/files/Evolve_Logo.png?v=1668790317" alt="Evolve"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/evolve/'">
                    <img src="https://orangepet.cl/media/codazon_cache/brand/400x400/wysiwyg/codazon/grocery_gourmet/home/Acana.jpg" alt="Acana"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/orijen-acana/'">
                    <img src="data:image/png;base64,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" alt="Orijen"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/orijen-acana/'">
                    <img src="https://laikapp.s3.amazonaws.com/dev_images_categories/TASTE_OF_THE_WILD_CIRCULO.png" alt="Taste of the Wild"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/taste-of-the-wild/'">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-J8kI7yDUu-S-_xz8QQBW6r4Ler1m0Zm3RI3kwiRKmBIr5ER55xZWjgtJP0vgkdgL5xk&usqp=CAU" alt="Nutra Nuggets"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/nutra-nuggets/'">
                    <img src="https://s3.us-east-1.amazonaws.com/laikapp/images_categories/BR_FOR_CAT1.png" alt="Br For Cat"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/br-for-cats-dogs/'">
                    <img src="https://pbs.twimg.com/profile_images/553276024469745665/_dIOQEOA_400x400.jpeg" alt="Nutre Can"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/nutre-can/'">
                    <img src="https://pbs.twimg.com/profile_images/553276723106574336/b-djD6AW_400x400.jpeg" alt="Nutrecat"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/nutre-can/'">
                    <img src="https://logodownload.org/wp-content/uploads/2019/09/pedigree-logo-5.png" alt="Pedigree"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/pedigree-whiskas/'">
                    <img src="https://1000marcas.net/wp-content/uploads/2021/06/Whiskas-logo.png" alt="Whiskas"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/pedigree-whiskas/'">
                    <img src="https://www.nestle.com.br/sites/g/files/pydnoa436/files/styles/brand_image/public/logo-purina-dog-chow.jpg?itok=qvuOKTIk" alt="Dog Chow"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/dog-chow-cat-chow/'">
                    <img src="https://s3.us-east-1.amazonaws.com/laikapp/images_categories/cat_chow_circulo.png" alt="Cat Chow"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/dog-chow-cat-chow/'">
                    <img src="https://ceragro.com/wp-content/uploads/2021/10/logo_ringo.png" alt="Ringo"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/ringo-mirringo/'">
                    <img src="https://picosyplumas.co/wp-content/uploads/2020/04/Logo-Mirringo.png" alt="Mirringo"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/ringo-mirringo/'">
                    <img src="https://laikapp.s3.amazonaws.com/images_categories/1587054860_DOGOURMET_300X300.png" alt="Dogourmet"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/otras-marcas/dogourmet/'">
                    <img src="data:image/jpeg;base64,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" alt="Oh Mai Gat"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/otras-marcas/oh-mai-gat/'">
                    <img src="https://laikapp.s3.amazonaws.com/images_categories/1591640419_DONKAT_820X761.png" alt="Donkat"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/otras-marcas/donkat-gatos/'">
                    <img src="https://s3.us-east-1.amazonaws.com/laikapp/images_categories/filpo_circulo.png" alt="Filpo"
                    onclick="window.location.href = 'https://beethovenvillavo.com/marcas/otras-marcas/filpo/'">
                </div>
            </div>
            <button class="carousel-right-btn"><p>&#8250;</p></button>
            `
            
            section.insertAdjacentElement('beforebegin', brandCarousel);
            section.style.display = 'none';

            // Events
            const brands = document.querySelector('.brands');
            const leftBtn = document.querySelector('.carousel-left-btn');
            const rightBtn = document.querySelector('.carousel-right-btn');

            let index = 0;

            rightBtn.addEventListener('click', () => {
            index++;
            if (index > brands.children.length - 5) {
                index = 0;
            }
            brands.style.transform = `translateX(-${index * (window.innerWidth * 0.85) / 5}px)`;
            });

            leftBtn.addEventListener('click', () => {
            index--;
            if (index < 0) {
                index = brands.children.length - 5;
            }
            brands.style.transform = `translateX(-${index * (window.innerWidth * 0.85) / 5}px)`;
            });

            setInterval(() => {
            rightBtn.click();
            }, 5000);
        })();
    }*/

    
    {# /* // WhatsApp Pop Up */ #}
    
    (function() {
        let body = document.body;
        let adWhatsApp = document.createElement('div');
        adWhatsApp.classList.add('ad');
        adWhatsApp.classList.add('whatsAppMessage');

        let adMessage = document.createElement('p');
        adMessage.innerHTML = '¿Tienes alguna duda? ¿No encuentras lo que buscas?, ¡Escribenos! Te ayudaremos con gusto';
        adWhatsApp.appendChild(adMessage);

        let closeButton = document.createElement('span');
        closeButton.innerHTML = 'x';
        closeButton.classList.add('close-btn');
        closeButton.onclick = function() {
            adWhatsApp.classList.remove('show');
        };
        adWhatsApp.appendChild(closeButton);

        let not = document.getElementById('cookies-notification');

        not.insertAdjacentElement('afterend', adWhatsApp);

        setTimeout(()=>{
            if (not.style.display != 'none' && window.innerWidth <= 768) {
                adWhatsApp.style.bottom = '175px';
            }
            adWhatsApp.classList.add('show');
        }, 10000);

        let notButton = document.getElementById('cookies-notification-button');

        notButton.onclick = function() { adWhatsApp.style.bottom = '65px'; };
    })();

    {# /* // Beethoven App Pop Up */ #}

    (function() {
        let body = document.body;
        let adApp = document.createElement('div');

        body.insertBefore(adApp, body.firstChild);
    })();

	{#/*============================================================================
      #Header and nav
    ==============================================================================*/ #}

    {# /* // Header */ #}

        {% if template == 'home' and settings.head_transparent %}
            {% if settings.slider and settings.slider is not empty %}        

                var $swiper_height = window.innerHeight - 100;
                
                document.addEventListener("scroll", function() {
                    if (document.documentElement.scrollTop > $swiper_height ) {
                        jQueryNuvem(".js-head-main").removeClass("head-transparent");
                    } else {
                        jQueryNuvem(".js-head-main").addClass("head-transparent");
                    }
                });

            {% endif %}
        {% endif %}

        {# /* // Nav offset */ #}

        function applyOffset(selector){

            // Get nav height on load
            if (window.innerWidth > 768) {
                var head_height = jQueryNuvem(".js-head-main").height();
                jQueryNuvem(selector).css("paddingTop", head_height.toString() + 'px');
            }else{

                {# On mobile there is no top padding due to position sticky CSS #}
                var head_height = 0;
            }

            // Apply offset nav height on load
            
            window.addEventListener("resize", function() {

                // Get nav height on resize
                var head_height = jQueryNuvem(".js-head-main").height();

                // Apply offset on resize
                if (window.innerWidth > 768) {
                    jQueryNuvem(selector).css("paddingTop", head_height.toString() + 'px');
                }else{

                    {# On mobile there is no top padding due to position sticky CSS #}
                    jQueryNuvem(selector).css("paddingTop", "0px");
                }
            });
        }


    {% if settings.head_fix %}

        applyOffset(".js-head-offset");

        {# Show and hide mobile nav on scroll #}

            var didScroll;
            var lastScrollTop = 0;
            var delta = 30;
            var navbarHeight = jQueryNuvem(".js-head-main").outerHeight();
            var topbarHeight = jQueryNuvem(".js-topbar").outerHeight();

            window.addEventListener("scroll", function(event){
                didScroll = true;
            });

            setInterval(function() {
                if (didScroll) {
                    hasScrolled();
                    didScroll = false;
                }
            }, 250);

            function hasScrolled() {
                var st = window.pageYOffset;
                
                // Make sure they scroll more than delta
                if(Math.abs(lastScrollTop - st) <= delta)
                    return;
                
                // If they scrolled down and are past the navbar, add class .move-up.
                if (st > lastScrollTop && st > navbarHeight){
                    jQueryNuvem(".js-head-main").addClass('compress').css('top', (- topbarHeight).toString() + 'px' );
                    if (window.innerWidth < 768) {
                    	$category_controls.css('top', (navbarHeight - topbarHeight - 2).toString() + 'px' );
                	}
                    
                } else {
                    // Scroll Up
                    let documentHeight = Math.max(
                        document.body.scrollHeight,
                        document.body.offsetHeight,
                        document.documentElement.clientHeight,
                        document.documentElement.scrollHeight,
                        document.documentElement.offsetHeight
                    );

                    if(st + window.innerHeight < documentHeight) {
                        jQueryNuvem(".js-head-main").removeClass('compress').css('top', "0px" );
                        if (window.innerWidth < 768) {
                        	$category_controls.css('top', navbarHeight.toString() + 'px' );
                    	}
                    }
                }

                lastScrollTop = st;
            }
            
    {% endif %}      


    {# /* // Hide Breadcrumbs */ #}

    (function() {
        let breadcrumb = document.body?.children[13]?.children[1]?.children[0]?.children[0]?.children[0];
        if(breadcrumb && breadcrumb.classList.contains('breadcrumbs')) breadcrumb.style.display = 'none';
    })();


    {# /* // Hide Account */ #}

    (function() {
        let account = document.querySelectorAll('[data-store="account-links"]');
        if (account[0]) account[0].style.setProperty('display', 'none', 'important');
        if (account[1]) account[1].style.setProperty('display', 'none', 'important');
    })();

    {# /* // Hide Top Sections and Add Icons */ #}    

    (function() {
        let topSections = document.querySelectorAll('.nav-item.nav-item-desktop.nav-main-item');
        topSections.forEach(section => {
            if(section.innerText == 'politica de privacidad' || section.innerText == 'Preguntas Frecuentes'
            || section.innerText == 'Nuestra promesa de servicio' || section.innerText == 'Ubicaciones y contacto'
            || section.innerText == 'Sobre nosotros' || section.innerText == 'Como comprar?') {
                section.style.display = 'none';
            } else {
                if (section.innerText == 'INICIO') section.innerHTML = '\n<svg xmlns="http://www.w3.org/2000/svg" class="svg-image"><path d="m21.743 12.331-9-10c-.379-.422-1.107-.422-1.486 0l-9 10a.998.998 0 0 0-.17 1.076c.16.361.518.593.913.593h2v7a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-4h4v4a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-7h2a.998.998 0 0 0 .743-1.669z"></path></svg>' + section.innerHTML;
                if (section.innerText == 'PERROS ') section.children[0].innerHTML = '\n<svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>' + section.children[0].innerHTML;
                if (section.innerText == 'GATOS ') section.children[0].innerHTML = '\n<svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>' + section.children[0].innerHTML;
                if (section.innerText == 'ALIMENTOS ') section.children[0].innerHTML = '\n<svg xmlns="http://www.w3.org/2000/svg" class="svg-image"><path d="M21 10a3.58 3.58 0 0 0-1.8-3 3.66 3.66 0 0 0-3.63-3.13 3.86 3.86 0 0 0-1 .13 3.7 3.7 0 0 0-5.11 0 3.86 3.86 0 0 0-1-.13A3.66 3.66 0 0 0 4.81 7 3.58 3.58 0 0 0 3 10a1 1 0 0 0-1 1 10 10 0 0 0 5 8.66V21a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1v-1.34A10 10 0 0 0 22 11a1 1 0 0 0-1-1zM5 10a1.59 1.59 0 0 1 1.11-1.39l.83-.26-.16-.85a1.64 1.64 0 0 1 1.66-1.62 1.78 1.78 0 0 1 .83.2l.81.45.5-.77a1.71 1.71 0 0 1 2.84 0l.5.77.81-.45a1.78 1.78 0 0 1 .83-.2 1.65 1.65 0 0 1 1.67 1.6l-.16.85.82.28A1.59 1.59 0 0 1 19 10z"></path></svg>' + section.children[0].innerHTML;
                if (section.innerText == 'ACCESORIOS ') section.children[0].innerHTML = '\n<svg xmlns="http://www.w3.org/2000/svg" class="svg-image"><path d="M4.929 19.071a9.953 9.953 0 0 0 6.692 2.906c-.463-2.773.365-5.721 2.5-7.856 2.136-2.135 5.083-2.963 7.856-2.5-.092-2.433-1.053-4.839-2.906-6.692s-4.26-2.814-6.692-2.906c.463 2.773-.365 5.721-2.5 7.856-2.136 2.135-5.083 2.963-7.856 2.5a9.944 9.944 0 0 0 2.906 6.692z"></path><path d="M15.535 15.535a6.996 6.996 0 0 0-1.911 6.318 9.929 9.929 0 0 0 8.229-8.229 6.999 6.999 0 0 0-6.318 1.911zm-7.07-7.07a6.996 6.996 0 0 0 1.911-6.318 9.929 9.929 0 0 0-8.23 8.229 7 7 0 0 0 6.319-1.911z"></path></svg>' + section.children[0].innerHTML;
                if (section.innerText == 'HIGIENE ') section.children[0].innerHTML = '\n<svg xmlns="http://www.w3.org/2000/svg" class="svg-image"><path d="M21 18.33A6.78 6.78 0 0 0 19.5 15a6.73 6.73 0 0 0-1.5 3.33 1.51 1.51 0 1 0 3 0zM11 20.33A6.78 6.78 0 0 0 9.5 17 6.73 6.73 0 0 0 8 20.33 1.59 1.59 0 0 0 9.5 22a1.59 1.59 0 0 0 1.5-1.67zM16 20.33A6.78 6.78 0 0 0 14.5 17a6.73 6.73 0 0 0-1.5 3.33A1.59 1.59 0 0 0 14.5 22a1.59 1.59 0 0 0 1.5-1.67zM6 18.33A6.78 6.78 0 0 0 4.5 15 6.73 6.73 0 0 0 3 18.33 1.59 1.59 0 0 0 4.5 20 1.59 1.59 0 0 0 6 18.33zM2 12h20v2H2zM13 4.07V2h-2v2.07A8 8 0 0 0 4.07 11h15.86A8 8 0 0 0 13 4.07z"></path></svg>' + section.children[0].innerHTML;
                if (section.innerText == 'FARMACIA ') section.children[0].innerHTML = '\n<svg xmlns="http://www.w3.org/2000/svg" class="svg-image"><path d="M8.434 20.566c1.335 0 2.591-.52 3.535-1.464l7.134-7.133a5.008 5.008 0 0 0-.001-7.072 4.969 4.969 0 0 0-3.536-1.463c-1.335 0-2.59.52-3.534 1.464l-7.134 7.133a5.01 5.01 0 0 0-.001 7.072 4.971 4.971 0 0 0 3.537 1.463zm5.011-14.254a2.979 2.979 0 0 1 2.12-.878c.802 0 1.556.312 2.122.878a3.004 3.004 0 0 1 .001 4.243l-2.893 2.892-4.242-4.244 2.892-2.891z"></path></svg>' + section.children[0].innerHTML;
                if (section.innerText == 'MARCAS ALIADAS') section.innerHTML = '\n<svg xmlns="http://www.w3.org/2000/svg" height="1em" viewBox="0 0 512 512"><!--! Font Awesome Free 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M448 256A192 192 0 1 0 64 256a192 192 0 1 0 384 0zM0 256a256 256 0 1 1 512 0A256 256 0 1 1 0 256zm256 80a80 80 0 1 0 0-160 80 80 0 1 0 0 160zm0-224a144 144 0 1 1 0 288 144 144 0 1 1 0-288zM224 256a32 32 0 1 1 64 0 32 32 0 1 1 -64 0z"/></svg>' + section.innerHTML;
            }
        });

        let leftSections = Array.from(document.querySelectorAll('[data-component="menu"]')[1].children); 
        leftSections.forEach(section => {
            if (section.innerText.includes('PERROS')) {
                section.children[0].classList.contains('nav-item-container') ? section.children[0].style.display = 'flex' : section.style.display = 'flex';
                section.children[0].children[0].style.width = '90%';
                section.children[0].innerHTML = '\n<svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>' + section.children[0].innerHTML;
            }else if (section.innerText.includes('GATOS')) {
                section.children[0].classList.contains('nav-item-container') ? section.children[0].style.display = 'flex' : section.style.display = 'flex';
                section.children[0].children[0].style.width = '90%';
                section.children[0].innerHTML = '\n<svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>' + section.children[0].innerHTML;
            } else {
                section.children[0].style.width = '90%';
            }

            if (section.innerText.includes('INICIO')){
                section.children[0].classList.contains('nav-item-container') ? section.children[0].style.display = 'flex' : section.style.display = 'flex';
                section.innerHTML = '\n<svg xmlns="http://www.w3.org/2000/svg" class="svg-image"><path d="m21.743 12.331-9-10c-.379-.422-1.107-.422-1.486 0l-9 10a.998.998 0 0 0-.17 1.076c.16.361.518.593.913.593h2v7a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-4h4v4a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-7h2a.998.998 0 0 0 .743-1.669z"></path></svg>' + section.innerHTML;
            } 

            if (section.innerText.includes('MARCAS ALIADAS')) {
                section.children[0].classList.contains('nav-item-container') ? section.children[0].style.display = 'flex' : section.style.display = 'flex';
                section.innerHTML = '\n<svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 512 512"><!--! Font Awesome Free 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M448 256A192 192 0 1 0 64 256a192 192 0 1 0 384 0zM0 256a256 256 0 1 1 512 0A256 256 0 1 1 0 256zm256 80a80 80 0 1 0 0-160 80 80 0 1 0 0 160zm0-224a144 144 0 1 1 0 288 144 144 0 1 1 0-288zM224 256a32 32 0 1 1 64 0 32 32 0 1 1 -64 0z"/></svg>' + section.innerHTML;
            }
        });
        

        if (window.innerWidth < 768) {
            const burgerButton = document.querySelector('.col-auto.text-left.d-block.d-md-none');
            burgerButton.innerHTML += '<a href="https://beethovenvillavo.com/"><svg xmlns="http://www.w3.org/2000/svg" style="width: 25px; height: 25px;"><path d="m21.743 12.331-9-10c-.379-.422-1.107-.422-1.486 0l-9 10a.998.998 0 0 0-.17 1.076c.16.361.518.593.913.593h2v7a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-4h4v4a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-7h2a.998.998 0 0 0 .743-1.669z"></path></svg></a>';
        }
    })();

    {# /* // Change colors menu nav and footer  */ #}

    (function() {
        let items = Array.from(document.querySelectorAll('[data-component="menu"]')[1].children);
        items.forEach(item => {
            if(item.innerText.includes('Preguntas Frecuentes') || item.innerText.includes('Nuestra promesa de servicio')
            || item.innerText.includes('Ubicaciones y contacto') || item.innerText.includes('Sobre nosotros')
            || item.innerText.includes('politica de privacidad')) {
                item.children[0].style.color = '#e67e22';
            }
        });

        // Hide some items
        items[6].style.display = 'none';
        items[5].style.display = 'none';
        items[4].style.display = 'none';
        items[3].style.display = 'none';

        items = Array.from(document.querySelector('.footer-menu').children);
        items.forEach(item => {
            if(item.innerText.includes('Preguntas Frecuentes') || item.innerText.includes('Nuestra promesa de servicio')
            || item.innerText.includes('Ubicaciones y contacto') || item.innerText.includes('Sobre nosotros')
            || item.innerText.includes('politica de privacidad')) {
                item.children[0].style.color = '#e67e22';
            }
        });
    })();
    
    {# /* // Change link WhatsApp  */ #}

    function linkWhatsApp() {
        let inputElements = document.querySelectorAll('[data-store="product-buy-button"]');
        if (inputElements.length == 0) inputElements = document.querySelectorAll('.js-addtocart.js-prod-submit-form.btn.btn-primary.btn-small.w-100.mb-2.nostock');
        inputElements.forEach(inputElement => {
            if (inputElement && inputElement.value && (inputElement.value == 'Consultanos disponibilidad' || inputElement.value == 'Consultanos precio y stock' || inputElement.value == 'Consultar precio')) {
                if (inputElement.hasAttribute('disabled')) inputElement.removeAttribute('disabled');
                inputElement.setAttribute('type', 'button');
                inputElement.onclick = () => window.open('https://wa.me/573185556767', '_blank');
            }
        });
    }
    linkWhatsApp();

    {# /* // Add title and button to the brand carrousel  */ #}

    (function() {
        let sectionBrands = document.querySelector('.section-brands-home');
        if (sectionBrands) {
            sectionBrands.innerHTML = `\n<h3 class="h1 text-primary" style="margin-bottom: 0;">MARCAS ALIADAS</h3>` + sectionBrands.innerHTML; 
            sectionBrands.innerHTML = sectionBrands.innerHTML + `\n<a class="navButton" style="font-size: 20px;" href="https://beethovenvillavo.com/marcas1/">VER TODAS</a>`; 
        } 
    })();

    {# /* // Postal Code  */ #}

    (function() {
        calcButton = document.querySelector('.js-calculate-shipping.btn.btn-secondary.btn-block');
        if(calcButton) calcButton.setAttribute("style", "font-size: 11px; padding: 15px 12px 15px 12px;");
    })();

    {# /* // Adjust sections  */ #}

    window.addEventListener('load', function() {
        if (window.location.href == 'https://beethovenvillavo.com/' && window.innerWidth >= 768){
            let sections = document.getElementsByClassName('col-md-4');
            sections[0].setAttribute("style", "max-width: 16.666666%; padding-right: 10px; padding-left: 10px;");
            sections[1].setAttribute("style", "max-width: 16.666666%; padding-right: 10px; padding-left: 10px;");
            sections[2].setAttribute("style", "max-width: 16.666666%; padding-right: 10px; padding-left: 10px;");
            sections[3].setAttribute("style", "max-width: 16.666666%; padding-right: 10px; padding-left: 10px;");
            sections[4].setAttribute("style", "max-width: 16.666666%; padding-right: 10px; padding-left: 10px;");
            sections[5].setAttribute("style", "max-width: 16.666666%; padding-right: 10px; padding-left: 10px;");
            sections[6].setAttribute("style", "max-width: 24%; padding-right: 10px; padding-left: 10px;");
            sections[7].setAttribute("style", "max-width: 24%; padding-right: 10px; padding-left: 10px;");
            sections[8].setAttribute("style", "max-width: 24%; padding-right: 10px; padding-left: 10px;");
            sections[9].setAttribute("style", "max-width: 24%; padding-right: 10px; padding-left: 10px;");
        }
    });  

    {# /* // Utilities */ #}

        jQueryNuvem(".js-utilities-item").on("mouseenter", function (e) {
            e.preventDefault();
            jQueryNuvem(e.currentTarget).toggleClass("active");
        }).on("mouseleave", function(e) {
            e.preventDefault();
            jQueryNuvem(e.currentTarget).toggleClass("active");
        });


    {# /* // Nav */ #}

        var $top_nav = jQueryNuvem(".js-mobile-nav");
        var $page_main_content = jQueryNuvem(".js-main-content");
        var $search_backdrop = jQueryNuvem(".js-search-backdrop");

        $top_nav.addClass("move-down").removeClass("move-up");


        {# Nav subitems #}

        jQueryNuvem(".js-toggle-page-accordion").on("click", function (e) {
            e.preventDefault();
            jQueryNuvem(e.currentTarget).toggleClass("active").closest(".js-nav-list-toggle-accordion").next(".js-pages-accordion").slideToggle(300);
        });

        var win_height = window.innerHeight;
        var head_height = jQueryNuvem(".js-head-main").height();

        jQueryNuvem(".js-desktop-dropdown").css('maxHeight', (win_height - head_height - 50).toString() + 'px');

        jQueryNuvem(".js-item-subitems-desktop").on("mouseenter", function (e) {
            jQueryNuvem(e.currentTarget).addClass("active");
        }).on("mouseleave", function(e) {
            jQueryNuvem(e.currentTarget).removeClass("active");
        });

        jQueryNuvem(".nav-main-item").on("mouseenter", function (e) {
            jQueryNuvem('.nav-desktop-list').children(".selected").removeClass("selected");

            jQueryNuvem(e.currentTarget).addClass("selected");
        });



        {# Focus search #}

        jQueryNuvem(".js-toggle-search").on("click", function (e) {
            e.preventDefault;
            jQueryNuvem(".js-search-input").trigger('focus');
        });


    {# /* // Nav Bottom */ #}

    if (window.innerWidth <= 768) {
        let body = document.body;
        let navBottom = document.createElement('div');
        navBottom.classList.add('nav-bottom');

        let sectionNavBottom1 = document.createElement('div');
        let sectionNavBottom2 = document.createElement('div');
        let sectionNavBottom3 = document.createElement('div');
        let sectionNavBottom4 = document.createElement('div');
        let sectionNavBottom5 = document.createElement('div');
        sectionNavBottom1.classList.add('nav-bottom-section');
        sectionNavBottom2.classList.add('nav-bottom-section');
        sectionNavBottom3.classList.add('nav-bottom-section');
        sectionNavBottom4.classList.add('nav-bottom-section');
        sectionNavBottom5.classList.add('nav-bottom-section');
        
        sectionNavBottom2.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" class="svg-image"><path d="M21 10a3.58 3.58 0 0 0-1.8-3 3.66 3.66 0 0 0-3.63-3.13 3.86 3.86 0 0 0-1 .13 3.7 3.7 0 0 0-5.11 0 3.86 3.86 0 0 0-1-.13A3.66 3.66 0 0 0 4.81 7 3.58 3.58 0 0 0 3 10a1 1 0 0 0-1 1 10 10 0 0 0 5 8.66V21a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1v-1.34A10 10 0 0 0 22 11a1 1 0 0 0-1-1zM5 10a1.59 1.59 0 0 1 1.11-1.39l.83-.26-.16-.85a1.64 1.64 0 0 1 1.66-1.62 1.78 1.78 0 0 1 .83.2l.81.45.5-.77a1.71 1.71 0 0 1 2.84 0l.5.77.81-.45a1.78 1.78 0 0 1 .83-.2 1.65 1.65 0 0 1 1.67 1.6l-.16.85.82.28A1.59 1.59 0 0 1 19 10z"></path></svg>
        <p>Alimentos</p>
        `;
        sectionNavBottom3.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" class="svg-image"><path d="M4.929 19.071a9.953 9.953 0 0 0 6.692 2.906c-.463-2.773.365-5.721 2.5-7.856 2.136-2.135 5.083-2.963 7.856-2.5-.092-2.433-1.053-4.839-2.906-6.692s-4.26-2.814-6.692-2.906c.463 2.773-.365 5.721-2.5 7.856-2.136 2.135-5.083 2.963-7.856 2.5a9.944 9.944 0 0 0 2.906 6.692z"></path><path d="M15.535 15.535a6.996 6.996 0 0 0-1.911 6.318 9.929 9.929 0 0 0 8.229-8.229 6.999 6.999 0 0 0-6.318 1.911zm-7.07-7.07a6.996 6.996 0 0 0 1.911-6.318 9.929 9.929 0 0 0-8.23 8.229 7 7 0 0 0 6.319-1.911z"></path></svg>
        <p>Accesorios</p>
        `;
        sectionNavBottom4.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" class="svg-image"><path d="M21 18.33A6.78 6.78 0 0 0 19.5 15a6.73 6.73 0 0 0-1.5 3.33 1.51 1.51 0 1 0 3 0zM11 20.33A6.78 6.78 0 0 0 9.5 17 6.73 6.73 0 0 0 8 20.33 1.59 1.59 0 0 0 9.5 22a1.59 1.59 0 0 0 1.5-1.67zM16 20.33A6.78 6.78 0 0 0 14.5 17a6.73 6.73 0 0 0-1.5 3.33A1.59 1.59 0 0 0 14.5 22a1.59 1.59 0 0 0 1.5-1.67zM6 18.33A6.78 6.78 0 0 0 4.5 15 6.73 6.73 0 0 0 3 18.33 1.59 1.59 0 0 0 4.5 20 1.59 1.59 0 0 0 6 18.33zM2 12h20v2H2zM13 4.07V2h-2v2.07A8 8 0 0 0 4.07 11h15.86A8 8 0 0 0 13 4.07z"></path></svg>
        <p>Higiene</p>
        `;
        sectionNavBottom5.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" class="svg-image"><path d="M8.434 20.566c1.335 0 2.591-.52 3.535-1.464l7.134-7.133a5.008 5.008 0 0 0-.001-7.072 4.969 4.969 0 0 0-3.536-1.463c-1.335 0-2.59.52-3.534 1.464l-7.134 7.133a5.01 5.01 0 0 0-.001 7.072 4.971 4.971 0 0 0 3.537 1.463zm5.011-14.254a2.979 2.979 0 0 1 2.12-.878c.802 0 1.556.312 2.122.878a3.004 3.004 0 0 1 .001 4.243l-2.893 2.892-4.242-4.244 2.892-2.891z"></path></svg>
        <p>Farmacia</p>
        `;
        sectionNavBottom1.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 512 512" style="width: 20px;"><path d="M448 256A192 192 0 1 0 64 256a192 192 0 1 0 384 0zM0 256a256 256 0 1 1 512 0A256 256 0 1 1 0 256zm256 80a80 80 0 1 0 0-160 80 80 0 1 0 0 160zm0-224a144 144 0 1 1 0 288 144 144 0 1 1 0-288zM224 256a32 32 0 1 1 64 0 32 32 0 1 1 -64 0z"/></svg>
        <p>Marcas</p>
        `;

        sectionNavBottom2.onclick = function() { window.location.href = 'https://beethovenvillavo.com/marcas/'; };
        sectionNavBottom3.onclick = function() { window.location.href = 'https://beethovenvillavo.com/accesorios/'; };
        sectionNavBottom4.onclick = function() { window.location.href = 'https://beethovenvillavo.com/limpieza-e-higiene/'; };
        sectionNavBottom5.onclick = function() { window.location.href = 'https://beethovenvillavo.com/farmacia/'; };
        sectionNavBottom1.onclick = function() { window.location.href = 'https://beethovenvillavo.com/marcas1/'; };

        navBottom.appendChild(sectionNavBottom2);
        navBottom.appendChild(sectionNavBottom3);
        navBottom.appendChild(sectionNavBottom4);
        navBottom.appendChild(sectionNavBottom5);
        navBottom.appendChild(sectionNavBottom1);
        body.appendChild(navBottom);

        let whatsapp = document.getElementById('whatsapp-icon');
        whatsapp.style.bottom = '55px';
        let not = document.getElementById('cookies-notification');
        not.style.bottom = '49px';

        if (window.location.href.includes('marcas/') || window.location.href.includes('alimentos')) {
            sectionNavBottom2.children[0].style.fill = '#e67e22';
            sectionNavBottom2.children[1].style.color = 'white';
        }
        if (window.location.href.includes('accesorios')) {
            sectionNavBottom3.children[0].style.fill = '#e67e22';
            sectionNavBottom3.children[1].style.color = 'white';
        }
        if (window.location.href.includes('limpieza-e-higiene') || window.location.href.includes('higiene-y-cuidado') || window.location.href.includes('limpieza-higiene-y-cuidados')) {
            sectionNavBottom4.children[0].style.fill = '#e67e22';
            sectionNavBottom4.children[1].style.color = 'white';
        }
        if (window.location.href.includes('farmacia')) {
            sectionNavBottom5.children[0].style.fill = '#e67e22';
            sectionNavBottom5.children[1].style.color = 'white';
        }
        if (window.location.href.includes('marcas1/')) {
            sectionNavBottom1.children[0].style.fill = '#e67e22';
            sectionNavBottom1.children[1].style.color = 'white';
        }
    }


    {# /* // Search suggestions */ #}

        LS.search(jQueryNuvem(".js-search-input"), function (html, count) {
            $search_suggests = jQueryNuvem(this).closest(".js-search-container").next(".js-search-suggest");
            if (count > 0) {
                $search_suggests.html(html).show();
            } else {
                $search_suggests.hide();
            }
            if (jQueryNuvem(this).val().length == 0) {
                $search_suggests.hide();
            }
        }, {
            snipplet: 'header/header-search-results.tpl'
        });

        if (window.innerWidth > 768) {

            {# Hide search suggestions if user click outside results #}

            jQueryNuvem("body").on("click", function () {
                jQueryNuvem(".js-search-suggest").hide();
            });

            {# Maintain search suggestions visibility if user click on links inside #}

            jQueryNuvem(document).on("click", ".js-search-suggest a", function () {
                jQueryNuvem(".js-search-suggest").show();
            });
        }

        jQueryNuvem(".js-search-suggest").on("click", ".js-search-suggest-all-link", function (e) {
            e.preventDefault();
            $this_closest_form = jQueryNuvem(this).closest(".js-search-suggest").prev(".js-search-form");
            $this_closest_form.submit();
        });


	{#/*============================================================================
	  #Sliders
	==============================================================================*/ #}

	{% if template == 'home' %}

		{# /* // Home slider */ #}


        var width = window.innerWidth;
        if (width > 767) {
            var slider_autoplay = {delay: 6000,};
        } else {
            var slider_autoplay = false;
        }

        window.homeSlider = {
            getAutoRotation: function() {
                return slider_autoplay;
            },
            updateSlides: function(slides) {
                homeSwiper.removeAllSlides();
                slides.forEach(function(aSlide){
                    homeSwiper.appendSlide(
                        '<div class="swiper-slide slide-container">' +
                            (aSlide.link ? '<a href="' + aSlide.link + '">' : '' ) +
                                '<img src="' + aSlide.src + '" class="slider-image"/>' +
                                '<div class="swiper-text swiper-' + aSlide.color + '">' +
                                    (aSlide.description ? '<div class="swiper-description mb-3">' + aSlide.description + '</div>' : '' ) +
                                    (aSlide.title ? '<div class="swiper-title">' + aSlide.title + '</div>' : '' ) +
                                    (aSlide.button && aSlide.link ? '<div class="btn btn-primary btn-small swiper-btn mt-4 px-4">' + aSlide.button + '</div>' : '' ) +
                                '</div>' +
                            (aSlide.link ? '</a>' : '' ) +
                        '</div>'
                    );
                });

                {% set has_mobile_slider = settings.toggle_slider_mobile and settings.slider_mobile and settings.slider_mobile is not empty %}

                if(!slides.length){
                    jQueryNuvem(".js-home-main-slider-container").addClass("hidden");
                    jQueryNuvem(".js-home-empty-slider-container").removeClass("hidden");
                    jQueryNuvem(".js-home-mobile-slider-visibility").removeClass("d-md-none");
                    {% if has_mobile_slider %}
                        jQueryNuvem(".js-home-main-slider-visibility").removeClass("d-none d-md-block");
                        homeMobileSwiper.update();
                    {% endif %}
                }else{
                    jQueryNuvem(".js-home-main-slider-container").removeClass("hidden");
                    jQueryNuvem(".js-home-empty-slider-container").addClass("hidden");
                    jQueryNuvem(".js-home-mobile-slider-visibility").addClass("d-md-none");
                    {% if has_mobile_slider %}
                        jQueryNuvem(".js-home-main-slider-visibility").addClass("d-none d-md-block");
                    {% endif %}
                }
            },
            changeAutoRotation: function(){

            },
        };

        var preloadImagesValue = false;
        var lazyValue = true;
        var loopValue = true;
        var paginationClickableValue = true;

        var homeSwiper = null;
        createSwiper(
            '.js-home-slider', {
                preloadImages: preloadImagesValue,
                lazy: lazyValue,
                {% if settings.slider | length > 1 %}
                    loop: loopValue,
                {% endif %}
                autoplay: slider_autoplay,
                pagination: {
                    el: '.js-swiper-home-pagination',
                    clickable: paginationClickableValue,
                },
                navigation: {
                    nextEl: '.js-swiper-home-next',
                    prevEl: '.js-swiper-home-prev',
                },
            },
            function(swiperInstance) {
                homeSwiper = swiperInstance;
            }
        );

        var homeMobileSwiper = null;
        createSwiper(
            '.js-home-slider-mobile', {
                preloadImages: preloadImagesValue,
                lazy: lazyValue,
                {% if settings.slider_mobile | length > 1 %}
                    loop: loopValue,
                {% endif %}
                autoplay: slider_autoplay,
                pagination: {
                    el: '.js-swiper-home-pagination-mobile',
                    clickable: paginationClickableValue,
                },
                navigation: {
                    nextEl: '.js-swiper-home-next-mobile',
                    prevEl: '.js-swiper-home-prev-mobile',
                },
            },
            function(swiperInstance) {
                homeMobileSwiper = swiperInstance;
            }
        );

        {% if settings.slider | length == 1 %}
            jQueryNuvem('.js-swiper-home .swiper-wrapper').addClass( "disabled" );
            jQueryNuvem('.js-swiper-home-pagination, .js-swiper-home-prev, .js-swiper-home-next').remove();
        {% endif %}

        {% set columns = settings.grid_columns %}


        {# /* // Products slider */ #}

        {% set has_featured_products_slider = sections.primary.products and settings.featured_products_format != 'grid' %}
        {% set has_new_products_slider = sections.new.products and settings.new_products_format != 'grid' %}
        {% set has_sale_products_slider = sections.sale.products and settings.sale_products_format != 'grid' %}

        {% if has_featured_products_slider or has_new_products_slider or has_sale_products_slider %}

            var lazyVal = true;
            var watchOverflowVal = true;
            var centerInsufficientSlidesVal = true;
            var slidesPerViewDesktopVal = {% if columns == 2 %}4{% else %}3{% endif %};
            var slidesPerViewMobileVal = 1.5;

            {% if has_featured_products_slider %}

                window.swiperLoader('.js-swiper-featured', {
                    lazy: lazyVal,
                    watchOverflow: watchOverflowVal,
                    centerInsufficientSlides: centerInsufficientSlidesVal,
                    threshold: 5,
                    watchSlideProgress: true,
                    watchSlidesVisibility: true,
                    slideVisibleClass: 'js-swiper-slide-visible',
                {% if sections.primary.products | length > 3 %}
                    loop: true,
                {% endif %}
                    navigation: {
                        nextEl: '.js-swiper-featured-next',
                        prevEl: '.js-swiper-featured-prev',
                    },
                    slidesPerView: slidesPerViewMobileVal,
                    breakpoints: {
                        768: {
                            slidesPerView: slidesPerViewDesktopVal,
                        }
                    }
                });

            {% endif %}

            {% if has_new_products_slider %}

                window.swiperLoader('.js-swiper-new', {
                    lazy: lazyVal,
                    watchOverflow: watchOverflowVal,
                    centerInsufficientSlides: centerInsufficientSlidesVal,
                    threshold: 5,
                    watchSlideProgress: true,
                    watchSlidesVisibility: true,
                    slideVisibleClass: 'js-swiper-slide-visible',
                {% if sections.new.products | length > 3 %}
                    loop: true,
                {% endif %}
                    navigation: {
                        nextEl: '.js-swiper-new-next',
                        prevEl: '.js-swiper-new-prev',
                    },
                    slidesPerView: slidesPerViewMobileVal,
                    breakpoints: {
                        768: {
                            slidesPerView: slidesPerViewDesktopVal,
                        }
                    }
                });

            {% endif %}

            {% if has_sale_products_slider %}

                window.swiperLoader('.js-swiper-sale', {
                    lazy: lazyVal,
                    watchOverflow: watchOverflowVal,
                    centerInsufficientSlides: centerInsufficientSlidesVal,
                    threshold: 5,
                    watchSlideProgress: true,
                    watchSlidesVisibility: true,
                    slideVisibleClass: 'js-swiper-slide-visible',
                {% if sections.sale.products | length > 3 %}
                    loop: true,
                {% endif %}
                    navigation: {
                        nextEl: '.js-swiper-sale-next',
                        prevEl: '.js-swiper-sale-prev',
                    },
                    slidesPerView: slidesPerViewMobileVal,
                    breakpoints: {
                        768: {
                            slidesPerView: slidesPerViewDesktopVal,
                        }
                    }
                });

            {% endif %}

        {% endif %}

        {# /* // Home demo products slider */ #}

        createSwiper('.js-swiper-featured-demo', {
            lazy: true,
            loop: true,
            watchOverflow: true,
            centerInsufficientSlides: true,
            slidesPerView: 1.5,
            navigation: {
                nextEl: '.js-swiper-featured-demo-next',
                prevEl: '.js-swiper-featured-demo-prev',
            },
            breakpoints: {
                640: {
                    slidesPerView: {% if columns == 2 %}4{% else %}3{% endif %},
                }
            }
        });


        {# /* // Brands slider */ #}

        {% if settings.brands and settings.brands is not empty %}

            createSwiper('.js-swiper-brands', {
                lazy: true,
                {% if settings.brands | length > 4 %}
                    loop: true,
                {% endif %}
                watchOverflow: true,
                centerInsufficientSlides: true,
                spaceBetween: 30,
                slidesPerView: 1.5,
                navigation: {
                    nextEl: '.js-swiper-brands-next',
                    prevEl: '.js-swiper-brands-prev',
                },
                breakpoints: {
                    640: {
                        slidesPerView: 5,
                    }
                }
            });

        {% endif %}

	{% endif %}

    {% if template == 'product' %}

        {# /* // Product Related */ #}

        {% set related_products_ids = product.metafields.related_products.related_products_ids %}
        {% if related_products_ids %}
            {% set related_products = related_products_ids | get_products %}
            {% set show = (related_products | length > 0) %}
        {% endif %}
        {% if not show %}
            {% set related_products = category.products | shuffle | take(8) %}
            {% set show = (related_products | length > 1) %}
        {% endif %}

        {% set columns = settings.grid_columns %}
         createSwiper('.js-swiper-related', {
            lazy: true,
            {% if related_products | length > 3 %}
                loop: true,
            {% endif %}
            watchOverflow: true,
            centerInsufficientSlides: true,
            threshold: 5,
            watchSlideProgress: true,
            watchSlidesVisibility: true,
            slideVisibleClass: 'js-swiper-slide-visible',
            slidesPerView: 1.5,
            navigation: {
                nextEl: '.js-swiper-related-next',
                prevEl: '.js-swiper-related-prev',
            },
            breakpoints: {
                640: {
                    slidesPerView: {% if columns == 2 %}4{% else %}3{% endif %},
                }
            }
        });

    {% endif %}



	{% set has_banner_services = settings.banner_services %}

	{% if has_banner_services %}

		{# /* // Banner services slider */ #}

        var width = window.innerWidth;
        if (width < 767) {
            createSwiper('.js-informative-banners', {
                slidesPerView: 1.2,
                watchOverflow: true,
                centerInsufficientSlides: true,
                pagination: {
                    el: '.js-informative-banners-pagination',
                    clickable: true,
                },
                breakpoints: {
                    640: {
                        slidesPerView: 3,
                    }
                }
            });
        }

    {% endif %}

    {# /* // Home Banner */ #}
    if (window.location.href.includes('beethovenvillavo') && window.location.href.split('/').length - 1  <= 3) {
        let bannerSectionRow = document.querySelector('.section-banners-home').children[0].children[0];

        // Accesorios
        let banner1 = document.createElement('div');
        banner1.classList.add('col-md-4');
        
        banner1.innerHTML = `
        <div class="textbanner box-rounded textbanner-shadow">
            <a class="textbanner-link" href="https://beethovenvillavo.com/accesorios/" title="Banner de BEETHOVEN PET CARE VILLAVICENCIO " aria-label="Banner de BEETHOVEN PET CARE VILLAVICENCIO ">
                <div class="textbanner-image">
                    <img class="textbanner-image-background lazyautosizes blur-up-huge lazyloaded" src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1456655457-1684681739-c66d81a0f5d96f2c8eefe95b721c3f401684681740.png?1504714583"  data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1456655457-1684681739-c66d81a0f5d96f2c8eefe95b721c3f401684681740.png?1504714583 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1456655457-1684681739-c66d81a0f5d96f2c8eefe95b721c3f401684681740.png?1504714583 640w" data-sizes="auto" data-expand="-10" alt="Banner de BEETHOVEN PET CARE VILLAVICENCIO " sizes="345px" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1456655457-1684681739-c66d81a0f5d96f2c8eefe95b721c3f401684681740.png?1504714583 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1456655457-1684681739-c66d81a0f5d96f2c8eefe95b721c3f401684681740.png?1504714583 640w">
                </div>
            </a>
        </div>
        `

        bannerSectionRow.appendChild(banner1);

        // Higiene
        let banner2 = document.createElement('div');
        banner2.classList.add('col-md-4');
        
        banner2.innerHTML = `
        <div class="textbanner box-rounded textbanner-shadow">
            <a class="textbanner-link" href="https://beethovenvillavo.com/limpieza-e-higiene/" title="Banner de BEETHOVEN PET CARE VILLAVICENCIO " aria-label="Banner de BEETHOVEN PET CARE VILLAVICENCIO ">
                <div class="textbanner-image">
                    <img class="textbanner-image-background lazyautosizes blur-up-huge lazyloaded" src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/1-img-884447024-1684682010-4e25bde5637f9c6252df9cda6f0b2ec41684682010-50-0.webp?1969931227" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/1-img-884447024-1684682010-4e25bde5637f9c6252df9cda6f0b2ec41684682010-480-0.webp?1969931227 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/1-img-884447024-1684682010-4e25bde5637f9c6252df9cda6f0b2ec41684682010-640-0.webp?1969931227 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/1-img-884447024-1684682010-4e25bde5637f9c6252df9cda6f0b2ec41684682010-480-0.webp?1969931227 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/1-img-884447024-1684682010-4e25bde5637f9c6252df9cda6f0b2ec41684682010-640-0.webp?1969931227 640w">
                </div>
            </a>
        </div>
        `

        bannerSectionRow.appendChild(banner2);

        // Farmacia
        let banner3 = document.createElement('div');
        banner3.classList.add('col-md-4');
        
        banner3.innerHTML = `
        <div class="textbanner box-rounded textbanner-shadow">
            <a class="textbanner-link" href="https://beethovenvillavo.com/farmacia/" title="Banner de BEETHOVEN PET CARE VILLAVICENCIO " aria-label="Banner de BEETHOVEN PET CARE VILLAVICENCIO ">
                <div class="textbanner-image">
                    <img class="textbanner-image-background lazyautosizes blur-up-huge lazyloaded" src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1056899053-1684682252-dadf7ea78bd7b9f5c3efafdf1b85156e1684682252.png?904009221" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1056899053-1684682252-dadf7ea78bd7b9f5c3efafdf1b85156e1684682252.png?904009221 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1056899053-1684682252-dadf7ea78bd7b9f5c3efafdf1b85156e1684682252.png?904009221 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1056899053-1684682252-dadf7ea78bd7b9f5c3efafdf1b85156e1684682252.png?904009221 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1056899053-1684682252-dadf7ea78bd7b9f5c3efafdf1b85156e1684682252.png?904009221 640w">
                </div>
            </a>
        </div>
        `

        bannerSectionRow.appendChild(banner3);

        bannerSectionRow = document.querySelectorAll('.section-banners-home')[1].children[0].children[0];

        // Promoción 4 -> Agropecuaria
        let banner4 = document.createElement('div');
        banner4.classList.add('col-md-4');
        
        banner4.innerHTML = `
        <div class="textbanner box-rounded textbanner-shadow">
            <div class="textbanner-image">
                <img class="textbanner-image-background lazyautosizes blur-up-huge lazyloaded" src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2057876991-1684776242-138616a812a6e5ea3078483cb63850481684776242.png?657979914" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2057876991-1684776242-138616a812a6e5ea3078483cb63850481684776242.png?657979914 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2057876991-1684776242-138616a812a6e5ea3078483cb63850481684776242.png?657979914 640w" data-sizes="auto" data-expand="-10" alt="Banner de BEETHOVEN PET CARE VILLAVICENCIO " sizes="183px" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2057876991-1684776242-138616a812a6e5ea3078483cb63850481684776242.png?657979914 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2057876991-1684776242-138616a812a6e5ea3078483cb63850481684776242.png?657979914 640w">
            </div>
        </div>
        `
        bannerSectionRow.appendChild(banner4);
    }


	{#/*============================================================================
	  #Social
	==============================================================================*/ #}

    {% if template == 'home' %}
        {% set video_url = settings.video_embed %}
    {% elseif template == 'product' and product.video_url %}
        {% set video_url = product.video_url %}
    {% endif %}

	{% if video_url %}

        {# /* // Youtube or Vimeo video for home or each product */ #}

        LS.loadVideo('{{ video_url }}');

    {% endif %}

	{#/*============================================================================
	  #Product grid
	==============================================================================*/ #}

    {# /* // Secondary image on mouseover */ #}
    
    {% if settings.product_hover %}
        if (window.innerWidth > 767) {
            jQueryNuvem(document).on("mouseover", ".js-item-with-secondary-image:not(.item-with-two-images)", function(e) {
                var secondary_image_to_show = jQueryNuvem(this).find(".js-item-image-secondary");
                secondary_image_to_show.show();
                secondary_image_to_show.on('lazyloaded', function(e){
                    jQueryNuvem(e.currentTarget).closest(".js-item-with-secondary-image").addClass("item-with-two-images");
                });
            });
        }
    {% endif %}

    var $category_controls = jQueryNuvem(".js-category-controls");
    var mobile_nav_height = jQueryNuvem(".js-head-main").innerHeight();

	{% if template == 'category' %}

        {# /* // Fixed category controls */ #}

        if (window.innerWidth < 768) {

            {% if settings.head_fix %}
                $category_controls.css("top" , mobile_nav_height.toString() + 'px');
            {% else %}
                jQueryNuvem(".js-category-controls").css("top" , "0px");
            {% endif %}

            {# Detect if category controls are sticky and add css #}

            var observer = new IntersectionObserver(function(entries) {
                if(entries[0].intersectionRatio === 0)
                    jQueryNuvem(".js-category-controls").addClass("is-sticky");
                else if(entries[0].intersectionRatio === 1)
                    jQueryNuvem(".js-category-controls").removeClass("is-sticky");
                }, { threshold: [0,1]
            });

            observer.observe(document.querySelector(".js-category-controls-prev"));
        }


        {# /* // Navigation Buttons */ #}

        if (window.innerWidth < 768) {
            (function() {
            let section = document.body.children[13].children[3];
            let navButtonsList = document.createElement('div');
            navButtonsList.classList.add('nav-buttons-list')


            // Alimentos, Accesorios, Higiene, Farmacia -> Gato, Perro
            if (window.location.href.includes('https://beethovenvillavo.com/marcas/') 
                || window.location.href.includes('https://beethovenvillavo.com/accesorios/')
                || window.location.href.includes('https://beethovenvillavo.com/limpieza-e-higiene/')
                || window.location.href.includes('https://beethovenvillavo.com/farmacia/')) {

                if (window.location.href.includes('https://beethovenvillavo.com/marcas/') && window.location.href.split('/').length - 1  == 4) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                    </div>
                    `
                } else if (window.location.href.includes('https://beethovenvillavo.com/accesorios/') && window.location.href.split('/').length - 1  == 4) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/accesorios1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/accesorios2/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                    </div>
                    `
                } else if (window.location.href.includes('https://beethovenvillavo.com/farmacia/') && window.location.href.split('/').length - 1  == 4) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/farmacia2/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/farmacia1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                    </div>
                    `
                } else if (window.location.href.includes('https://beethovenvillavo.com/limpieza-e-higiene/') && window.location.href.split('/').length - 1  == 4){
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/higiene-y-cuidados/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/limpieza-higiene-y-cuidados/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                    </div>
                    `
                }

                section.insertAdjacentElement('beforebegin', navButtonsList);
            }

            // Concentrados -> Cachorro, Adulto, Senior
            else if ((window.location.href.includes('https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/') ||
                window.location.href.includes('https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/')) 
                && window.location.href.split('/').length - 1  == 7){
                if (window.location.href.includes('perros')) {
                    navButtonsList.innerHTML = `
                    <div class="listRow"><a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/cachorros/">Cachorros</a></div>
                    <div class="listRow"><a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/adultos/">Adultos</a></div>
                    <div class="listRow"><a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/senior-7/">Senior(+7)</a></div>
                    `
                } else if (window.location.href.includes('gatos')) {
                    navButtonsList.innerHTML = `
                    <div class="listRow"><a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/cachorros1/">Cachorros</a></div>
                    <div class="listRow"><a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/adultos1/">Adultos</a></div>
                    <div class="listRow"><a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/senior-71/">Senior(+7)</a></div>
                    `
                }

                section.insertAdjacentElement('beforebegin', navButtonsList);
            }

            // Dietas -> Alergias, Obesidad, Hepático, ...
            else if ((window.location.href.includes('https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/') ||
                window.location.href.includes('https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/')) 
                && window.location.href.split('/').length - 1  == 7){
                if (window.location.href.includes('perros')) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/alergias/">Alergias</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/hepatico/">Hepático</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/gastrointestinal/">Gastrointestinal</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/obesidad/">Obesidad</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/renal-urinary/">Renal/Urinary</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/otros/">Otros</a>
                    </div>
                    `
                } else if (window.location.href.includes('gatos')) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/alergias2/">Alergias</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/hepatico2/">Hepático</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/gastrointestinal2/">Gastrointestinal</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/obesidad2/">Obesidad</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/renal-urinary2/">Renal/Urinary</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/otros2/">Otros</a>
                    </div>
                    `
                }

                section.insertAdjacentElement('beforebegin', navButtonsList);
            }

            // Humedo medicado -> Alergias, Obesidad, Hepático, ...
            else if ((window.location.href.includes('https://beethovenvillavo.com/perros/alimentos1/alimento-humedo/dieta-blanda-medicada/') ||
                window.location.href.includes('https://beethovenvillavo.com/gatos/alimentos2/alimento-humedo2/dieta-blanda-medicada1/')) 
                && window.location.href.split('/').length - 1  == 7){
                if (window.location.href.includes('perros')) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimento-humedo/dieta-blanda-medicada/alergias1/">Alergias</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimento-humedo/dieta-blanda-medicada/hepatico1/">Hepático</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimento-humedo/dieta-blanda-medicada/gastrointestinal1/">Gastrointestinal</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimento-humedo/dieta-blanda-medicada/obesidad1/">Obesidad</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimento-humedo/dieta-blanda-medicada/renal-urinary1/">Renal/Urinary</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimento-humedo/dieta-blanda-medicada/otros1/">Otros</a>
                    </div>
                    `
                } else if (window.location.href.includes('gatos')) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/alimento-humedo2/dieta-blanda-medicada1/alergias3/">Alergias</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/alimento-humedo2/dieta-blanda-medicada1/hepatico3/">Hepático</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/alimento-humedo2/dieta-blanda-medicada1/gastrointestinal3/">Gastrointestinal</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/alimento-humedo2/dieta-blanda-medicada1/obesidad3/">Obesidad</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/alimento-humedo2/dieta-blanda-medicada1/renal-urinary3/">Renal/Urinary</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/alimento-humedo2/dieta-blanda-medicada1/otros3/">Otros</a>
                    </div>
                    `
                }

                section.insertAdjacentElement('beforebegin', navButtonsList);
            }

            // Alimento Seco -> Concentrado, Dietas
            else if ((window.location.href.includes('https://beethovenvillavo.com/perros/alimentos1/alimentos/') ||
                window.location.href.includes('https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/'))
                && window.location.href.split('/').length - 1  == 6){
                if (window.location.href.includes('perros')) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/">Concentrados de Mantenimiento</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/">Dietas de Prescripción Veterinaria</a>
                    </div>
                    `
                } else if (window.location.href.includes('gatos')) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/">Concentrados de Mantenimiento</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/">Dietas de Prescripción Veterinaria</a>
                    </div>
                    `
                }

                section.insertAdjacentElement('beforebegin', navButtonsList);
            }

            // Alimento Húmedo -> Pouches, Dieta Blanda
            else if ((window.location.href.includes('https://beethovenvillavo.com/perros/alimentos1/alimento-humedo/') ||
                window.location.href.includes('https://beethovenvillavo.com/gatos/alimentos2/alimento-humedo2/'))
                && window.location.href.split('/').length - 1  == 6){
                if (window.location.href.includes('perros')) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimento-humedo/pouches-y-latas/">Pouches y Latas</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimento-humedo/dieta-blanda-medicada/">Dieta Blanda Medicada</a>
                    </div>
                    `
                } else if (window.location.href.includes('gatos')) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/alimento-humedo2/pouches-y-latas-alimento-humedo/">Pouches y Latas</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/alimento-humedo2/dieta-blanda-medicada1/">Dieta Blanda Medicada</a>
                    </div>
                    `
                }

                section.insertAdjacentElement('beforebegin', navButtonsList);
            }

            // Snacks Perro -> Galletas, Huesitos, Naturales
            else if (window.location.href.includes('https://beethovenvillavo.com/perros/alimentos1/snacks/')
                    && window.location.href.split('/').length - 1  == 6){
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/snacks/galletas-y-huesos/">Galletas y Golosinas</a>
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/snacks/opciones-naturales/">Opciones Naturales</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/snacks/huesos-naturales-o-de-carnasa/">Huesitos</a>
                </div>
                `
                
                section.insertAdjacentElement('beforebegin', navButtonsList);
            }

            // Alimentos -> Seco, Húmedo, Snacks, ...
            else if ((window.location.href.includes('https://beethovenvillavo.com/perros/alimentos1/') ||
                window.location.href.includes('https://beethovenvillavo.com/gatos/alimentos2/'))
                && window.location.href.split('/').length - 1  == 5) {
                if (window.location.href.includes('perros')) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/">Alimento Seco</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/snacks/">Snacks y Golosinas</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimento-humedo/">Alimento Húmedo</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/dietas-barf/">Dietas Barf</a>
                    </div>
                    `
                } else if (window.location.href.includes('gatos')) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/">Alimento Seco</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/snacks1/">Snacks y Golosinas</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/alimento-humedo2/">Alimento Húmedo</a>
                    </div>
                    `
                }

                section.insertAdjacentElement('beforebegin', navButtonsList);
            }

            // Accesorios -> Juguetes, Comederos, Collares, ...
            else if ((window.location.href.includes('https://beethovenvillavo.com/perros/accesorios1/') ||
                window.location.href.includes('https://beethovenvillavo.com/gatos/accesorios2/'))
                && window.location.href.split('/').length - 1  == 5) {
                if (window.location.href.includes('perros')) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/accesorios1/juguetes1/">Juguetes</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/accesorios1/camas/">Camas</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/accesorios1/maletas-y-transportadores/">Maletas y transportadores</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/accesorios1/comederos/">Comederos</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/accesorios1/cepillos-y-deslanadores/">Cepillos y Deslanadores</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/accesorios1/collares-e-indumentaria/">Collares e Indumentaria</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/accesorios1/para-el-parque-y-paseos/">Para el Parque y Paseos</a>
                    </div>
                    `
                } else if (window.location.href.includes('gatos')) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/accesorios2/juguetes2/">Juguetes</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/accesorios2/collares-y-pecheras/">Collares y Pecheras</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/accesorios2/maletas-y-transportadores2/">Maletas y Transportadores</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/accesorios2/comederos-y-fuentes1/">Comederos y fuentes</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/accesorios2/gimnasios-camas-y-rascadores/">Gimnasios, Camas y Rascadores</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/accesorios2/cepillos-y-deslanadores1/">Cepillos y Deslanadores</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/accesorios2/cajas-de-arena-areneras/">Areneras</a>
                    </div>
                    `
                }

                section.insertAdjacentElement('beforebegin', navButtonsList);
            }

            // Limpieza. higiene y cuidados -> Para el hogar, Pañitos, Tapetes, Pañales, ...
            else if ((window.location.href.includes('https://beethovenvillavo.com/perros/higiene-y-cuidados/') ||
                window.location.href.includes('https://beethovenvillavo.com/gatos/limpieza-higiene-y-cuidados/'))
                && window.location.href.split('/').length - 1  == 5) {
                if (window.location.href.includes('perros')) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/higiene-y-cuidados/cosmeticos-para-bano/">Cosméticos para Pelaje y Baño</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/higiene-y-cuidados/panales-y-tapetes/">Pañitos, Tapetes y Pañales</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/higiene-y-cuidados/para-el-hogar1/">Para el Hogar y Adiestramiento</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/higiene-y-cuidados/cuidado-dental/">Cuidado Preventivo</a>
                    </div>
                    `
                } else if (window.location.href.includes('gatos')) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/limpieza-higiene-y-cuidados/para-tratamientos-dermatologicos/">Cosméticos para Pelaje y Baño</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/limpieza-higiene-y-cuidados/panitos-tapetes-y-panales1/">Pañitos, Tapetes y Pañales</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/arenas/">Arenas Sanitarias</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/limpieza-higiene-y-cuidados/para-el-hogar-y-adiestramiento/">Para el Hogar y Adiestramiento</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/limpieza-higiene-y-cuidados/cuidado-preventivo-dental-otico-y-mas1/">Cuidado Preventivo</a>
                    </div>
                    `
                }

                section.insertAdjacentElement('beforebegin', navButtonsList);
            }

            // Farmacia -> Antipulgas, Purgantes, Suplementos...
            else if ((window.location.href.includes('https://beethovenvillavo.com/perros/farmacia2/') ||
                window.location.href.includes('https://beethovenvillavo.com/gatos/farmacia1/'))
                && window.location.href.split('/').length - 1  == 5) {
                if (window.location.href.includes('perros')) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/farmacia2/antipulgas-y-garrapatas2/">Antipulgas y garrapatas</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/farmacia2/desinfectantes-y-cicatrizantes1/">Desinfectantes y cicatrizantes</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/farmacia2/afecciones-gastrointestinales/">Afecciones gastrointestinales</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/farmacia2/ver-mas3/">Ver más...</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/perros/farmacia2/desparasitantes-purgantes2/">Desparasitantes y purgantes</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/farmacia2/suplementos-multivitaminicos2/">Suplementos multivitaminicos</a>
                        <a class="navButton" href="https://beethovenvillavo.com/perros/farmacia2/afecciones-dermatologicas/">Afecciones dermatológicas</a>
                    </div>
                    `
                } else if (window.location.href.includes('gatos')) {
                    navButtonsList.innerHTML = `
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/farmacia1/antipulgas-y-garrapatas1/">Antipulgas y garrapatas</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/farmacia1/desinfectantes-y-cicatrizantes/">Desinfectantes y cicatrizantes</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/farmacia1/para-afecciones-gastrointestinales/">Afecciones gastrointestinales</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/farmacia1/ver-mas2/">Ver más...</a>
                    </div>
                    <div class="list">
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/farmacia1/desparasitantes-purgantes1/">Desparasitantes y purgantes</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/farmacia1/suplementos-multivitaminicos1/">Suplementos multivitaminicos</a>
                        <a class="navButton" href="https://beethovenvillavo.com/gatos/farmacia1/para-afecciones-dermatologicas1/">Afecciones dermatológicas</a>
                    </div>
                    `
                }

                section.insertAdjacentElement('beforebegin', navButtonsList);
            }

            // Perro -> Alimentos, Accesorios, Higiene...
            else if (window.location.href.includes('https://beethovenvillavo.com/perros/')
                    && window.location.href.split('/').length - 1  == 4) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/">Alimentos</a>
                    <a class="navButton" href="https://beethovenvillavo.com/perros/accesorios1/">Accesorios</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/higiene-y-cuidados/">Higiene</a>
                    <a class="navButton" href="https://beethovenvillavo.com/perros/farmacia2/">Farmacia</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            }

            // Gato -> Alimentos, Accesorios, Higiene...
            else if (window.location.href.includes('https://beethovenvillavo.com/gatos/')
                    && window.location.href.split('/').length - 1  == 4) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/">Alimentos</a>
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/limpieza-higiene-y-cuidados/">Higiene</a>
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/farmacia1/">Farmacia</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/arenas/">Arenas Sanitarias</a>
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/accesorios2/">Accesorios</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            }
            })();
        }


        {# /* // Brand Carousel */ #}
        
        if (true) {
            (function() {
            let section = document.body.children[13].children[3];
            let brandCarousel = document.createElement('div');
            brandCarousel.classList.add('brand-carousel-container')

            // Dietas Perro y gato
            if ((window.location.href.includes('https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/')
                || window.location.href.includes('https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/'))
                && window.location.href.split('/').length - 1  == 7){
                if (window.location.href.includes('perro')) {
                    brandCarousel.innerHTML = `
                    <button class="carousel-left-btn"><p>&#8249;</p></button>
                    <div class="brand-carousel">
                        <div class="brands">
                            <img src="https://mex.mars.com/sites/g/files/jydpyr316/files/2019-03/Logos_BUSINESS_SEGMENTS_23.png" alt="Royal Canin"
                            onclick="window.location.href = 'https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/royal-canin2/'">
                            <img src="https://s3.us-east-1.amazonaws.com/laikapp/images_categories/vet_life_circulo2.png" alt="Vet Life"
                            onclick="window.location.href = 'https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/vet-life1/'">
                            <img src="https://uxt-cf-images.mediazs.com/w4bhfqu0yxyq/pAFdxb9hJrgI55GNkamCa/e1bb3ec3b41a768f90677b9a08082538/logo_Hills1000x1000.jpg?fm=jpg&fl=progressive&w=300&q=85" alt="Hill's"
                            onclick="window.location.href = 'https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/hills2/'">
                            <img src="data:image/png;base64,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" alt="Pro Plan"
                            onclick="window.location.href = 'https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/pro-plan2/'">
                            <img src="https://exiagricola.net/tienda/wp-content/uploads/2017/07/logo-equilibrio.jpg" alt="Equilibrio"
                            onclick="window.location.href = 'https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/equilibrio2/'">
                        </div>
                    </div>
                    <a class="navButton" style="font-size: 20px;" href="https://beethovenvillavo.com/marcas1/">VER TODAS</a>
                    <button class="carousel-right-btn"><p>&#8250;</p></button>
                    `
                } else if (window.location.href.includes('gato')) {
                    brandCarousel.innerHTML = `
                    <button class="carousel-left-btn"><p>&#8249;</p></button>
                    <div class="brand-carousel">
                        <div class="brands">
                            <img src="https://mex.mars.com/sites/g/files/jydpyr316/files/2019-03/Logos_BUSINESS_SEGMENTS_23.png" alt="Royal Canin"
                            onclick="window.location.href = 'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/royal-canin4/'">
                            <img src="https://s3.us-east-1.amazonaws.com/laikapp/images_categories/vet_life_circulo2.png" alt="Vet Life"
                            onclick="window.location.href = 'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/vet-life2/'">
                            <img src="https://uxt-cf-images.mediazs.com/w4bhfqu0yxyq/pAFdxb9hJrgI55GNkamCa/e1bb3ec3b41a768f90677b9a08082538/logo_Hills1000x1000.jpg?fm=jpg&fl=progressive&w=300&q=85" alt="Hill's"
                            onclick="window.location.href = 'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/hills4/'">
                            <img src="data:image/png;base64,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" alt="Pro Plan"
                            onclick="window.location.href = 'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/pro-plan4/'">
                            <img src="https://exiagricola.net/tienda/wp-content/uploads/2017/07/logo-equilibrio.jpg" alt="Equilibrio"
                            onclick="window.location.href = 'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/equilibrio4/'">
                        </div>
                        <a class="navButton" style="font-size: 20px;" href="https://beethovenvillavo.com/marcas1/">VER TODAS</a>
                    </div>
                    <button class="carousel-right-btn"><p>&#8250;</p></button>
                    `
                }
                
                section.insertAdjacentElement('beforebegin', brandCarousel);
            }

            // Alimentos, Seco, Concentrados Perro
            else if ((window.location.href.includes('https://beethovenvillavo.com/perros/') && window.location.href.split('/').length - 1  == 4)
                    || (window.location.href.includes('https://beethovenvillavo.com/perros/alimentos1/') && window.location.href.split('/').length - 1  == 5)
                    || (window.location.href.includes('https://beethovenvillavo.com/perros/alimentos1/alimentos/') && window.location.href.split('/').length - 1  == 6)
                    || (window.location.href.includes('https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/') && window.location.href.split('/').length - 1  == 7)){
                brandCarousel.innerHTML = `
                <button class="carousel-left-btn"><p>&#8249;</p></button>
                <div class="brand-carousel">
                    <div class="brands">
                        <img src="https://laikapp.s3.amazonaws.com/dev_images_categories/AGILITY_GOLD_CIRCULO_OK2.png" alt="Agility Gold">
                        <img src="https://www.laika.com.uy/media/catalog/category/max.png" alt="Max">
                        <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbl5jqXwarJux5wx2vXi7thOJ7WgeoXxAw8iFfPj_jkVdreyLdepa631bPKLPm8uUjoN4&usqp=CAU" alt="Naturalis">
                        <img src="https://s3.us-east-1.amazonaws.com/laikapp/images_categories/chunky_circulo3.png" alt="Chunky">
                        <img src="https://cdn.shopify.com/s/files/1/0580/6191/4287/collections/Ceba-ITALCAN-marca.png?v=1625065230" alt="Italcan">
                        <img src="https://picosyplumas.co/wp-content/uploads/2020/04/Logo-Monello.png" alt="Monello">
                        <img src="https://www.nestle.com.br/sites/g/files/pydnoa436/files/styles/brand_image/public/logo-purina-dog-chow.jpg?itok=qvuOKTIk" alt="Dog Chow">
                        <img src="https://mex.mars.com/sites/g/files/jydpyr316/files/2019-03/Logos_BUSINESS_SEGMENTS_23.png" alt="Royal Canin">
                        <img src="data:image/png;base64,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" alt="Pro Plan">
                        <img src="https://uxt-cf-images.mediazs.com/w4bhfqu0yxyq/pAFdxb9hJrgI55GNkamCa/e1bb3ec3b41a768f90677b9a08082538/logo_Hills1000x1000.jpg?fm=jpg&fl=progressive&w=300&q=85" alt="Hill's">
                        <img src="https://laikapp.s3.amazonaws.com/dev_images_categories/TASTE_OF_THE_WILD_CIRCULO.png" alt="Taste of the Wild">
                        <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-J8kI7yDUu-S-_xz8QQBW6r4Ler1m0Zm3RI3kwiRKmBIr5ER55xZWjgtJP0vgkdgL5xk&usqp=CAU" alt="Nutra Nuggets">
                        <img src="https://laikapp.s3.amazonaws.com/images_categories/1591636532_DONKAN_1254X1092.png" alt="Donkan">
                        <img src="https://laikapp.s3.amazonaws.com/images_categories/1587054860_DOGOURMET_300X300.png" alt="Dogourmet">
                        <img src="https://ceragro.com/wp-content/uploads/2021/10/logo_ringo.png" alt="Ringo">
                        <img src="https://s3.us-east-1.amazonaws.com/laikapp/images_categories/filpo_circulo.png" alt="Filpo">
                        <img src="https://pbs.twimg.com/profile_images/553276024469745665/_dIOQEOA_400x400.jpeg" alt="Nutre Can">
                        <img src="https://orangepet.cl/media/codazon_cache/brand/400x400/wysiwyg/codazon/grocery_gourmet/home/Acana.jpg" alt="Acana">
                        <img src="https://cdn.shopify.com/s/files/1/0435/6374/5433/files/Evolve_Logo.png?v=1668790317" alt="Evolve">
                        <img src="https://royalpet.pe/wp-content/uploads/2021/05/purina-excellent-logo-EFA929CAF8-seeklogo.com_.png" alt="Excellent Purina">
                        <img src="https://exiagricola.net/tienda/wp-content/uploads/2017/07/logo-equilibrio.jpg" alt="Equilibrio">
                        <img src="https://nupec.com/wp-content/uploads/2020/06/images.png" alt="Nupec">
                    </div>
                </div>
                <a class="navButton" style="font-size: 20px;" href="https://beethovenvillavo.com/marcas1/">VER TODAS</a>
                <button class="carousel-right-btn"><p>&#8250;</p></button>
                `
                
                section.insertAdjacentElement('beforebegin', brandCarousel);
            }

            // Alimentos, Seco, Concentrados gato
            else if ((window.location.href.includes('https://beethovenvillavo.com/gatos/') && window.location.href.split('/').length - 1  == 4)
                    || (window.location.href.includes('https://beethovenvillavo.com/gatos/alimentos2/') && window.location.href.split('/').length - 1  == 5)
                    || (window.location.href.includes('https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/') && window.location.href.split('/').length - 1  == 6)
                    || (window.location.href.includes('https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/') && window.location.href.split('/').length - 1  == 7)){
                brandCarousel.innerHTML = `
                <button class="carousel-left-btn"><p>&#8249;</p></button>
                <div class="brand-carousel">
                    <div class="brands">
                        <img src="https://1000marcas.net/wp-content/uploads/2021/06/Whiskas-logo.png" alt="Whiskas"></img>
                        <img src="https://s3.us-east-1.amazonaws.com/laikapp/images_categories/BR_FOR_CAT1.png" alt="Br For Cat"></img>
                        <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-J8kI7yDUu-S-_xz8QQBW6r4Ler1m0Zm3RI3kwiRKmBIr5ER55xZWjgtJP0vgkdgL5xk&usqp=CAU" alt="Nutra Nuggets">
                        <img src="https://royalpet.pe/wp-content/uploads/2021/05/purina-excellent-logo-EFA929CAF8-seeklogo.com_.png" alt="Excellent Purina">
                        <img src="https://exiagricola.net/tienda/wp-content/uploads/2017/07/logo-equilibrio.jpg" alt="Equilibrio">
                        <img src="https://nupec.com/wp-content/uploads/2020/06/images.png" alt="Nupec">
                        <img src="https://laikapp.s3.amazonaws.com/images_categories/1591640419_DONKAT_820X761.png" alt="Donkat"></img>
                        <img src="data:image/jpeg;base64,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" alt="Oh Mai Gat"></img>
                        <img src="https://uxt-cf-images.mediazs.com/w4bhfqu0yxyq/pAFdxb9hJrgI55GNkamCa/e1bb3ec3b41a768f90677b9a08082538/logo_Hills1000x1000.jpg?fm=jpg&fl=progressive&w=300&q=85" alt="Hill's">
                        <img src="https://picosyplumas.co/wp-content/uploads/2020/04/Logo-Mirringo.png" alt="Mirringo"></img>
                        <img src="https://pbs.twimg.com/profile_images/553276723106574336/b-djD6AW_400x400.jpeg" alt="Nutrecat"></img>
                        <img src="https://sandycat.com.co/wp-content/uploads/2019/10/q-ida-cat-150x150.jpg" alt="Q-idacat"></img>
                        <img src="https://cdn.shopify.com/s/files/1/0435/6374/5433/files/Evolve_Logo.png?v=1668790317" alt="Evolve">
                        <img src="https://orangepet.cl/media/codazon_cache/brand/400x400/wysiwyg/codazon/grocery_gourmet/home/Acana.jpg" alt="Acana">
                        <img src="https://laikapp.s3.amazonaws.com/dev_images_categories/TASTE_OF_THE_WILD_CIRCULO.png" alt="Taste of the Wild">
                        <img src="https://mex.mars.com/sites/g/files/jydpyr316/files/2019-03/Logos_BUSINESS_SEGMENTS_23.png" alt="Royal Canin">
                        <img src="data:image/png;base64,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" alt="Pro Plan">
                        <img src="https://s3.us-east-1.amazonaws.com/laikapp/images_categories/chunky_circulo3.png" alt="Chunky">
                        <img src="https://picosyplumas.co/wp-content/uploads/2020/04/Logo-Monello.png" alt="Monello">
                        <img src="https://laikapp.s3.amazonaws.com/dev_images_categories/AGILITY_GOLD_CIRCULO_OK2.png" alt="Agility Gold">
                        <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbl5jqXwarJux5wx2vXi7thOJ7WgeoXxAw8iFfPj_jkVdreyLdepa631bPKLPm8uUjoN4&usqp=CAU" alt="Naturalis">
                        <img src="https://www.laika.com.uy/media/catalog/category/max.png" alt="Max">
                    </div>
                </div>
                <a class="navButton" style="font-size: 20px;" href="https://beethovenvillavo.com/marcas1/">VER TODAS</a>
                <button class="carousel-right-btn"><p>&#8250;</p></button>
                `
                
                section.insertAdjacentElement('beforebegin', brandCarousel);
            }

            // Marcas Perro Gato
            else if (window.location.href.includes('https://beethovenvillavo.com/marcas/') && window.location.href.split('/').length - 1  == 4){
                brandCarousel.innerHTML = `
                <button class="carousel-left-btn"><p>&#8249;</p></button>
                <div class="brand-carousel">
                    <div class="brands">
                        <img src="https://laikapp.s3.amazonaws.com/dev_images_categories/AGILITY_GOLD_CIRCULO_OK2.png" alt="Agility Gold"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/agility-gold1/'">
                        <img src="https://nupec.com/wp-content/uploads/2020/06/images.png" alt="Nupec"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/nupec/'">
                        <img src="https://www.laika.com.uy/media/catalog/category/max.png" alt="Max"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/max1/'">
                        <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbl5jqXwarJux5wx2vXi7thOJ7WgeoXxAw8iFfPj_jkVdreyLdepa631bPKLPm8uUjoN4&usqp=CAU" alt="Naturalis"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/max1/'">
                        <img src="https://s3.us-east-1.amazonaws.com/laikapp/images_categories/chunky_circulo3.png" alt="Chunky"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/chunky/'">
                        <img src="https://picosyplumas.co/wp-content/uploads/2020/04/Logo-Monello.png" alt="Monello"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/monello/'">
                        <img src="https://mex.mars.com/sites/g/files/jydpyr316/files/2019-03/Logos_BUSINESS_SEGMENTS_23.png" alt="Royal Canin"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/royal-canin/'">
                        <img src="https://uxt-cf-images.mediazs.com/w4bhfqu0yxyq/pAFdxb9hJrgI55GNkamCa/e1bb3ec3b41a768f90677b9a08082538/logo_Hills1000x1000.jpg?fm=jpg&fl=progressive&w=300&q=85" alt="Hill's"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/hills/'">
                        <img src="https://s3.us-east-1.amazonaws.com/laikapp/images_categories/vet_life_circulo2.png" alt="Vet Life"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/vet-life/'">
                        <img src="data:image/png;base64,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" alt="Pro Plan"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/pro-plan/'">
                        <img src="https://exiagricola.net/tienda/wp-content/uploads/2017/07/logo-equilibrio.jpg" alt="Equilibrio"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/equilibrio/'">
                        <img src="https://royalpet.pe/wp-content/uploads/2021/05/purina-excellent-logo-EFA929CAF8-seeklogo.com_.png" alt="Excellent Purina"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/excellent/'">
                        <img src="https://cdn.shopify.com/s/files/1/0435/6374/5433/files/Evolve_Logo.png?v=1668790317" alt="Evolve"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/evolve/'">
                        <img src="https://orangepet.cl/media/codazon_cache/brand/400x400/wysiwyg/codazon/grocery_gourmet/home/Acana.jpg" alt="Acana"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/orijen-acana/'">
                        <img src="data:image/png;base64,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" alt="Orijen"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/orijen-acana/'">
                        <img src="https://laikapp.s3.amazonaws.com/dev_images_categories/TASTE_OF_THE_WILD_CIRCULO.png" alt="Taste of the Wild"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/taste-of-the-wild/'">
                        <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-J8kI7yDUu-S-_xz8QQBW6r4Ler1m0Zm3RI3kwiRKmBIr5ER55xZWjgtJP0vgkdgL5xk&usqp=CAU" alt="Nutra Nuggets"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/nutra-nuggets/'">
                        <img src="https://s3.us-east-1.amazonaws.com/laikapp/images_categories/BR_FOR_CAT1.png" alt="Br For Cat"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/br-for-cats-dogs/'">
                        <img src="https://pbs.twimg.com/profile_images/553276024469745665/_dIOQEOA_400x400.jpeg" alt="Nutre Can"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/nutre-can/'">
                        <img src="https://pbs.twimg.com/profile_images/553276723106574336/b-djD6AW_400x400.jpeg" alt="Nutrecat"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/nutre-can/'">
                        <img src="https://logodownload.org/wp-content/uploads/2019/09/pedigree-logo-5.png" alt="Pedigree"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/pedigree-whiskas/'">
                        <img src="https://1000marcas.net/wp-content/uploads/2021/06/Whiskas-logo.png" alt="Whiskas"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/pedigree-whiskas/'">
                        <img src="https://www.nestle.com.br/sites/g/files/pydnoa436/files/styles/brand_image/public/logo-purina-dog-chow.jpg?itok=qvuOKTIk" alt="Dog Chow"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/dog-chow-cat-chow/'">
                        <img src="https://s3.us-east-1.amazonaws.com/laikapp/images_categories/cat_chow_circulo.png" alt="Cat Chow"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/dog-chow-cat-chow/'">
                        <img src="https://ceragro.com/wp-content/uploads/2021/10/logo_ringo.png" alt="Ringo"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/ringo-mirringo/'">
                        <img src="https://picosyplumas.co/wp-content/uploads/2020/04/Logo-Mirringo.png" alt="Mirringo"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/ringo-mirringo/'">
                        <img src="https://laikapp.s3.amazonaws.com/images_categories/1587054860_DOGOURMET_300X300.png" alt="Dogourmet"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/otras-marcas/dogourmet/'">
                        <img src="data:image/jpeg;base64,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" alt="Oh Mai Gat"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/otras-marcas/oh-mai-gat/'">
                        <img src="https://laikapp.s3.amazonaws.com/images_categories/1591640419_DONKAT_820X761.png" alt="Donkat"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/otras-marcas/donkat-gatos/'">
                        <img src="https://s3.us-east-1.amazonaws.com/laikapp/images_categories/filpo_circulo.png" alt="Filpo"
                        onclick="window.location.href = 'https://beethovenvillavo.com/marcas/otras-marcas/filpo/'">
                    </div>
                </div>
                <a class="navButton" style="font-size: 20px;" href="https://beethovenvillavo.com/marcas1/">VER TODAS</a>
                <button class="carousel-right-btn"><p>&#8250;</p></button>
                `
                
                section.insertAdjacentElement('beforebegin', brandCarousel);
            }

            // Events
            if ((window.location.href.includes('https://beethovenvillavo.com/perros/')
                || window.location.href.includes('https://beethovenvillavo.com/gatos/')
                || window.location.href.includes('https://beethovenvillavo.com/marcas/') && window.location.href.split('/').length - 1  == 4)
                && window.location.href.split('/').length - 1  <= 5){

                const brands = document.querySelector('.brands');
                const leftBtn = document.querySelector('.carousel-left-btn');
                const rightBtn = document.querySelector('.carousel-right-btn');
    
                let index = 0;
                let numBrands;
                let touchStartX = 0;
                let touchEndX = 0;

                if (window.innerWidth >= 768) numBrands = 6;
                else numBrands = 5;

                brands.addEventListener('touchstart', function(event) {
                    touchStartX = event.touches[0].clientX;
                });

                brands.addEventListener('touchmove', function(event) {
                    touchEndX = event.touches[0].clientX;
                });

                brands.addEventListener('touchend', function(event) {
                    if (touchEndX < touchStartX) {
                        rightBtn.click();
                    } else if (touchEndX > touchStartX) {
                        leftBtn.click();
                    }
                });
    
                rightBtn.addEventListener('click', () => {
                index++;
                if (index > brands.children.length - numBrands) {
                    index = 0;
                }
                brands.style.transform = `translateX(-${index * (window.innerWidth * 0.85) / numBrands}px)`;
                });
    
                leftBtn.addEventListener('click', () => {
                index--;
                if (index < 0) {
                    index = brands.children.length - numBrands;
                }
                brands.style.transform = `translateX(-${index * (window.innerWidth * 0.85) / numBrands}px)`;
                });
    
                setInterval(() => {
                    rightBtn.click();
                }, 5000);
            }
            })();
        }



        {# /* // Filters */ #}

        jQueryNuvem(document).on("click", ".js-apply-filter, .js-remove-filter", function(e) {
            e.preventDefault();
            var filter_name = jQueryNuvem(this).data('filterName');
            var filter_value = jQueryNuvem(this).attr('data-filter-value');
            if(jQueryNuvem(this).hasClass("js-apply-filter")){
                jQueryNuvem(this).find("[type=checkbox]").prop("checked", true);
                LS.urlAddParam(
                    filter_name,
                    filter_value,
                    true
                );
            }else{
                jQueryNuvem(this).find("[type=checkbox]").prop("checked", false);
                LS.urlRemoveParam(
                    filter_name,
                    filter_value
                );
            }

            {# Toggle class to avoid adding double parameters in case of double click and show applying changes feedback #}

            if (jQueryNuvem(this).hasClass("js-filter-checkbox")){
                if (window.innerWidth < 768) {
                    jQueryNuvem(".js-filters-overlay").show();
                    if(jQueryNuvem(this).hasClass("js-apply-filter")){
                        jQueryNuvem(".js-applying-filter").show();
                    }else{
                        jQueryNuvem(".js-removing-filter").show();
                    }
                }
                jQueryNuvem(this).toggleClass("js-apply-filter js-remove-filter");
            }
        });

        jQueryNuvem(document).on("click", ".js-remove-all-filters", function(e) {
            e.preventDefault();
            LS.urlRemoveAllParams();
        });

		{# /* // Sort by */ #}

        jQueryNuvem('.js-sort-by').on("change", function (e) {
            var params = LS.urlParams;
            params['sort_by'] = jQueryNuvem(e.currentTarget).val();
            var sort_params_array = [];
            for (var key in params) {
                if (!['results_only', 'page'] == (key)) {
                    sort_params_array.push(key + '=' + params[key]);
                }
            }
            var sort_params = sort_params_array.join('&');
            window.location = window.location.pathname + '?' + sort_params;
        });

	{% endif %}

    {% if template == 'category' or template == 'search' %}

        !function() {

        	{# /* // Infinite scroll */ #}

            {% if pages.current == 1 and not pages.is_last %}
                LS.hybridScroll({
                    productGridSelector: '.js-product-table',
                    spinnerSelector: '#js-infinite-scroll-spinner',
                    loadMoreButtonSelector: '.js-load-more',
                    hideWhileScrollingSelector: ".js-hide-footer-while-scrolling",
                    productsBeforeLoadMoreButton: 50,
                    productsPerPage: 12
                });
            {% endif %}
        }();

	{% endif %}

    {% if settings.quick_shop %}

        {# /* // Quickshop */ #}

        jQueryNuvem(document).on("click", ".js-item-buy-open", function(e) {
            e.preventDefault();
            jQueryNuvem(this).toggleClass("btn-primary btn-secondary");
            jQueryNuvem(this).closest(".js-quickshop-container").find(".js-item-variants").fadeToggle(300);

            var elementTop = jQueryNuvem(this).closest(".js-product-container").offset().top;
            var viewportTop = window.pageYOffset;

            if(elementTop < viewportTop){
                document.documentElement.scroll({
                    top: jQueryNuvem(this).closest(".js-product-container").offset().top - 180,
                    behavior: 'smooth'
                });
            }

        });

        jQueryNuvem(document).on("click", ".js-item-buy-close", function(e) {
            e.preventDefault();
            jQueryNuvem(this).closest(".js-item-variants").fadeToggle(300);
            jQueryNuvem(this).closest(".js-quickshop-container").find(".js-item-buy-open").toggleClass("btn-primary btn-secondary");
        });

    {% endif %}

    {% if settings.product_color_variants %}

        {# Product color variations #}

        jQueryNuvem(document).on("click", ".js-color-variant", function(e) {
            e.preventDefault();
            $this = jQueryNuvem(this);

            var option_id = $this.data('option');
            $selected_option = $this.closest('.js-item-product').find('.js-variation-option option').filter(function(el) {
                return el.value == option_id;
            });
            $selected_option.prop('selected', true).trigger('change');
            var available_variant = jQueryNuvem(this).closest(".js-quickshop-container").data('variants');

            var available_variant_color = jQueryNuvem(this).closest('.js-color-variant-active').data('option');

            for (var variant in available_variant) {
                if (option_id == available_variant[variant]['option'+ available_variant_color ]) {

                    if (available_variant[variant]['stock'] == null || available_variant[variant]['stock'] > 0 ) {

                        var otherOptions = getOtherOptionNumbers(available_variant_color);

                        var otherOption = available_variant[variant]['option' + otherOptions[0]];
                        var anotherOption = available_variant[variant]['option' + otherOptions[1]];

                        changeSelect(jQueryNuvem(this), otherOption, otherOptions[0]);
                        changeSelect(jQueryNuvem(this), anotherOption, otherOptions[1]);
                        break;

                    }
                }
            }

            $this.siblings().removeClass("selected");
            $this.addClass("selected");
        });

        function getOtherOptionNumbers(selectedOption) {
            switch (selectedOption) {
                case 0:
                    return [1, 2];
                case 1:
                    return [0, 2];
                case 2:
                    return [0, 1];
            }
        }

        function changeSelect(element, optionToSelect, optionIndex) {
            if (optionToSelect != null) {
                var selected_option_attribute = element.closest('.js-item-product').find('.js-color-variant-available-' + (optionIndex + 1)).data('value');
                var selected_option = element.closest('.js-item-product').find('#' + selected_option_attribute + " option").filter(function(el) {
                    return el.value == optionToSelect;
                });

                selected_option.prop('selected', true).trigger('change');
            }
        }
    {% endif %}

    {% if settings.quick_shop or settings.product_color_variants %}

        LS.registerOnChangeVariant(function(variant){
            {# Show product image on color change #}
            var current_image = jQueryNuvem('.js-item-product[data-product-id="'+variant.product_id+'"] .js-item-image');
            current_image.attr('srcset', variant.image_url);

            {% if settings.product_hover %}
                {# Remove secondary feature on image updated from changeVariant #}
                current_image.closest(".js-item-with-secondary-image").removeClass("item-with-two-images");
            {% endif %}
        });

    {% endif %}

    {#/*============================================================================
	  #Product detail functions
	==============================================================================*/ #}

	{# /* // Installments */ #}

	{# Installments without interest #}

	function get_max_installments_without_interests(number_of_installment, installment_data, max_installments_without_interests) {
	    if (parseInt(number_of_installment) > parseInt(max_installments_without_interests[0])) {
	        if (installment_data.without_interests) {
	            return [number_of_installment, installment_data.installment_value.toFixed(2)];
	        }
	    }
	    return max_installments_without_interests;
	}

	{# Installments with interest #}

	function get_max_installments_with_interests(number_of_installment, installment_data, max_installments_with_interests) {
	    if (parseInt(number_of_installment) > parseInt(max_installments_with_interests[0])) {
	        if (installment_data.without_interests == false) {
	            return [number_of_installment, installment_data.installment_value.toFixed(2)];
	        }
	    }
	    return max_installments_with_interests;
	}

	{# Refresh installments inside detail popup #}

	function refreshInstallmentv2(price){
        jQueryNuvem(".js-modal-installment-price" ).each(function( el ) {
	        const installment = Number(jQueryNuvem(el).data('installment'));
	        jQueryNuvem(el).text(LS.currency.display_short + (price/installment).toLocaleString('de-DE', {maximumFractionDigits: 2, minimumFractionDigits: 2}));
	    });
	}

    {# Refresh price on payments popup with payment discount applied #}

    function refreshPaymentDiscount(price){
        jQueryNuvem(".js-price-with-discount" ).each(function( el ) {
            const payment_discount = jQueryNuvem(el).data('paymentDiscount');
            jQueryNuvem(el).text(LS.formatToCurrency(price - ((price * payment_discount) / 100)))
        });
    }

	{# /* // Change variant */ #}

	{# Updates price, installments, labels and CTA on variant change #}

	function changeVariant(variant) {
        jQueryNuvem(".js-product-detail .js-shipping-calculator-response").hide();
        jQueryNuvem("#shipping-variant-id").val(variant.id);

	    var parent = jQueryNuvem("body");
	    if (variant.element) {
	        parent = jQueryNuvem(variant.element);
	    }

	    var sku = parent.find('#sku');
	    if(sku.length) {
	        sku.text(variant.sku).show();
	    }

	    var installment_helper = function($element, amount, price){
	        $element.find('.js-installment-amount').text(amount);
	        $element.find('.js-installment-price').attr("data-value", price);
	        $element.find('.js-installment-price').text(LS.currency.display_short + parseFloat(price).toLocaleString('de-DE', { minimumFractionDigits: 2 }));
	        if(variant.price_short && Math.abs(variant.price_number - price * amount) < 1) {
	            $element.find('.js-installment-total-price').text((variant.price_short).toLocaleString('de-DE', { minimumFractionDigits: 2 }));
	        } else {
	            $element.find('.js-installment-total-price').text(LS.currency.display_short + (price * amount).toLocaleString('de-DE', { minimumFractionDigits: 2 }));
	        }
	    };

	    if (variant.installments_data) {
	        var variant_installments = JSON.parse(variant.installments_data);
	        var max_installments_without_interests = [0,0];
	        var max_installments_with_interests = [0,0];
	        for (let payment_method in variant_installments) {
                let installments = variant_installments[payment_method];
	            for (let number_of_installment in installments) {
                    let installment_data = installments[number_of_installment];
	                max_installments_without_interests = get_max_installments_without_interests(number_of_installment, installment_data, max_installments_without_interests);
	                max_installments_with_interests = get_max_installments_with_interests(number_of_installment, installment_data, max_installments_with_interests);
	                var installment_container_selector = '#installment_' + payment_method + '_' + number_of_installment;

	                if(!parent.hasClass("js-quickshop-container")){
	                    installment_helper(jQueryNuvem(installment_container_selector), number_of_installment, installment_data.installment_value.toFixed(2));
	                }
	            }
	        }
	        var $installments_container = jQueryNuvem(variant.element + ' .js-max-installments-container .js-max-installments');
	        var $installments_modal_link = jQueryNuvem(variant.element + ' #btn-installments');
	        var $payments_module = jQueryNuvem(variant.element + ' .js-product-payments-container');
	        var $installmens_card_icon = jQueryNuvem(variant.element + ' .js-installments-credit-card-icon');

	        {% if product.has_direct_payment_only %}
	        var installments_to_use = max_installments_without_interests[0] >= 1 ? max_installments_without_interests : max_installments_with_interests;

	        if(installments_to_use[0] <= 0 ) {
	        {%  else %}
	        var installments_to_use = max_installments_without_interests[0] > 1 ? max_installments_without_interests : max_installments_with_interests;

	        if(installments_to_use[0] <= 1 ) {
	        {% endif %}
	            $installments_container.hide();
	            $installments_modal_link.hide();
	            $payments_module.hide();
	            $installmens_card_icon.hide();
	        } else {
	            $installments_container.show();
	            $installments_modal_link.show();
	            $payments_module.show();
	            $installmens_card_icon.show();
	            installment_helper($installments_container, installments_to_use[0], installments_to_use[1]);
	        }
	    }

	    if(!parent.hasClass("js-quickshop-container")){
            jQueryNuvem('#installments-modal .js-installments-one-payment').text(variant.price_short).attr("data-value", variant.price_number);
		}

	    if (variant.price_short){

            var variant_price_clean = variant.price_short.replace('$', '').replace('R', '').replace(',', '').replace('.', '');
            var variant_price_raw = parseInt(variant_price_clean, 10);

	        parent.find('.js-price-display').text(variant.price_short).show();
	        parent.find('.js-price-display').attr("content", variant.price_number).data('productPrice', variant_price_raw);
	    } else {
	        parent.find('.js-price-display').hide();
	    }

	    if ((variant.compare_at_price_short) && !(parent.find(".js-price-display").css("display") == "none")) {
	        parent.find('.js-compare-price-display').text(variant.compare_at_price_short).show();
	    } else {
	        parent.find('.js-compare-price-display').hide();
	    }

	    var button = parent.find('.js-addtocart');
	    button.removeClass('cart').removeClass('contact').removeClass('nostock');
	    var $product_shipping_calculator = parent.find("#product-shipping-container");

        {# Update CTA wording and status #}

	    {% if not store.is_catalog %}
	    if (!variant.available){
	        button.val('{{ "Consultanos disponibilidad" | translate }}');
	        button.addClass('nostock');
            linkWhatsApp();
	        //button.attr('disabled', 'disabled');
	        $product_shipping_calculator.hide();
	    } else if (variant.contact) {
	        button.val('{{ "Consultar precio" | translate }}');
	        button.addClass('contact');
	        //button.removeAttr('disabled');
	        $product_shipping_calculator.hide();
	    } else {
	        button.val('{{ "Agregar al carrito" | translate }}');
	        button.addClass('cart');
	        button.removeAttr('disabled');
	        $product_shipping_calculator.show();
	    }

	    {% endif %}

        {% if template == 'product' %}
            const base_price = Number(jQueryNuvem("#price_display").attr("content"));
            refreshInstallmentv2(base_price);
            refreshPaymentDiscount(variant.price_number);

            {% if settings.last_product and product.variations %}
                if(variant.stock == 1) {
                    jQueryNuvem('.js-last-product').show();
                } else {
                    jQueryNuvem('.js-last-product').hide();
                }
            {% endif %}
        {% endif %}


        {# Update shipping on variant change #}

        LS.updateShippingProduct();

        zipcode_on_changevariant = jQueryNuvem("#product-shipping-container .js-shipping-input").val();
        jQueryNuvem("#product-shipping-container .js-shipping-calculator-current-zip").text(zipcode_on_changevariant);

        {% if store.has_free_shipping_progress and cart.free_shipping.min_price_free_shipping.min_price %}
            {# Updates free shipping bar #}

            LS.freeShippingProgress();

        {% endif %}
	}

	{# /* // Trigger change variant */ #}

    jQueryNuvem(document).on("change", ".js-variation-option", function(e) {
        var $parent = jQueryNuvem(this).closest(".js-product-variants");
        var $variants_group = jQueryNuvem(this).closest(".js-product-variants-group");
        var quick_id = jQueryNuvem(this).closest(".js-quickshop-container").attr("id");
        if($parent.hasClass("js-product-quickshop-variants")){
            {% if template == 'home' %}
                LS.changeVariant(changeVariant, '.js-swiper-slide-visible #' + quick_id);
            {% else %}
                LS.changeVariant(changeVariant, '#' + quick_id);
            {% endif %}

            {% if settings.product_color_variants %}
                {# Match selected color variant with selected quickshop variant #}
                if(($variants_group).hasClass("js-color-variants-container")){
                    var selected_option_id = jQueryNuvem(this).find("option").filter((el) => el.selected).val();
                    jQueryNuvem('#' + quick_id).find('.js-color-variant').removeClass("selected");
                    jQueryNuvem('#' + quick_id).find('.js-color-variant[data-option="'+selected_option_id+'"]').addClass("selected");
                }
            {% endif %}
        } else {
            LS.changeVariant(changeVariant, '#single-product');
        }

        {# Offer and discount labels update #}

        var $this_product_container = jQueryNuvem(this).closest(".js-product-container");
        var $this_compare_price = $this_product_container.find(".js-compare-price-display");
        var $this_price = $this_product_container.find(".js-price-display");
        var $installment_container = $this_product_container.find(".js-product-payments-container");
        var $installment_text = $this_product_container.find(".js-max-installments-container");
        var $this_add_to_cart =  $this_product_container.find(".js-prod-submit-form");

        // Get the current product discount percentage value
        var current_percentage_value = $this_product_container.find(".js-offer-percentage");

        // Get the current product price and promotional price
        var compare_price_value = $this_compare_price.html();
        var price_value = $this_price.html();

        // Calculate new discount percentage based on difference between filtered old and new prices
        const percentageDifference = window.moneyDifferenceCalculator.percentageDifferenceFromString(compare_price_value, price_value);
        if(percentageDifference){
            $this_product_container.find(".js-offer-percentage").text(percentageDifference);
            $this_product_container.find(".js-offer-label").css("display" , "table");
        }

        if ($this_compare_price.css("display") == "none" || !percentageDifference) {
            $this_product_container.find(".js-offer-label").hide();
        }
        if ($this_add_to_cart.hasClass("nostock")) {
            $this_product_container.find(".js-stock-label").show();
        }
        else {
            $this_product_container.find(".js-stock-label").hide();
	    }
	    if ($this_price.css('display') == 'none'){
	        $installment_container.hide();
	        $installment_text.hide();
	    }else{
	        $installment_text.show();
	    }
	});

	{# /* // Submit to contact */ #}

	{# Submit to contact form when product has no price #}

    jQueryNuvem(".js-product-form").on("submit", function (e) {
	    var button = jQueryNuvem(e.currentTarget).find('[type="submit"]');
	    //button.attr('disabled', 'disabled');
	    if ((button.hasClass('contact')) || (button.hasClass('catalog'))) {
	        e.preventDefault();
	        //var product_id = jQueryNuvem(e.currentTarget).find("input[name='add_to_cart']").val();
	        //window.location = "{{ store.contact_url | escape('js') }}?product=" + product_id;
            window.open('https://wa.me/573185556767', '_blank');
	    } else if (button.hasClass('cart')) {
	        button.val('{{ "Agregando..." | translate }}');
	    }
	});

	{% if template == 'product' %}

        {% set has_multiple_slides = product.images_count > 1 or video_url %}

	    {# /* // Product slider */ #}

            var width = window.innerWidth;
            if (width > 767) {
                var speedVal = 0;
                var spaceBetweenVal = 0;
                var slidesPerViewVal = 1;
            } else {
                var speedVal = 300;
                var spaceBetweenVal = 10;
                var slidesPerViewVal = 1.2;
            }

            var productSwiper = null;
            createSwiper(
                '.js-swiper-product', {
                    lazy: true,
                    speed: speedVal,
                    {% if has_multiple_slides %}
                    slidesPerView: slidesPerViewVal,
                    centeredSlides: true,
                    spaceBetween: spaceBetweenVal,
                    {% endif %}
                    pagination: {
                        el: '.js-swiper-product-pagination',
                        type: 'fraction',
                        clickable: true,
                    },
                    navigation: {
                        nextEl: '.js-swiper-product-next',
                        prevEl: '.js-swiper-product-prev',
                    },
                    on: {
                        init: function () {
                            jQueryNuvem(".js-product-slider-placeholder").hide();
                            jQueryNuvem(".js-swiper-product").css("visibility", "visible").css("height", "auto");
                            {% if product.video_url %}
                                if (window.innerWidth < 768) {
                                    productSwiperHeight = jQueryNuvem(".js-swiper-product").height();
                                    jQueryNuvem(".js-product-video-slide").height(productSwiperHeight);
                                }
                            {% endif %}
                        },
                        {% if product.video_url %}
                            slideChangeTransitionEnd: function () {
                                if(jQueryNuvem(".js-product-video-slide").hasClass("swiper-slide-active")){
                                    jQueryNuvem(".js-labels-group").fadeOut(100);
                                }else{
                                    jQueryNuvem(".js-labels-group").fadeIn(100);
                                }
                                jQueryNuvem('.js-video').show();
                                jQueryNuvem('.js-video-iframe').hide().find("iframe").remove();
                            },
                        {% endif %}
                    },
                },
                function(swiperInstance) {
                    productSwiper = swiperInstance;
                }
            );

            {% if store.useNativeJsLibraries() %}

                Fancybox.bind('[data-fancybox="product-gallery"]', {
                    Toolbar: { display: ['counter', 'close'] },
                    Thumbs: { autoStart: false },
                    on: {
                        shouldClose: (fancybox, slide) => {
                            // Update position of the slider
                            productSwiper.slideTo( fancybox.getSlide().index, 0 );
                            jQueryNuvem(".js-product-thumb").removeClass("selected");

                            var $product_thumbnail = jQueryNuvem(".js-product-thumb[data-thumb-loop='"+fancybox.getSlide().index+"']").addClass("selected");
                            if($product_thumbnail.length){
                                $product_thumbnail.addClass("selected");
                            }else{
                                jQueryNuvem(".js-product-thumb[data-thumb-loop='4']").addClass("selected");
                            }
                        },
                    },
                });

            {% else %}

                $().fancybox({
                    selector : '[data-fancybox="product-gallery"]',
                    toolbar  : false,
                    smallBtn : true,
                    beforeClose : function(instance) {
                        // Update position of the slider
                        productSwiper.slideTo( instance.currIndex, 0 );
                        jQueryNuvem(".js-product-thumb").removeClass("selected");

                        var $product_thumbnail = jQueryNuvem(".js-product-thumb[data-thumb-loop='"+instance.currIndex+"']").addClass("selected");
                        if($product_thumbnail.length){
                            $product_thumbnail.addClass("selected");
                        }else{
                            jQueryNuvem(".js-product-thumb[data-thumb-loop='4']").addClass("selected");
                        }
                    },
                });

            {% endif %}

	    {% if has_multiple_slides %}
	        LS.registerOnChangeVariant(function(variant){
	            var liImage = jQueryNuvem('.js-swiper-product').find("[data-image='"+variant.image+"']");
	            var selectedPosition = liImage.data('imagePosition');
                var slideToGo = parseInt(selectedPosition);
                productSwiper.slideTo(slideToGo);
                jQueryNuvem(".js-product-slide-img").removeClass("js-active-variant");
                liImage.find(".js-product-slide-img").addClass("js-active-variant");
	        });

            jQueryNuvem(".js-product-thumb").on("click", function(e){
                e.preventDefault();
                jQueryNuvem(".js-product-thumb").removeClass("selected");
                jQueryNuvem(e.currentTarget).addClass("selected");
                var thumbLoop = jQueryNuvem(e.currentTarget).data("thumbLoop");
                var slideToGo = parseInt(thumbLoop);
                productSwiper.slideTo(slideToGo);
                if(jQueryNuvem(e.currentTarget).hasClass("js-product-thumb-modal")){
                    jQueryNuvem('.js-swiper-product').find("[data-image-position='"+slideToGo+"'] .js-product-slide-link").trigger('click');
                }
            });
	    {% endif %}

        {# /* // Pinterest sharing */ #}

        jQueryNuvem('.js-pinterest-share').on("click", function(e){
            e.preventDefault();
            jQueryNuvem(".pinterest-hidden a").get()[0].click();
        });

        {# Product show description and relocate on mobile #}

        if (window.innerWidth > 767) {
            jQueryNuvem("#product-description").show();
        }else{
            jQueryNuvem("#product-description").insertAfter("#product_form").show();
        }

	{% endif %}

    {# Product quantitiy #}

    jQueryNuvem('.js-quantity .js-quantity-up').on('click', function(e) {
        $quantity_input = jQueryNuvem(e.currentTarget).closest(".js-quantity").find(".js-quantity-input");
        $quantity_input.val( parseInt($quantity_input.val(), 10) + 1);
    });

    jQueryNuvem('.js-quantity .js-quantity-down').on('click', function(e) {
        $quantity_input = jQueryNuvem(e.currentTarget).closest(".js-quantity").find(".js-quantity-input");
        quantity_input_val = $quantity_input.val();
        if (quantity_input_val>1) {
            $quantity_input.val( parseInt($quantity_input.val(), 10) - 1);
        }
    });


	{#/*============================================================================
	  #Cart
	==============================================================================*/ #}

    {# /* // Toggle cart */ #}
    {% if store.has_free_shipping_progress and cart.free_shipping.min_price_free_shipping.min_price %}

        {# Updates free progress on page load #}

        LS.freeShippingProgress(true);

    {% endif %}

    {# /* // Position of cart page summary */ #}

    var head_height = jQueryNuvem(".js-head-main").outerHeight();

    if (window.innerWidth > 768) {
        {% if settings.head_fix %}
            jQueryNuvem("#cart-sticky-summary").css("top" , (head_height + 10).toString() + 'px');
        {% else %}
            jQueryNuvem("#cart-sticky-summary").css("top" , "10px");
        {% endif %}
    }


    {# /* // Add to cart */ #}

    jQueryNuvem(document).on("click", ".js-addtocart:not(.js-addtocart-placeholder)", function (e) {

        {# Button variables for transitions on add to cart #}

        var $productContainer = jQueryNuvem(this).closest('.js-product-container');
        var $productVariants = $productContainer.find(".js-variation-option");
        var $productButton = $productContainer.find("input[type='submit'].js-addtocart");
        var $productButtonPlaceholder = $productContainer.find(".js-addtocart-placeholder");
        var $productButtonText = $productButtonPlaceholder.find(".js-addtocart-text");
        var $productButtonAdding = $productButtonPlaceholder.find(".js-addtocart-adding");
        var $productButtonSuccess = $productButtonPlaceholder.find(".js-addtocart-success");

        {# Define if event comes from quickshop or product page #}

        var isQuickShop = $productContainer.hasClass('js-quickshop-container');

         {# Added item information for notification #}

        if (!isQuickShop) {
            if(jQueryNuvem(".js-product-slide-img.js-active-variant").length) {
                var imageSrc = $productContainer.find('.js-product-slide-img.js-active-variant').data('srcset').split(' ')[0];
            } else {
                var imageSrc = $productContainer.find('.js-product-slide-img').attr('srcset').split(' ')[0];
            }
            var quantity = $productContainer.find('.js-quantity-input').val();
            var name = $productContainer.find('.js-product-name').text();
            var price = $productContainer.find('.js-price-display').text();
            var addedToCartCopy = "{{ 'Agregar al carrito' | translate }}";
        } else {
            var imageSrc = jQueryNuvem(this).closest('.js-quickshop-container').find('img').attr('srcset').split(' ')[0];
            var quantity = 1;
            var name = $productContainer.find('.js-item-name').text();
            var price = $productContainer.find('.js-price-display').text().trim();
            var addedToCartCopy = "{{ 'Comprar' | translate }}";
            if ($productContainer.hasClass("js-quickshop-has-variants")) {
                var addedToCartCopy = "{{ 'Agregar al carrito' | translate }}";
            }else{
                var addedToCartCopy = "{{ 'Comprar' | translate }}";
            }
        }

        if (!jQueryNuvem(this).hasClass('contact')) {

            {% if settings.ajax_cart %}
                e.preventDefault();
            {% endif %}

            {# Hide real button and show button placeholder during event #}

            $productButton.hide();
            $productButtonPlaceholder.css('display' , 'inline-block');
            $productButtonText.fadeOut();
            $productButtonAdding.addClass("active");

            {% if settings.ajax_cart %}

                var callback_add_to_cart = function(){

                    {# Animate cart amount #}

                    jQueryNuvem(".js-cart-widget-amount").addClass("swing");

                    setTimeout(function(){
                        jQueryNuvem(".js-cart-widget-amount").removeClass("swing");
                    },6000);

                    {# Fill notification info #}

                    jQueryNuvem('.js-cart-notification-item-img').attr('srcset', imageSrc);
                    jQueryNuvem('.js-cart-notification-item-name').text(name);
                    jQueryNuvem('.js-cart-notification-item-quantity').text(quantity);
                    jQueryNuvem('.js-cart-notification-item-price').text(price);

                    if($productVariants.length){
                        var output = [];

                        $productVariants.each( function(el){
                            var variants = jQueryNuvem(el);
                            output.push(variants.val());
                        });
                        jQueryNuvem(".js-cart-notification-item-variant-container").show();
                        jQueryNuvem(".js-cart-notification-item-variant").text(output.join(', '))
                    }else{
                        jQueryNuvem(".js-cart-notification-item-variant-container").hide();
                    }

                    {# Set products amount wording visibility #}

                    var cartItemsAmount = jQueryNuvem(".js-cart-widget-amount").text();

                    if(cartItemsAmount > 1){
                        jQueryNuvem(".js-cart-counts-plural").show();
                        jQueryNuvem(".js-cart-counts-singular").hide();
                    }else{
                        jQueryNuvem(".js-cart-counts-singular").show();
                        jQueryNuvem(".js-cart-counts-plural").hide();
                    }

                    {# Show button placeholder with transitions #}

                    $productButtonAdding.removeClass("active");
                    $productButtonSuccess.addClass("active");
                    setTimeout(function(){
                        $productButtonSuccess.removeClass("active");
                        $productButtonText.fadeIn();
                    },2000);
                    setTimeout(function(){
                        $productButtonPlaceholder.removeAttr("style").hide();
                        $productButton.show();
                    },3000);

                    $productContainer.find(".js-added-to-cart-product-message").slideDown();

                    {# Show notification and hide it only after second added to cart #}

                    setTimeout(function(){
                        jQueryNuvem(".js-alert-added-to-cart").show().addClass("notification-visible").removeClass("notification-hidden");
                    },500);

                    if (!cookieService.get('first_product_added_successfully')) {
                        cookieService.set('first_product_added_successfully', 1, 7 );
                    } else{
                        setTimeout(function(){
                            jQueryNuvem(".js-alert-added-to-cart").removeClass("notification-visible").addClass("notification-hidden");
                            setTimeout(function(){
                                jQueryNuvem('.js-cart-notification-item-img').attr('src', '');
                                jQueryNuvem(".js-alert-added-to-cart").hide();
                            },2000);
                        },8000);
                    }


                    {# Update shipping input zipcode on add to cart #}

                    {# Use zipcode from input if user is in product page, or use zipcode cookie if is not #}

                    if (jQueryNuvem("#product-shipping-container .js-shipping-input").val()) {
                        zipcode_on_addtocart = jQueryNuvem("#product-shipping-container .js-shipping-input").val();
                        jQueryNuvem("#cart-shipping-container .js-shipping-input").val(zipcode_on_addtocart);
                        jQueryNuvem(".js-shipping-calculator-current-zip").text(zipcode_on_addtocart);
                    } else if (cookieService.get('calculator_zipcode')){
                        var zipcode_from_cookie = cookieService.get('calculator_zipcode');
                        jQueryNuvem('.js-shipping-input').val(zipcode_from_cookie);
                        jQueryNuvem(".js-shipping-calculator-current-zip").text(zipcode_from_cookie);
                    }

                    {% if store.has_free_shipping_progress %}

                        {# Update free shipping wording #}

                        jQueryNuvem(".js-fs-add-this-product").hide();
                        jQueryNuvem(".js-fs-add-one-more").show();
                    {% endif %}

                }
                var callback_error = function(){
                    {# Restore real button visibility in case of error #}

                    $productButtonAdding.removeClass("active");
                    $productButtonText.fadeIn();
                    $productButtonPlaceholder.removeAttr("style").hide();
                    $productButton.show();
                }
                $prod_form = jQueryNuvem(this).closest("form");
                LS.addToCartEnhanced(
                    $prod_form,
                    addedToCartCopy,
                    '{{ "Agregando..." | translate }}',
                    '{{ "¡Uy! No tenemos más stock de este producto para agregarlo al carrito." | translate }}',
                    {{ store.editable_ajax_cart_enabled ? 'true' : 'false' }},
                        callback_add_to_cart,
                        callback_error
                );
            {% endif %}
        }
    });


    {# /* // Cart quantitiy changes */ #}

    jQueryNuvem(document).on("keypress", ".js-cart-quantity-input", function (e) {
        if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
            return false;
        }
    });

    jQueryNuvem(document).on("focusout", ".js-cart-quantity-input", function (e) {
        var itemID = jQueryNuvem(this).attr("data-item-id");
        var itemVAL = jQueryNuvem(this).val();
        if (itemVAL == 0) {
            var r = confirm("{{ '¿Seguro que quieres borrar este artículo?' | translate }}");
            if (r == true) {
                LS.removeItem(itemID, true);
            } else {
                jQueryNuvem(this).val(1);
            }
        } else {
            LS.changeQuantity(itemID, itemVAL, true);
        }
    });

    {# /* // Empty cart alert */ #}

    jQueryNuvem(".js-trigger-empty-cart-alert").on("click", function (e) {
        e.preventDefault();
        let emptyCartAlert = jQueryNuvem(".js-mobile-nav-empty-cart-alert").fadeIn(100);
        setTimeout(() => emptyCartAlert.fadeOut(500), 1500);
    });

    {# /* // Go to checkout */ #}

    {# Clear cart notification cookie after consumers continues to checkout #}

    jQueryNuvem('form[action="{{ store.cart_url | escape('js') }}"]').on("submit", function() {
        cookieService.remove('first_product_added_successfully');
    });


	{#/*============================================================================
	  #Shipping calculator
	==============================================================================*/ #}

    {# /* // Update calculated cost wording */ #}

    {% if settings.shipping_calculator_cart_page %}
        if (jQueryNuvem('.js-selected-shipping-method').length) {
            var shipping_cost = jQueryNuvem('.js-selected-shipping-method').data("cost");
            var $shippingCost = jQueryNuvem("#shipping-cost");
            $shippingCost.text(shipping_cost);
            $shippingCost.removeClass('opacity-40');
        }
    {% endif %}

	{# /* // Select and save shipping function */ #}

    selectShippingOption = function(elem, save_option) {
        jQueryNuvem(".js-shipping-method, .js-branch-method").removeClass('js-selected-shipping-method');
        jQueryNuvem(elem).addClass('js-selected-shipping-method');

        {% if settings.shipping_calculator_cart_page %}

            var shipping_cost = jQueryNuvem(elem).data("cost");
            var shipping_price_clean = jQueryNuvem(elem).data("price");

            if(shipping_price_clean = 0.00){
                var shipping_cost = '{{ Gratis | translate }}'
            }

            // Updates shipping (ship and pickup) cost on cart
            var $shippingCost = jQueryNuvem("#shipping-cost");
            $shippingCost.text(shipping_cost);
            $shippingCost.removeClass('opacity-40');

        {% endif %}

        if (save_option) {
            LS.saveCalculatedShipping(true);
        }
        if (jQueryNuvem(elem).hasClass("js-shipping-method-hidden")) {
            {# Toggle other options visibility depending if they are pickup or delivery for cart and product at the same time #}
            if (jQueryNuvem(elem).hasClass("js-pickup-option")) {
                jQueryNuvem(".js-other-pickup-options, .js-show-other-pickup-options .js-shipping-see-less").show();
                jQueryNuvem(".js-show-other-pickup-options .js-shipping-see-more").hide();
            } else {
                jQueryNuvem(".js-other-shipping-options, .js-show-more-shipping-options .js-shipping-see-less").show();
                jQueryNuvem(".js-show-more-shipping-options .js-shipping-see-more").hide()
            }
        }
    };

    {# Apply zipcode saved by cookie if there is no zipcode saved on cart from backend #}

    if (cookieService.get('calculator_zipcode')) {

        {# If there is a cookie saved based on previous calcualtion, add it to the shipping input to triggert automatic calculation #}

        var zipcode_from_cookie = cookieService.get('calculator_zipcode');

        {% if settings.ajax_cart %}

            {# If ajax cart is active, target only product input to avoid extra calulation on empty cart #}

            jQueryNuvem('#product-shipping-container .js-shipping-input').val(zipcode_from_cookie);

        {% else %}

            {# If ajax cart is inactive, target the only input present on screen #}

            jQueryNuvem('.js-shipping-input').val(zipcode_from_cookie);

        {% endif %}

        jQueryNuvem(".js-shipping-calculator-current-zip").text(zipcode_from_cookie);

        {# Hide the shipping calculator and show spinner  #}

        jQueryNuvem(".js-shipping-calculator-head").addClass("with-zip").removeClass("with-form");
        jQueryNuvem(".js-shipping-calculator-with-zipcode").addClass("transition-up-active");
        jQueryNuvem(".js-shipping-calculator-spinner").show();
    } else {

        {# If there is no cookie saved, show calcualtor #}

        jQueryNuvem(".js-shipping-calculator-form").addClass("transition-up-active");
    }

    {# Remove shipping suboptions from DOM to avoid duplicated modals #}

    removeShippingSuboptions = function(){
        var shipping_suboptions_id = jQueryNuvem(".js-modal-shipping-suboptions").attr("id");
        jQueryNuvem("#" + shipping_suboptions_id).remove();
        jQueryNuvem('.js-modal-overlay[data-modal-id="#' + shipping_suboptions_id + '"').remove();
    };

    {# /* // Calculate shipping function */ #}


    jQueryNuvem(".js-calculate-shipping").on("click", function (e) {
	    e.preventDefault();

        {# Take the Zip code to all shipping calculators on screen #}
        let shipping_input_val = jQueryNuvem(e.currentTarget).closest(".js-shipping-calculator-form").find(".js-shipping-input").val();

        jQueryNuvem(".js-shipping-input").val(shipping_input_val);

        {# Calculate on page load for both calculators: Product and Cart #}
        {% if template == 'product' %}
             if (!vanillaJS) {
                LS.calculateShippingAjax(
                    jQueryNuvem('#product-shipping-container').find(".js-shipping-input").val(),
                    '{{store.shipping_calculator_url | escape('js')}}',
                    jQueryNuvem("#product-shipping-container").closest(".js-shipping-calculator-container") );
             }
        {% endif %}

        if (jQueryNuvem(".js-cart-item").length) {
            LS.calculateShippingAjax(
            jQueryNuvem('#cart-shipping-container').find(".js-shipping-input").val(),
            '{{store.shipping_calculator_url | escape('js')}}',
            jQueryNuvem("#cart-shipping-container").closest(".js-shipping-calculator-container") );
        }

        jQueryNuvem(".js-shipping-calculator-current-zip").html(shipping_input_val);
        removeShippingSuboptions();
	});

	{# /* // Calculate shipping by submit */ #}

    jQueryNuvem(".js-shipping-input").on('keydown', function (e) {
	    var key = e.which ? e.which : e.keyCode;
	    var enterKey = 13;
	    if (key === enterKey) {
	        e.preventDefault();
            jQueryNuvem(e.currentTarget).closest(".js-shipping-calculator-form").find(".js-calculate-shipping").trigger('click');
	        if (window.innerWidth < 768) {
                jQueryNuvem(e.currentTarget).trigger('blur');
	        }
	    }
	});

    {# /* // Shipping and branch click */ #}

    jQueryNuvem(document).on("change", ".js-shipping-method, .js-branch-method", function (e) {
        selectShippingOption(this, true);
        jQueryNuvem(".js-shipping-method-unavailable").hide();
    });

    {# /* // Select shipping first option on results */ #}

    jQueryNuvem(document).on('shipping.options.checked', '.js-shipping-method', function (e) {
        let shippingPrice = jQueryNuvem(this).attr("data-price");
        LS.addToTotal(shippingPrice);

        let total = (LS.data.cart.total / 100) + parseFloat(shippingPrice);
        jQueryNuvem(".js-cart-widget-total").html(LS.formatToCurrency(total));

        selectShippingOption(this, false);
    });

    {# /* // Toggle branches link */ #}

    jQueryNuvem(document).on("click", ".js-toggle-branches", function (e) {
        e.preventDefault();
        jQueryNuvem(".js-store-branches-container").slideToggle("fast");
        jQueryNuvem(".js-see-branches, .js-hide-branches").toggle();
    });

    {# /* // Toggle more shipping options */ #}

    jQueryNuvem(document).on("click", ".js-toggle-more-shipping-options", function(e) {
	    e.preventDefault();

        {# Toggle other options depending if they are pickup or delivery for cart and product at the same time #}

        if(jQueryNuvem(this).hasClass("js-show-other-pickup-options")){
            jQueryNuvem(".js-other-pickup-options").slideToggle(600);
            jQueryNuvem(".js-show-other-pickup-options .js-shipping-see-less, .js-show-other-pickup-options .js-shipping-see-more").toggle();
        }else{
            jQueryNuvem(".js-other-shipping-options").slideToggle(600);
            jQueryNuvem(".js-show-more-shipping-options .js-shipping-see-less, .js-show-more-shipping-options .js-shipping-see-more").toggle();
        }
	});

    {# /* // Calculate shipping on page load */ #}

    {# Only shipping input has value, cart has saved shipping and there is no branch selected #}

    calculateCartShippingOnLoad = function() {
        {# Triggers function when a zipcode input is filled #}
        if (jQueryNuvem("#cart-shipping-container .js-shipping-input").val()) {
            // If user already had calculated shipping: recalculate shipping
            setTimeout(function() {
                LS.calculateShippingAjax(
                    jQueryNuvem('#cart-shipping-container').find(".js-shipping-input").val(),
                    '{{store.shipping_calculator_url | escape('js')}}',
                    jQueryNuvem("#cart-shipping-container").closest(".js-shipping-calculator-container") );
                    removeShippingSuboptions();
            }, 100);
        }

        if (jQueryNuvem(".js-branch-method").hasClass('js-selected-shipping-method')) {
            {% if store.branches|length > 1 %}
                jQueryNuvem(".js-store-branches-container").slideDown("fast");
                jQueryNuvem(".js-see-branches").hide();
                jQueryNuvem(".js-hide-branches").show();
            {% endif %}
        }
    };

    {% if cart.has_shippable_products %}
        calculateCartShippingOnLoad();
    {% endif %}


    {% if template == 'product' %}
        if (!vanillaJS) {
            {# /* // Calculate product detail shipping on page load */ #}

            if(jQueryNuvem('#product-shipping-container').find(".js-shipping-input").val()){
                setTimeout(function() {
                    LS.calculateShippingAjax(
                        jQueryNuvem('#product-shipping-container').find(".js-shipping-input").val(),
                        '{{store.shipping_calculator_url | escape('js')}}',
                        jQueryNuvem("#product-shipping-container").closest(".js-shipping-calculator-container") );

                    removeShippingSuboptions();
                }, 100);
            }
        }

        {# /* // Pitch login instead of zipcode helper if is returning customer */ #}

        {% if not customer %}
            if (cookieService.get('returning_customer')) {
                jQueryNuvem('.js-shipping-zipcode-help').remove();
            } else {
                jQueryNuvem('.js-product-quick-login').remove();
            }
        {% endif %}

    {% endif %}

    {# /* // Change CP */ #}

    jQueryNuvem(document).on("click", ".js-shipping-calculator-change-zipcode", function(e) {
        e.preventDefault();
        jQueryNuvem(".js-shipping-calculator-response").fadeOut(100);
        jQueryNuvem(".js-shipping-calculator-head").addClass("with-form").removeClass("with-zip");
        jQueryNuvem(".js-shipping-calculator-with-zipcode").removeClass("transition-up-active");
        jQueryNuvem(".js-shipping-calculator-form").addClass("transition-up-active");
    });

	{# /* // Shipping provinces */ #}

	{% if provinces_json %}
        jQueryNuvem('select[name="country"]').on("change", function (e) {
		    var provinces = {{ provinces_json | default('{}') | raw }};
		    LS.swapProvinces(provinces[jQueryNuvem(e.currentTarget).val()]);
		}).trigger('change');
	{% endif %}


    {# /* // Change store country: From invalid zipcode message */ #}

    jQueryNuvem(document).on("click", ".js-save-shipping-country", function(e) {

        e.preventDefault();

        {# Change shipping country #}

        var selected_country_url = jQueryNuvem(this).closest(".js-modal-shipping-country").find(".js-shipping-country-select option").filter((el) => el.selected).attr("data-country-url");
        location.href = selected_country_url;

        jQueryNuvem(this).text('{{ "Aplicando..." | translate }}').addClass("disabled");
    });

    {#/*============================================================================
      #Brands Page
    ==============================================================================*/ #}
    
    if (window.location.href.includes('marcas1/') && window.location.href.split('/').length - 1  < 5) {
        let brandsRow = document.querySelector('.row.justify-content-md-center');
        let brandsRowParent = brandsRow.parentNode; 
        brandsRowParent.innerHTML = '';
        
        // Alimentos
        let images = ['<span class="h1 text-primary" style="position: absolute;">A</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1611624178-1688058006-31e67a69ee908b67efcf4a267812ad641688058007.png?1031205779" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1611624178-1688058006-31e67a69ee908b67efcf4a267812ad641688058007.png?1031205779 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1611624178-1688058006-31e67a69ee908b67efcf4a267812ad641688058007.png?1031205779 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1611624178-1688058006-31e67a69ee908b67efcf4a267812ad641688058007.png?1031205779 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1611624178-1688058006-31e67a69ee908b67efcf4a267812ad641688058007.png?1031205779 640w">', // Agility Gold
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2023774714-1688058063-fd55d2d905c56d228bf749b02e0225cd1688058063.png?182077310" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2023774714-1688058063-fd55d2d905c56d228bf749b02e0225cd1688058063.png?182077310 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2023774714-1688058063-fd55d2d905c56d228bf749b02e0225cd1688058063.png?182077310 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2023774714-1688058063-fd55d2d905c56d228bf749b02e0225cd1688058063.png?182077310 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2023774714-1688058063-fd55d2d905c56d228bf749b02e0225cd1688058063.png?182077310 640w">', // Acana
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-758437203-1688058116-ce477aabd80fc5190bd2e0cfa9c51a1d1688058116.png?1540989670" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-758437203-1688058116-ce477aabd80fc5190bd2e0cfa9c51a1d1688058116.png?1540989670 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-758437203-1688058116-ce477aabd80fc5190bd2e0cfa9c51a1d1688058116.png?1540989670 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-758437203-1688058116-ce477aabd80fc5190bd2e0cfa9c51a1d1688058116.png?1540989670 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-758437203-1688058116-ce477aabd80fc5190bd2e0cfa9c51a1d1688058116.png?1540989670 640w">', // Alpo
                      '<span class="h1 text-primary" style="position: absolute;">B</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-757088370-1688059017-0320e62383023bb54c621381be17e9561688059018.png?1975689070" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-757088370-1688059017-0320e62383023bb54c621381be17e9561688059018.png?1975689070 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-757088370-1688059017-0320e62383023bb54c621381be17e9561688059018.png?1975689070 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-757088370-1688059017-0320e62383023bb54c621381be17e9561688059018.png?1975689070 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-757088370-1688059017-0320e62383023bb54c621381be17e9561688059018.png?1975689070 640w">', // Br for cat
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1822392330-1688059071-7fe9990e2a73d8193729ec5a74cc06131688059071.png?2047162220" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1822392330-1688059071-7fe9990e2a73d8193729ec5a74cc06131688059071.png?2047162220 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1822392330-1688059071-7fe9990e2a73d8193729ec5a74cc06131688059071.png?2047162220 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1822392330-1688059071-7fe9990e2a73d8193729ec5a74cc06131688059071.png?2047162220 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1822392330-1688059071-7fe9990e2a73d8193729ec5a74cc06131688059071.png?2047162220 640w">', // Br for dog
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1672767528-1688059109-99ee2307cb107493820a72c4bdafbf791688059109.png?1526835541" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1672767528-1688059109-99ee2307cb107493820a72c4bdafbf791688059109.png?1526835541 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1672767528-1688059109-99ee2307cb107493820a72c4bdafbf791688059109.png?1526835541 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1672767528-1688059109-99ee2307cb107493820a72c4bdafbf791688059109.png?1526835541 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1672767528-1688059109-99ee2307cb107493820a72c4bdafbf791688059109.png?1526835541 640w">', // Birbo 
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2101714387-1688059153-51025f9afe9771557bf6dcfbd09a7e2f1688059154.png?1739973957" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2101714387-1688059153-51025f9afe9771557bf6dcfbd09a7e2f1688059154.png?1739973957 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2101714387-1688059153-51025f9afe9771557bf6dcfbd09a7e2f1688059154.png?1739973957 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2101714387-1688059153-51025f9afe9771557bf6dcfbd09a7e2f1688059154.png?1739973957 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2101714387-1688059153-51025f9afe9771557bf6dcfbd09a7e2f1688059154.png?1739973957 640w">', // Br for dog wild 
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-351851223-1688059182-bf93b54c10699b1e77c20eefb5ec029c1688059182.png?1876213836" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-351851223-1688059182-bf93b54c10699b1e77c20eefb5ec029c1688059182.png?1876213836 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-351851223-1688059182-bf93b54c10699b1e77c20eefb5ec029c1688059182.png?1876213836 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-351851223-1688059182-bf93b54c10699b1e77c20eefb5ec029c1688059182.png?1876213836 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-351851223-1688059182-bf93b54c10699b1e77c20eefb5ec029c1688059182.png?1876213836 640w">', // Br for cat wild 
                      '<span class="h1 text-primary" style="position: absolute;">C</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1268024120-1688059214-036fa22c6e6ef88671df45cafded10e81688059214.png?1292749072" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1268024120-1688059214-036fa22c6e6ef88671df45cafded10e81688059214.png?1292749072 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1268024120-1688059214-036fa22c6e6ef88671df45cafded10e81688059214.png?1292749072 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1268024120-1688059214-036fa22c6e6ef88671df45cafded10e81688059214.png?1292749072 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1268024120-1688059214-036fa22c6e6ef88671df45cafded10e81688059214.png?1292749072 640w">', // Chunky
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-28852518-1688059273-951fc2c039b3af3c8333f74b2723dfa01688059273.png?419427244" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-28852518-1688059273-951fc2c039b3af3c8333f74b2723dfa01688059273.png?419427244 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-28852518-1688059273-951fc2c039b3af3c8333f74b2723dfa01688059273.png?419427244 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-28852518-1688059273-951fc2c039b3af3c8333f74b2723dfa01688059273.png?419427244 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-28852518-1688059273-951fc2c039b3af3c8333f74b2723dfa01688059273.png?419427244 640w">', // Cat chow
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-336692324-1688059304-5a13083c1aaa064b74ee8a9ec6f778d01688059305.png?1880241381" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-336692324-1688059304-5a13083c1aaa064b74ee8a9ec6f778d01688059305.png?1880241381 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-336692324-1688059304-5a13083c1aaa064b74ee8a9ec6f778d01688059305.png?1880241381 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-336692324-1688059304-5a13083c1aaa064b74ee8a9ec6f778d01688059305.png?1880241381 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-336692324-1688059304-5a13083c1aaa064b74ee8a9ec6f778d01688059305.png?1880241381 640w">', // Country value
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-681918929-1688059333-cbfc460e6ac47674449cfc241a268f621688059334.png?915450425" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-681918929-1688059333-cbfc460e6ac47674449cfc241a268f621688059334.png?915450425 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-681918929-1688059333-cbfc460e6ac47674449cfc241a268f621688059334.png?915450425 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-681918929-1688059333-cbfc460e6ac47674449cfc241a268f621688059334.png?915450425 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-681918929-1688059333-cbfc460e6ac47674449cfc241a268f621688059334.png?915450425 640w">', // Cat/Dog licius
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-139119715-1688059360-0838b48f46f9600b47534790aeafd4581688059360.png?242314834" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-139119715-1688059360-0838b48f46f9600b47534790aeafd4581688059360.png?242314834 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-139119715-1688059360-0838b48f46f9600b47534790aeafd4581688059360.png?242314834 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-139119715-1688059360-0838b48f46f9600b47534790aeafd4581688059360.png?242314834 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-139119715-1688059360-0838b48f46f9600b47534790aeafd4581688059360.png?242314834 640w">', // Churu
                      '<span class="h1 text-primary" style="position: absolute;">D</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1856870967-1688059390-ea2f328e166ce0f9b1dc4db122b0c0b01688059390.png?1419634541" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1856870967-1688059390-ea2f328e166ce0f9b1dc4db122b0c0b01688059390.png?1419634541 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1856870967-1688059390-ea2f328e166ce0f9b1dc4db122b0c0b01688059390.png?1419634541 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1856870967-1688059390-ea2f328e166ce0f9b1dc4db122b0c0b01688059390.png?1419634541 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1856870967-1688059390-ea2f328e166ce0f9b1dc4db122b0c0b01688059390.png?1419634541 640w">', // Diamond naturals
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1583375647-1688059435-0b8c3e23e04982f29b5a247829c11cdb1688059435.png?183152827" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1583375647-1688059435-0b8c3e23e04982f29b5a247829c11cdb1688059435.png?183152827 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1583375647-1688059435-0b8c3e23e04982f29b5a247829c11cdb1688059435.png?183152827 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1583375647-1688059435-0b8c3e23e04982f29b5a247829c11cdb1688059435.png?183152827 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1583375647-1688059435-0b8c3e23e04982f29b5a247829c11cdb1688059435.png?183152827 640w">', // Dog Chow
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-210298799-1688059465-d259bdc6db50632da6e79727993ccaee1688059465.png?374988808" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-210298799-1688059465-d259bdc6db50632da6e79727993ccaee1688059465.png?374988808 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-210298799-1688059465-d259bdc6db50632da6e79727993ccaee1688059465.png?374988808 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-210298799-1688059465-d259bdc6db50632da6e79727993ccaee1688059465.png?374988808 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-210298799-1688059465-d259bdc6db50632da6e79727993ccaee1688059465.png?374988808 640w">', // Dr. Clauder'S
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1396627511-1688059495-fcbca1a66db7be0a9b89e8abdb1a0e2e1688059495.png?347297640" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1396627511-1688059495-fcbca1a66db7be0a9b89e8abdb1a0e2e1688059495.png?347297640 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1396627511-1688059495-fcbca1a66db7be0a9b89e8abdb1a0e2e1688059495.png?347297640 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1396627511-1688059495-fcbca1a66db7be0a9b89e8abdb1a0e2e1688059495.png?347297640 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1396627511-1688059495-fcbca1a66db7be0a9b89e8abdb1a0e2e1688059495.png?347297640 640w">', // Dogourmet
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-798691204-1688059532-a289d1373c0669ecd436322850d22c711688059533.png?1821848677" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-798691204-1688059532-a289d1373c0669ecd436322850d22c711688059533.png?1821848677 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-798691204-1688059532-a289d1373c0669ecd436322850d22c711688059533.png?1821848677 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-798691204-1688059532-a289d1373c0669ecd436322850d22c711688059533.png?1821848677 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-798691204-1688059532-a289d1373c0669ecd436322850d22c711688059533.png?1821848677 640w">', // Donkan
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1997531459-1688059571-aa9358d57f1beca94447f9821ff342451688059572.png?1418254459" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1997531459-1688059571-aa9358d57f1beca94447f9821ff342451688059572.png?1418254459 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1997531459-1688059571-aa9358d57f1beca94447f9821ff342451688059572.png?1418254459 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1997531459-1688059571-aa9358d57f1beca94447f9821ff342451688059572.png?1418254459 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1997531459-1688059571-aa9358d57f1beca94447f9821ff342451688059572.png?1418254459 640w">', // Don Kat
                      '<span class="h1 text-primary" style="position: absolute;">E</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1219581224-1688059606-ba2e7c7878398d8e10c83f23b41259b51688059606.png?398841295" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1219581224-1688059606-ba2e7c7878398d8e10c83f23b41259b51688059606.png?398841295 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1219581224-1688059606-ba2e7c7878398d8e10c83f23b41259b51688059606.png?398841295 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1219581224-1688059606-ba2e7c7878398d8e10c83f23b41259b51688059606.png?398841295 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1219581224-1688059606-ba2e7c7878398d8e10c83f23b41259b51688059606.png?398841295 640w">', // Equilibrio
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-748281693-1688059649-b0d99f24c4b1d5925e8623347ed2f0681688059650.png?1544959262" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-748281693-1688059649-b0d99f24c4b1d5925e8623347ed2f0681688059650.png?1544959262 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-748281693-1688059649-b0d99f24c4b1d5925e8623347ed2f0681688059650.png?1544959262 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-748281693-1688059649-b0d99f24c4b1d5925e8623347ed2f0681688059650.png?1544959262 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-748281693-1688059649-b0d99f24c4b1d5925e8623347ed2f0681688059650.png?1544959262 640w">', // Excellent
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-382556777-1688059682-b12a4cd5d4c17f4f69686b528562f99e1688059682.png?1076424154" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-382556777-1688059682-b12a4cd5d4c17f4f69686b528562f99e1688059682.png?1076424154 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-382556777-1688059682-b12a4cd5d4c17f4f69686b528562f99e1688059682.png?1076424154 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-382556777-1688059682-b12a4cd5d4c17f4f69686b528562f99e1688059682.png?1076424154 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-382556777-1688059682-b12a4cd5d4c17f4f69686b528562f99e1688059682.png?1076424154 640w">', // Evolve
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1528439356-1688059710-f496dad867e5b37d1854c71bca9cb6a61688059710.png?38097248" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1528439356-1688059710-f496dad867e5b37d1854c71bca9cb6a61688059710.png?38097248 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1528439356-1688059710-f496dad867e5b37d1854c71bca9cb6a61688059710.png?38097248 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1528439356-1688059710-f496dad867e5b37d1854c71bca9cb6a61688059710.png?38097248 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1528439356-1688059710-f496dad867e5b37d1854c71bca9cb6a61688059710.png?38097248 640w">', // Eukanuba
                      '<span class="h1 text-primary" style="position: absolute;">F</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1144113654-1688059747-89b5d30adee3a7c7af814345e87bc9551688059748.png?1263345451" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1144113654-1688059747-89b5d30adee3a7c7af814345e87bc9551688059748.png?1263345451 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1144113654-1688059747-89b5d30adee3a7c7af814345e87bc9551688059748.png?1263345451 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1144113654-1688059747-89b5d30adee3a7c7af814345e87bc9551688059748.png?1263345451 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1144113654-1688059747-89b5d30adee3a7c7af814345e87bc9551688059748.png?1263345451 640w">', // Filpo
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1901928572-1688059784-f6f035abfb1d6605c59e49eecc0d3d7c1688059785.png?35324475" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1901928572-1688059784-f6f035abfb1d6605c59e49eecc0d3d7c1688059785.png?35324475 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1901928572-1688059784-f6f035abfb1d6605c59e49eecc0d3d7c1688059785.png?35324475 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1901928572-1688059784-f6f035abfb1d6605c59e49eecc0d3d7c1688059785.png?35324475 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1901928572-1688059784-f6f035abfb1d6605c59e49eecc0d3d7c1688059785.png?35324475 640w">', // Felix
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1844265694-1688059815-91fe614d8fc9f1b37e0d2131ee77a1f91688059816.png?1372518094" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1844265694-1688059815-91fe614d8fc9f1b37e0d2131ee77a1f91688059816.png?1372518094 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1844265694-1688059815-91fe614d8fc9f1b37e0d2131ee77a1f91688059816.png?1372518094 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1844265694-1688059815-91fe614d8fc9f1b37e0d2131ee77a1f91688059816.png?1372518094 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1844265694-1688059815-91fe614d8fc9f1b37e0d2131ee77a1f91688059816.png?1372518094 640w">', // Fancy feast
                      '<span class="h1 text-primary" style="position: absolute;">G</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1003807786-1688059857-aa6ec505423fdab5bfa7f1201e4b4c3b1688059857.png?1296130361" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1003807786-1688059857-aa6ec505423fdab5bfa7f1201e4b4c3b1688059857.png?1296130361 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1003807786-1688059857-aa6ec505423fdab5bfa7f1201e4b4c3b1688059857.png?1296130361 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1003807786-1688059857-aa6ec505423fdab5bfa7f1201e4b4c3b1688059857.png?1296130361 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1003807786-1688059857-aa6ec505423fdab5bfa7f1201e4b4c3b1688059857.png?1296130361 640w">', // Gemon
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-827616906-1688059893-2e269ed3b6df4bf22f06dcd57d0753fc1688059894.png?1323417128" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-827616906-1688059893-2e269ed3b6df4bf22f06dcd57d0753fc1688059894.png?1323417128 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-827616906-1688059893-2e269ed3b6df4bf22f06dcd57d0753fc1688059894.png?1323417128 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-827616906-1688059893-2e269ed3b6df4bf22f06dcd57d0753fc1688059894.png?1323417128 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-827616906-1688059893-2e269ed3b6df4bf22f06dcd57d0753fc1688059894.png?1323417128 640w">', // gatsy
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-942780079-1688059923-e4fb9d862e372fb5cae2f0bb464ac4201688059924.png?2055525115" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-942780079-1688059923-e4fb9d862e372fb5cae2f0bb464ac4201688059924.png?2055525115 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-942780079-1688059923-e4fb9d862e372fb5cae2f0bb464ac4201688059924.png?2055525115 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-942780079-1688059923-e4fb9d862e372fb5cae2f0bb464ac4201688059924.png?2055525115 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-942780079-1688059923-e4fb9d862e372fb5cae2f0bb464ac4201688059924.png?2055525115 640w">', // Guaumor
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-28322191-1688059955-11fee3abf9854b772adfc64666a9dc021688059955.png?1603125724" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-28322191-1688059955-11fee3abf9854b772adfc64666a9dc021688059955.png?1603125724 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-28322191-1688059955-11fee3abf9854b772adfc64666a9dc021688059955.png?1603125724 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-28322191-1688059955-11fee3abf9854b772adfc64666a9dc021688059955.png?1603125724 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-28322191-1688059955-11fee3abf9854b772adfc64666a9dc021688059955.png?1603125724 640w">', // Ganador
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1799792656-1688059983-34f35533819c89a3435db374036e70c41688059984.png?1689000780" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1799792656-1688059983-34f35533819c89a3435db374036e70c41688059984.png?1689000780 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1799792656-1688059983-34f35533819c89a3435db374036e70c41688059984.png?1689000780 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1799792656-1688059983-34f35533819c89a3435db374036e70c41688059984.png?1689000780 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1799792656-1688059983-34f35533819c89a3435db374036e70c41688059984.png?1689000780 640w">', // Grand Vita
                      '<span class="h1 text-primary" style="position: absolute;">H</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1329205780-1688060041-0daa1e3420b49aebe3e4e63ef98f777c1688060041.png?586603282" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1329205780-1688060041-0daa1e3420b49aebe3e4e63ef98f777c1688060041.png?586603282 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1329205780-1688060041-0daa1e3420b49aebe3e4e63ef98f777c1688060041.png?586603282 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1329205780-1688060041-0daa1e3420b49aebe3e4e63ef98f777c1688060041.png?586603282 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1329205780-1688060041-0daa1e3420b49aebe3e4e63ef98f777c1688060041.png?586603282 640w">', // Hills
                      '<span class="h1 text-primary" style="position: absolute;">I</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-306836802-1688060071-084820b4acaff1cf3db375f0527bfbf91688060072.png?791966636" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-306836802-1688060071-084820b4acaff1cf3db375f0527bfbf91688060072.png?791966636 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-306836802-1688060071-084820b4acaff1cf3db375f0527bfbf91688060072.png?791966636 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-306836802-1688060071-084820b4acaff1cf3db375f0527bfbf91688060072.png?791966636 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-306836802-1688060071-084820b4acaff1cf3db375f0527bfbf91688060072.png?791966636 640w">', // Italcan
                      '<span class="h1 text-primary" style="position: absolute;">K</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2071255571-1688060103-09b2c5dc7158ca20be29f230d3d210bd1688060104.png?275503447" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2071255571-1688060103-09b2c5dc7158ca20be29f230d3d210bd1688060104.png?275503447 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2071255571-1688060103-09b2c5dc7158ca20be29f230d3d210bd1688060104.png?275503447 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2071255571-1688060103-09b2c5dc7158ca20be29f230d3d210bd1688060104.png?275503447 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2071255571-1688060103-09b2c5dc7158ca20be29f230d3d210bd1688060104.png?275503447 640w">', // Kody
                      '<span class="h1 text-primary" style="position: absolute;">L</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1621537242-1688060133-511d75a9bbe01ba5c78c0571d1c3980c1688060134.png?1564142719" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1621537242-1688060133-511d75a9bbe01ba5c78c0571d1c3980c1688060134.png?1564142719 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1621537242-1688060133-511d75a9bbe01ba5c78c0571d1c3980c1688060134.png?1564142719 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1621537242-1688060133-511d75a9bbe01ba5c78c0571d1c3980c1688060134.png?1564142719 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1621537242-1688060133-511d75a9bbe01ba5c78c0571d1c3980c1688060134.png?1564142719 640w">', // Lucky
                      '<span class="h1 text-primary" style="position: absolute;">M</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-593877066-1688060161-59d87f36c62aba30eaa1bc2d2b4ba5461688060161.png?1679735543" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-593877066-1688060161-59d87f36c62aba30eaa1bc2d2b4ba5461688060161.png?1679735543 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-593877066-1688060161-59d87f36c62aba30eaa1bc2d2b4ba5461688060161.png?1679735543 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-593877066-1688060161-59d87f36c62aba30eaa1bc2d2b4ba5461688060161.png?1679735543 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-593877066-1688060161-59d87f36c62aba30eaa1bc2d2b4ba5461688060161.png?1679735543 640w">', // Max
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1491469095-1688060191-901d2571516f2e82bac152e9f7f202051688060192.png?1630243389" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1491469095-1688060191-901d2571516f2e82bac152e9f7f202051688060192.png?1630243389 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1491469095-1688060191-901d2571516f2e82bac152e9f7f202051688060192.png?1630243389 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1491469095-1688060191-901d2571516f2e82bac152e9f7f202051688060192.png?1630243389 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1491469095-1688060191-901d2571516f2e82bac152e9f7f202051688060192.png?1630243389 640w">', // Max Cat
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1510257479-1688060217-5a3e922216a5ff1cf85c3769c0e6d1a41688060217.png?979185802" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1510257479-1688060217-5a3e922216a5ff1cf85c3769c0e6d1a41688060217.png?979185802 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1510257479-1688060217-5a3e922216a5ff1cf85c3769c0e6d1a41688060217.png?979185802 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1510257479-1688060217-5a3e922216a5ff1cf85c3769c0e6d1a41688060217.png?979185802 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1510257479-1688060217-5a3e922216a5ff1cf85c3769c0e6d1a41688060217.png?979185802 640w">', // Monello
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-483872086-1688060248-ea3fbdc305d1ad51fba46e6e9f1e3bd71688060248.png?1335798586" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-483872086-1688060248-ea3fbdc305d1ad51fba46e6e9f1e3bd71688060248.png?1335798586 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-483872086-1688060248-ea3fbdc305d1ad51fba46e6e9f1e3bd71688060248.png?1335798586 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-483872086-1688060248-ea3fbdc305d1ad51fba46e6e9f1e3bd71688060248.png?1335798586 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-483872086-1688060248-ea3fbdc305d1ad51fba46e6e9f1e3bd71688060248.png?1335798586 640w">', // Mirringo
                      '<span class="h1 text-primary" style="position: absolute;">N</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-178714297-1688060281-e6b1d642b60f9fb4aff5e0cd5ca1aff21688060281.png?1567103796" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-178714297-1688060281-e6b1d642b60f9fb4aff5e0cd5ca1aff21688060281.png?1567103796 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-178714297-1688060281-e6b1d642b60f9fb4aff5e0cd5ca1aff21688060281.png?1567103796 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-178714297-1688060281-e6b1d642b60f9fb4aff5e0cd5ca1aff21688060281.png?1567103796 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-178714297-1688060281-e6b1d642b60f9fb4aff5e0cd5ca1aff21688060281.png?1567103796 640w">', // Nutra Nuggets
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1625514670-1688060308-6160d3a1d475ef0012421e4576dfc02e1688060309.png?853227638" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1625514670-1688060308-6160d3a1d475ef0012421e4576dfc02e1688060309.png?853227638 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1625514670-1688060308-6160d3a1d475ef0012421e4576dfc02e1688060309.png?853227638 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1625514670-1688060308-6160d3a1d475ef0012421e4576dfc02e1688060309.png?853227638 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1625514670-1688060308-6160d3a1d475ef0012421e4576dfc02e1688060309.png?853227638 640w">', // Naturalis
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-376394798-1688060340-62e30103d8c0feac2dd8934f59cf37fa1688060341.png?1854730577" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-376394798-1688060340-62e30103d8c0feac2dd8934f59cf37fa1688060341.png?1854730577 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-376394798-1688060340-62e30103d8c0feac2dd8934f59cf37fa1688060341.png?1854730577 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-376394798-1688060340-62e30103d8c0feac2dd8934f59cf37fa1688060341.png?1854730577 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-376394798-1688060340-62e30103d8c0feac2dd8934f59cf37fa1688060341.png?1854730577 640w">', // Naturals & Delicius
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1845492012-1688060364-3956d95c96f0464f88cbed30b09d1e3d1688060365.png?1823659007" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1845492012-1688060364-3956d95c96f0464f88cbed30b09d1e3d1688060365.png?1823659007 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1845492012-1688060364-3956d95c96f0464f88cbed30b09d1e3d1688060365.png?1823659007 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1845492012-1688060364-3956d95c96f0464f88cbed30b09d1e3d1688060365.png?1823659007 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1845492012-1688060364-3956d95c96f0464f88cbed30b09d1e3d1688060365.png?1823659007 640w">', // Nulo
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1349027066-1688060390-b2a827772a92d24d09eba1edfa7c47ad1688060390.png?1563154276" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1349027066-1688060390-b2a827772a92d24d09eba1edfa7c47ad1688060390.png?1563154276 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1349027066-1688060390-b2a827772a92d24d09eba1edfa7c47ad1688060390.png?1563154276 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1349027066-1688060390-b2a827772a92d24d09eba1edfa7c47ad1688060390.png?1563154276 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1349027066-1688060390-b2a827772a92d24d09eba1edfa7c47ad1688060390.png?1563154276 640w">', // Nupec
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1645665985-1688060415-3348df5f89869e86598cd7832860f8061688060415.png?746161752" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1645665985-1688060415-3348df5f89869e86598cd7832860f8061688060415.png?746161752 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1645665985-1688060415-3348df5f89869e86598cd7832860f8061688060415.png?746161752 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1645665985-1688060415-3348df5f89869e86598cd7832860f8061688060415.png?746161752 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1645665985-1688060415-3348df5f89869e86598cd7832860f8061688060415.png?746161752 640w">', // Nutre Cat
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1695965112-1688060444-9f2fdb059139883770e4639cdac5cb4e1688060445.png?98251241" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1695965112-1688060444-9f2fdb059139883770e4639cdac5cb4e1688060445.png?98251241 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1695965112-1688060444-9f2fdb059139883770e4639cdac5cb4e1688060445.png?98251241 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1695965112-1688060444-9f2fdb059139883770e4639cdac5cb4e1688060445.png?98251241 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1695965112-1688060444-9f2fdb059139883770e4639cdac5cb4e1688060445.png?98251241 640w">', // Nutre can
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1099002583-1688060475-c526bc5d8c00491633c15c5e6219953d1688060475.png?1883011828" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1099002583-1688060475-c526bc5d8c00491633c15c5e6219953d1688060475.png?1883011828 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1099002583-1688060475-c526bc5d8c00491633c15c5e6219953d1688060475.png?1883011828 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1099002583-1688060475-c526bc5d8c00491633c15c5e6219953d1688060475.png?1883011828 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1099002583-1688060475-c526bc5d8c00491633c15c5e6219953d1688060475.png?1883011828 640w">', // Nutrion
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1945389851-1688060498-041081b352c51b056297393dac71d9121688060499.png?428990981" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1945389851-1688060498-041081b352c51b056297393dac71d9121688060499.png?428990981 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1945389851-1688060498-041081b352c51b056297393dac71d9121688060499.png?428990981 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1945389851-1688060498-041081b352c51b056297393dac71d9121688060499.png?428990981 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1945389851-1688060498-041081b352c51b056297393dac71d9121688060499.png?428990981 640w">', // Nutriss
                      '<span class="h1 text-primary" style="position: absolute;">O</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-347013587-1688060529-167636f14f2b64ec1f711e555a192b2c1688060530.png?642145330" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-347013587-1688060529-167636f14f2b64ec1f711e555a192b2c1688060530.png?642145330 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-347013587-1688060529-167636f14f2b64ec1f711e555a192b2c1688060530.png?642145330 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-347013587-1688060529-167636f14f2b64ec1f711e555a192b2c1688060530.png?642145330 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-347013587-1688060529-167636f14f2b64ec1f711e555a192b2c1688060530.png?642145330 640w">', // Orijen
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-806282511-1688060558-7e24b6869e2fbe11bbe980e082c750831688060558.png?349378559" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-806282511-1688060558-7e24b6869e2fbe11bbe980e082c750831688060558.png?349378559 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-806282511-1688060558-7e24b6869e2fbe11bbe980e082c750831688060558.png?349378559 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-806282511-1688060558-7e24b6869e2fbe11bbe980e082c750831688060558.png?349378559 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-806282511-1688060558-7e24b6869e2fbe11bbe980e082c750831688060558.png?349378559 640w">', // Orijenes
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-456753763-1688060594-7a55853ebd702ca7cbd3329d9f5ac6b71688060595.png?1147567656" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-456753763-1688060594-7a55853ebd702ca7cbd3329d9f5ac6b71688060595.png?1147567656 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-456753763-1688060594-7a55853ebd702ca7cbd3329d9f5ac6b71688060595.png?1147567656 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-456753763-1688060594-7a55853ebd702ca7cbd3329d9f5ac6b71688060595.png?1147567656 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-456753763-1688060594-7a55853ebd702ca7cbd3329d9f5ac6b71688060595.png?1147567656 640w">', // Oh mai gat
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-383265494-1688060621-21ca59da82d640cffbe1c98896742dbe1688060622.png?861395581" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-383265494-1688060621-21ca59da82d640cffbe1c98896742dbe1688060622.png?861395581 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-383265494-1688060621-21ca59da82d640cffbe1c98896742dbe1688060622.png?861395581 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-383265494-1688060621-21ca59da82d640cffbe1c98896742dbe1688060622.png?861395581 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-383265494-1688060621-21ca59da82d640cffbe1c98896742dbe1688060622.png?861395581 640w">', // Optimum
                      '<span class="h1 text-primary" style="position: absolute;">P</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1665955398-1688060657-6e6d60d8787dd2dbc718c7542a49adee1688060657.png?529523737" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1665955398-1688060657-6e6d60d8787dd2dbc718c7542a49adee1688060657.png?529523737 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1665955398-1688060657-6e6d60d8787dd2dbc718c7542a49adee1688060657.png?529523737 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1665955398-1688060657-6e6d60d8787dd2dbc718c7542a49adee1688060657.png?529523737 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1665955398-1688060657-6e6d60d8787dd2dbc718c7542a49adee1688060657.png?529523737 640w">', // Pro plan
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1079168540-1688060685-33a85a524ae1467cbab4dc2ea14570731688060686.png?769922290" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1079168540-1688060685-33a85a524ae1467cbab4dc2ea14570731688060686.png?769922290 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1079168540-1688060685-33a85a524ae1467cbab4dc2ea14570731688060686.png?769922290 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1079168540-1688060685-33a85a524ae1467cbab4dc2ea14570731688060686.png?769922290 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1079168540-1688060685-33a85a524ae1467cbab4dc2ea14570731688060686.png?769922290 640w">', // Pedigree 
                      '<span class="h1 text-primary" style="position: absolute;">Q</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-446171820-1688060711-b49b381aebfc69468b12292e98763c941688060712.png?25541030" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-446171820-1688060711-b49b381aebfc69468b12292e98763c941688060712.png?25541030 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-446171820-1688060711-b49b381aebfc69468b12292e98763c941688060712.png?25541030 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-446171820-1688060711-b49b381aebfc69468b12292e98763c941688060712.png?25541030 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-446171820-1688060711-b49b381aebfc69468b12292e98763c941688060712.png?25541030 640w">', // Qida cat
                      '<span class="h1 text-primary" style="position: absolute;">R</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-755494758-1688060746-a2e653a7c9632329f2ad1e46caae42271688060747.png?1994665375" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-755494758-1688060746-a2e653a7c9632329f2ad1e46caae42271688060747.png?1994665375 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-755494758-1688060746-a2e653a7c9632329f2ad1e46caae42271688060747.png?1994665375 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-755494758-1688060746-a2e653a7c9632329f2ad1e46caae42271688060747.png?1994665375 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-755494758-1688060746-a2e653a7c9632329f2ad1e46caae42271688060747.png?1994665375 640w">', // Royal Canin
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-222948602-1688060777-164c6ad4a4ba5ee937a53be31f8f43551688060778.png?838906070" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-222948602-1688060777-164c6ad4a4ba5ee937a53be31f8f43551688060778.png?838906070 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-222948602-1688060777-164c6ad4a4ba5ee937a53be31f8f43551688060778.png?838906070 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-222948602-1688060777-164c6ad4a4ba5ee937a53be31f8f43551688060778.png?838906070 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-222948602-1688060777-164c6ad4a4ba5ee937a53be31f8f43551688060778.png?838906070 640w">', // Ringo
                      '<span class="h1 text-primary" style="position: absolute;">S</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1636858750-1688060806-f3ebcb98d2bc2328e5d1e2eb37cdc94a1688060807.png?115234420" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1636858750-1688060806-f3ebcb98d2bc2328e5d1e2eb37cdc94a1688060807.png?115234420 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1636858750-1688060806-f3ebcb98d2bc2328e5d1e2eb37cdc94a1688060807.png?115234420 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1636858750-1688060806-f3ebcb98d2bc2328e5d1e2eb37cdc94a1688060807.png?115234420 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1636858750-1688060806-f3ebcb98d2bc2328e5d1e2eb37cdc94a1688060807.png?115234420 640w">', // Smart Bone
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1199384487-1688060834-a6890d18250c8808097e321742e184281688060835.png?84988828" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1199384487-1688060834-a6890d18250c8808097e321742e184281688060835.png?84988828 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1199384487-1688060834-a6890d18250c8808097e321742e184281688060835.png?84988828 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1199384487-1688060834-a6890d18250c8808097e321742e184281688060835.png?84988828 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1199384487-1688060834-a6890d18250c8808097e321742e184281688060835.png?84988828 640w">', // Sportsman's Pride
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1436244433-1688060860-0e6630ce32f4e9f4aee0bd87ffbdcf301688060860.png?773780034" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1436244433-1688060860-0e6630ce32f4e9f4aee0bd87ffbdcf301688060860.png?773780034 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1436244433-1688060860-0e6630ce32f4e9f4aee0bd87ffbdcf301688060860.png?773780034 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1436244433-1688060860-0e6630ce32f4e9f4aee0bd87ffbdcf301688060860.png?773780034 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1436244433-1688060860-0e6630ce32f4e9f4aee0bd87ffbdcf301688060860.png?773780034 640w">', // Sheba
                      '<span class="h1 text-primary" style="position: absolute;">T</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2114051743-1688060888-14e6ace16568ccebe111da28af4dfcdd1688060888.png?1974066140" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2114051743-1688060888-14e6ace16568ccebe111da28af4dfcdd1688060888.png?1974066140 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2114051743-1688060888-14e6ace16568ccebe111da28af4dfcdd1688060888.png?1974066140 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2114051743-1688060888-14e6ace16568ccebe111da28af4dfcdd1688060888.png?1974066140 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-2114051743-1688060888-14e6ace16568ccebe111da28af4dfcdd1688060888.png?1974066140 640w">', // Tommy Dog
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1295209440-1688065593-f81316532c231da1ebd1cd89864467b51688065594.png?908194095" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1295209440-1688065593-f81316532c231da1ebd1cd89864467b51688065594.png?908194095 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1295209440-1688065593-f81316532c231da1ebd1cd89864467b51688065594.png?908194095 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1295209440-1688065593-f81316532c231da1ebd1cd89864467b51688065594.png?908194095 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1295209440-1688065593-f81316532c231da1ebd1cd89864467b51688065594.png?908194095 640w">', // Taste of the wild
                      '<span class="h1 text-primary" style="position: absolute;">V</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1876360712-1688060973-46be66502ecbaab39f2715b96dc4c00a1688060973.png?1140735833" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1876360712-1688060973-46be66502ecbaab39f2715b96dc4c00a1688060973.png?1140735833 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1876360712-1688060973-46be66502ecbaab39f2715b96dc4c00a1688060973.png?1140735833 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1876360712-1688060973-46be66502ecbaab39f2715b96dc4c00a1688060973.png?1140735833 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1876360712-1688060973-46be66502ecbaab39f2715b96dc4c00a1688060973.png?1140735833 640w">', // Vet Life
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1867936439-1688061019-4a1dc1fd9540b224e0ba6d9b8a2b6de11688061019.png?382773315" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1867936439-1688061019-4a1dc1fd9540b224e0ba6d9b8a2b6de11688061019.png?382773315 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1867936439-1688061019-4a1dc1fd9540b224e0ba6d9b8a2b6de11688061019.png?382773315 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1867936439-1688061019-4a1dc1fd9540b224e0ba6d9b8a2b6de11688061019.png?382773315 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1867936439-1688061019-4a1dc1fd9540b224e0ba6d9b8a2b6de11688061019.png?382773315 640w">', // Virbac
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1544678864-1688061054-ecd02523242cb8fc8921581f8f9dc3bc1688061054.png?1151489080" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1544678864-1688061054-ecd02523242cb8fc8921581f8f9dc3bc1688061054.png?1151489080 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1544678864-1688061054-ecd02523242cb8fc8921581f8f9dc3bc1688061054.png?1151489080 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1544678864-1688061054-ecd02523242cb8fc8921581f8f9dc3bc1688061054.png?1151489080 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1544678864-1688061054-ecd02523242cb8fc8921581f8f9dc3bc1688061054.png?1151489080 640w">', // Vet Solution
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-971761161-1688061084-4bbb31d8f1ce78672a856d6e36465e131688061084.png?908199074" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-971761161-1688061084-4bbb31d8f1ce78672a856d6e36465e131688061084.png?908199074 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-971761161-1688061084-4bbb31d8f1ce78672a856d6e36465e131688061084.png?908199074 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-971761161-1688061084-4bbb31d8f1ce78672a856d6e36465e131688061084.png?908199074 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-971761161-1688061084-4bbb31d8f1ce78672a856d6e36465e131688061084.png?908199074 640w">', // Vital can
                      '<span class="h1 text-primary" style="position: absolute;">W</span><img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/1-img-1921351372-1688061114-64d48dfed54c6e1c3e5d7fe2d60ff9841688061114-50-0.webp?2039887529" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/1-img-1921351372-1688061114-64d48dfed54c6e1c3e5d7fe2d60ff9841688061114-480-0.webp?2039887529 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/1-img-1921351372-1688061114-64d48dfed54c6e1c3e5d7fe2d60ff9841688061114-640-0.webp?2039887529 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/1-img-1921351372-1688061114-64d48dfed54c6e1c3e5d7fe2d60ff9841688061114-480-0.webp?2039887529 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/1-img-1921351372-1688061114-64d48dfed54c6e1c3e5d7fe2d60ff9841688061114-640-0.webp?2039887529 640w">', // Wow Can
                      '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-515794238-1688061259-39d1b1ecfc5724a7b3ff1642bff644151688061259.png?1690689048" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-515794238-1688061259-39d1b1ecfc5724a7b3ff1642bff644151688061259.png?1690689048 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-515794238-1688061259-39d1b1ecfc5724a7b3ff1642bff644151688061259.png?1690689048 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-515794238-1688061259-39d1b1ecfc5724a7b3ff1642bff644151688061259.png?1690689048 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-515794238-1688061259-39d1b1ecfc5724a7b3ff1642bff644151688061259.png?1690689048 640w">']; // Whiskas 68
        
        let imagesLinks = ['https://beethovenvillavo.com/marcas/agility-gold1/', 'https://beethovenvillavo.com/marcas/orijen-acana/',
                           'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/alpo1/', 'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/br-for-cat/',
                           'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/br-for-dogs/', 'https://beethovenvillavo.com/marcas/otras-marcas/birbo/',
                           'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/br-wild/', 'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/br-wild1/',
                           'https://beethovenvillavo.com/marcas/chunky/', 'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/cat-chow/',
                           'https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/country-value/', 'https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/cat-dog-licius/',
                           'https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/churu/', 'https://beethovenvillavo.com/marcas/diamond-naturals/',
                           'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/dog-chow/', '#',
                           'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/donkan-dogourmet/', 'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/donkan-dogourmet/',
                           'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/donkat-oh-mai-gat/', 'https://beethovenvillavo.com/marcas/equilibrio/',
                           'https://beethovenvillavo.com/marcas/excellent/', 'https://beethovenvillavo.com/marcas/evolve/',
                           'https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/eukanuba/', 'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ringo-filpo/',
                           'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/ver-mas4/felix/', 'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/ver-mas4/fancy-feast/',
                           'https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/gemon2/', 'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/gatsy1/',
                           'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/guaumor/', 'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/ganador/',
                           'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/grand-vita1/', 'https://beethovenvillavo.com/marcas/hills/',
                           'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/chunky-italcan/', 'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/kody/',
                           'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/lucky/', 'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/max-naturalis/',
                           'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/max/', 'https://beethovenvillavo.com/marcas/monello/',
                           'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/mirringo/', 'https://beethovenvillavo.com/marcas/nutra-nuggets/',
                           'https://beethovenvillavo.com/marcas/naturalis2/', 'https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/nd2/',
                           'https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/nulo2/', 'https://beethovenvillavo.com/marcas/nupec/',
                           'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/nutrecat-q-idacat/', 'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/nutre-can1/',
                           'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/nutrion/', 'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/nutriss/',
                           'https://beethovenvillavo.com/marcas/orijen-acana/', 'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/barf-origenes/',
                           'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/donkat-oh-mai-gat/', 'https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/optimum/',
                           'https://beethovenvillavo.com/marcas/pro-plan/', 'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/pedigree/',
                           'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/nutrecat-q-idacat/', 'https://beethovenvillavo.com/marcas/royal-canin/',
                           'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ringo-filpo/', 'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/smartbones/',
                           'https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/pride-sportsman/', 'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/ver-mas4/sheba/',
                           'https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/tommy2/', 'https://beethovenvillavo.com/marcas/taste-of-the-wild/',
                           'https://beethovenvillavo.com/marcas/vet-life/', 'https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/virbac3/',
                           'https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/vet-solution-by-mongue2/', 'https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/vitalcan2/',
                           'https://beethovenvillavo.com/productos/wow-can/', 'https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/whiskas/']; // 68

        let contBrands = 0;

        if (brandsRow) {
            brandsRow.innerHTML = '';

            images.forEach(image => {
                brandsRow.innerHTML = brandsRow.innerHTML + `<div class="brands-page-image"><a href="${imagesLinks[contBrands]}">${image}</a></div>`;
                contBrands++;
            });
        }

        brandsRowParent.appendChild(brandsRow);
        let title = document.createElement('h3');
        title.classList.add('h1'); title.classList.add('text-primary');
        title.innerText = 'Alimentos'; brandsRow.parentNode.insertBefore(title, brandsRow);
        
        // Implementos y Arenas
        brandsRow = document.createElement('div');
        brandsRow.classList.add('row'); brandsRow.classList.add('justify-content-md-center');
        images = ['<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1933009370-1688064132-403787c9a79c4869d1d4de5b4da39ab81688064132.png?1726306507" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1933009370-1688064132-403787c9a79c4869d1d4de5b4da39ab81688064132.png?1726306507 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1933009370-1688064132-403787c9a79c4869d1d4de5b4da39ab81688064132.png?1726306507 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1933009370-1688064132-403787c9a79c4869d1d4de5b4da39ab81688064132.png?1726306507 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1933009370-1688064132-403787c9a79c4869d1d4de5b4da39ab81688064132.png?1726306507 640w">', // Can Amor
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-789414614-1688064166-9a487538d2cf279666580024a0545da81688064167.png?1004870318" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-789414614-1688064166-9a487538d2cf279666580024a0545da81688064167.png?1004870318 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-789414614-1688064166-9a487538d2cf279666580024a0545da81688064167.png?1004870318 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-789414614-1688064166-9a487538d2cf279666580024a0545da81688064167.png?1004870318 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-789414614-1688064166-9a487538d2cf279666580024a0545da81688064167.png?1004870318 640w">', // Dinky
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-347234260-1688064191-10a4b907edee7b37a0512d44211a7c021688064192.png?1184053831" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-347234260-1688064191-10a4b907edee7b37a0512d44211a7c021688064192.png?1184053831 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-347234260-1688064191-10a4b907edee7b37a0512d44211a7c021688064192.png?1184053831 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-347234260-1688064191-10a4b907edee7b37a0512d44211a7c021688064192.png?1184053831 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-347234260-1688064191-10a4b907edee7b37a0512d44211a7c021688064192.png?1184053831 640w">', // Petys
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1634442587-1688064220-7440cec190a63783e0f0dbc4a67aefeb1688064220.png?1160701280" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1634442587-1688064220-7440cec190a63783e0f0dbc4a67aefeb1688064220.png?1160701280 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1634442587-1688064220-7440cec190a63783e0f0dbc4a67aefeb1688064220.png?1160701280 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1634442587-1688064220-7440cec190a63783e0f0dbc4a67aefeb1688064220.png?1160701280 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1634442587-1688064220-7440cec190a63783e0f0dbc4a67aefeb1688064220.png?1160701280 640w">', // Canada Litter
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-117783072-1688064302-419ef21714c83652bdc0e8b2d246c0471688064302.png?1075994975" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-117783072-1688064302-419ef21714c83652bdc0e8b2d246c0471688064302.png?1075994975 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-117783072-1688064302-419ef21714c83652bdc0e8b2d246c0471688064302.png?1075994975 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-117783072-1688064302-419ef21714c83652bdc0e8b2d246c0471688064302.png?1075994975 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-117783072-1688064302-419ef21714c83652bdc0e8b2d246c0471688064302.png?1075994975 640w">', // Free Miau
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1160762711-1688064329-68866e49078e2ef46d2ef19d12fe58ea1688064330.png?592312057" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1160762711-1688064329-68866e49078e2ef46d2ef19d12fe58ea1688064330.png?592312057 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1160762711-1688064329-68866e49078e2ef46d2ef19d12fe58ea1688064330.png?592312057 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1160762711-1688064329-68866e49078e2ef46d2ef19d12fe58ea1688064330.png?592312057 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1160762711-1688064329-68866e49078e2ef46d2ef19d12fe58ea1688064330.png?592312057 640w">', // Fofi Cat
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-900577941-1688064358-4951f244f5d33a2bddc15125c9c593c11688064358.png?542434816" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-900577941-1688064358-4951f244f5d33a2bddc15125c9c593c11688064358.png?542434816 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-900577941-1688064358-4951f244f5d33a2bddc15125c9c593c11688064358.png?542434816 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-900577941-1688064358-4951f244f5d33a2bddc15125c9c593c11688064358.png?542434816 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-900577941-1688064358-4951f244f5d33a2bddc15125c9c593c11688064358.png?542434816 640w">', // Maxi cat
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1434411589-1688064380-5448f87cb5702dddc47de6c9c93fc87f1688064381.png?627327236" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1434411589-1688064380-5448f87cb5702dddc47de6c9c93fc87f1688064381.png?627327236 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1434411589-1688064380-5448f87cb5702dddc47de6c9c93fc87f1688064381.png?627327236 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1434411589-1688064380-5448f87cb5702dddc47de6c9c93fc87f1688064381.png?627327236 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1434411589-1688064380-5448f87cb5702dddc47de6c9c93fc87f1688064381.png?627327236 640w">', // Fresh step
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-401518867-1688064406-862ef986ce56667fda4b5e6a08a2e92b1688064406.png?1909942520" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-401518867-1688064406-862ef986ce56667fda4b5e6a08a2e92b1688064406.png?1909942520 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-401518867-1688064406-862ef986ce56667fda4b5e6a08a2e92b1688064406.png?1909942520 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-401518867-1688064406-862ef986ce56667fda4b5e6a08a2e92b1688064406.png?1909942520 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-401518867-1688064406-862ef986ce56667fda4b5e6a08a2e92b1688064406.png?1909942520 640w">', // Michiko 9
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-186809139-1688064437-f4b9f9efc53580e87e3ccad39ba2ae5d1688064437.png?707448541" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-186809139-1688064437-f4b9f9efc53580e87e3ccad39ba2ae5d1688064437.png?707448541 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-186809139-1688064437-f4b9f9efc53580e87e3ccad39ba2ae5d1688064437.png?707448541 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-186809139-1688064437-f4b9f9efc53580e87e3ccad39ba2ae5d1688064437.png?707448541 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-186809139-1688064437-f4b9f9efc53580e87e3ccad39ba2ae5d1688064437.png?707448541 640w">', // Sepi Cat
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1294005842-1688064485-2ead1c05e6da536f84508a854da90f6f1688064486.png?728221688" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1294005842-1688064485-2ead1c05e6da536f84508a854da90f6f1688064486.png?728221688 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1294005842-1688064485-2ead1c05e6da536f84508a854da90f6f1688064486.png?728221688 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1294005842-1688064485-2ead1c05e6da536f84508a854da90f6f1688064486.png?728221688 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1294005842-1688064485-2ead1c05e6da536f84508a854da90f6f1688064486.png?728221688 640w">', // Tidy cats
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-37836104-1688064515-946bb481edc8de643f62a6408f55bd7d1688064516.png?269976587" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-37836104-1688064515-946bb481edc8de643f62a6408f55bd7d1688064516.png?269976587 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-37836104-1688064515-946bb481edc8de643f62a6408f55bd7d1688064516.png?269976587 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-37836104-1688064515-946bb481edc8de643f62a6408f55bd7d1688064516.png?269976587 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-37836104-1688064515-946bb481edc8de643f62a6408f55bd7d1688064516.png?269976587 640w">', // Pino Minino
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1296413903-1688064540-aaa297b16cdf6f5b412dadc479c11c861688064541.png?304316186" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1296413903-1688064540-aaa297b16cdf6f5b412dadc479c11c861688064541.png?304316186 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1296413903-1688064540-aaa297b16cdf6f5b412dadc479c11c861688064541.png?304316186 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1296413903-1688064540-aaa297b16cdf6f5b412dadc479c11c861688064541.png?304316186 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1296413903-1688064540-aaa297b16cdf6f5b412dadc479c11c861688064541.png?304316186 640w">', // Arena Calabaza Dets
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-958095664-1688064571-06a0422e7d094a3115a0bdf3250f22b81688064572.png?1340688793" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-958095664-1688064571-06a0422e7d094a3115a0bdf3250f22b81688064572.png?1340688793 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-958095664-1688064571-06a0422e7d094a3115a0bdf3250f22b81688064572.png?1340688793 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-958095664-1688064571-06a0422e7d094a3115a0bdf3250f22b81688064572.png?1340688793 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-958095664-1688064571-06a0422e7d094a3115a0bdf3250f22b81688064572.png?1340688793 640w">', // Misty Cat
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1660871603-1688064597-0dfb465684821b31bc1f19fdb5ab1b131688064597.png?461315300" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1660871603-1688064597-0dfb465684821b31bc1f19fdb5ab1b131688064597.png?461315300 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1660871603-1688064597-0dfb465684821b31bc1f19fdb5ab1b131688064597.png?461315300 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1660871603-1688064597-0dfb465684821b31bc1f19fdb5ab1b131688064597.png?461315300 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1660871603-1688064597-0dfb465684821b31bc1f19fdb5ab1b131688064597.png?461315300 640w">', // Arena Mirringo
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-330239517-1688064620-49e5e1e76f8aeaaddb5a803392bdc8e21688064621.png?806562531" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-330239517-1688064620-49e5e1e76f8aeaaddb5a803392bdc8e21688064621.png?806562531 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-330239517-1688064620-49e5e1e76f8aeaaddb5a803392bdc8e21688064621.png?806562531 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-330239517-1688064620-49e5e1e76f8aeaaddb5a803392bdc8e21688064621.png?806562531 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-330239517-1688064620-49e5e1e76f8aeaaddb5a803392bdc8e21688064621.png?806562531 640w">', // FURminator
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1536047219-1688064646-f11d40bc62fcf970d4df387e96fa7e6b1688064646.png?529860338" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1536047219-1688064646-f11d40bc62fcf970d4df387e96fa7e6b1688064646.png?529860338 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1536047219-1688064646-f11d40bc62fcf970d4df387e96fa7e6b1688064646.png?529860338 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1536047219-1688064646-f11d40bc62fcf970d4df387e96fa7e6b1688064646.png?529860338 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1536047219-1688064646-f11d40bc62fcf970d4df387e96fa7e6b1688064646.png?529860338 640w">', // Hydra
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-305035414-1688064673-3e853bb6d0efa9c02fa01e30b43895821688064674.png?247058753" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-305035414-1688064673-3e853bb6d0efa9c02fa01e30b43895821688064674.png?247058753 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-305035414-1688064673-3e853bb6d0efa9c02fa01e30b43895821688064674.png?247058753 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-305035414-1688064673-3e853bb6d0efa9c02fa01e30b43895821688064674.png?247058753 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-305035414-1688064673-3e853bb6d0efa9c02fa01e30b43895821688064674.png?247058753 640w">', // Nature's Miracle
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-224209434-1688064698-0c1312da5ce9e43c7a305c5273dc72721688064698.png?889843304" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-224209434-1688064698-0c1312da5ce9e43c7a305c5273dc72721688064698.png?889843304 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-224209434-1688064698-0c1312da5ce9e43c7a305c5273dc72721688064698.png?889843304 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-224209434-1688064698-0c1312da5ce9e43c7a305c5273dc72721688064698.png?889843304 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-224209434-1688064698-0c1312da5ce9e43c7a305c5273dc72721688064698.png?889843304 640w">']; // Kong
        imagesLinks = ['https://beethovenvillavo.com/limpieza-e-higiene/', 'https://beethovenvillavo.com/limpieza-e-higiene/', 'https://beethovenvillavo.com/limpieza-e-higiene/',
                       'https://beethovenvillavo.com/gatos/arenas/', 'https://beethovenvillavo.com/gatos/arenas/', 'https://beethovenvillavo.com/gatos/arenas/',
                       'https://beethovenvillavo.com/gatos/arenas/', 'https://beethovenvillavo.com/gatos/arenas/', 'https://beethovenvillavo.com/gatos/arenas/',
                       'https://beethovenvillavo.com/gatos/arenas/', 'https://beethovenvillavo.com/gatos/arenas/', 'https://beethovenvillavo.com/gatos/arenas/',
                       'https://beethovenvillavo.com/gatos/arenas/', 'https://beethovenvillavo.com/gatos/arenas/', 'https://beethovenvillavo.com/gatos/arenas/',
                       '#', '#', '#', '#'];
        contBrands = 0

        if (brandsRow) images.forEach(image => {
                brandsRow.innerHTML = brandsRow.innerHTML + `<div class="brands-page-image"><a href="${imagesLinks[contBrands]}">${image}</a></div>`;
                contBrands++;
            });

        brandsRowParent.appendChild(brandsRow);
        title = document.createElement('h3');
        title.classList.add('h1'); title.classList.add('text-primary');
        title.innerText = 'Implementos y Arenas'; brandsRow.parentNode.insertBefore(title, brandsRow);

        // Laboratorios y Farmacia
        brandsRow = document.createElement('div');
        brandsRow.classList.add('row'); brandsRow.classList.add('justify-content-md-center');
        images = ['<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-733380756-1688064777-15f370105230d771a3a1936f352607ee1688064777.png?437010821" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-733380756-1688064777-15f370105230d771a3a1936f352607ee1688064777.png?437010821 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-733380756-1688064777-15f370105230d771a3a1936f352607ee1688064777.png?437010821 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-733380756-1688064777-15f370105230d771a3a1936f352607ee1688064777.png?437010821 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-733380756-1688064777-15f370105230d771a3a1936f352607ee1688064777.png?437010821 640w">', // Credelio
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-985564774-1688064811-72d3b359c8554a76ac73fe60c76f550f1688064811.png?939240024" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-985564774-1688064811-72d3b359c8554a76ac73fe60c76f550f1688064811.png?939240024 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-985564774-1688064811-72d3b359c8554a76ac73fe60c76f550f1688064811.png?939240024 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-985564774-1688064811-72d3b359c8554a76ac73fe60c76f550f1688064811.png?939240024 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-985564774-1688064811-72d3b359c8554a76ac73fe60c76f550f1688064811.png?939240024 640w">', // Nex Guard
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1315701842-1688064844-67e37077fba95950ab789302b3891e8f1688064845.png?369122890" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1315701842-1688064844-67e37077fba95950ab789302b3891e8f1688064845.png?369122890 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1315701842-1688064844-67e37077fba95950ab789302b3891e8f1688064845.png?369122890 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1315701842-1688064844-67e37077fba95950ab789302b3891e8f1688064845.png?369122890 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1315701842-1688064844-67e37077fba95950ab789302b3891e8f1688064845.png?369122890 640w">', // Simparica
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1759787525-1688064887-c4d01a2c20081ab61a6870ef547c8fe61688064888.png?1111339361" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1759787525-1688064887-c4d01a2c20081ab61a6870ef547c8fe61688064888.png?1111339361 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1759787525-1688064887-c4d01a2c20081ab61a6870ef547c8fe61688064888.png?1111339361 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1759787525-1688064887-c4d01a2c20081ab61a6870ef547c8fe61688064888.png?1111339361 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1759787525-1688064887-c4d01a2c20081ab61a6870ef547c8fe61688064888.png?1111339361 640w">', // Bravecto
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1532316036-1688064918-6e6f337d773a66e78ec37fbe04e644e51688064919.png?748840187" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1532316036-1688064918-6e6f337d773a66e78ec37fbe04e644e51688064919.png?748840187 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1532316036-1688064918-6e6f337d773a66e78ec37fbe04e644e51688064919.png?748840187 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1532316036-1688064918-6e6f337d773a66e78ec37fbe04e644e51688064919.png?748840187 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1532316036-1688064918-6e6f337d773a66e78ec37fbe04e644e51688064919.png?748840187 640w">', // Natural Freshly
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-843758074-1688064969-f67173d2fb67372de59e5909d32ac0ed1688064969.png?1153218663" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-843758074-1688064969-f67173d2fb67372de59e5909d32ac0ed1688064969.png?1153218663 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-843758074-1688064969-f67173d2fb67372de59e5909d32ac0ed1688064969.png?1153218663 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-843758074-1688064969-f67173d2fb67372de59e5909d32ac0ed1688064969.png?1153218663 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-843758074-1688064969-f67173d2fb67372de59e5909d32ac0ed1688064969.png?1153218663 640w">', // Shed-X
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1690558806-1688064997-dac44849e750aea729e38c043d6941461688064997.png?622841028" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1690558806-1688064997-dac44849e750aea729e38c043d6941461688064997.png?622841028 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1690558806-1688064997-dac44849e750aea729e38c043d6941461688064997.png?622841028 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1690558806-1688064997-dac44849e750aea729e38c043d6941461688064997.png?622841028 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1690558806-1688064997-dac44849e750aea729e38c043d6941461688064997.png?622841028 640w">', // Mirrapel
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1731128638-1688065033-169d6eebd13613a09465a5e1f38b35ff1688065033.png?490366522" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1731128638-1688065033-169d6eebd13613a09465a5e1f38b35ff1688065033.png?490366522 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1731128638-1688065033-169d6eebd13613a09465a5e1f38b35ff1688065033.png?490366522 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1731128638-1688065033-169d6eebd13613a09465a5e1f38b35ff1688065033.png?490366522 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1731128638-1688065033-169d6eebd13613a09465a5e1f38b35ff1688065033.png?490366522 640w">', // Holliday
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1527079262-1688065058-3e747feba9c736c5cb323865885ed8461688065059.png?1622895225" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1527079262-1688065058-3e747feba9c736c5cb323865885ed8461688065059.png?1622895225 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1527079262-1688065058-3e747feba9c736c5cb323865885ed8461688065059.png?1622895225 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1527079262-1688065058-3e747feba9c736c5cb323865885ed8461688065059.png?1622895225 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1527079262-1688065058-3e747feba9c736c5cb323865885ed8461688065059.png?1622895225 640w">', // Invent
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1798155662-1688065082-f2f02614d89eb869fc958c3b9511bae41688065083.png?137178905" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1798155662-1688065082-f2f02614d89eb869fc958c3b9511bae41688065083.png?137178905 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1798155662-1688065082-f2f02614d89eb869fc958c3b9511bae41688065083.png?137178905 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1798155662-1688065082-f2f02614d89eb869fc958c3b9511bae41688065083.png?137178905 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1798155662-1688065082-f2f02614d89eb869fc958c3b9511bae41688065083.png?137178905 640w">', // Virbac
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-913050736-1688065109-6279e7f1d4d5b178e8665763ff06f75c1688065109.png?1509959818" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-913050736-1688065109-6279e7f1d4d5b178e8665763ff06f75c1688065109.png?1509959818 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-913050736-1688065109-6279e7f1d4d5b178e8665763ff06f75c1688065109.png?1509959818 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-913050736-1688065109-6279e7f1d4d5b178e8665763ff06f75c1688065109.png?1509959818 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-913050736-1688065109-6279e7f1d4d5b178e8665763ff06f75c1688065109.png?1509959818 640w">', // Bayer
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1584592164-1688065133-ae9dcabb4c6662290102cff3d32494bc1688065134.png?852865825" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1584592164-1688065133-ae9dcabb4c6662290102cff3d32494bc1688065134.png?852865825 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1584592164-1688065133-ae9dcabb4c6662290102cff3d32494bc1688065134.png?852865825 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1584592164-1688065133-ae9dcabb4c6662290102cff3d32494bc1688065134.png?852865825 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1584592164-1688065133-ae9dcabb4c6662290102cff3d32494bc1688065134.png?852865825 640w">', // Boehringer Ingelheim
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1802028413-1688065157-aabc0dc072aadd45bd3e6ed51a0658ba1688065157.png?1517744287" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1802028413-1688065157-aabc0dc072aadd45bd3e6ed51a0658ba1688065157.png?1517744287 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1802028413-1688065157-aabc0dc072aadd45bd3e6ed51a0658ba1688065157.png?1517744287 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1802028413-1688065157-aabc0dc072aadd45bd3e6ed51a0658ba1688065157.png?1517744287 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1802028413-1688065157-aabc0dc072aadd45bd3e6ed51a0658ba1688065157.png?1517744287 640w">', // Provet
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-410475887-1688065182-9d6e55c707509f5406ec6df19ff0c2271688065182.png?1152768820" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-410475887-1688065182-9d6e55c707509f5406ec6df19ff0c2271688065182.png?1152768820 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-410475887-1688065182-9d6e55c707509f5406ec6df19ff0c2271688065182.png?1152768820 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-410475887-1688065182-9d6e55c707509f5406ec6df19ff0c2271688065182.png?1152768820 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-410475887-1688065182-9d6e55c707509f5406ec6df19ff0c2271688065182.png?1152768820 640w">', // Carval
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1325940288-1688065205-b23238161807083f707bf8732b666f631688065206.png?1026143959" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1325940288-1688065205-b23238161807083f707bf8732b666f631688065206.png?1026143959 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1325940288-1688065205-b23238161807083f707bf8732b666f631688065206.png?1026143959 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1325940288-1688065205-b23238161807083f707bf8732b666f631688065206.png?1026143959 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1325940288-1688065205-b23238161807083f707bf8732b666f631688065206.png?1026143959 640w">', // Chalver
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-668889701-1688065230-56e4d97c20008caf265a3c5abe7007c91688065230.png?909897644" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-668889701-1688065230-56e4d97c20008caf265a3c5abe7007c91688065230.png?909897644 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-668889701-1688065230-56e4d97c20008caf265a3c5abe7007c91688065230.png?909897644 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-668889701-1688065230-56e4d97c20008caf265a3c5abe7007c91688065230.png?909897644 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-668889701-1688065230-56e4d97c20008caf265a3c5abe7007c91688065230.png?909897644 640w">', // Canis y Felis
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1491950638-1688065254-6d302474614a0ad2f213ec223369f46e1688065254.png?2141074546" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1491950638-1688065254-6d302474614a0ad2f213ec223369f46e1688065254.png?2141074546 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1491950638-1688065254-6d302474614a0ad2f213ec223369f46e1688065254.png?2141074546 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1491950638-1688065254-6d302474614a0ad2f213ec223369f46e1688065254.png?2141074546 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1491950638-1688065254-6d302474614a0ad2f213ec223369f46e1688065254.png?2141074546 640w">', // Feliway
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1232562476-1688065813-ffa7ba31f1254ccfd6eac6ef0d55a68f1688065813.png?889739932" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1232562476-1688065813-ffa7ba31f1254ccfd6eac6ef0d55a68f1688065813.png?889739932 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1232562476-1688065813-ffa7ba31f1254ccfd6eac6ef0d55a68f1688065813.png?889739932 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1232562476-1688065813-ffa7ba31f1254ccfd6eac6ef0d55a68f1688065813.png?889739932 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-1232562476-1688065813-ffa7ba31f1254ccfd6eac6ef0d55a68f1688065813.png?889739932 640w">', // Basic Form
                  '<img src="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-700637253-1688065305-d0d38501428f1ae2c33eef2ab7254f691688065305.png?639275564" data-srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-700637253-1688065305-d0d38501428f1ae2c33eef2ab7254f691688065305.png?639275564 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-700637253-1688065305-d0d38501428f1ae2c33eef2ab7254f691688065305.png?639275564 640w" srcset="//d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-700637253-1688065305-d0d38501428f1ae2c33eef2ab7254f691688065305.png?639275564 480w, //d2r9epyceweg5n.cloudfront.net/stores/002/954/703/themes/amazonas/img-700637253-1688065305-d0d38501428f1ae2c33eef2ab7254f691688065305.png?639275564 640w">']; // California
        imagesLinks = ['https://beethovenvillavo.com/farmacia/antipulgas-y-garrapatas/', 'https://beethovenvillavo.com/farmacia/antipulgas-y-garrapatas/',
        'https://beethovenvillavo.com/farmacia/antipulgas-y-garrapatas/', 'https://beethovenvillavo.com/farmacia/antipulgas-y-garrapatas/',
        '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#'];
        contBrands = 0

        if (brandsRow) images.forEach(image => {
                brandsRow.innerHTML = brandsRow.innerHTML + `<div class="brands-page-image"><a href="${imagesLinks[contBrands]}">${image}</a></div>`;
                contBrands++;
            });

        brandsRowParent.appendChild(brandsRow); 
        title = document.createElement('h3');
        title.classList.add('h1'); title.classList.add('text-primary');   
        title.innerText = 'Laboratorios y Farmacia'; brandsRow.parentNode.insertBefore(title, brandsRow);
    }

    {# /* // Dog and Cat Buttons */ #}

    if ( window.innerWidth < 768) {
        (function() {
            let section = document.body.children[13].children[3];
            let navButtonsList = document.createElement('div');
            navButtonsList.classList.add('nav-buttons-list')

            if (window.location.href.includes('https://beethovenvillavo.com/marcas/agility-gold1/') && window.location.href.split('/').length - 1  == 5) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/agility-gold/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/agility-gold2/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/orijen-acana/') && window.location.href.split('/').length - 1  == 5) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/orijen-acana1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/orijen-acana2/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/otras-marcas/birbo/') && window.location.href.split('/').length - 1  == 6) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/birbo-perro/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/birbo-gato/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/chunky/') && window.location.href.split('/').length - 1  == 5) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/chunky-italcan/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/chunky1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/churu/') && window.location.href.split('/').length - 1  == 7) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/churu1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/ver-mas4/churu2/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/diamond-naturals/') && window.location.href.split('/').length - 1  == 5) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/diamond-naturals1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/diamond-naturals2/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/equilibrio/') && window.location.href.split('/').length - 1  == 5) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/equilibrio1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/equilibrio3/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/excellent/') && window.location.href.split('/').length - 1  == 5) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/excellent-purina/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/excellent1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/evolve/') && window.location.href.split('/').length - 1  == 5) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/evolve1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/evolve2/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/gemon2/') && window.location.href.split('/').length - 1  == 7) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/gemon/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/ver-mas4/gemon1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/hills/') && window.location.href.split('/').length - 1  == 5) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/hills1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/hills3/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/monello/') && window.location.href.split('/').length - 1  == 5) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/monello1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/monello2/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/nutra-nuggets/') && window.location.href.split('/').length - 1  == 5) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/nutra-nuggets1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/nutra-nuggets2/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/naturalis2/') && window.location.href.split('/').length - 1  == 5) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/naturalis1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/naturalis/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/nd2/') && window.location.href.split('/').length - 1  == 7) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/n-d/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/ver-mas4/nd1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/nulo2/') && window.location.href.split('/').length - 1  == 7) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/nulo/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/ver-mas4/nulo1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/nupec/') && window.location.href.split('/').length - 1  == 5) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/nupec1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/nupec2/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/pro-plan/') && window.location.href.split('/').length - 1  == 5) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/pro-plan1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/pro-plan3/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/royal-canin/') && window.location.href.split('/').length - 1  == 5) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/royal-canin1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/royal-canin3/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/tommy2/') && window.location.href.split('/').length - 1  == 7) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/tommy/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/ver-mas4/tommy1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/taste-of-the-wild/') && window.location.href.split('/').length - 1  == 5) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/taste-of-the-wild1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/taste-of-the-wild2/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/vet-life/') && window.location.href.split('/').length - 1  == 5) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/dietas-de-prescripcion-veterinaria/vet-life1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/prescripcion-veterinaria/vet-life2/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/virbac3/') && window.location.href.split('/').length - 1  == 7) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/virbac1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/ver-mas4/virbac2/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/vet-solution-by-mongue2/') && window.location.href.split('/').length - 1  == 7) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/vet-solution-by-mongue/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/ver-mas4/vet-solution-by-mongue1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            } else if (window.location.href.includes('https://beethovenvillavo.com/marcas/otras-marcas/ver-mas/vitalcan2/') && window.location.href.split('/').length - 1  == 7) {
                navButtonsList.innerHTML = `
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/perros/alimentos1/alimentos/concentrados-de-mantenimiento/marcas-perro/ver-mas1/vitalcan/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32h52.1c12.7 0 24.9 5.1 33.9 14.1L496 64h56c13.3 0 24 10.7 24 24v24c0 44.2-35.8 80-80 80H464 448 426.7l-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32H352c-17.7 0-32-14.3-32-32V364.8c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2V480c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V249.8c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192h30 16H303.8L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>Perros</a>
                </div>
                <div class="list">
                    <a class="navButton" href="https://beethovenvillavo.com/gatos/alimentos2/concentrados-mantenimiento/concentrados-de-mantenimiento1/marcas-gato/ver-mas4/vitalcan1/"><svg xmlns="http://www.w3.org/2000/svg" class="svg-image" viewBox="0 0 576 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M320 192h17.1c22.1 38.3 63.5 64 110.9 64c11 0 21.8-1.4 32-4v4 32V480c0 17.7-14.3 32-32 32s-32-14.3-32-32V339.2L280 448h56c17.7 0 32 14.3 32 32s-14.3 32-32 32H192c-53 0-96-43-96-96V192.5c0-16.1-12-29.8-28-31.8l-7.9-1c-17.5-2.2-30-18.2-27.8-35.7s18.2-30 35.7-27.8l7.9 1c48 6 84.1 46.8 84.1 95.3v85.3c34.4-51.7 93.2-85.8 160-85.8zm160 26.5v0c-10 3.5-20.8 5.5-32 5.5c-28.4 0-54-12.4-71.6-32h0c-3.7-4.1-7-8.5-9.9-13.2C357.3 164 352 146.6 352 128v0V32 12 10.7C352 4.8 356.7 .1 362.6 0h.2c3.3 0 6.4 1.6 8.4 4.2l0 .1L384 21.3l27.2 36.3L416 64h64l4.8-6.4L512 21.3 524.8 4.3l0-.1c2-2.6 5.1-4.2 8.4-4.2h.2C539.3 .1 544 4.8 544 10.7V12 32v96c0 17.3-4.6 33.6-12.6 47.6c-11.3 19.8-29.6 35.2-51.4 42.9zM432 128a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm48 16a16 16 0 1 0 0-32 16 16 0 1 0 0 32z"/></svg>Gatos</a>
                </div>
                `

                section.insertAdjacentElement('beforebegin', navButtonsList);
            }
        })()
    }


    {#/*============================================================================
      #Forms
    ==============================================================================*/ #}

    jQueryNuvem(".js-winnie-pooh-form").on("submit", function (e) {
        jQueryNuvem(e.currentTarget).attr('action', '');
    });

    jQueryNuvem(".js-form").on("submit", function (e) {
        jQueryNuvem(e.currentTarget).find('.js-form-spinner').show();
    });

    {% if template == 'account.login' %}
        {% if not result.facebook and result.invalid %}
            jQueryNuvem(".js-account-input").addClass("alert-danger");
            jQueryNuvem(".js-account-input.alert-danger").on("focus", function() {
                jQueryNuvem(".js-account-input").removeClass("alert-danger");
            });
        {% endif %}
    {% endif %}

    {# Show the success or error message when resending the validation link #}

    {% if template == 'account.register' or template == 'account.login' %}
        jQueryNuvem(".js-resend-validation-link").on("click", function(e){
            window.accountVerificationService.resendVerificationEmail('{{ customer_email }}');
        });
    {% endif %}

    jQueryNuvem('.js-password-view').on("click", function (e) {
        jQueryNuvem(e.currentTarget).toggleClass('password-view');

        if(jQueryNuvem(e.currentTarget).hasClass('password-view')){
            jQueryNuvem(e.currentTarget).parent().find(".js-password-input").attr('type', '');
            jQueryNuvem(e.currentTarget).find(".js-eye-open, .js-eye-closed").toggle();
        } else {
            jQueryNuvem(e.currentTarget).parent().find(".js-password-input").attr('type', 'password');
            jQueryNuvem(e.currentTarget).find(".js-eye-open, .js-eye-closed").toggle();
        }
    });

    {% if store.country == 'AR' and template == 'home' %}

        if (cookieService.get('returning_customer') && LS.shouldShowQuickLoginNotification()) {
            {# Make login link toggle quick login modal #}
            jQueryNuvem(".js-login").removeAttr("href").attr("data-toggle", "#quick-login").addClass("js-modal-open js-trigger-modal-zindex-top");
        }
    {% endif %}


    {#/*============================================================================
      #Footer
    ==============================================================================*/ #}

    {% if store.afip %}

        {# Add alt attribute to external AFIP logo to improve SEO #}

        jQueryNuvem('img[src*="www.afip.gob.ar"]').attr('alt', '{{ "Logo de AFIP" | translate }}');

    {% endif %}


    {#/*============================================================================
      #Empty placeholders
    ==============================================================================*/ #}

    {% set show_help = not has_products %}

    {% if template == 'home' and show_help %}

        {# /* // Home slider */ #}

        var width = window.innerWidth;
        if (width > 767) {
            var slider_empty_autoplay = {delay: 6000,};
        } else {
            var slider_empty_autoplay = false;
        }

        window.homeEmptySlider = {
            getAutoRotation: function() {
                return slider_empty_autoplay;
            },
        };
        createSwiper('.js-home-empty-slider', {
            {% if not params.preview %}
            lazy: true,
            {% endif %}
            loop: true,
            autoplay: slider_empty_autoplay,
            pagination: {
                el: '.js-swiper-empty-home-pagination',
                clickable: true,
                renderBullet: function (index, className) {
                  return '<span class="' + className + '">' + (index + 1) + '</span>';
                },
            },
            navigation: {
                nextEl: '.js-swiper-empty-home-next',
                prevEl: '.js-swiper-empty-home-prev',
            },
            on: {
                init: function () {
                    jQueryNuvem(".js-home-empty-slider").css("visibility", "visible").css("height", "100%");
                },
            },
        });


        {# /* // Banner services slider */ #}
        var width = window.innerWidth;
        if (width < 767) {
            createSwiper('.js-informative-banners', {
                slidesPerView: 1.2,
                watchOverflow: true,
                centerInsufficientSlides: true,
                pagination: {
                    el: '.js-informative-banners-pagination',
                    clickable: true,
                },
                breakpoints: {
                    640: {
                        slidesPerView: 3,
                    }
                }
            });
        }

        {# /* // Brands slider */ #}
        createSwiper('.js-swiper-brands', {
            lazy: true,
            loop: true,
            watchOverflow: true,
            centerInsufficientSlides: true,
            spaceBetween: 30,
            slidesPerView: 1.5,
            navigation: {
                nextEl: '.js-swiper-brands-next',
                prevEl: '.js-swiper-brands-prev',
            },
            breakpoints: {
                640: {
                    slidesPerView: 5,
                }
            }
        });

    {% endif %}

    {% if template == '404' and show_help %}

        {# /* // Product Related */ #}

        {% set columns = settings.grid_columns %}
        createSwiper('.js-swiper-related', {
            lazy: true,
            loop: true,
            watchOverflow: true,
            centerInsufficientSlides: true,
            slidesPerView: 1.5,
            watchSlideProgress: true,
            watchSlidesVisibility: true,
            slideVisibleClass: 'js-swiper-slide-visible',
            navigation: {
                nextEl: '.js-swiper-related-next',
                prevEl: '.js-swiper-related-prev',
            },
            breakpoints: {
                640: {
                    slidesPerView: {% if columns == 2 %}4{% else %}3{% endif %},
                }
            }
        });

        {# /* // Product slider */ #}

        var width = window.innerWidth;
        if (width > 767) {
            var speedVal = 0;
            var loopVal = false;
            var spaceBetweenVal = 0;
            var slidesPerViewVal = 1;
        } else {
            var speedVal = 300;
            var loopVal = true;
            var spaceBetweenVal = 10;
            var slidesPerViewVal = 1.2;
        }

        createSwiper('.js-swiper-product', {
            lazy: true,
            speed: speedVal,
            {% if product.images_count > 1 %}
            loop: loopVal,
            slidesPerView: slidesPerViewVal,
            centeredSlides: true,
            spaceBetween: spaceBetweenVal,
            {% endif %}
            pagination: {
                el: '.js-swiper-product-pagination',
                type: 'fraction',
                clickable: true,
            },
            on: {
                init: function () {
                    jQueryNuvem(".js-product-slider-placeholder").hide();
                    jQueryNuvem(".js-swiper-product").css("visibility", "visible").css("height", "auto");
                },
            },
        });

        {# /* 404 handling to show the example product */ #}

        if ( window.location.pathname === "/product/example/" || window.location.pathname === "/br/product/example/" ) {
            document.title = "{{ "Producto de ejemplo" | translate | escape('js') }}";
            jQueryNuvem("#404").hide();
            jQueryNuvem("#product-example").show();
        } else {
            jQueryNuvem("#product-example").hide();
        }

    {% endif %}
});
