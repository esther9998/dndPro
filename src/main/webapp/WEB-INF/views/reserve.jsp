<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    	<script src="/resources/js/jquery-3.2.1.min.js"></script>
<div class="section bg-light" data-aos="fade-up" id="section-reservation">
          <div class="container">
            <div class="row section-heading justify-content-center site-meun-top">
              <div class="col-md-8 text-center">
                <h2 class="heading mb-3">Reservation</h2><hr>
              </div>
            </div>
            <div class="row justify-content-center">
              <div class="col-md-10 p-5 form-wrap">
                <form  name="frm" >
                  <div class="row mb-4">
                    <div class="form-group col-md-4">
                      <label for="name" class="label">Name</label>
                      <div class="form-field-icon-wrap">
                        <span class="icon ion-android-person"></span>
                        <input type="text" class="form-control" id="name">
                      </div>
                    </div>
                    <div class="form-group col-md-4">
                      <label for="email" class="label">Email</label>
                      <div class="form-field-icon-wrap">
                        <span class="icon ion-email"></span>
                        <input type="email" class="form-control" id="email">
                      </div>
                    </div>
                    <div class="form-group col-md-4">
                      <label for="phone" class="label">Phone</label>
                      <div class="form-field-icon-wrap">
                        <span class="icon ion-android-call"></span>
                        <input type="text" class="form-control" id="phone">
                      </div>
                    </div>

                    <div class="form-group col-md-4">
                      <label for="persons" class="label">Number of Persons</label>
                      <div class="form-field-icon-wrap">
                        <span class="icon ion-android-arrow-dropdown"></span>
                        <select name="persons" id="persons" class="form-control">
                          <option value="1">1 person</option>
                          <option value="2">2 persons</option>
                          <option value="3">3 persons</option>
                          <option value="4">4 persons</option>
                          <option value="5">5 persons</option>
                          <option value="6">6 persons</option>
                          <option value="10">10+ persons</option>
                        </select>
                      </div>
                    </div>
                    <div class="form-group col-md-4">
                      <label for="date" class="label">Date</label>
                      <div class="form-field-icon-wrap">
                        <span class="icon ion-calendar"></span>
                        <input type="text" class="form-control" id="date">
                      </div>
                    </div>
                    <div class="form-group col-md-4">
                      <label for="time" class="label">Time</label>
                      <div class="form-field-icon-wrap">
                        <span class="icon ion-android-time"></span>
                        <input type="text" class="form-control" id="time">
                      </div>
                    </div>
                  </div>
                  <div class="row justify-content-center">
                    <div class="col-md-4">
                      <input type="button"  class="btn btn-primary btn-outline-primary btn-block" value="Reserve Now" onclick="sendForm()">
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div> <!-- .section -->
			
			<script>
			/* ********************************************************* */
			// 페이지 초기 세팅   
			/* ********************************************************* */
			 $(document).ready( function() {
				// 타임피커 초기 세팅
				 $('#time').timepicker({
					    timeFormat: 'h:i a',
					    interval: 30,
					    minTime: '11',
					    maxTime: '9:00 pm',
					    defaultTime: '11',
					    startTime: '10:00 am',
					    dynamic: false,
					    dropdown: true,
					    scrollbar: true
					});
				 
			});
			
			/* ********************************************************* */
			// 유효성 검사 
			/* ********************************************************* */
			//이름  
			function validate(){			
			    if( $("#name").val().trim()== "" ){
			     alert( "Please provide your name!" );
			     $("#name").focus() ;
			     return false;
			   }
			    //이메일  
			    if( $("#email").val().trim()== "" ){ 
				     alert( "Please provide your email!" );
				     $("#email").focus() ;
				     return false;
				   }
				//전화번호  
			    if( $("#phone").val().trim()== "" || $("#phone").val().trim().length != 11 ){
				     alert( "Please provide your contact numbers!" );
				     $("#phone").focus() ;
				     return false;
				   }else if(isNaN($("#phone").val())){
				     alert( "Please provide only numbers" );
				     $("#phone").focus() ;
				   }
			/* ********************************************************* */
			  //오늘날짜 가져오기 
			/* ********************************************************* */
			    	var today = new Date();
			    	var year = today.getFullYear();
			    	var month = today.getMonth()+1;
			    	var day = today.getDate();
			    	var hour = today.getHours();
			    	var dateNow = month+"/"+day+"/"+year;
			    	var hourNow = today.getHours();
			    	console.log(dateNow);
			    	console.log(hourNow);
			/* ********************************************************* */
			   //날짜 유효성 검사 
			/* ********************************************************* */
			    if( $("#date").val().trim()== ""||$("#date").val().length < 8 || $("#date").val().length > 9){
			    	alert( "Please choose a day for reservation") ;
			  		$("#date").datepicker("setDate", new Date);
			    	$("#date").focus() ;
				     return false;
				   }
			/* ********************************************************* */
				//오늘기준 이전날짜 체크
			/* ********************************************************* */
			    var dayCheckArr = $("#date").val().split("/");
			    if(dayCheckArr[2]<year){
						alert("The date is not validate.");
						$("#date").focus() ;
				     return false;
			    }else if(dayCheckArr[1]<day){
						alert("The date is not validate.");
						$("#date").focus() ;
				     return false;
			    }else if(dayCheckArr[0]<month){
						alert("The date is not validate.");
						$("#date").focus() ;
				     return false;
			    }
			/* ********************************************************* */
				// 시간 유효성
			/* ********************************************************* */
			    if( $("#time").val().trim()== "" ){
			    	alert( "Please choose a time for reservation" );
				     $("#time").focus() ;
				     return false;
				   }
			
			   	var getTodayHour = new Date().getHours();
				var editTime =0;
				if($("#time").val().includes("pm")){
					 var temp = $("#time").val().split(":") ;
					 if (temp[0]=="12") {
						editTime =  Number(temp[0]);
					}else{
						editTime = 12 + Number(temp[0]);
					}
				}
				    
		 // 오늘날짜에 이전시간을 입력한경우.  
		    if(dateNow == $("#date").val() ){
		    	if (editTime <= hourNow) {
						 alert("Please set a valid time.");
						 $('#time').val("");
						 $('#time').focus();
						 return false;
				}
		    }
						 
			   return true ;
			}
//ajax 데이터 전
function sendForm() {
	//유효성 검사 
				var validateCheked = validate();
				if(validateCheked){				
				var data ={
						 name : $("#name").val(),
						 phone : $("#phone").val(),
						 email : $("#email").val(),
						 persons : $("#persons").val(),
						 date : $("#date").val(),
						 time : $("#time").val()
				}
					$.ajax({
						url: '/reservedInfo',
						type: "POST",
						contentType: 'application/json;charset=UTF-8',
						dataType: 'json',
						data:  JSON.stringify(data),
						success :function(data){
							if(data == 1){
							alert( "Thank you for your booking!"
									+ "\n\n We send you the confirmation email. " 
									+ "\n\n To cancel or change your schedule, check the email..");
							location.reload();
							}else if(data == 0){
							alert(data+"Email address is not validate. ");
							location.reload();
							}else{
							alert(data+"There is error occured. Please try again. ");
							location.reload();
							}
							},
						error:function(xhr, status,error){
							alert("There is an error occured. Please fill the form again. ");
						alert(xhr+"+++++++++" +status+"////////////"+error);
							location.reload();
						}
					
					});
					}else{
						console.log("form is not complated");
					};
				};
					
			</script>