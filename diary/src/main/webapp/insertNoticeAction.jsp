<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%
	request.setCharacterEncoding("utf-8");	

	//validation(요청 파라미터값 유효성 검사) // 공백이거나 null 값이오면 폼으로
   if(request.getParameter("noticeTitle") == null 
         || request.getParameter("noticeContent") == null   
         || request.getParameter("noticeWriter") == null
         || request.getParameter("noticePw") == null
         || request.getParameter("noticeTitle").equals("")
         || request.getParameter("noticeContent").equals("")
         || request.getParameter("noticeWriter").equals("")
         || request.getParameter("noticePw").equals("")) {
      
      response.sendRedirect("./insertNoticeForm.jsp");
      return;// 1) 코드진행종료 2) 반환값을 남길때
   	}
	
   String noticeTitle = request.getParameter("noticeTitle");
   String noticeContent = request.getParameter("noticeContent");
   String noticeWriter = request.getParameter("noticeWriter");
   String noticePw = request.getParameter("noticePw");
	//값들을 DB 테이블 입력
		
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
				"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	String sql = "insert into notice(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate) values(?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 4개
   stmt.setString(1, noticeTitle);
   stmt.setString(2, noticeContent);
   stmt.setString(3, noticeWriter);
   stmt.setString(4, noticePw);	
   
   	// 변화된 행값
	int row = stmt.executeUpdate(); 
	System.out.println(row + " <--  row");
	
	 if(row == 0) { // 비빌번호 틀려서 삭제행이 0행
	      response.sendRedirect("./insertNoticeForm.jsp?noticeNo="
					+request.getParameter("noticeNo"));
		} else {
		      response.sendRedirect("./noticeList.jsp");
		
		}
%>