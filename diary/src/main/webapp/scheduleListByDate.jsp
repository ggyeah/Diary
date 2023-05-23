<%@page import="javax.print.attribute.standard.PresentationDirection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	
	// y, m, d 값이 null or "" -> redirection scheduleList.jsp
	
	int y = Integer.parseInt(request.getParameter("y"));
	// 자바API에서 12월 11, 마리아DB에서 12월 12
	int m = Integer.parseInt(request.getParameter("m")) + 1;
	int d = Integer.parseInt(request.getParameter("d"));
	
	System.out.println(y + " <-- scheduleListByDate param y");
	System.out.println(m + " <-- scheduleListByDate param m");
	System.out.println(d + " <-- scheduleListByDate param d");
	
	//요청값 유효성 검사
 	// 현재 jsp에서 바로 list로 접속가능
	if(request.getParameter("y") == null
		||request.getParameter("m") == null 
		||request.getParameter("d") == null
		|| request.getParameter("y").equals("")
		|| request.getParameter("m").equals("")
		|| request.getParameter("d").equals("")) {
		response.sendRedirect("./scheduleList.jsp");
		return; // 1) 코드진행종료 2) 반환값을 남길때
	}
	
	String strM = m+"";
	if(m<10) {
		strM = "0"+strM;
	}
	String strD = d+"";
	if(d<10) {
		strD = "0"+strD;
	}
	
	// 일별 스케줄 리스트
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	String sql = "select * from schedule where schedule_date = ? order by schedule_time asc";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, y+"-"+strM+"-"+strD);
	System.out.println(stmt + " <-- scheduleListByDate stmt");
	ResultSet rs = stmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleListByDate</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class = "container"> 
   <div class="container"><!-- 메인메뉴 -->
      <a href="./home.jsp" class="btn btn-outline-dark">홈으로</a>
      <a href="./noticeList.jsp" class="btn btn-outline-dark" >공지 리스트</a>
      <a href="./scheduleList.jsp" class="btn btn-outline-dark" >일정 리스트</a>
   </div>
	<h1>스케줄 입력</h1>
	<form action="./insertScheduleAction.jsp" method="post">
		<table class="table table-bordered">
			<tr>
				<th>날짜</th>
				<td><input type="date" name="scheduleDate" 
							value="<%=y%>-<%=strM%>-<%=strD%>" 
							readonly="readonly"></td>
			</tr>
			<tr>
				<th>시간</th>
				<td><input type="time" name="scheduleTime"></td>
			</tr>
			<tr>
				<th>색깔</th>
				<td>
					<input type="color" name="scheduleColor" value="#00000">
				</td>
			</tr>
			<tr>
				<th>메모</th>
				<td><textarea cols="80" rows="3" name="scheduleMemo"></textarea></td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td><input type="password" name="schedulePw"></td>
			</tr>
		</table>
		<button type="submit" class="btn btn-outline-danger">스케줄 입력</button>
	</form>
	
	<h1><%=y%>년 <%=m%>월 <%=d%>일 스케줄 목록</h1>
	<table  class="table table-bordered">
		<tr class="table-info">
			<th>시간</th>
			<th>메모</th>
			<th>작성일</th>
			<th>수정일</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
		<%
			while(rs.next()) {
		%>
				<tr>
					<td><%=rs.getString("schedule_time")%></td>
					<td><%=rs.getString("schedule_memo")%></td>
					<td><%=rs.getString("createdate")%></td>
					<td><%=rs.getString("updatedate")%></td>
					<td><a href="./updateScheduleForm.jsp?scheduleNo=<%=rs.getString("schedule_no")%>"  class="btn btn-danger -sm">수정</a></td>
					<td><a href="./deleteScheduleForm.jsp?scheduleNo=<%=rs.getString("schedule_no")%>"  class="btn btn-danger -sm">삭제</a></td>
				</tr>
		<%		
			}
		%>
	</table>
</body>
</html>