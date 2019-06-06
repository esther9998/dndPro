<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
   <%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<div class="container">

    <div class="calendar_plan">
      <div class="cl_plan">
        <div class="cl_title">Today</div>
        <div class="cl_copy">${weekStartDate} ~ ${weekEndDate}</div>
      </div>
    </div>
    <div class="calendar_events">
      <p class="ce_title">Upcoming Events</p>
      <p class="ce_title">일주일 예약 일정을 보여줍니다.<br>
      <button class="btn btn-info"><div class="ei_Dot dot_active"></div>  예약</button>
      <button class="btn btn-info"><div class="ei_Dot dot_attend"></div>  완료</button>
      <button class="btn btn-info"><div class="ei_Dot dot_cancel"></div>  취소</button>
     <button class="btn btn-info"><div class="ei_Dot dot_noShow"></div>  부재</button>


		<c:forEach var="sevenDays" items="${sevenDays}" varStatus="status">
			<c:set var="sum" value="0" />
			<c:set var="appo" value="0" />
			<c:set var="complete" value="0" />
			<c:set var="cancel" value="0" />
			<c:set var="noshow" value="0" />
			
			<c:forEach var="week" items="${week}" varStatus="status">
				<c:if test="${sevenDays == week.reserv_date}">
					<c:set var="sum" value="${sum + 1}" />
					<c:if test="${week.reserv_status == 0 }">
						<c:set var="appo" value="${appo + 1}" />
					</c:if>
					<c:if test="${week.reserv_status == 1 }">
						<c:set var="complete" value="${complete + 1}" />
					</c:if>
					<c:if test="${week.reserv_status == 2 }">
						<c:set var="cancel" value="${cancel + 1}" />
					</c:if>
					<c:if test="${week.reserv_status == 3 }">
						<c:set var="noshow" value="${noshow + 1}" />
					</c:if>				
				</c:if>
			</c:forEach>
			<div class="event_item" <c:if test="${localDate== sevenDays}"> style="background: lightblue;" </c:if> >
				${sevenDays} 총예약 :
				<c:out value="${sum}" /> 건 <br>
				<div class="ei_Dot dot_active"></div>  예약 :  <c:out value="${appo}" />팀
				<br>
				<div class="ei_Dot dot_attend"></div>  완료 :  <c:out value="${complete}" />팀
				<br>
				<div class="ei_Dot dot_cancel"></div>  취소 :  <c:out value="${cancel}" />팀
				<br>
				<div class="ei_Dot dot_noShow"></div>  부재 :  <c:out value="${noshow}" />팀
				<br>
			</div>
				<hr>
		</c:forEach>
    </div>
  </div>