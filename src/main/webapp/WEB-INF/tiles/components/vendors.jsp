<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<script src="/resources/js/jquery-3.2.1.min.js"></script>
		<script src="/resources/js/jquery-migrate-3.0.1.min.js"></script>
		<script src="/resources/js/popper.min.js"></script>
		<script src="/resources/js/bootstrap.min.js"></script>
		<script src="/resources/js/owl.carousel.min.js"></script>
		<script src="/resources/js/jquery.waypoints.min.js"></script>

		<script src="/resources/js/bootstrap-datepicker.js"></script>
		<script src="/resources/js/jquery.timepicker.min.js"></script>
		<script src="/resources/js/jquery.stellar.min.js"></script>

		<script src="/resources/js/jquery.easing.1.3.js"></script>
		<script src="/resources/js/jquery.isotope.js"></script>

		<script src="/resources/js/aos.js"></script>


		<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBVWaKrjvy3MaE7SQ74_uJiULgl1JY0H2s&sensor=false"></script>

		<script src="/resources/js/main.js"></script>
		<script src="/resources/js/nivo-lightbox.js"></script>
		<script src="/resources/js/slideImg.js"></script>
		<script>
		function main() {

			(function () {
			   'use strict';

			  	// Portfolio isotope filter
			    $(window).load(function() {
			        var $container = $('.portfolio-items');
			        $container.isotope({
			            filter: '*',
			            animationOptions: {
			                duration: 750,
			                easing: 'linear',
			                queue: false
			            }
			        });
			        $('.cat a').click(function() {
			            $('.cat .active').removeClass('active');
			            $(this).addClass('active');
			            var selector = $(this).attr('data-filter');
			            $container.isotope({
			                filter: selector,
			                animationOptions: {
			                    duration: 750,
			                    easing: 'linear',
			                    queue: false
			                }
			            });
			            return false;
			        });

			    });
				

			    // Nivo Lightbox 
			    $('.portfolio-item a').nivoLightbox({
			            effect: 'slideDown',  
			            keyboardNav: true,                            
			        });
			}());

			}
			main();
		</script>
