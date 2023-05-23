<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	// request 인코딩 설정// 글씨가 깨지지 않도록함
	request.setCharacterEncoding("UTF-8");


	//요청된 값들을 변수에 할당시킴 (form에서 받아온 값) // 형변환
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	  
	// 디버깅
	System.out.println(scheduleNo + " <-- scheduleNo");
	System.out.println(scheduleDate + " <--  scheduleDate");
	System.out.println(scheduleTime + " <--scheduleTime");
	System.out.println(scheduleColor + " <--scheduleColor");
	System.out.println(scheduleMemo + " <-- cheduleMemo");
	System.out.println(schedulePw + " <-- insertScheduleAction param schedulePw");
	
	// null이나 공백 값을 보내면 나오는 오류메세지 출력문 
	String msg = null; // no은 메세지 출력이 안되서 제외함
	if(request.getParameter("scheduleDate")==null 
			|| request.getParameter("scheduleDate").equals("")) {
			msg = "scheduleDate is required";
	} else if(request.getParameter("scheduleTime")==null 
			|| request.getParameter("scheduleTime").equals("")) {
			msg = "scheduleTime is required";
	} else if(request.getParameter("scheduleMemo")==null 
			|| request.getParameter("scheduleMemo").equals("")) {
			msg = "scheduleMemo is required";
	} else if(request.getParameter("scheduleColor")==null 
			|| request.getParameter("scheduleColor").equals("")) {
			msg = "scheduleColor is required";
	} else if(request.getParameter("schedulePw")==null 
			|| request.getParameter("schedulePw").equals("")) {
			msg = "schedulePw is required";
	}
	if(msg != null) { 
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo="
								+scheduleNo
								+"&msg="+msg);
        return; // 1) 코드진행종료 2) 반환값을 남길때
	}
	
	// 장치드라이버를 로딩	
    Class.forName("org.mariadb.jdbc.Driver");
  	// 로그인 후 접속정보 반환받음
    Connection conn = DriverManager.getConnection(
				"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
    //sql 선언 set 이후로 바뀔 값 / where 어떤 값일때 
    //mariadb로 전송될 값임
    String sql = "update schedule set schedule_date=?, schedule_time=?, schedule_memo=?, schedule_color=?, updatedate=now() where schedule_no=? and schedule_pw=?";
    PreparedStatement stmt = conn.prepareStatement(sql);
    // ? 6개에 대한 선언
    stmt.setString(1, scheduleDate);
    stmt.setString(2, scheduleTime);
    stmt.setString(3, scheduleMemo);
    stmt.setString(4, scheduleColor);
    stmt.setInt(5, scheduleNo);
    stmt.setString(6, schedulePw);
    
	//디버깅
	System.out.println(stmt +" <--sql");
	
	//영향을 받을 행값
    int row = stmt.executeUpdate();
	//디버깅
	System.out.println(row + " <-- row");
	
	if(row == 0) { // 변경된 행값이 0행이면 비밀번호가 틀린것 폼으로 돌아가 오류메세지 출력
		response.sendRedirect("./updateScheduleForm.jsp?noticeNo="
				+scheduleNo
				+"&msg=incorrect schedulePw");
	} else if(row == 1) {// 행이 1개 변한것으로 수정이 반영되어 리스트로 돌아감
		response.sendRedirect("./scheduleList.jsp");
	} else { // update문 실행을 취소(rollback)해야 한다// 아직배우지 않았음
		System.out.println("error row값 : "+row);
	}

%>	