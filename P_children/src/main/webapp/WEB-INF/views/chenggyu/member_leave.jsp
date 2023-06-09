
<!-- member_leave -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Mate With 회원 탈퇴</title>
<script src="https://code.jquery.com/jquery-3.6.4.js" integrity="sha256-a9jBBRygX1Bh5lt8GZjXDzyOB+bWve9EiO7tROUtj/E=" crossorigin="anonymous"></script>
<link href="${pageContext.request.contextPath}/resources/chenggyu/board.css?v=2" rel="stylesheet" type="text/css">
<script type="text/javascript">
function leave(){
	var pwd = $('#pwd').val();
	console.log(pwd);
	if( pwd != ${dto.pwd} ){
		alert("비밀번호를 확인해주세요");
	} else {
		if(!confirm('회원탈퇴 하시겠습니까?')){
			return false;
	} else {
	$.ajax({
		url: "member_leave_save",
		type: "POST",
		data : $("#leave_form").serialize(),
		success: function(data){
			$("#count").text(data)
			console.log("성공");
			 window.location.href = "${contextPath }/root/index" ;
			 alert("이용해주셔서 감사했습니다");
		},
		error: function(){
			console.log("실패");
		}
		
	})
	}
}
}
</script>
</head>
<body>

	<c:import url="../default/header.jsp"/>
	   
		<section><!-- body -->
		<div class="form-box"> <!--  container  -->
		<div class="title">회원 탈퇴</div>
		<form id="leave_form" action="${contextPath }/member/member_leave_save">
			<div class="user-details">
				<div class="input-box">
					<span class="details">아이디</span>
					<input type="text"   name="id" value="${dto.id }" readonly="readonly">	
				</div>
				<div class="input-box">
					<span class="details">비밀번호 </span>
					<input type="text"  name="pwd" id="pwd">
				</div>
			</div>
			<div class="button">
				<input type="button" value="확인" onclick="leave()" class="but_1">
			</div>
		</form>
			<ul class="menu">
				<li><a href="">메뉴</a>
					<ul class="submenu_">
						<hr>
						<li><a href="${contextPath }/member/member_information">이전</a></li>
					</ul>
				</li>
			</ul>		
		</div>
	</section>
	
	 <c:import url="../default/footer.jsp"/>


</body>
</html>