<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
<!-- 	<link href="https://www.jqueryscript.net/css/jquerysctipttop.css" rel="stylesheet" type="text/css">
	<link rel="stylesheet" type="text/css" href="/resources/pbCalendar/pb.calendar.css">

	<script src="https://code.jquery.com/jquery-1.12.4.min.js" integrity="sha384-nvAa0+6Qg9clwYCGGPpDQLVpLNn0fRaROjHqs13t4Ggj3Ez50XnGQqc/r8MhnRDZ" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.1/moment.min.js" integrity="sha384-F13mJAeqdsVJS5kJv7MZ4PzYmJ+yXXZkt/gEnamJGTXZFzYgAcVtNg5wBDrRgLg9" crossorigin="anonymous"></script>
	<script  src="/resources/pbCalendar/pb.calendar.js"></script>
 -->
	<style type="text/css">
		.pb-calendar .schedule-dot-item.blue{
			background-color: blue;
		}
		.pb-calendar .schedule-dot-item.red{
			background-color: red;
		}
		.pb-calendar .schedule-dot-item.green{
			background-color: green;
		}
	</style>

	<div class="container">
		<h1 class="page-title">캘린더</h1>
		<div id="pb-calendar" class="pb-calendar"></div>
		<div class="copyrights">PBCalendar is freely distributable under the terms of the MIT license.</div>
		<div class="contact-info">Developed by Pnbro. paul@pnbro.com</div>
	</div>


<!-- <script type="text/javascript">
 jQuery(document).ready(function(){

	var current_yyyymm_ = moment().format("YYYYMM");

	$("#pb-calendar").pb_calendar({
		schedule_list : function(callback_, yyyymm_){
			var temp_schedule_list_ = {};

			temp_schedule_list_[current_yyyymm_+"03"] = [
				{'ID' : 1, style : "red"}
			];

			temp_schedule_list_[current_yyyymm_+"10"] = [
				{'ID' : 2, style : "red"},
				{'ID' : 3, style : "blue"},
			];

			temp_schedule_list_[current_yyyymm_+"20"] = [
				{'ID' : 4, style : "red"},
				{'ID' : 5, style : "blue"},
				{'ID' : 6, style : "green"},
			];
			callback_(temp_schedule_list_);
		},
		schedule_dot_item_render : function(dot_item_el_, schedule_data_){
			dot_item_el_.addClass(schedule_data_['style'], true);
			return dot_item_el_;
		}
	});
</script>  -->

<!-- <script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-36251023-1']);
  _gaq.push(['_setDomainName', 'jqueryscript.net']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script> -->
