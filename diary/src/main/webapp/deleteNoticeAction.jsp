<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	//요청값 유효성 검사 // 오류메세지 출력문
	// pw가 공백이거나 null 값이면 form에 오류메세지를 출력한다
	String msg = null;  
	if( request.getParameter("noticePw") == null 
		|| request.getParameter("noticePw").equals("")) {
		msg = "noticePw is required";
	}
	if(msg != null) {
	response.sendRedirect("./deleteNoticeForm.jsp?noticeNo="
							+request.getParameter("noticeNo")
							+"&msg="+msg);
    return;// 1) 코드진행종료 2) 반환값을 남길때
	}
	
	//요청된 값들을 변수에 할당시킴 (form에서 받아온 값) // 형변환
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	
	//디버깅 
	System.out.println(noticeNo + " <-- deleteNoticeAction param noticeNo");
	System.out.println(noticePw + " <-- deleteNoticeAction param noticePw");
	//delete from notice where notice_no=? and notice_pw=?
		
	//1) 장치드라이버를 로딩		
	Class.forName("org.mariadb.jdbc.Driver");
	//2) 로그인 후 접속정보 반환받음
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	String sql = "delete from notice where notice_no=? and notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo);
	stmt.setString(2, noticePw);
	System.out.println(stmt + " <-- deleteNoticeAction sql");
	
	int row = stmt.executeUpdate();
	// 디버깅
	System.out.println(row + " <-- deleteNoticeAction row");
	
	 if(row == 0) { // 비빌번호 틀려서 삭제행이 0행
	      response.sendRedirect("./deleteNoticeForm.jsp?noticeNo="
					+request.getParameter("noticeNo")
					+"&msg=incorrect noticePw");
		} else {
		      response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo);
		}
	 %>