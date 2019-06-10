<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
 <div class="bg-light" id="section-menu" data-aos="fade-up">
  	<div class="container">
					<div class="row section-heading justify-content-center site-meun-top">
						<div class="col-md-8 text-center">
							<h2 class="heading mb-3">Schedules</h2>
							<hr>
						</div>
					</div>
 <!--  <div class="nav nav-tabs">
    <button class="active nav-item"><a  data-toggle="tab" href="#day">Today</a></button>
    <button  data-toggle="tab nav-item"><a href="#week">Week</a></button>
    <button  data-toggle="tab nav-item"><a href="#month">Month</a></button>
  </div> -->
  <ul class="nav nav-tabs">
  <li class="nav-item">
    <a class="nav-link active" data-toggle="tab" href="#day">Today</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" data-toggle="tab" href="#week">Week</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" data-toggle="tab" href="#month">Month</a>
  </li>
</ul>

  <div class="tab-content">
    <div id="day" class="tab-pane fade in active">
      <jsp:include page="./daily.jsp"></jsp:include>
    </div>
    <div id="week" class="tab-pane fade">
 		<jsp:include page="./week.jsp"></jsp:include>    
	 </div>
    <div id="month" class="tab-pane fade">
      <jsp:include page="./month.jsp"></jsp:include>
    </div>
  </div>
</div>
</div> 
 
