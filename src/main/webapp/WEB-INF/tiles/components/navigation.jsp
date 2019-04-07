<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<div class="topnav" id="myTopnav">
<div class="nav_logo" >
		<a href="#" class="">LOGO</a>
  		<a href="javascript:void(0);" class="icon" onclick="myFunction()">
  			  <i class="fa fa-bars"></i>
	  </a>
</div>  

  <div class="nav_menu">
 	 	<a href="#home" class="active menu">Home</a>
	  	<a href="#news"  class="menu">News</a>
	  	<a href="#contact" class="menu">Contact</a>
	  	<a href="#about" class="menu">About</a>
  </div>
</div>

	<script>
function myFunction() {
  var x = document.getElementById("myTopnav");
  if (x.className === "topnav") {
    x.className += " responsive";
  } else {
    x.className = "topnav";
  }
}
</script>
      <!-- 
        <div class=" site-menu"  id="#nav-target">
          <ul class="navbar-nav ml-auto">
            <li class="nav-item active"><a href="#section-home" class="nav-link">Home</a></li>
            <li class="nav-item"><a href="#section-about" class="nav-link">About</a></li>
            <li class="nav-item"><a href="#section-offer" class="nav-link">Offer</a></li>
            <li class="nav-item"><a href="#section-menu" class="nav-link">Menu</a></li>
            <li class="nav-item"><a href="#section-news" class="nav-link">News</a></li>
            <li class="nav-item"><a href="#section-gallery" class="nav-link">Gallery</a></li>
            <li class="nav-item"><a href="#section-contact" class="nav-link">Contact</a></li>
          </ul>
        </div>
      </div>
    </nav> -->


    <!-- 
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
  <a class="navbar-brand" href="#"><b>모락모락</b> </a>
  <button class="navbar-toggler " type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  
  <div class=" navbar-collapse collapse"  id="navbarNavDropdown">
    <ul class="navbar-nav show">
      <li class="nav-item active">
        <a class="nav-link" href="/">Home <span class="sr-only">(current)</span></a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="/contact">오시는길</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#">자주찾는 질문 </a>
      </li>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          레이아웃종류 
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
          <a class="dropdown-item" href="/gallery">갤러리</a>
          <a class="dropdown-item" href="/menu">메뉴</a>
          <a class="dropdown-item" href="/reserve">예약</a>
        </div>
      </li>
    </ul>
  </div>
</nav>
  -->

		<!-- <nav class="site-menu navbar-expand-sm navbar navbar-default" id="ftco-navbar-spy">
			<div class="site-menu-inner" id="ftco-navbar">
				<ul class="list-unstyled">
					<li><a href="/">Home</a></li>
					<li><a href="/gallery">갤러리</a></li> 
					<li><a href="/menu">메뉴</a></li>
					<li><a href="/reserve">예약</a></li>
					<li><a href="/contact">오시는길</a></li>
				</ul>
			</div>
		</nav>
		
 -->