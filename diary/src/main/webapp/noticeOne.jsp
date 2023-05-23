<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp");
		return; // 1) 코드진행종료 2) 반환값을 남길때
	}
	
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	/*
		select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate 
		from notice 
		where notice_no = ?
	*/
	String sql = "select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo);
	System.out.println(stmt + " <-- stmt");
	ResultSet rs = stmt.executeQuery();
	// 모델데이터 
	 Notice notice = null; // int totalCnt; ArrayList<Notice> list
	 // Notice notice = new Notice();
	 if(rs.next()) {
	      notice = new Notice();
	      notice.noticeNo = rs.getInt("notice_no");
	      notice.noticeTitle = rs.getString("notice_title");
	      notice.noticeContent = rs.getString("notice_content");
	      notice.noticeWriter = rs.getString("notice_writer");
	      notice.createdate = rs.getString("createdate");
	      notice.updatedate = rs.getString("updatedate");
	   }

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="container">
   <div ><!-- 메인메뉴 -->
      <a href="./home.jsp" class="btn btn-outline-dark">홈으로</a>
      <a href="./noticeList.jsp" class="btn btn-outline-dark" >공지 리스트</a>
      <a href="./scheduleList.jsp" class="btn btn-outline-dark" >일정 리스트</a>
   </div>
	
	<h1>공지 상세</h1>
	<!--  view 단 -->
			<table class="table table-bordered">
            <tr>
               <th class="table-info">번호</th>
               <td><%=notice.noticeNo%></td>
            </tr>
            <tr>
               <th class="table-info">제목</th>
               <td><%=notice.noticeTitle%></td>
            </tr>
            <tr>
               <th class="table-info">내용</th>
               <td><%=notice.noticeContent%></td>
            </tr>
            <tr>
               <th class="table-info">작성자</th>
               <td><%=notice.noticeWriter%></td>
            </tr>
            <tr>
               <th class="table-info">작성일</th>
               <td><%=notice.createdate%></td>
            </tr>
            <tr>
               <th class="table-info">수정일</th>
               <td><%=notice.updatedate%></td>
            </tr>
			</table>
	<div>
		<a href="./updateNoticeForm.jsp?noticeNo=<%=noticeNo%>" class="btn btn-danger -sm">수정</a>
		<a href="./deleteNoticeForm.jsp?noticeNo=<%=noticeNo%>" class="btn btn-danger -sm">삭제</a>
	</div>
</body>
</html>