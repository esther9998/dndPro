<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    	<script src="/resources/js/jquery-3.2.1.min.js"></script>
<div class="section bg-light" data-aos="fade-up" id="section-reservation">
          <div class="container">
            <div class="row section-heading justify-content-center">
              <div class="col-md-8 text-center">
                <h2 class="heading mb-3">Reservation</h2>
              </div>
            </div>
            <div class="row justify-content-center">
              <div class="col-md-10 p-5 form-wrap">
                <form  name="frm" onsubmit="return sendForm();">
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
                      <input type="submit"  class="btn btn-primary btn-outline-primary btn-block" value="Reserve Now">
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div> <!-- .section -->
			
			<script>
			// 유효성검
			function validate(){
			    if( $("#name").val().trim()== "" ){
			     alert( "Please provide your name!" );
			     $("#name").focus() ;
			     return null;
			   }
			    if( $("#email").val().trim()== "" ){
				     alert( "Please provide your email!" );
				     $("#email").focus() ;
				     return null;
				   }
			    if( $("#phone").val().trim()== "" || $("#phone").val().trim().length != 11 ){
				     alert( "Please provide your contact numbers!" );
				     $("#phone").focus() ;
				     return null;
				   }else if(isNaN($("#phone").val())){
				     alert( "Please provide only numbers" );
				     $("#phone").focus() ;
				   }
			  //오늘날짜 가져오기 
			    	var today = new Date();
			    	var year = today.getFullYear();
			    	var month = today.getMonth()+1;
			    	var day = today.getDate();
			   //날짜 유효성 검사 
			    if( $("#date").val().trim()== "" ||$("#date").val().length < 9 || $("#date").val().length > 10 ){
			    	alert( "Please choose a day for reservation" );
			    	//TO DO :달력은 리셋이 안되고 있음.
			    	$("#date").val(month+"/"+day+"/"+year);
			    	
			    	$("#date").focus() ;
				     return null;
				   }
				//오늘기준 이전날짜 체크
			    var dayCheckArr = $("#date").val().split("/");
			    if(dayCheckArr[2]<year){
						alert("The date is not validate.");
						$("#date").focus() ;
				     return null;
			    }else if(dayCheckArr[1]<day){
						alert("The date is not validate.");
						$("#date").focus() ;
				     return null;
			    }else if(dayCheckArr[0]<month){
						alert("The date is not validate.");
						$("#date").focus() ;
				     return null;
			    }
					
			    if( $("#time").val().trim()== "" ){
			    	alert( "Please choose a time for reservation" );
				     $("#time").focus() ;
				     return null;
				   }
			
			   return( true );
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
							alert("Thank you for your booking. We send you the confirmation email. ");
							
							},
						error:function(xhr, status,error){
							alert("error +");
						}
					
					});
					}else{
						console.log("form is not complated");
					};
				};
					
			</script>