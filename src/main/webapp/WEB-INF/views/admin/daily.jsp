<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container">
<!--   <div class="calendar light"> -->
    <div class="calendar_plan">
      <div class="cl_plan">
        <div class="cl_title">Today</div>
        <div class="cl_copy">${date}</div>
        <div class="cl_add">+edit</div>
      </div>
    </div>
    
    <div class="calendar_events">
      <p class="ce_title">Upcoming Events</p>
  ${reservation.reserv_date} //
      ${date} ..
      ${reservation.reserv_date == date}  
      
      <c:forEach var="reservation" items="${reserv}" varStatus="status">
     <%--   <c:if test="${reservation.reserv_date == date}">  --%>
	      
	      <div class="event_item">
	      	<c:if test="${reservation.reserv_status==0}">
	      		<div class="ei_Dot dot_active"></div>
	      	</c:if>
	      	<c:if test="${reservation.reserv_status==1}">
	      		<div class="ei_Dot dot_attend"></div>
	      	</c:if>
	      	<c:if test="${reservation.reserv_status==2}">
	      		<div class="ei_Dot dot_cancel"></div>
	      	</c:if>
	        <div class="ei_Title">${reservation.reserv_date} TIME : ${reservation.reserv_time}</div>
	        <div class="ei_Copy">${reservation.reserv_name} PERSONS :${reservation.reserv_persons}</div>
	        <div class="ei_Copy">PHONE:${reservation.reserv_phone} EMAIL: ${reservation.reserv_email}</div>
	        ${reservation.reserv_date == date} 
	      </div>
        
      </c:forEach>
      
      
    </div>
<!--   </div>  -->
  </div>

  