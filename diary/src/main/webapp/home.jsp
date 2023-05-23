<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- css -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="container">
   <div><!-- 메인메뉴 -->
      <a href="./home.jsp" class="btn btn-outline-dark">홈으로</a>
      <a href="./noticeList.jsp" class="btn btn-outline-dark" >공지 리스트</a>
      <a href="./scheduleList.jsp" class="btn btn-outline-dark" >일정 리스트</a>
   </div>
   
   <!-- 날짜순 최근 공지 5개 & 오늘 일정(모두)-->
   <%
	  //1) 장치드라이버를 로딩
      Class.forName("org.mariadb.jdbc.Driver");
      //2) 로그인 후 접속정보 반환받음
      Connection conn = DriverManager.getConnection(
            "jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
      // 최근 공지 5개만 출력
      String sql1 = "select notice_no, notice_title, createdate from notice order by createdate desc limit 0, 5";
      PreparedStatement stmt1 = conn.prepareStatement(sql1); // 
      System.out.println(stmt1 + " <-- stmt1");
      ResultSet rs1 = stmt1.executeQuery();
      
      // 오늘 일정출력 //현재날짜출력 : curdate()
      String sql2 = "select schedule_no, schedule_date, schedule_time, substr(schedule_memo,1,10) memo from schedule where schedule_date = curdate() order by schedule_time asc";
      PreparedStatement stmt2 = conn.prepareStatement(sql2);
      System.out.println(stmt2 + " <-- stmt2");
      ResultSet rs2 = stmt2.executeQuery();
   %>
   <h2 class="text-center">공지사항</h2>
   <table  class="table table-bordered">
      <tr class="table-info">
         <th>제목</th>
         <th>작성일</th>
      </tr>
      <% 
         while(rs1.next()) {
      %>
         <tr>
            <td>
               <a href="./noticeOne.jsp?noticeNo=<%=rs1.getInt("notice_no")%>">
                  <%=rs1.getString("notice_title")%>
               </a>
            </td>
            <td><%=rs1.getString("createdate").substring(0, 10)%></td>
         </tr>
      <%      
         }
      %>
   </table>
   
      <h2 class="text-center">오늘일정</h2>
   <table  class="table table-bordered container">
      <tr class="table-info">
         <th>날짜</th>
         <th>시간</th>
         <th>메모</th>
      </tr>
      <%
         while(rs2.next()) {
      %>
         <tr>
            <td>
               <%=rs2.getString("schedule_date")%>
            </td>
            <td><%=rs2.getString("schedule_time")%></td>
            <td>
               <a href="./scheduleOne.jsp?scheduleNo=<%=rs2.getInt("schedule_no")%>">
                  <%=rs2.getString("memo")%>
               </a>
            </td>
         </tr>
      <%      
         }
      %>
   </table>
</body>
</html>