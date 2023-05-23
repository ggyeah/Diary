<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//요청값 유효성 검사
	//no가 null값이면 noticelist로
	 if(request.getParameter("noticeNo") == null) {
      response.sendRedirect("./noticeList.jsp");
      return; // 1) 코드진행종료 2) 반환값을 남길때
  	 }

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	// 디버깅
	 System.out.println(noticeNo + " <-- deleteNoticeForm param noticeNo");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateNoticeForm</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="container">
	<h1>공지 삭제</h1>
	<div class="alert alert-danger">
	<%
		if(request.getParameter("msg") != null) {
	%>
			<strong>!!</strong>: <%=request.getParameter("msg")%>
	<%
		}
	%>
	</div>
	<form action="./deleteNoticeAction.jsp" method="post">
	<table class="table table-bordered">
		<tr>
			<td>번호</td>
	        <td>
	        	<input type="text" name="noticeNo" value="<%=noticeNo%>" readonly="readonly">
	       		 <!-- hidden : 안보여서 수정할 수 없다 // 보이지만 수정할수 없다 readonly="readonly"-->
	        </td>
		</tr>
		<tr>
			<td>비밀번호</td>
	        <td>
	       	 <input type="password" name="noticePw">
	        </td>
		</tr>
		<tr>
	         <td colspan="2">
	              <button type="submit" class="btn btn-danger">삭제</button>
			</td>
		</tr>
		
	</table>
	</form>
</body>
</html>