<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	// 유효성 코드 추가 -> 분기 -> return
	
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp");	
		return;
	}
	
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");

	String sql = "select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo);
	System.out.println(stmt + " <-- stmt");
	ResultSet rs = stmt.executeQuery();		
 
	rs.next();
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
	<div><!-- 메인메뉴 -->
	      <a href="./home.jsp" class="btn btn-outline-dark">홈으로</a>
	      <a href="./noticeList.jsp" class="btn btn-outline-dark" >공지 리스트</a>
	      <a href="./scheduleList.jsp" class="btn btn-outline-dark" >일정 리스트</a>
    </div>
	<h1>수정</h1>
	<div class="alert alert-danger">
	<%
		if(request.getParameter("msg") != null) {
	%>
			<strong>!!</strong>: <%=request.getParameter("msg")%>
	<%
		}
	%>
	</div>
	<form action="./updateNoticeAction.jsp" method="post">
		<table class="table table-bordered ">
			<tr>
				<td>
					번호
				</td>
				<td>
					<input type="number" name="noticeNo" 
						value="<%=rs.getInt("notice_no")%>" readonly="readonly"> 
				</td>
			</tr>
			<tr>
				<td>
					제목
				</td>
				<td>
					<input type="text" name="noticeTitle" 
						value="<%=rs.getString("notice_title")%>"> 
				</td>
			</tr>
			<tr>
				<td>
					내용
				</td>
				<td>
					<textarea rows="5" cols="80" name="noticeContent">
						<%=rs.getString("notice_content")%>
					</textarea>
				</td>
			</tr>
			<tr>
				<td>
					작성자
				</td>
				<td>
					<%=rs.getString("notice_writer")%>
				</td>
			</tr>
			<tr>
				<td>
					작성일
				</td>
				<td>
					<%=rs.getString("createdate")%>
				</td>
			</tr>
			<tr>
				<td>
					수정일
				</td>
				<td>
					<%=rs.getString("updatedate")%>
				</td>
			</tr>
			<tr>
				<td>
					비밀번호
				</td>
				<td>
					<input type="password" name="noticePw"> 
				</td>
			</tr>
		</table>
		<div>
			<button type="submit" class="btn btn-danger">수정</button>
		</div><!--  수정버튼을 누르면 name= 값들이 action으로 넘어감 -->
	</form>
</body>
</html>