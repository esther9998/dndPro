<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/JavaScript" src="/js/jquery-3.1.1.min.js"></script>
<title>Insert title here</title>

<style>
body {
margin : 0;
display : block;
}

* {
box-sizing : border-box;
}

div {
display : block;
}

.container{
padding-right : 15px;
padding-left : 15px;
margin-right : auto;
margin-left : auto;
}

table {
border : 1px solid;
width : 100%;
max-width : 100%;
margin-bottom : 20px;
background-color : transparent;
border-spacing : 0;
border-collapse : collapse;
display : table;
}

tr{
display : table-row;
}

tr, td{
border : 1px solid #e4e4e4;
}

th{
border-bottom : 1px solid black;
}

th, td {
text-align : center;
}

td, th{
display : table-cell;
padding : 8px;
line-height : 1.42857143;
vertical-align : top;
}

.searchcoin, .searchname {
display : table-cell;
padding-right : 30px; 
}

.search {
margin-bottom : 30px;
margin-top : 30px;
}

#searching {
margin-left : 20px;
}

ul {
list-style : none;
padding-left : 0px;
text-align : center;
}

ul li, button:hover{
cursor : pointer
}

i{
border : solid black;
border-width : 0 3px 3px 0;
display : inline-block;
padding : 8px;
margin-top : 16px;
}

.right{
transform : rotate(-45deg);
-webkit-transform : rotate(-45deg);
}

.left{
transform : rotate(135deg);
-webkit-transform : rotate(135deg);
}

li {
display : inline;
}

ul li a:hover {
background-color : #ccedff;
} 

ul li a{
display : inline-block;
width : 135px;
height : 50px;
}

input{
border : 1px solid;
}

select{
border : 1px solid;
}

button{
border : 1px solid;
}

</style>


</head>

<body>
<div class='container'>
<div class = 'search'>
<div class = 'searchcoin'>
코인 :
<select id="searchselect">
<c:forEach var="list" items='${coinlist}' varStatus="status">
<option id="coin_name" value="${list.COIN_NUM}" <c:if test="${list.COIN_NUM eq page.TARGET_COIN_NUM}">selected</c:if>><c:out value="${list.COIN_NAME}"/></option>
</c:forEach>

</select>
</div>
<div class = 'searchname'>
이름 :
<input id="search" type="text"> <button type="button" id="searching">검색</button>
</div>

</div>


<table align='center'>
<thead>
<tr>
<th>회원번호</th>
<th>회원이름</th>
<!-- <th>멤버사용</th>
<th>코인번호</th>
<th>코인종류</th> -->
<th>보유수량</th>
<th>매수잔량</th>
<th>매도잔량</th>
<th>총 보유수량</th>
</tr>
</thead>
<tbody>
<c:forEach var="emp" items='${fork}' varStatus="status">
<tr>
<td><c:out value="${emp.MEMBER_NUM}"/></td>
<td><c:out value="${emp.MEMBER_NAME}"/></td>
<%-- <td><c:out value="${emp.MEMBER_USE}"/></td>
<td><c:out value="${emp.COIN_NUM}"/></td>
<td><c:out value="${emp.COIN_KIND}"/></td> --%>
<td><c:out value="${emp.WALLET_BALANCE}"/></td>
<td><c:out value="${emp.BUY_SUM}"/></td>
<td><c:out value="${emp.SELL_SUM}"/></td>
<td><c:out value="${emp.SUM_TOTAL}"/></td>
</tr>
</c:forEach>
</tbody>
</table>

<c:if test="${ 0 le page.PAGE_NUM}">
<ul>
<li><a id="backpage" ><i class="arrow left"></i></a></li>
<li><a id="forewardpage"><i class="arrow right"></i></a></li>
</ul>
</c:if>
<input type="hidden" id="page" value="${page.PAGE_NUM}">
<input type="hidden" id="totalcount" value="${totalcount}">
</div>

<script> 
 $("#backpage").click(function(){
	var page = $("#page").val();
	var search = $("#searchselect option:selected").val();
	if(Number(page) == 0){
		alert("1페이지입니다.");
		return;
    }
	page=Number(page) -20;
	var url = "https://concokorea.com/ADM/HARDFORK/"+search+"/"+page;
	window.location = url;
});
$("#forewardpage").click(function(){
	var page = $("#page").val();
	var totalcount = $("#totalcount").val();
	var search = $("#searchselect option:selected").val();
	if(Number(totalcount) < page){
		alert("마지막페이지입니다.");
		return;
    }
	page=Number(page)+20;
	var url = "https://concokorea.com/ADM/HARDFORK/"+search+"/"+page;
	window.location = url;
});  
$("#searching").click(function(){
	var search = $("#searchselect option:selected").val();
	var name = $("#search").val();
	if(name == "" || name == null){
		var url = "https://concokorea.com/ADM/HARDFORK/"+search+"/0";
	}else{
		var url = "https://concokorea.com/ADM/HARDFORK/GETMEMBER/"+search+"/"+name;
	}	
	window.location = url;
});
</script>

</body>
</html>