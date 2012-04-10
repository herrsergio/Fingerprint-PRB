<%!
    String getDataset(String psCurrentYear, String psPeriod, String psWeek, String msDay)
    {
        String lsQuery;
		String selectedDate;

		System.out.println("psCurrentYear: "+psCurrentYear+", psPeriod: "+psPeriod+", psWeek: "+psWeek+", msDay: "+msDay);
        
		lsQuery = "SELECT to_char(date_id, 'YYYY-MM-DD') AS begindate " +
		          "FROM ss_cat_time WHERE year_no="+msYear+" AND period_no="+msPeriod+" AND "+
				  "week_no="+msWeek+" AND weekday_id IN (SELECT weekday_id FROM ss_cat_time "+
				  "WHERE year_no="+msYear+" AND period_no="+msPeriod+" AND "+
				  "week_no="+msWeek+" AND EXTRACT(day FROM date_id) = " + msDay + ")";

		selectedDate = moAbcUtils.queryToString(lsQuery);

		System.out.println("selectedDate : "+selectedDate);
		
        lsQuery = "SELECT ppc.emp_num, "+
                   "ppe.name||' '||ppe.last_name AS nombre, "+
                   "(SELECT EXTRACT(HOUR "+
                   "FROM CAST(ppc.timein1 AS TIMESTAMP))||':'||"+
                   "(SELECT EXTRACT(MINUTE "+
                   "FROM CAST(ppc.timein1 AS TIMESTAMP)))||':'|| "+
                   "(SELECT EXTRACT(SECOND "+
                   "FROM CAST(ppc.timein1 AS TIMESTAMP)))) AS Timein1, "+
                   "(SELECT EXTRACT(HOUR "+
                   "FROM CAST(ppc.timeout1 AS TIMESTAMP))||':'|| "+
                   "(SELECT EXTRACT(MINUTE "+
                   "FROM CAST(ppc.timeout1 AS TIMESTAMP)))||':'|| "+
                   "(SELECT EXTRACT(SECOND "+
                   "FROM CAST(ppc.timeout1 AS TIMESTAMP)))) AS Timeout1, "+
                   "(SELECT EXTRACT(HOUR "+
                   "FROM CAST(ppc.timein2 AS TIMESTAMP))||':'|| "+
                   "(SELECT EXTRACT(MINUTE "+
                   "FROM CAST(ppc.timein2 AS TIMESTAMP)))||':'|| "+
                   "(SELECT EXTRACT(SECOND "+
                   "FROM CAST(ppc.timein2 AS TIMESTAMP)))) AS Timein2, "+
                   "(SELECT EXTRACT(HOUR "+
                   "FROM CAST(ppc.timeout2 AS TIMESTAMP))||':'|| "+
                   "(SELECT EXTRACT(MINUTE "+
                   "FROM CAST(ppc.timeout2 AS TIMESTAMP)))||':'|| "+
                   "(SELECT EXTRACT(SECOND "+
                   "FROM CAST(ppc.timeout2 AS TIMESTAMP)))) AS Timeout2, "+
                   //"(SELECT age(CAST(ppc.timeout1 AS TIMESTAMP), CAST(ppc.timein1 AS TIMESTAMP))) AS Total "+
				   "(SELECT total_worked_hours(CAST(ppc.timein1 as varchar), CAST(ppc.timeout1 as varchar), "+
				   "CAST(ppc.timein2 as varchar), CAST(ppc.timeout2 as varchar))) AS Total "+
                   "FROM pp_emp_check ppc "+
                   "INNER JOIN pp_employees ppe ON (ppe.emp_num=ppc.emp_num) "+
                   "WHERE date_id='"+selectedDate+"' " +
                   "ORDER BY emp_num DESC ";
		System.out.println("query: "+lsQuery);



        /*
        lsQuery = "SELECT ppc.emp_num, ppe.name||' '||ppe.last_name AS nombre, ppc.timein1, ppc.timeout1, ppc.timein2, ppc.timeout2 "+
		          "FROM pp_emp_check ppc INNER JOIN pp_employees ppe ON (ppe.emp_num=ppc.emp_num) "+
				  "WHERE date_id='"+selectedDate+"' ORDER BY emp_num DESC";
        */

        return moAbcUtils.getJSResultSet(lsQuery);
    }

%>
