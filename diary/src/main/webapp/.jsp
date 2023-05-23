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
</head>
<body>
	<h1>스케줄 입력</h1>
	<form action="./insertScheduleAction.jsp" method="post">
		<table>
			<tr>
				<th>schedule_date</th>
				<td><input type="date" name="scheduleDate" 
							value="<%=y%>-<%=strM%>-<%=strD%>" 
							readonly="readonly"></td>
			</tr>
			<tr>
				<th>schedule_time</th>
				<td><input type="time" name="scheduleTime"></td>
			</tr>
			<tr>
				<th>schedule_color</th>
				<td>
					<input type="color" name="scheduleColor" value="#00000">
				</td>
			</tr>
			<tr>
				<th>schedule_memo</th>
				<td><textarea cols="80" rows="3" name="scheduleMemo"></textarea></td>
			</tr>
		</table>
		<button type="submit">스케줄 입력</button>
	</form>
	
	<h1><%=y%>년 <%=m%>월 <%=d%>일 스케줄 목록</h1>
	<table>
		<tr>
			<th>schedule_time</th>
			<th>schedule_memo</th>
			<th>createdate</th>
			<th>updatedate</th>
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
					<td><a href="./updateScheduleForm.jsp?scheduleNo=<%=rs.getString("schedule_no")%>">수정</a></td>
					<td><a href="./deleteScheduleForm.jsp?scheduleNo=<%=rs.getString("schedule_no")%>">삭제</a></td>
				</tr>
		<%		
			}
		%>
	</table>
</body>
</html>