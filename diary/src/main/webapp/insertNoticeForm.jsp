<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertNoticeForm</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="container">
   <div><!-- 메인메뉴 -->
      <a href="./home.jsp" class="btn btn-outline-dark">홈으로</a>
      <a href="./noticeList.jsp" class="btn btn-outline-dark" >공지 리스트</a>
      <a href="./scheduleList.jsp" class="btn btn-outline-dark" >일정 리스트</a>
   </div>
	
	<h1>공지 입력</h1>
	<form action="./insertNoticeAction.jsp" method="post">
	      <table class="table table-bordered">
	         <tr>
	            <th class="table-info">제목</th>
	            <td>
	               <input type="text" name="noticeTitle">
	            </td>
	         </tr>
	         <tr>
	            <th class="table-info">내용</th>
	            <td>
	               <textarea rows="5" cols="80" name="noticeContent"></textarea>
	            </td>
	         </tr>
	         <tr>
	            <th class="table-info">작성자</th>
	            <td>
	               <input type="text" name="noticeWriter">
	            </td>
	         </tr>
	         <tr>
	            <th class="table-info">비밀번호</th>
	            <td>
	               <input type="password" name="noticePw">
	            </td>
	         </tr>
	         <tr>
	            <td colspan="2">
	              <button type="submit" class="btn btn-outline-danger">입력</button>
				</td>
			</tr>
	
		</table>
	</form>
</body>
</html>