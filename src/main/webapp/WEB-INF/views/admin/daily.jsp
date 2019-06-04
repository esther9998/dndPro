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
      <c:forEach var="oneAppo" items="${reserv}" varStatus="status">
<%-- 	<c:if test="${'reserv_date' eq 'date'} "> --%>
	      <div class="event_item">
	      	<c:if test="${oneAppo.reserv_status==0}">
	      		<div class="ei_Dot dot_active"></div>
	      	</c:if>
	      	<c:if test="${oneAppo.reserv_status==1}">
	      		<div class="ei_Dot dot_attend"></div>
	      	</c:if>
	      	<c:if test="${oneAppo.reserv_status==2}">
	      		<div class="ei_Dot dot_cancel"></div>
	      	</c:if>
	        <div class="ei_Title">${status.count}.  ${oneAppo.reserv_time}   PERSONS :${oneAppo.reserv_persons}</div>
	        <div class="ei_Copy"> (${oneAppo.reserv_date} ) </div>
	        <div class="ei_Copy">NAME: ${oneAppo.reserv_name}  (${oneAppo.reserv_phone} ) </div>
	        <div class="ei_Copy">EMAIL: ${oneAppo.reserv_email}</div>
	        ${date} 
	        ${oneAppo.reserv_date} 
	        ${oneAppo.reserv_date eq date} 
	      </div>
<%-- 	       </c:if>    --%>
      </c:forEach>
      
      
    </div>
<!--   </div>  -->
  </div>

  