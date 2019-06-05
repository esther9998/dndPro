<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
   
<div class="container">

    <div class="calendar_plan">
      <div class="cl_plan">
        <div class="cl_title">Today</div>
        <div class="cl_copy">${weekEndDate} ~ ${weekStartDate}</div>
        <div class="cl_add">+edit</div>
      </div>
    </div>
    <div class="calendar_events">
      <p class="ce_title">Upcoming Events</p>
      
		      <c:forEach var="week" items="${week}" varStatus="status">
			      <div class="event_item">
			      	<c:if test="${week.reserv_status==0}">
			      		<div class="ei_Dot dot_active"></div>
			      	</c:if>
			      	<c:if test="${week.reserv_status==1}">
			      		<div class="ei_Dot dot_attend"></div>
			      	</c:if>
			      	<c:if test="${week.reserv_status==2}">
			      		<div class="ei_Dot dot_cancel"></div>
			      	</c:if>
			        <div class="ei_Title">${status.count}.  ${week.reserv_time}   PERSONS :${week.reserv_persons}</div>
			        <div class="ei_Copy"> (${week.reserv_date} ) </div>
			        <div class="ei_Copy">NAME: ${week.reserv_name}  (${week.reserv_phone} ) </div>
			        <div class="ei_Copy">EMAIL: ${week.reserv_email}</div>
			      </div>
		      </c:forEach>
      
    </div>
  </div>
