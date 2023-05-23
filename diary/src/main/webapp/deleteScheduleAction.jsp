<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	// 요청값 유효성 검사 // 오류메세지 출력문
	String msg = null; 
	if( request.getParameter("schedulePw") == null  
		|| request.getParameter("schedulePw").equals("")) {
		msg = "noticePw is required";
	}
	if(msg != null) {	
	response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo="
							+request.getParameter("scheduleNo")
							+"&msg="+msg);
	return;// 1) 코드진행종료 2) 반환값을 남길때
	}
	//요청된 값들을 변수에 할당시킴 (form에서 받아온 값) // 형변환
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String schedulePw = request.getParameter("schedulePw");
	
	//디버깅 
	System.out.println(scheduleNo + " <-- deletescheduleAction param scheduleNo");
	System.out.println(schedulePw + " <-- deletescheduleAction param schedulePw");
	//delete from notice where notice_no=? and notice_pw=?
		
	//1) 장치드라이버를 로딩		
	Class.forName("org.mariadb.jdbc.Driver");
	//2) 로그인 후 접속정보 반환받음
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	String sql = "delete from schedule where schedule_no=? and schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, scheduleNo);
	stmt.setString(2, schedulePw);
	System.out.println(stmt + " <-- deleteScheduleAction sql");
	
	int row = stmt.executeUpdate();
	// 디버깅
	System.out.println(row + " <-- deleteScheduleAction row");
	
	 if(row == 0) { // 비빌번호 틀려서 삭제행이 0행
	      response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo="
	    		  				+request.getParameter("scheduleNo")
								+"&msg=incorrect schedulePw");
		} else {
		      response.sendRedirect("./scheduleList.jsp?scheduleNo="+scheduleNo);
		}
	 %>