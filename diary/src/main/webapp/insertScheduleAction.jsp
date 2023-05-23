<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");	

	//validation(요청 파라미터값 유효성 검사) // 공백이거나 null 값이오면 폼으로
	if(request.getParameter("scheduleDate") == null 
	|| request.getParameter("scheduleTime") == null   
	|| request.getParameter("scheduleColor") == null
	|| request.getParameter("scheduleMemo") == null
	|| request.getParameter("schedulePw") == null
	|| request.getParameter("scheduleTime").equals("")
	|| request.getParameter("scheduleTime").equals("")
	|| request.getParameter("scheduleColor").equals("")
	|| request.getParameter("scheduleMemo").equals("")
	|| request.getParameter("schedulePw").equals("")) {
	
	response.sendRedirect("./scheduleList.jsp");
	return;// 1) 코드진행종료 2) 반환값을 남길때
	}

	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	//디버깅
	System.out.println(scheduleDate + " <-- insertScheduleAction param scheduleDate");
	System.out.println(scheduleTime + " <-- insertScheduleAction param scheduleTime");
	System.out.println(scheduleColor + " <-- insertScheduleAction param scheduleColor");
	System.out.println(scheduleMemo + " <-- insertScheduleAction param scheduleMemo");
	System.out.println(schedulePw + " <-- insertScheduleAction param schedulePw");
	//1) 장치드라이버를 로딩	
	Class.forName("org.mariadb.jdbc.Driver");
	//2) 로그인 후 접속정보 반환받음
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	String sql = "insert into schedule(schedule_date, schedule_time, schedule_memo, schedule_color, schedule_pw, createdate, updatedate) values(?,?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	//? 5개
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleMemo);
	stmt.setString(4, scheduleColor);
	stmt.setString(5, schedulePw);
	System.out.println(stmt + " <-- insertScheduleAction stmt");
	
	//영향받은 행
	int row = stmt.executeUpdate();
	if(row==1) {
		System.out.println("insertScheduleAction 정상 입력");
	} else {
		System.out.println("insertScheduleAction 비정상 입력 row : "+ row);
	}
	// date형식대로 자르기
	String y = scheduleDate.substring(0,4);
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1 ;
	String d = scheduleDate.substring(8);
	
	System.out.println(y + " <-- insertScheduleAction y");
	System.out.println(m + " <-- insertScheduleAction m");
	System.out.println(d + " <-- insertScheduleAction d");
	
	response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
%>