<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.revise_notice_wrap {
	background-color:#ffffff;
	width:800px;
	height:700px;
	font-size:13px;
}
.revise_notice_wrap tr {
	height:35px;
}
.notice_revise_btn {
		display:inline-block;
		background-color: #bbbbbb;
	    width: 70px;
	    height: 30px;
	    cursor: pointer;
	    line-height: 30px;
	    text-align: center;
	    color: #ffffff;
	    font-size: 13px;
	    letter-spacing: 1px;
	    border: 1px solid #d7d7d7;
	    border-radius: 3px;
	    font-weight: 600;
	}
.notice_revise_close_btn {
	display:inline-block;
	background-color: #bbbbbb;
    width: 70px;
    height: 30px;
    cursor: pointer;
    line-height: 30px;
    text-align: center;
    color: #ffffff;
    font-size: 13px;
    letter-spacing: 1px;
    border: 1px solid #d7d7d7;
    border-radius: 3px;
    font-weight: 600;
	margin-left:15px;
}
.revise_notice_tab {
	width:60px;
}
.notice_revise_password {
	height:20px;
}
.revise_notice_tab {
	width:60px;
}
.notice_revise_password {
	height:20px;
}
</style>
<script>
console.log("##########")
console.log('${NOTICE_CONTENT}')
var notice_content = '${NOTICE_CONTENT}';
var notice_type = "${NOTICE_TYPE}";
var notice_num = "${NOTICE_NUM}";
var notice_use = "${NOTICE_USE}";
$(document).ready(function() {
	//팝업 공지일때,
	if(notice_type == "03") {
		$("#notice_date").show();
	} else {
		$("#notice_date").hide();
	}
	
	$("#revise_notice_use").val(notice_use);
	$("#revise_notice_type").val(notice_type);
});
$(function(){
    //전역변수선언
    var editor_object = [];
     
    nhn.husky.EZCreator.createInIFrame({ //iframe을 만든다.
        oAppRef: editor_object,
        elPlaceHolder: "revise_notice_content", //textarea id입력
        sSkinURI: "/smarteditor/SmartEditor2Skin.html", //에디터스킨 html파일 경로를 지정한다.
        htParams : {
            // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
            bUseToolbar : true,             
            // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
            bUseVerticalResizer : true,     
            // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
            bUseModeChanger : true, 
        },
        fOnAppLoad : function() {
        	editor_object.getById["revise_notice_content"].exec("PASTE_HTML", [notice_content]);
        } 
    });
     
    //전송버튼 클릭이벤트
    $("#update_notice_btn").click(function(){
        //id가 smarteditor인 textarea에 에디터에서 대입
        editor_object.getById["revise_notice_content"].exec("UPDATE_CONTENTS_FIELD", []);
        
        // 이부분에 에디터 validation 검증
        var revise_notice_content = editor_object.getById['revise_notice_content'].getIR();
        
//         alert(revise_notice_content);

		var revise_notice_type = "";
        if ($("#revise_notice_type").val() == "01") {
        	revise_notice_type = "공지";
        } else if ( $("#revise_notice_type").val() == "02") {
        	revise_notice_type = "긴급";
        } else if ( $("#revise_notice_type").val() == "03") {
        	revise_notice_type = "팝업";
        }
        
        if ( notice_content == "<p><br></p>") {
        	alert("내용을 입력해주세요.");
        	return;
        }
        if ( $("#admin_password").val() == "") {
        	alert("관리자 비밀번호를 입력해주세요.");
        	return;
        }
        
        var confirm_rst = confirm("분류 : " + revise_notice_type + "\n사용여부 : " + $("#revise_notice_use").val() + "\n\n공지사항을 등록을 실행하시겠습니까?");
	     		
  		if ( confirm_rst == false) {
   			return;
   		} else { 
	        
	        //팝업일 때
	        if($("#revise_notice_type").val() == "03") {
				//ajax
		        var url="/ADM/update_notice_process";
			   	$.ajax({
			   		type:"POST",
			   		url:url,
			   		async:false,
			   		dataType : 'json',
			   		data: {
			   			"notice_type":$("#revise_notice_type").val(),
			   			"start_date":$("#start_date").val(),
			   			"end_date":$("#end_date").val(),
			   			"notice_title":$("#revise_notice_title").val(),
			   			"notice_content":revise_notice_content,
			   			"notice_num":notice_num,
			   			"notice_use":$("#revise_notice_use").val(),
			   			"admin_psasword":$("#admin_password").val()
			   		},
			   		success:function(obj) { //가져오는 값(변수)
		    			if (obj.ResultCode == "0") {
		    				alert(obj.Data);
		    				$("#popup_mask").hide();
		    				$("#balance_form").hide();
		    				$("#insert_notice_wrap").empty();
		    			} else if (obj.ResultCode == "1") {
		    				alert(obj.Data);
		    				adminPageload('/ADM/loginPage');
		    			} else {
		    				alert(obj.Data);
		    				return;
		    			}
			   		},
			   		error:function(e) { //500 ERR
			   			//서버내부오류
			   			alert("잠시 후 시도해주세요.");
			   		}
			   	});
	        } else {
	        	//ajax
		        var url="/ADM/update_notice_process";
			   	$.ajax({
			   		type:"POST",
			   		url:url,
			   		async:false,
			   		dataType : 'json',
			   		data: {
			   			"notice_type":$("#revise_notice_type").val(),
			   			"start_date":null,
			   			"end_date":null,
			   			"notice_title":$("#revise_notice_title").val(),
			   			"notice_content":revise_notice_content,
			   			"notice_num":notice_num,
			   			"notice_use":$("#revise_notice_use").val(),
			   			"admin_password":$("#admin_password").val()
			   		},
			   		success:function(obj) { //가져오는 값(변수)
		    			if (obj.ResultCode == "0") {
		    				alert(obj.Data);
		    				$("#popup_mask").hide();
		    				$("#balance_form").hide();
		    				$("#revise_notice_wrap").empty();
		    			} else if (obj.ResultCode == "1") {
		    				alert(obj.Data);
		    				adminPageload('/ADM/loginPage');
		    			} else {
		    				alert(obj.Data);
		    				return;
		    			}
			   		},
			   		error:function(e) { //500 ERR
			   			//서버내부오류
			   			alert("잠시 후 시도해주세요.");
			   		}
			   	});
	        }
   		}
    });
});

  
$(function() {
    $( "#start_date, #end_date" ).datepicker({
    	   dateFormat: 'yy-mm-dd',
    	    prevText: '이전 달',
    	    nextText: '다음 달',
    	    monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
    	    monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
    	    dayNames: ['일', '월', '화', '수', '목', '금', '토'],
    	    dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
    	    dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
    	    showMonthAfterYear: true,
    	    yearSuffix: '년',
	        showButtonPanel: true, 
	        currentText: '오늘 날짜', 
	        closeText: '닫기', 
    });
});
</script>
</head>
<body>
<div class="revise_notice_wrap" id="revise_notice_wrap">
	<div style="position:relative; padding-top:25px; padding-left:45px;">
		<table style="width:100%;">
			<tr>
				<td>번호</td>
				<td><input type="text" id="revise_notice_num" disabled value="${NOTICE_NUM}">
			</tr>
			<tr>
				<td>분류</td>
				<td>
					<select style="width:80px; height:25px;" id="revise_notice_type">
					  <option value="01">공지</option>
					  <option value="02">긴급</option>
					  <option value="03">팝업</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>사용여부</td>
				<td>
					<select style="width:80px; height:25px;" id="revise_notice_use">
						<option value="N">N</option>
						<option value="Y">Y</option>	
					</select>
				</td>
			</tr>
			<tr id="notice_date" style="display:none;">
				<td>기간</td>
				<td><input type="text" id="start_date" style="width:80px; text-align:center;" value="${START_DATE}"> ~ <input type="text" id="end_date" style="width:80px; text-align:center;" value="${END_DATE}"></td>
			</tr>
			<tr>
				<td>제목</td>
				<td><input type="text"  style="width:350px; height:23px; line-heght:23px;" id="revise_notice_title" value="${NOTICE_TITLE}"></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><label style="color:#f74040; font-weight:600;">※권장사항 : font-size : 11pt</label>
			</tr>
			<tr>
				<td colspan="2"><textarea name="revise_notice_content" id="revise_notice_content" rows="10" cols="100" style="width:700px; height:320px;" id="revise_notice_value"></textarea>
			</tr>
			<tr>
				<td class="revise_notice_tab" >비밀번호 :</td>
				<td><input type="password" size=21; id="admin_password"></td>
			</tr>
		</table>
	</div>
	<div style="margin-top:10px; text-align:center;;">
		<div id="update_notice_btn" class="notice_revise_btn">수정</div>
		<div class="notice_revise_close_btn" id="notice_revise_close_btn">취소</div>
	</div>
</div>
</body>
</html>