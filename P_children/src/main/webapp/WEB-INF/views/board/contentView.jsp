
<!-- board/contentView.jsp -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<script src="https://code.jquery.com/jquery-3.6.4.js" integrity="sha256-a9jBBRygX1Bh5lt8GZjXDzyOB+bWve9EiO7tROUtj/E=" crossorigin="anonymous">
</script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>board/contentView.jsp</title>
<script type="text/javascript">

	// 파일 업로드 시 img 태그에 그림 화면 보이기
	function readURL(input){
		var file = input.files[0]; // 파일 정보
		if(file != ""){
			var reader = new FileReader();
			reader.readAsDataURL(file); // 파일 정보 읽어오기
			reader.onload = function(e){ // 읽기에 성공하면 결과 표시
				$("#preview").attr("src", e.target.result)
			}
			
		}
	}
	
	function deleteConfirm() {
		
		if(!confirm('삭제하시겠습니까?')){
			return false;
		} else {
			location.href='${contextPath }/board/delete?write_no=${dto.write_no }&file_name=${dto.file_name }';
		}
		
	}
	
	// 댓글 입력창 보이기
	function slide_click() {
		$("#first").slideDown("slow");
		$("#modal_wrap").show();
	}
	
	// 댓글 입력창 숨기기
	function slide_hide() {
		$("#first").slideUp("fast");
		$("#modal_wrap").hide();
		$("#content").html(" ");
	}
	
	// 댓글 추가
	function rep() {
		if($("#content").val() == "") { // 내용이 없을 때
			alert("댓글 내용이 없습니다!");
		} else {
			let form = {}
			let arr = $("#frm").serializeArray();
			for( i = 0; i <arr.length ; i++) {
				form[arr[i].name] = arr[i].value
			}
			// console.log(form);
			
			$.ajax({
				url: "addReply",
				type: "POST", 
				data: JSON.stringify(form),
				contentType: "application/json; charset=utf-8",
				success: function(data) {
					if(data == 1)
						alert("댓글 추가 성공~!")
						slide_hide();
						$("#content").val(' ');
						replyData();
				},
				error: function() {
					alert("Error !!")
				}
				
				
			})
		}
		
	} // rep() end
	
	// 댓글 리스트업 기능(댓글 보이게 하는 기능)
	function replyData() {
		$.ajax({
			url: "replyData/"+$("#write_no").val(), //val() = value
			type: "get",
			dataType: "json",
			success: function(rep) {
				let htm = ""
				let count = 0;  // 해당 게시판의 모든 댓글과 대댓글 수
				if(rep.length > 0) {
					rep.forEach(function(redata){
						let date = new Date(redata.write_date)
						let writeDate = date.getFullYear()+"년 " +(date.getMonth() + 1) + "월 "
						writeDate += date.getDate() + "일 " + date.getHours() + " 시 "
						writeDate += date.getMinutes() + "분 " + date.getSeconds() + "초"
						count += 1;
						
						if(redata.depth == 0){ // 댓글인 경우 : depth == 0
							htm += "<div class='reply' align='left' id='rep" + redata.reply_no + "'><b> " + redata.id + " </b>님 / ";
							htm += "<span style='float:right;' align='right'><b>작성일 : " + writeDate + "</b></span><br>"
							htm += "<span class='repContent'>" + redata.content + "</span><br>"
							htm += "<input type='hidden' class='replyNo' value='" + redata.reply_no + "'/>"
							htm += "<button onclick='reComment("+ redata.reply_no +")'> 답글 보기</button>"
							htm += "<button onclick='ShowAddReCommentForm("+ redata.reply_no+")'>답글 달기</button>"
							
							// 댓글 작성자와 현재 유저가 일치하는 경우
							if(redata.id == $("#user").val() || $("#userGrade").val() == $("#admin").val()) {
								htm += "<a href='${contextPath }/board/deleteReply?reply_no="
										+ redata.reply_no
										+ "&write_group=" + redata.write_group + "'>[삭제]</a>"
										
								if(redata.id == $("#user").val()){
									htm += "<a href='#' onclick='updateReply("+ redata.reply_no +")'>[수정]</a>"
								}
										
								htm += "</div>"
							} else {
								htm += "</div>"
							}
						} 
						
						
				})
				} // if(rep.list.length > 0) end
				else { // 댓글이 없는 경우
					 htm += "<div align='left'>";
					 htm += "<h6>등록된 댓글이 없습니다.</h6>";
					 htm += "</div>";
				}
				
				$("#reply").html(htm)

			} // success end
			,
			error: function() {
				alert("댓글 가져오기 실패 !!")
			}
		})
		
	}
	
	// 댓글 수정하기
	function updateReply(reply_no){
		
		// 다른 댓글 켜져있을 경우 종료
		if($('#updateContent').val() != null){
			replyData();
		}
		
		let replyView = ""
		replyView += "<div align='left'><form id='updateResultFrm' action='${contextPath }/board/updateReply'><b>"+ $("#user").val() +"</b><input type='hidden' name='id' value='" + $("#user").val() + "' readonly><br>";
		replyView += "<input type='hidden'  name='write_no'  value='" + $('#write_no').val() + "'>"
		replyView += "<input type='hidden' id='updateReply_no' name='updateReply_no' value='" + $('#rep' + reply_no).children('.replyNo').val() + "'>"
		replyView += "<b> 의 수 정 내 용 : </b><textarea id='updateContent' name='updateContent' rows='5' cols='30' autofocus>" + $('#rep' + reply_no).children('.repContent').text() + "</textarea><br></div>"
		replyView += "<input type='button' onclick='updateReplyConfirm()' value='수정 완료'>"
		replyView += "<input type='button' onclick='replyData()' value='취소'></form><br>"
		$('#rep'+ reply_no).replaceWith(replyView);
		$('#rep'+ reply_no).children('#updateContent').focus();	
	}
	
	// 댓글 수정 확인
	function updateReplyConfirm(){
		/* alert('수정?');
		 */
		if(!confirm('수정하시겠습니까?')){
			return false;
		} else {
			$("#updateResultFrm").submit();
		}
	}
	
	
	// 대댓글(답글) 보기
	function reComment(reply_no){ // 댓글 reply_no(cGroup)에 해당하는 select 문, 자기 reply_no 순서대로 부르면 된다.
		
		if($("#rep" + reply_no).children(".reComment").length > 0) { // 대댓글(답글)이 나와 있을 경우
			//console.log($("#rep" + reply_no).children(".reComment").html()+" 입니다");	
			$("#rep" + reply_no).children(".reComment").remove(); // 대댓글 삭제
		} else {
			$.ajax({	
				url: "reCommentData/" + reply_no,
				type: "POST", 
				dataType: "json",	
				contentType: "application/json; charset=utf-8",
				success: function(reComment) {
					let htm = ""
					let count = 0;  // 해당 댓글의 대댓글 수
					if(reComment.length > 0) {
						reComment.forEach(function(redata){
							let date = new Date(redata.write_date)
							let writeDate = date.getFullYear()+"년 " +(date.getMonth() + 1) + "월 "
							writeDate += date.getDate() + "일 " + date.getHours() + " 시 "
							writeDate += date.getMinutes() + "분 " + date.getSeconds() + "초"
							count += 1;
							
							if(redata.depth == 1){ // 답글인 경우 : depth == 1
								htm += "<div class='reComment' align='left' id='reComment" + redata.reply_no + "'><b> " + redata.id + " </b>님 / ";
								htm += "<span style='float:right;' align='right'><b>작성일 : " + writeDate + "</b></span><br>"
								htm += "<span class='repContent'>" + redata.content + "</span><br>"
								htm += "<input type='hidden' class='replyNo' value='" + redata.reply_no + "'/>"
								
								// 대댓글 작성자와 현재 유저가 일치하는 경우 or 관리자인 경우
								if(redata.id == $("#user").val() || $("#userGrade").val() == $("#admin").val()) {
									htm += "<a href='${contextPath }/board/deleteReply?reply_no="
											+ redata.reply_no
											+ "&write_group=" + redata.write_group + "'>[삭제]</a>"
											// 대댓글 작성자와 현재 유저가 일치하는 경우
									if(redata.id == $("#user").val()) {
										htm += "<a href='#' onclick='updateReComment("+ redata.reply_no +")'>[수정]</a>"
									}
									
									htm += "</div>"
								} else {
									htm += "</div>"
								}
							} 
							
							
					})
					} // if(rep.list.length > 0) end
					else { // 댓글이 없는 경우
						 htm += "<div class='reComment' align='left'>";
						 htm += "<h6>등록된 답글이 없습니다.</h6>";
						 htm += "</div>";
					}
					
					$("#rep" + reply_no).append(htm)
				}, //success end
				error: function() {
					alert("Error !!")
				}
			})
		}
		
	
		
	} // reComment end
	
	// 대댓글 삽입 폼
	function ShowAddReCommentForm(reply_no){ // 답글 삽입 폼 생성
		 if($(".ShowAddReComment").text() != null) {
			 cancelAddReComment();
		}
		
		let htm = "";
		
		htm += "<div class='ShowAddReComment'>";
		htm += "<form method='post' id='addReCommentFrm' action='#'><b> "+$("#user").val()+"</b>";
		htm += "<input type='hidden' id='cGroup' name='cGroup' value='"+ reply_no +"'>"; 			// cGroup
		htm += "<input type='hidden'  name='write_no'  value='" + $('#write_no').val() + "'>"		// write_Group
		htm += "</b><input type='hidden' name='id' value='" + $("#user").val() + "' readonly><br>"; // id
		htm += "<textarea name='reCommentContent'></textarea>"
		htm += "<input type='button' onclick='addReComment("+ reply_no +")' value='답글쓰기'>  &nbsp; "
		htm += "</form><button onclick='cancelAddReComment()'> 취소 </button></div>"
		
		$("#rep" + reply_no).append(htm);
		
		
	} // ShowAddReCommentForm end
	
	// 대댓글 생성 화면 지우기
	function cancelAddReComment(){
		$(".ShowAddReComment").html(" ");
	}
	
	// 대댓글 생성
	function addReComment(cGroup) {
		let form = {}
		let arr = $("#addReCommentFrm").serializeArray();
		for( i = 0; i <arr.length ; i++) {
			form[arr[i].name] = arr[i].value
		}
		
		// console.log(arr[3].value + "입니다");
		
		if(arr[3].value != "") {
			$.ajax({
				url: "addReComment",
				type: "POST", 
				data: JSON.stringify(form),
				contentType: "application/json; charset=utf-8",
				success: function(data) {
					if(data == 1)
						alert("답글 추가 성공~!")
						cancelAddReComment();  	// 추가 성공 후 답글 입력창 종료
						reComment(cGroup);
				},
				error: function() {
				}
				
			})
		} else {
			alert("입력값이 없습니다");
		}
		
	} // rep() end
	
	// 대댓글 수정하기
	function updateReComment(reply_no){
		
		// 대댓글 해당하는 댓글(부모댓글)의 reply_no 값
		let cGroup = $('#reComment' + reply_no).closest('div').siblings('.replyNo').val();
		
		// 다른 댓글 켜져있을 경우 종료
		if($('#updateReCommentContent').val() != null){
			replyData();
			console.log(cGroup);
			reComment(cGroup);
		}
		
		let replyView = ""
		replyView += "<div align='left' class='updateReComment'><form id='updateReCommentResultFrm' action='${contextPath }/board/updateReComment'><b>"+ $("#user").val() +"</b><input type='hidden' name='id' value='" + $("#user").val() + "' readonly><br>";
		replyView += "<input type='hidden'  name='write_no'  value='" + $('#write_no').val() + "'>"
		replyView += "<input type='hidden' id='updateReCommentReply_no' name='updateReCommentReply_no' value='" + $('#reComment' + reply_no).children('.replyNo').val() + "'>"
		replyView += "<b> 의 수 정 내 용 : </b><textarea id='updateReCommentContent' name='updateReCommentContent' rows='5' cols='30' autofocus>" + $('#reComment' + reply_no).children('.repContent').text() + "</textarea><br>"
		replyView += "<input type='button' onclick='updateReCommentConfirm("+ cGroup +")' value='수정 완료'>"
		replyView += "<input type='button' onclick='cancleUpdateReComment("+ reply_no +","+ $('#reComment' + reply_no).closest('div').siblings('.replyNo').val() +")' value='취소'></form><br></div>"
		$('#reComment'+ reply_no).replaceWith(replyView);
		$('#reComment'+ reply_no).children('#updateReCommentContent').focus();	
	}
	
	// 대댓글 수정 확인
	function updateReCommentConfirm(cGroup){
		if(!confirm('수정하시겠습니까?')){
			return false;
		} else {
			$("#updateReCommentResultFrm").submit();
			reComment(cGroup);
			reComment(cGroup);
		}
	}
	
	// 대댓글 수정 취소
	function cancleUpdateReComment(reply_no, cGroup) {
		$('.updateReComment').replaceWith(""); // 대댓글 수정 div 삭제
		$("#rep" + cGroup).children(".reComment").remove(); // 댓글에 해당하는 대댓글들 모두 삭제 (reComment에서 .reComment가 하나라도 있으면 안 열림)
		//replyData();
		reComment(cGroup);
	}
	

