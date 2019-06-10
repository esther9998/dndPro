<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container">
<!--   <div class="calendar light"> -->
    <div class="calendar_plan">
      <div class="cl_plan">
        <div class="cl_title">Today</div>
        <div class="cl_copy">${todayDate}</div>
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
<hr>
		<c:forEach var="daily" items="${data}" varStatus="status">
					<!-- 예약 상태 -->
					<c:if test="${daily.reserv_date  eq  todayDate}">
						<div class="event_item" >
						<div <c:if test="${daily.reserv_status =='0'}"> class="ei_Dot  dot_active" </c:if>
						<c:if test="${daily.reserv_status =='1'}"> class="ei_Dot  dot_attend" </c:if>
						<c:if test="${daily.reserv_status =='2'}"> class="ei_Dot dot_cancel" </c:if>
						 <c:if test="${daily.reserv_status =='3'}"> class="ei_Dot  dot_noShow" </c:if>></div>
						<select style="margin-top: 20px;" name="${daily.reserv_idx}" id="select_status">
							<option value="0" <c:if test="${daily.reserv_status =='0'}"> selected </c:if>>예약 <option>
							<option value="1" <c:if test="${daily.reserv_status =='1'}"> selected </c:if>>완료</option>
							<option value="2"<c:if test="${daily.reserv_status =='2'}"> selected </c:if>>취소</option>
							<option value="3"<c:if test="${daily.reserv_status =='3'}"> selected </c:if>>부재</option>
						</select>
			        <div class="ei_Title">예약자 : ${daily.reserv_name} </div>
			        <div class="ei_Copy">시간 :${daily.reserv_time}  </div>
			        <div class="ei_Copy">인원 :${daily.reserv_persons}</div>
			        <div class="ei_Copy">예약날짜 : ${daily.reserv_date}  등록날짜: ${daily.reserv_register} </div>
			        <div class="ei_Copy">폰번호: ${daily.reserv_phone}  | EMAIL: ${daily.reserv_email}</div>
					</div>
					</c:if>
		      </c:forEach>
      
    </div>
  </div>
  
  <script>

  // 예약상태 변경 
  $("#select_status").change(function () {
    var idx = "";
    var val ="";
    idx = $( this ).attr('name') ;
   	val = $("select[name="+idx+"]").val();
    var data = {val : val, idx: idx }
    changeStatus(data);    	  
  });
  // 예약상태 업데이트  
  function changeStatus(data) {
						$.ajax({
							url: '/updateStatus',
							type: "POST",
							contentType: 'application/json;charset=UTF-8',
							dataType: 'json',
							data:  JSON.stringify(data),
							success :function(rst){
								alert("변경되었습니다.  ");
								location.reload();
								},
							error:function(xhr, status,error){
								alert("다시 시도해주세요.  ");
								location.reload();
							}
						
						});
					};

    </script>

  