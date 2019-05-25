<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c" %>
    <%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<jsp:include page="../components/head.jsp"></jsp:include>
</head>
<body data-spy="scroll" data-target="#ftco-navbar" data-offset="200">
	<div class="site-wrap">
 	<tiles:insertAttribute name="header"/>  
	
	<div class="main-wrap " >
		<tiles:insertAttribute name="navigation"/> 
		<tiles:insertAttribute name="content" />
	</div>
		<tiles:insertAttribute name="footer" />

		<!-- loader -->
		<div id="loader" class="show fullscreen">
			<svg class="circular" width="48px" height="48px">
				<circle class="path-bg" cx="24" cy="24" r="22" fill="none"stroke-width="4" stroke="#eeeeee" />
				<circle class="path" cx="24" cy="24" r="22" fill="none"stroke-width="4" stroke-miterlimit="10" stroke="#ff7a5c" /></svg>
		</div>
</div>
<!--  -------------------------------------------------------------------------------------------- -->
<jsp:include page="../components/vendors.jsp"></jsp:include>
</body>
</html>