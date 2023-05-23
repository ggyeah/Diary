<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//요청값 유효성 검사
	 if(request.getParameter("scheduleNo") == null) {
      response.sendRedirect("./scheduleList.jsp");
      return; // 1) 코드진행종료 2) 반환값을 남길때
   }

	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	// 디버깅 
	 System.out.println(scheduleNo + " <-- scheduleNo");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateNoticeForm</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body  class="container">
	<h1>일정 삭제</h1>
	<div class="alert alert-danger">
	<%
		if(request.getParameter("msg") != null) {
	%>
			<strong>!!</strong>: <%=request.getParameter("msg")%>
	<%
		}
	%>
	</div>
	<form action="./deleteScheduleAction.jsp" method="post">
	<table>
		<tr>
			<td>번호</td>
	        <td>
	        	<input type="text" name="scheduleNo" value="<%=scheduleNo%>" readonly="readonly">
	       		 <!-- hidden : 안보여서 수정할 수 없다 // 다른방식 readonly="readonly"-->
	        </td>
		</tr>
		<tr>
			<td>비밀번호</td>
	        <td>
	       	 <input type="password" name="schedulePw">
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