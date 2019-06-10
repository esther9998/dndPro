<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>관리자 로그인</title>
<!-- <script type="text/JavaScript"  src="/js/jquery-3.1.1.min.js"></script>
<script type="text/JavaScript"  src="/js/jquery.history.js"></script>
<script language="javascript" type="text/javascript" src="/js/common.js"></script>   -->
<link rel="stylesheet"href="/resources/fonts/fontawesome/css/font-awesome.min.css">

<style>
.admin_login { width:296px; margin:180px auto; }
.admin_login img { margin:0 0 22px 98px; }
.admin_login .title { color:#0073a4; font-size:25px; font-weight:600; text-indent:21px; margin:0 0 20px 0; }
.admin_login input { width:95.2%; height:44px; padding:0 0 0 10px; margin:10px 0 -1px 0; }
.admin_login_button { margin-top:10px; padding:11px 0 15px 0; border-radius:3px; background-color:#1fc4b1; width:100%; text-align:center; font-weight:600; color:#fff; cursor:pointer; }
.admin_login_button:hover { background-color:#1eaf9a; }
</style>

</head>
<body>
<div class="section bg-light" data-aos="fade-up" id="section-reservation">
          <div class="container">
            <div class="row section-heading justify-content-center site-meun-top">
              <div class="col-md-8 text-center">
                <h2 class="heading mb-3">관리자 로그인</h2>
		            <hr>
              </div>
            </div>
<!-- --------------- -->
  <div class="modal-dialog" role="document" >
    <div class="modal-content"> 
      <div class="modal-header text-center">
        <h4 class="modal-title w-100 font-weight-bold">Sign in</h4>
        <!-- <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>     x 버튼  -->
      </div>
      <div class="modal-body mx-3">
        <div class="md-form mb-5">
          <i class="fa fa-lg fa-envelope  prefix grey-text"></i>
          <label data-error="wrong" data-success="right" for="defaultForm-email">Your id</label>
          <input type="email" id="admin_id" class="form-control validate">
        </div>

        <div class="md-form mb-4">
          <i class="fa fa-2x fa-lock prefix grey-text"></i>
          <label data-error="wrong" data-success="right" for="defaultForm-pass">Your password</label>
          <input type="password" id="admin_pw" class="form-control validate">
        </div>

      </div>
      <div class="modal-footer d-flex justify-content-center">
        <button class="btn btn-default" id="login_btn">Login</button>
      </div>
    </div>
  </div>
  </div>
  </div>
<script>

$(document).ready(function () {
	$("#login_btn").on('click', function() {
		admin_loginChk();
	});
	
    $("#admin_id").keydown(function (key) {
        if(key.keyCode == 13) {
        	admin_loginChk();
        }
    });
    
    $("#admin_pw").keydown(function (key) {
       if(key.keyCode == 13) {
    	   admin_loginChk();
       }
    });
    
   /*  //알림 허용
    if (Notification.permission !== "granted")
        Notification.requestPermission();
    
    $('#modalLoginForm').on('shown.bs.modal', function () {
    	  $('#id').trigger('focus')
    	}) */
});
function admin_loginChk() {

	if ( $("#admin_id").val() == "" ) {
		alert("아이디를 입력해주세요.");	
		return;
	}
	if ( $("#admin_pw").val() == "") {
		alert("비밀번호를 입력해주세요.");
		return;
	}
	var data ={
			id:$("#admin_id").val(),
			pw:$("#admin_pw").val()
	}

	$.ajax({
		/* beforeSend : function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		}, */
		type:"POST",
		url:'/admin_chk',
		data:data,
		dataType:"json",
		async: false, 
		success:function(rst) {    
			 location.href = "/calendar";
		},
		error:function() {
				alert("아이디와 비번이 일치하지 않습니다.  재시도해주세요.");
			$("#admin_id").focus();
		}
	});
}
</script>
</body>
</html>