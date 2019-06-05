<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container">
<!--   <div class="calendar light"> -->
    <div class="calendar_plan">
      <div class="cl_plan">
        <div class="cl_title">Today</div>
        <div class="cl_copy">${localDate}</div>
        <div class="cl_add">+edit</div>
      </div>
    </div>
    <div class="calendar_events">
      <p class="ce_title">Upcoming Events</p>
      <p class="ce_title">하루 예약 일정을 보여줍니다.<br>
      <button class="btn"> +edit</button>버튼을 눌러 예약 상태를 변경할수 있습니다.</p>
      <button class="btn btn-info"><div class="ei_Dot dot_active"></div>  예약</button>
      <button class="btn btn-info"><div class="ei_Dot dot_attend"></div>  완료</button>
      <button class="btn btn-info"><div class="ei_Dot dot_cancel"></div>  취소</button>
     <button class="btn btn-info"><div class="ei_Dot dot_noShow"></div>  부재</button>
      
		      <c:forEach var="oneAppo" items="${daily}" varStatus="status">
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
			      	<c:if test="${oneAppo.reserv_status==3}">
			      		<div class="ei_Dot dot_noShow"></div>
			      	</c:if>
			        <div class="ei_Title">${status.count}.  ${oneAppo.reserv_time}   PERSONS :${oneAppo.reserv_persons}</div>
			        <div class="ei_Copy"> (${oneAppo.reserv_date} ) </div>
			        <div class="ei_Copy">NAME: ${oneAppo.reserv_name}  (${oneAppo.reserv_phone} ) </div>
			        <div class="ei_Copy">EMAIL: ${oneAppo.reserv_email}</div>
			      </div>
		      </c:forEach>
      
    </div>
  </div>

  