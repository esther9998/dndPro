<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>관리자 로그인</title>
<script type="text/JavaScript"  src="/js/jquery-3.1.1.min.js"></script>
<script type="text/JavaScript"  src="/js/jquery.history.js"></script>
<script language="javascript" type="text/javascript" src="/js/common.js"></script>  
<link rel="shortcut icon" href="/images/favicon.png" type="image/x-icon">
<link rel="icon" href="/images/favicon.ico" type="image/x-icon">
<style>
.admin_login { width:296px; margin:180px auto; }
.admin_login img { margin:0 0 22px 98px; }
.admin_login .title { color:#0073a4; font-size:25px; font-weight:600; text-indent:21px; margin:0 0 20px 0; }
.admin_login input { width:95.2%; height:44px; padding:0 0 0 10px; margin:10px 0 -1px 0; }
.admin_login_button { margin-top:10px; padding:11px 0 15px 0; border-radius:3px; background-color:#1fc4b1; width:100%; text-align:center; font-weight:600; color:#fff; cursor:pointer; }
.admin_login_button:hover { background-color:#1eaf9a; }
</style>
<script>

$(document).ready(function () {
	$("#login_btn").on('click', function() {
		ADM_loginChk();
	});
	
    $("#id").keydown(function (key) {
        if(key.keyCode == 13) {
        	ADM_loginChk();
        }
    });
    
    $("#pw").keydown(function (key) {
       if(key.keyCode == 13) {
    	   ADM_loginChk();
       }
    });
    
    //알림 허용
    if (Notification.permission !== "granted")
        Notification.requestPermission();
    
    $('#modalLoginForm').on('shown.bs.modal', function () {
    	  $('#id').trigger('focus')
    	})
});
function ADM_loginChk() {

	if ( $("#id").val() == "" ) {
		alert("아이디를 입력해주세요.");	
		return;
	}
	if ( $("#pw").val() == "") {
		alert("비밀번호를 입력해주세요.");
		return;
	}
	var url = "https://concokorea.com/ADM/loginProcess";

	$.ajax({
		beforeSend : function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		type:"POST",
		url:url,
		data: {
			"id":$("#id").val(),
			"pw":$("#pw").val()
		},
		dataType:"json",
		success:function(obj) {  
 			if (obj.ResultCode == "0") {
				location.href="/ADM/admin_board";
 			} else if ( obj.ResultCode == "1") {
				alert(lang["alert"]["22"]);
				$('input[type="password"]').val(""); 
				return;	
 			} else if ( obj.ResultCode == "2") {
 				alert(lang["alert"]["24"]);
 				$('input[type="password"]').val(""); 
 				return;
 			} else if ( obj.ResultCode == "3"){
				alert(lang["alert"]["29"]);
				$('input[type="password"]').val(""); 
				return;
 			} else if ( obj.ResultCode == "4") {
 				alert(lang["alert"]["23"]);
 				location.replace("/");
 			} else {
				alert(lang["alert"]["22"]);
				$('input[type="password"]').val(""); 
				$('input[type="password"]').val(""); 
				return;	
 			}
		},
		error:function(xhr, status, err) {
			if (xhr.status == 403) {
				alert(lang["alert"]["23"]);
				location.replace("/");
			}
		}
	});
}
</script>
</head>
<body>
<div class="admin_login">
	<div class="title"> 관리자 페이지</div>
	<input type="text" id="id">
	<input type="password" id="pw">
	<div class="admin_login_button" id="login_btn">LogIn</div>
</div>
<!-- --------------- -->
<div class="modal fade" id="modalLoginForm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
  aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header text-center">
        <h4 class="modal-title w-100 font-weight-bold">Sign in</h4>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body mx-3">
        <div class="md-form mb-5">
          <i class="fas fa-envelope prefix grey-text"></i>
          <input type="email" id="id" class="form-control validate">
          <label data-error="wrong" data-success="right" for="defaultForm-email">Your email</label>
        </div>

        <div class="md-form mb-4">
          <i class="fas fa-lock prefix grey-text"></i>
          <input type="password" id="pw" class="form-control validate">
          <label data-error="wrong" data-success="right" for="defaultForm-pass">Your password</label>
        </div>

      </div>
      <div class="modal-footer d-flex justify-content-center">
        <button class="btn btn-default" id="login_btn">Login</button>
      </div>
    </div>
  </div>
</div>

<div class="text-center">
  <a href="" class="btn btn-default btn-rounded mb-4" data-toggle="modal" data-target="#modalLoginForm">Launch
    Modal Login Form</a>
</div>


<!-- <input type="text" size="15" id="id"> -->
<!-- <input type="password" size="15" id="pw"> -->
<!-- <input type="button" value="로그인" id="login_btn"> -->
</body>
</html>