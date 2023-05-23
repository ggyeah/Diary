<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<% 
    int targetYear = 0;
    int targetMonth = 0;
    //년이나 월이 요청값에 넘어오지 않으면 오늘 날짜의 년/월 값으로 출력됨
    if (request.getParameter("targetYear") == null 
    		|| (request.getParameter("targetMonth") == null)) {
   		Calendar c = Calendar.getInstance();
    	targetYear = c.get(Calendar.YEAR);
    	targetMonth = c.get(Calendar.MONTH);
    } else { 
    	targetYear = Integer.parseInt(request.getParameter("targetYear"));
    	targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
    }
    System.out.println(targetYear + "<-- scheduleList parem targetYear");
    System.out.println(targetMonth + "<-- scheduleList parem targetMonth");
    
    // 오늘날짜 받아옴
    Calendar today = Calendar.getInstance();
    int todayDate = today.get(Calendar.DATE);
    
    //targetMonth 1일의 요일
    Calendar firstDay = Calendar.getInstance(); //2023.04.24
   	firstDay.set(Calendar.YEAR, targetYear);
	firstDay.set(Calendar.MONTH, targetMonth); 
	firstDay.set(Calendar.DATE, 1); //2023.04.01
	
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK); //2023.04.01 몇번째 요일인지, 일1, 토7
    
	 // 년23월12 입력 Calendar API 년24 월1변경
	 // 년23월-1 입력 Calendar API 년22 월12 변경
	 targetYear = firstDay.get(Calendar.YEAR);
	 targetMonth = firstDay.get(Calendar.MONTH);

	//1일앞의 공백칸의 수 
    int startBlank = firstYoil -1;
    System.out.println(startBlank + "<-- startBlank");
    
    //targetMonth 마지막일
    int lastDate = firstDay.getActualMaximum(Calendar.DATE);
    System.out.println(lastDate + "<-- lastDate");
    
    //출력하고자 하는달 전달의 마지막날짜
    Calendar secondDate = Calendar.getInstance();
    secondDate.set(Calendar.YEAR, targetYear);
    secondDate.set(Calendar.MONTH, targetMonth-1);
    int lastmonth = secondDate.getActualMaximum(Calendar.DATE);
    
    //전체 TD의 7의 나머지 값은 0
    //lastDate날짜 뒤 공백칸의 수
    //(lastDate + ?) % 7 == 0;
	int endBlank = 0;
	if((startBlank + lastDate) % 7 != 0) {
		endBlank = 7-(startBlank+lastDate)%7;
	}
	//전체 TD의 개수
	int totalTD = startBlank + lastDate + endBlank;
	 System.out.println(totalTD + "<-- totalTD");
	 
	 //db연결
	 Class.forName("org.mariadb.jdbc.Driver");
  	 Connection conn = DriverManager.getConnection(
         "jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
  	 
  	 /*
  	 "select schedule_no scheduleNo, day(schedule_date) scheduleDate, substr(schedule_memo, 1, 5) scheduleMemo 
  	 , schedule_color scheduleColor 
  	 from schedule 
  	 where year(schedule_date) = ? and month (schedule_date) = ? 
  	 order by month (schedule_date) asc"
  	 */
  	 
  	  PreparedStatement stmt = conn.prepareStatement("select schedule_no scheduleNo, day(schedule_date) scheduleDate, substr(schedule_memo, 1, 5) scheduleMemo, schedule_color scheduleColor from schedule where year(schedule_date) = ? and month (schedule_date) = ? order by month (schedule_date) asc");
  	  stmt.setInt(1, targetYear);
  	  stmt.setInt(2, targetMonth+1);
  	  System.out.println(stmt + " <-- stmt");
  	  ResultSet rs = stmt.executeQuery();
  	  // ResultSet -> ArrayList<Schedule>
  	  ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
  	 while(rs.next()) {
  		  Schedule s = new Schedule();
  	      s.scheduleNo = rs.getInt("scheduleNo");
  	   	  s.scheduleDate = rs.getString("scheduleDate"); // 전체 날짜가 아닌 일(Day)값만
  	      s.scheduleMemo = rs.getString("scheduleMemo"); // 전체메모가 아닌 5자만
  	      s.scheduleColor = rs.getString("scheduleColor");
	  	  scheduleList.add(s);
	  	  }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleList</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="container">
   <div><!-- 메인메뉴 -->
      <a href="./home.jsp" class="btn btn-outline-dark">홈으로</a>
      <a href="./noticeList.jsp" class="btn btn-outline-dark" >공지 리스트</a>
      <a href="./scheduleList.jsp" class="btn btn-outline-dark" >일정 리스트</a>
   </div>
   <h1 class="container text-center text-nowrap">
    <a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>" class="btn btn-secondary">이전달</a>
    <%=targetYear%>년 <%=targetMonth+1%>월
   	<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>" class="btn btn-secondary">다음달</a>
  </h1>
   <div>
   <table class="table table-bordered container">
         <thead>
         <tr class="table-info">
            <th>일요일</th>
            <th>월요일</th>
            <th>화요일</th>
            <th>수요일</th>
            <th>목요일</th>
            <th>금요일</th>
            <th>토요일</th>      
         </tr>
      </thead>
   		<tr>
     <tr class ="w-100 p-3">
         <%
            for(int i=0; i<totalTD; i+=1) {
               int num = i-startBlank+1;
               
               if(i != 0 && i%7==0) {
         %>
                  </tr><tr>
         <%         
				}
				String tdStyle = "";
				if(num>0 && num<=lastDate) {	
					// 오늘 날짜이면
					if(today.get(Calendar.YEAR) == targetYear 
						&& today.get(Calendar.MONTH) == targetMonth
						&& today.get(Calendar.DATE) == num) {
						tdStyle = "background-color:#D4F4FA;";
					}	
		%>
						<td style="<%=tdStyle%>">
						<div><!--날짜 숫자 -->
						<a href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>"><%=num%></a>	
						</div>
						<div><!--일정 memo (5글자만) -->
						<%
							for(Schedule s : scheduleList) {
								if (num == Integer.parseInt(s.scheduleDate)) {
						%>
							<div style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo%></div>
						<%		
								}
							}
						%>
						</div>
						
						</td>	
		<%	
					
				} else {
					 if ( num <= lastDate) {
		%>	
				 <td class="text-black-50"><%= num+lastmonth %></td>
		<% 			} else {
		%>			
				 <td class="text-black-50"><%= num-lastDate %></td>
		<%			
				}
			}
            }
		%>
	</tr>

   </table>
   </div>
</body>
</html>