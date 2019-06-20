<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<meta name="viewport" content="initial-scale=1.0">
    <meta charset="utf-8">
    <script src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>
<div class="section bg-light" data-aos="fade-up"
	id="section-contact  site-meun-top">
	<div class="container">
		<div class="row section-heading justify-content-center site-meun-top">
			<div class="col-md-8 text-center">
				<h2 class="heading mb-3">Contacts</h2>
				<hr>
			</div>
		</div>
		<div class="row justify-content-center">
			<div class="col-md-10 p-5 form-wrap">
				<div class=" animate-box">
					<div class="col-md-4 col-md-push-1 animate-box" >
						<div class="fh5co-contact-info">
							<ul>
								<li class="address">198 West 21th Street, <br> Suite
									721 New York NY 10016
								</li>
								<li class="phone"><a href="tel://1234567920">+ 1 235 235598</a></li>
								<li class="email"><a href="mailto:info@yoursite.com">info@yoursite.com</a></li>
								<li class="url"><a href="http://gettemplates.co">gettemplates.co</a></li>
							</ul>
						</div>
					</div>
					<div class="col-md-5 animate-box" style="display: inline;">
						<div onload="initMap()">
							<div id="map_canvas" style="height: 300px;"></div>
							<!-- 	<img alt="mapSample" src="/resources/images/mapSample.jpg" > -->
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- 	</div> -->
			<!-- .section -->
			
		<!-- 구글맵  -->
 <script>
function initMap() {
    var uluru = {lat: 1.289440, lng: 103.849983};
    var map = new google.maps.Map(document.getElementById('map_canvas'), {
      zoom: 4,
      center: uluru
    });
    var marker = new google.maps.Marker({
      position: uluru,
      map: map
    });
  }
    </script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyC_cZiy74pIP33wkvRjRCt2cOlSQHGrp1s&callback=initMap"
        async defer> 
    </script>