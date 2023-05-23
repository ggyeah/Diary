<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<% 	//1. request 인코딩 설정// 글씨가 깨지지 않도록
	request.setCharacterEncoding("UTF-8");

	//2. 디버깅 form에서 넘긴 4개의 값을 확인 (form에서 name 지정된 값)
	System.out.println(request.getParameter("storeNo")
			+" <-- updateNoticeAction noticeNo");
	System.out.println(request.getParameter("noticeTitle")
			+" <-- updateNoticeAction noticeTitle");
	System.out.println(request.getParameter("noticeContent")
			+" <-- updateNoticeAction noticeContent");
	System.out.println(request.getParameter("noticePw")
			+" <-- updateNoticeAction noticePw");
	
	String msg = null; // no은 메세지 출력이 안되서 제외함
	if(request.getParameter("noticeTitle")==null 
			|| request.getParameter("noticeTitle").equals("")) {
			msg = "noticeTitle is required";
	} else if(request.getParameter("noticeContent")==null 
			|| request.getParameter("noticeContent").equals("")) {
			msg = "noticeContent is required";
	} else if(request.getParameter("noticePw")==null 
			|| request.getParameter("noticePw").equals("")) {
			msg = "noticePw is required";
	}
	if(msg != null) { // noticeNo가 null or 위의 ifelse문에 하나라도 해당된다
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="
								+request.getParameter("noticeNo")
								+"&msg="+msg);
        return;
	}
	//4. 요청값들을 변수에 할당(형면환)
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
    String noticeTitle = request.getParameter("noticeTitle");
    String noticeContent = request.getParameter("noticeContent");
   
    //4번에 대한 디버깅
    System.out.println(noticeNo + " <-- updateNoticeAction noticeNo");
	System.out.println(noticePw + " <-- updateNoticeAction noticePw");
 	System.out.println(noticeTitle + " <-- updateNoticeAction noticeTitle");
	System.out.println(noticeContent + " <-- updateNoticeAction noticeContent");
		
	// 장치드라이버를 로딩	
	Class.forName("org.mariadb.jdbc.Driver");
	// 로그인 후 접속정보 반환받음
	Connection conn = DriverManager.getConnection(
				"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 5. mariadb RDBS에 update문을 전송
	String sql = "UPDATE notice SET notice_title = ? , notice_content = ?, updatedate = now() WHERE notice_no=? and notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,noticeTitle);
	stmt.setString(2,noticeContent);
	stmt.setInt(3, noticeNo);
	stmt.setString(4, noticePw);
	//디버깅
	System.out.println(stmt +" <-- updateNoticeAction sql");
	
	//영향받은 행의 수 
	int row = stmt.executeUpdate(); 
	
	// 디버깅
	System.out.println(row + " <-- updateNoticeAction row");
   // 6. 5번에 결과에 페이지(View)를 분기한다
	if(row == 0) {
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="
				+request.getParameter("noticeNo")
				+"&msg=incorrect noticePw");
	} else if(row == 1) {
		response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo);
	} else {
		// update문 실행을 취소(rollback)해야 한다
		System.out.println("error row값 : "+row);
	}

%>