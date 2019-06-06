<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container">
<!--   <div class="calendar light"> -->
    <div class="calendar_plan">
      <div class="cl_plan">
        <div class="cl_title">Today</div>
        <div class="cl_copy">${localDate}</div>
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
		<c:forEach var="oneAppo" items="${daily}" varStatus="status">
					<!-- 예약 상태 -->
					<c:if test="${oneAppo.reserv_status==0}">
						<div class="event_item" >
						<div class="ei_Dot dot_active"></div>
						<select style="margin-top: 20px;" name="${oneAppo.reserv_idx}" id="select_status">
							<option value="0" selected="selected">예약 <option>
							<option value="1" >완료</option>
							<option value="2">취소</option>
							<option value="3">부재</option>
						</select>
			        <div class="ei_Title">${status.count}.  ${oneAppo.reserv_time}   PERSONS :${oneAppo.reserv_persons}</div>
			        <div class="ei_Copy"> (${oneAppo.reserv_date} ) </div>
			        <div class="ei_Copy">NAME: ${oneAppo.reserv_name}  (${oneAppo.reserv_phone} ) </div>
			        <div class="ei_Copy">EMAIL: ${oneAppo.reserv_email}</div>
					</div>
					</c:if>
					
					<!--완료  상태 -->
					<c:if test="${oneAppo.reserv_status==1}">
					<div class="event_item" >
						<div class="ei_Dot dot_attend"></div>
						<select style="margin-top: 20px;" name="${oneAppo.reserv_idx}" id="select_status">
							<option value="0">예약<option>
							<option value="1" selected="selected">완료</option>
							<option value="2">취소</option>
							<option value="3">부재</option>
						</select>
			        <div class="ei_Title">${status.count}.  ${oneAppo.reserv_time}   PERSONS :${oneAppo.reserv_persons}</div>
			        <div class="ei_Copy"> (${oneAppo.reserv_date} ) </div>
			        <div class="ei_Copy">NAME: ${oneAppo.reserv_name}  (${oneAppo.reserv_phone} ) </div>
			        <div class="ei_Copy">EMAIL: ${oneAppo.reserv_email}</div>
					</div>
					</c:if>
					<!--취소  상태 -->
					<c:if test="${oneAppo.reserv_status==2}">
			        <div class="event_item" >
					<div class="ei_Dot dot_cancel"></div>
						<select style="margin-top: 20px;" name="${oneAppo.reserv_idx}" id="select_status">
							<option value="0">예약 <option>
							<option value="1">완료</option>
							<option value="2" selected="selected">취소</option>
							<option value="3">부재</option>
						</select>
			        <div class="ei_Title">${status.count}.  ${oneAppo.reserv_time}   PERSONS :${oneAppo.reserv_persons}</div>
			        <div class="ei_Copy"> (${oneAppo.reserv_date} ) </div>
			        <div class="ei_Copy">NAME: ${oneAppo.reserv_name}  (${oneAppo.reserv_phone} ) </div>
			        <div class="ei_Copy">EMAIL: ${oneAppo.reserv_email}</div>
					</div>
					</c:if>
					<!--부재   상태 -->
					<c:if test="${oneAppo.reserv_status==3}">
					 <div class="event_item" >
					<div class="ei_Dot dot_noShow"></div>
						<select style="margin-top: 20px;"  name="${oneAppo.reserv_idx}" id="select_status">
							<option value="0">예약<option>
							<option value="1">  완료</option>
							<option value="2">취소</option>
							<option value="3" selected="selected">부재</option>
						</select>
			        <div class="ei_Title">${status.count}.  ${oneAppo.reserv_time}   PERSONS :${oneAppo.reserv_persons}</div>
			        <div class="ei_Copy"> (${oneAppo.reserv_date} ) </div>
			        <div class="ei_Copy">NAME: ${oneAppo.reserv_name}  (${oneAppo.reserv_phone} ) </div>
			        <div class="ei_Copy">EMAIL: ${oneAppo.reserv_email}</div>
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
    alert(val+"ssssss"+ idx);
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
								alert("변경되었습니다.  "+rst);
								location.reload();
								},
							error:function(xhr, status,error){
								alert("다시 시도해주세요.  ");
								location.reload();
							}
						
						});
					};

    </script>

  