</script>
<style type="text/css">
#modal_wrap {
	display: none;
	position: fixed;
	z-index: 9;
	margin: 0 auto;
	top: 0; left: 0; right: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.4);
}

#first {
	display: none;
	position: fixed;
	z-index: 10;
	margin: 0 auto;
	top: 30px; left: 0; right: 0;
	width: 300px;
	height: 350px;
	background: rgba(210, 240, 250, 0.9);
}

#second {
	display: none;
	position: fixed;
	z-index: 10;
	margin: 0 auto;
	top: 30px; left: 0; right: 0;
	width: 300px;
	height: 350px;
	background: rgba(210, 240, 250, 0.9);
}

h1 {
	text-align: center;
}

.contentView {
	display: flex;
	justify-content: center;
}

.reply {
	width: 1000px;
	border: 1px solid red;
}

#updateResultFrm {
	display: flex;
	justify-content: center;
}

#updateResultFrm textarea {
	display: block;
}

.reComment {
	background-color: cookie;
}
</style>
</head>
<body onload="replyData()">
	<!-- 관리자 확인 -->
	<div>
		<input type="hidden" id='userGrade' value="${info.grade }">
		<input type="hidden" id="admin" value="${admin }">
	</div>
	<!-- 답글 작성 페이지 -->
	<div id="modal_wrap">
		<div id="first">
			<div style="width: 600px; margin: 0 auto; padding-top: 20px;">
				<form id="frm" action="#">
					<input type="hidden" id="write_no" name="write_no" value="${dto.write_no }">
					<input type="hidden" id="user" name="id" value="${user }">
					<b>답글(댓글) 작성 페이지</b>
					<hr>
					<b>작성자 : ${user }</b>
					<hr>
					<b>내 용</b><br>
					<textarea id="content" name="content" rows="5" cols="30"></textarea>
					<hr>
					<button type="button" onclick="rep()">답 글</button>
					<button type="button" onclick="slide_hide()">취 소</button>
				</form>
			</div>
		</div>
	</div>
	
	<!-- 답글 수정 페이지 -->
	<div id="modal_wrap">
		<div id="second">
			<div style="width: 400px; margin: 0 auto; padding-top: 20px;">
				<form id="updateFrm" action="#">
					<input type="hidden" id="write_no" name="write_no" value="${dto.write_no }">
					<input type="hidden" id="user" name="id" value="${user }">
					<b>답글(댓글) 수정 페이지</b>
					<hr>
					<b>작성자 : ${user }</b>
					<hr>
					<hr>
					<b>내 용</b><br>
					<textarea id="content" name="content" rows="5" cols="30"></textarea>
					<hr>
					<button type="button" onclick="repUpdate()">수 정</button>
					<button type="button" onclick="slide_hide()">취 소</button>
				</form>
			</div>
		</div>
	</div>
	
	<!-- 본문 -->
	<%-- <c:import url="../default/header.jsp"/> --%>
	<h1> 글보기 </h1>
	<br><br>
	<div class="wrap contentView">
		<table class="table table-striped">
			<tr>
				<th width="100px"> 글번호 </th><td width="200px" class="form-control input-sm">${dto.write_no }</td>
				<th width="100px"> 작성자 </th><td width="200px" class="form-control input-sm">${dto.id }</td>
			</tr>
			<tr>
				<th width="100px"> 제 목 </th><td width="200px" class="form-control input-sm">${dto.title }</td>
				<th width="100px"> 작성일 </th><td width="200px" class="form-control input-sm">${dto.savedate }</td>
			</tr>
			<tr>
				<th> 내 용 </th><td>${dto.content }</td>
				<td colspan="2">
					<c:if test="${dto.file_name == 'nan'}">
						<b>이미지가 없습니다...</b>
					</c:if>
					<c:if test="${dto.file_name != 'nan'}">
						<img src="${contextPath }/board/download?file_name=${dto.file_name}" width="200px" height="200px">
					</c:if>
				</td>
			</tr>
			<tr>
				<td colspan="4" align="center">
					<%-- <c:if test="${dto.id == loginUser}"> --%>
					<!-- 답글 페이지 -->
					<div id="reply"></div>
					
					<c:if test="${dto.id == user || info.grade == admin }">
						<input type="button" value="수정하기" onclick="location.href='${contextPath }/board/modifyForm?write_no=${dto.write_no }'" /> &nbsp;
						<input type="button" value="삭제하기" onclick="deleteConfirm()" /> &nbsp;
					</c:if>
					<input type="button" value="답글달기" onclick="slide_click()"> &nbsp;
					<input type="button" value="글목록" onclick="location.href='${contextPath}/board/boardAllList'">
				</td>
			</tr>
		</table>
	</div>
	<%-- <c:import url="../default/footer.jsp"/> --%>
</body>
</html>