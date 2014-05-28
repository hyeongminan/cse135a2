<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
<script type="text/javascript" src="js/js.js" language="javascript"></script>
</head>
<body>
<%@ page import="cse135.Util" %>
<%@ page import="java.lang.Math;" %>
<p align = "right"> <a href="login.jsp">Back to options</a> <p>
<%
class Item 
{
	private int id=0;
	private String name=null;
	private float amount_price=0f;
	public int getId() {
		return id; 
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public float getAmount_price() {
		return amount_price;
	}
	public void setAmount_price(float amount_price) {
		this.amount_price = amount_price;
	}
}
ArrayList<Item> p_list=new ArrayList<Item>();
ArrayList<Item> s_list=new ArrayList<Item>();
Item item=null;
Connection conn=null;
Statement stmt,stmt_2,stmt_3, stmt_4,stmt_5;
ResultSet rs=null,rs_2=null,rs_3=null,rs_4=null, rs_5=null;
String SQL=null;
String rows=null, age=null, state=null, category=null, action=null;
String rows_sql=null, age_sql=null, state_sql=null, category_sql=null, action_sql=null;
int row_offset=0, col_offset=0, age_limit;
try
{
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	
	/*
	String url="jdbc:postgresql://127.0.0.1:5432/P1";
	String user="postgres";
	String password="postgres";
	conn =DriverManager.getConnection(url, user, password);
	*/
	/*
	//this one is for local host testing to see if faster than server db
	conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost/P1?" +
            "user=postgres&password=postgres");
	*/
	
    conn = DriverManager.getConnection(
        	        "jdbc:postgresql://" +
        	    	Util.SERVERNAME + ":" +
        	    	Util.PORTNUMBER + "/" +
        	    	Util.DATABASE,
        	    	Util.USERNAME,
        	        Util.PASSWORD);
	stmt =conn.createStatement();
	stmt_2 =conn.createStatement();
	stmt_3 =conn.createStatement();
	stmt_4 = conn.createStatement();
	/**SQL_1 for (state, amount)**/
	
	if(request.getParameter("action") != null)
	{
		if(request.getParameter("row_offset") == null)
			row_offset = 0;
		else
			row_offset = Integer.parseInt(request.getParameter("row_offset"));
		if(request.getParameter("col_offset") == null)
			col_offset = 0;
		else
			col_offset = Integer.parseInt(request.getParameter("col_offset"));
		action = request.getParameter("action");
		rows = request.getParameter("rows");
		age = request.getParameter("age");
		state = request.getParameter("state");
		category = request.getParameter("category");
		
		if(action.equals("Prev20Rows"))
		{
			row_offset = Util.prev_rows(row_offset);
			//Util.prev_rows(session);
		}
		else if(action.equals("Next20Rows"))
		{
			row_offset = Util.next_rows(row_offset);
			//Util.next_rows(session); 
		}
		else if(action.equals("Prev10Cols"))
		{
			col_offset = Util.prev_cols(col_offset);
			//Util.prev_cols(session);
		}
		else if(action.equals("Next10Cols"))
		{
			col_offset = Util.next_cols(col_offset);
			//Util.next_cols(session);
		}
		else
		{
			col_offset = 0;
			row_offset = 0;
			//Util.reset_rows(session);
			//Util.reset_cols(session);
		}
		
	}
	else {
		//Util.reset_rows(session);
		//Util.reset_cols(session);
		col_offset = 0;
		row_offset = 0;
		action = "";
		rows = "customers";
		age = "all";
		state = "all";
		category = "all_categories";
	}
	
	if(rows.equals("customers"))
	{
		rows_sql = "u.name";
	}
	else
	{
		rows_sql = "u.state";
	}
	

	if(age.equals("all"))
	{
		age_sql = "";
	}
	else
	{
		age_limit = Integer.parseInt(age);
		if(age_limit == 0)
		{
			age_sql = "and '" + 12 + "'<=u.age and '" + 18 + "'>=u.age ";
		}
		else if(age_limit == 1)
		{
			age_sql = "and '" + 18 + "'<=u.age and '" + 45 + "'>=u.age ";
		}
		else if(age_limit == 2)
		{
			age_sql = "and '" + 45 + "'<=u.age and '" + 65 + "'>=u.age ";
		}
		else 
		{
			age_sql = "and '" + 65 + "'<=u.age ";
		}
		
	}
	
	if(state.equals("all"))
	{
		state_sql = "";
	}
	else
	{
		state_sql = "and '" + state + "'=u.state ";
	}
	
	if(category.equals("all_categories"))
	{
		category_sql = "and p.cid=c.id ";
	}
	else
	{
		category_sql = "and '" + category + "'=c.name and p.cid=c.id ";
	}
	
	String SQL_1="create temporary table temp1 AS " +
				 "select p.id, p.name, p.price, sum(s.quantity*p.price) as amount from products p, sales s ,users u, categories c "+
				 "where s.uid=u.id and s.pid=p.id "+age_sql+state_sql+category_sql+
				 "group by p.name,p.id,p.price "+
				 "order by  p.name asc "+
				 "limit 10 " +
				 "offset "+ col_offset +
				 ";";
				 
				 
	String SQL_2 = "";
	if(rows.equals("customers"))
	{
		SQL_2="create temporary table temp AS " +
					 "select  "+rows_sql+", sum(s.quantity*p.price) as amount, u.id from users u, sales s,  products p, categories c "+
					 "where s.uid=u.id and s.pid=p.id "+age_sql+state_sql+category_sql+
					 "group by "+rows_sql+", u.id "+ 
					 "order by "+rows_sql+" asc "+
					 "limit 20 " +
					 "offset "+ row_offset +
			   		 ";";
	}
	else
	{
		SQL_2="create temporary table temp AS " +
				 "select  "+rows_sql+", sum(s.quantity*p.price) as amount from users u, sales s,  products p, categories c "+
				 "where s.uid=u.id and s.pid=p.id "+age_sql+state_sql+category_sql+
				 "group by "+rows_sql + " " +  
				 "order by "+rows_sql+" asc "+
				 "limit 20 " +
				 "offset "+ row_offset +
		   		 ";";
	}

	stmt.execute(SQL_1);
	SQL_1 = "select * from temp1;";
	rs=stmt.executeQuery(SQL_1);
	int p_id=0;
	String p_name=null;
	float p_amount_price=0;
	while(rs.next())
	{
		p_id=rs.getInt(1);
		p_name=rs.getString(2);
		p_amount_price=rs.getFloat(4);
		item=new Item();
		item.setId(p_id);
		item.setName(p_name);
		item.setAmount_price(p_amount_price);
		p_list.add(item);
	
	}
	
	stmt.execute(SQL_2);
	SQL_2 = "select * from temp;";
	rs_2=stmt_2.executeQuery(SQL_2);//state not id, many users in one state
	String s_name=null;
	float s_amount_price=0;
	while(rs_2.next())
	{
		s_name=rs_2.getString(1);
		s_amount_price=rs_2.getFloat(2);
		item=new Item();
		item.setName(s_name);
		item.setAmount_price(s_amount_price);
		s_list.add(item);
	}	
	
	String SQL_3 = "";
	
	if(rows.equals("customers"))
	{
		SQL_3 = "select c.name as cname, p.name as pname, sum(p.price * s.quantity) as sale from temp c, temp1 p, sales s " +
				"where s.uid=c.id and s.pid=p.id "+
				"group by c.name, p.name " +
				"order by c.name asc;";
	}
	else
	{
		SQL_3 = "select c.state, p.name, sum(p.price * s.quantity) as sale from temp c, temp1 p, sales s, users u " +
				"where s.uid=u.id and s.pid=p.id and c.state=u.state "+
				"group by c.state, p.name " +
				"order by c.state asc;";
	}
			
	rs_3=stmt_3.executeQuery(SQL_3);
	rs_3.next();
		
	
//    out.println("product #:"+p_list.size()+"<br>state #:"+s_list.size()+"<p>");
	int i=0,j=0;
	int limit1=0, limit2=0;
	//String SQL_3="";	
	float amount=0;
%>
	<table align="center" width="98%" border="1">
		<tr align="center">
			<td><strong><font color="#FF0000"><%=rows%> </font></strong></td>
<%	
	limit1=Math.min(10,p_list.size());
	limit2=Math.min(20,s_list.size());
	for(i=0;i<limit1;i++)
	{
		p_id			=   p_list.get(i).getId();
		p_name			=	p_list.get(i).getName();
		p_amount_price	=	p_list.get(i).getAmount_price();
		out.print("<td> <strong>"+p_name+"<br>["+p_amount_price+"]</strong></td>");
	}
%>
		</tr>
<%	
	boolean rs_3_empty_flag = false;
	for(i=0;i<limit2;i++)
	{
		s_name			=	s_list.get(i).getName();
		s_amount_price	=	s_list.get(i).getAmount_price();
		out.println("<tr  align=\"center\">");
		out.println("<td><strong>"+s_name+"["+s_amount_price+"]</strong></td>");
		
		for(j=0;j<limit1;j++) 
		{
			
			p_id			=   p_list.get(j).getId();
			p_name			=	p_list.get(j).getName();
			
			
			if(!rs_3_empty_flag && s_name.equals(rs_3.getString(1)) && p_name.equals(rs_3.getString(2)))
			{
				out.print("<td><font color='#0000ff'>"+rs_3.getFloat(3)+"</font></td>");
				if(!rs_3.next())
					rs_3_empty_flag = true;
			}
			else
			{
				out.println("<td><font color='#ff0000'>0</font></td>");
			}
			

			/*
			SQL_3="select sum(s.quantity*p.price) as amount from users u, products p, sales s "+
				 "where s.uid=u.id and s.pid=p.id and "+rows_sql+"='"+s_name+"' and p.id='"+p_id+"' group by "+rows_sql+", p.name";

			 rs_3=stmt_3.executeQuery(SQL_3);
			 if(rs_3.next())
			 {
				 amount=rs_3.getFloat(1);
				 out.print("<td><font color='#0000ff'>"+amount+"</font></td>");
			 }
			 else
			 {
			 	out.println("<td><font color='#ff0000'>0</font></td>");
			 }
			 */

		}
		out.println("</tr>");
	}
	
	session.setAttribute("TOP_10_Products",p_list);
	
	if(s_list.size() == 20)
	{
%>
		<tr align="right">
		<!--
			<td colspan="">
				<form method="GET" action="do_Analysis_States_3.jsp" value="Prev20Rows">
					<input type="hidden" name="action" value="Prev20Rows">
					<input type="hidden" name="rows" value="<%=rows%>">
					<input type="hidden" name="age" value="<%=age%>">
					<input type="hidden" name="state" value="<%=state%>">
					<input type="hidden" name="category" value="<%=category%>">
					<input type="submit" value="Previous 20 <%=rows%>">
				</form>
			</td> -->
			<td colspan="11" >
				<form method="GET" action="do_Analysis_States_3.jsp" value="Next20Rows">
					<input type="hidden" name="action" value="Next20Rows">
					<input type="hidden" name="row_offset" value="<%=row_offset%>">					
					<input type="hidden" name="col_offset" value="<%=col_offset%>">
					<input type="hidden" name="rows" value="<%=rows%>">
					<input type="hidden" name="age" value="<%=age%>">
					<input type="hidden" name="state" value="<%=state%>">
					<input type="hidden" name="category" value="<%=category%>">
					<input type="submit" value="Next 20 <%=rows%>">
				</form>
			</td> 
		</tr>
		<%
	}
	if(p_list.size()==10)
	{
		%>
		<tr align="right">
		<!--
			<td colspan="10">
				<form method="GET" action="do_Analysis_States_3.jsp" value="Prev10Cols">
					<input type="hidden" name="action" value="Prev10Cols">
					<input type="hidden" name="rows" value="<%=rows%>">
					<input type="hidden" name="age" value="<%=age%>">
					<input type="hidden" name="state" value="<%=state%>">
					<input type="hidden" name="category" value="<%=category%>">
					<input type="submit" value="Previous 10 Products">
				</form>
			</td> -->
			
			<td colspan="11">
				<form method="GET" action="do_Analysis_States_3.jsp" value="Next10Cols">
					<input type="hidden" name="action" value="Next10Cols">
					<input type="hidden" name="row_offset" value="<%=row_offset%>">					
					<input type="hidden" name="col_offset" value="<%=col_offset%>">
					<input type="hidden" name="rows" value="<%=rows%>">
					<input type="hidden" name="age" value="<%=age%>">
					<input type="hidden" name="state" value="<%=state%>">
					<input type="hidden" name="category" value="<%=category%>">
					<input type="submit" value="Next 10 Products">
				</form>
			</td>
		</tr>
		<%
	}
		%>
	</table>
	<% 
	if(!(action.equals("Next20Rows") || action.equals("Next10Cols")))
	{
	%>
	<form method="GET" action="do_Analysis_States_3.jsp">
	
		<h3> Row Selection </h3>
		
		Row:
				<select name="rows">
		
				<option value="customers" <%=Util.selector("customer",rows)%>>Customers</option>
				<option value="states" <%=Util.selector("states",rows)%>>States</option>
				
				</select> <p />
				
		<h3> Filters </h3>
				
				
		Age:
			<select name="age" value="<%=age%>">
				<option value="all" <%=Util.selector("all",age)%>>All</option>
				<option value="0" <%=Util.selector("0",age)%>>12-18</option>
				<option value="1" <%=Util.selector("1",age)%>>18-45</option>
				<option value="2" <%=Util.selector("2",age)%>>45-65</option>
				<option value="3" <%=Util.selector("3",age)%>>65-</option>
			</select> <p/>
		
		State: 
			<select name="state">
				<option value="all" <%=Util.selector("all",state)%>>All States</option>
				<option value="Alaska" <%=Util.selector("Alaska",state)%>>Alaska</option>
				<option value="Arizona" <%=Util.selector("Arizona",state)%>>Arizona</option> 
				<option value="Arkansas" <%=Util.selector("Arkansas",state)%>>Arkansas</option> 
				<option value="California" <%=Util.selector("California",state)%>>California</option> 
				<option value="Colorado" <%=Util.selector("Colorado",state)%>>Colorado</option> 
				<option value="Connecticut" <%=Util.selector("Connecticut",state)%>>Connecticut</option> 
				<option value="Delaware" <%=Util.selector("Delaware",state)%>>Delaware</option> 
				<option value="Florida" <%=Util.selector("Florida",state)%>>Florida</option> 
				<option value="Georgia" <%=Util.selector("Georgia",state)%>>Georgia</option> 
				<option value="Hawaii" <%=Util.selector("Hawaii",state)%>>Hawaii</option> 
				<option value="Idaho" <%=Util.selector("Idaho",state)%>>Idaho</option> 
				<option value="Illinois" <%=Util.selector("Illinois",state)%>>Illinois</option> 
				<option value="Indiana" <%=Util.selector("Indiana",state)%>>Indiana</option> 
				<option value="Iowa" <%=Util.selector("Iowa",state)%>>Iowa</option> 
				<option value="Kansas" <%=Util.selector("Kansas",state)%>>Kansas</option> 
				<option value="Kentucky" <%=Util.selector("Kentucky",state)%>>Kentucky</option> 
				<option value="Louisiana" <%=Util.selector("Louisiana",state)%>>Louisiana</option> 
				<option value="Maine" <%=Util.selector("Maine",state)%>>Maine</option> 
				<option value="Maryland" <%=Util.selector("Maryland",state)%>>Maryland</option> 
				<option value="Massachusetts" <%=Util.selector("Massachusetts",state)%>>Massachusetts</option> 
				<option value="Michigan" <%=Util.selector("Michigan",state)%>>Michigan</option> 
				<option value="Minnesota" <%=Util.selector("Minnesota",state)%>>Minnesota</option> 
				<option value="Mississippi" <%=Util.selector("Mississippi",state)%>>Mississippi</option> 
				<option value="Missouri" <%=Util.selector("Missouri",state)%>>Missouri</option> 
				<option value="Montana" <%=Util.selector("Montana",state)%>>Montana</option> 
				<option value="Nebraska" <%=Util.selector("Nebraska",state)%>>Nebraska</option> 
				<option value="Nevada" <%=Util.selector("Nevada",state)%>>Nevada</option> 
				<option value="New Hampshire" <%=Util.selector("New Hampshire",state)%>>New Hampshire</option> 
				<option value="New Jersey" <%=Util.selector("New Jersey",state)%>>New Jersey</option> 
				<option value="New Mexico" <%=Util.selector("New Mexico",state)%>>New Mexico</option>
				<option value="New York" <%=Util.selector("New York",state)%>>New York</option>
			 	<option value="North Carolina" <%=Util.selector("North Carolina",state)%>>North Carolina</option> 
			 	<option value="North Dakota" <%=Util.selector("North Dakota",state)%>>North Dakota</option> 
			 	<option value="Ohio" <%=Util.selector("Ohio",state)%>>Ohio</option> 
			 	<option value="Oklahoma" <%=Util.selector("Oklahoma",state)%>>Oklahoma</option> 
			 	<option value="Oregon" <%=Util.selector("Oregon",state)%>>Oregon</option> 
			 	<option value="Pennsylvania" <%=Util.selector("Pennsylvania",state)%>>Pennsylvania</option> 
			 	<option value="Rhode Island" <%=Util.selector("Rhode Island",state)%>>Rhode Island</option> 
			 	<option value="South Carolina" <%=Util.selector("South Carolina",state)%>>South Carolina</option> 
			 	<option value="South Dakota" <%=Util.selector("South Dakota",state)%>>South Dakota</option> 
			 	<option value="Tennessee" <%=Util.selector("Tennessee",state)%>>Tennessee</option> 
			 	<option value="Texas" <%=Util.selector("Texas",state)%>>Texas</option> 
			 	<option value="Utah" <%=Util.selector("Utah",state)%>>Utah</option> 
			 	<option value="Vermont" <%=Util.selector("Vermont",state)%>>Vermont</option> 
			 	<option value="Virginia" <%=Util.selector("Virginia",state)%>>Virginia</option> 
			 	<option value="Washington" <%=Util.selector("Washington",state)%>>Washington</option> 
			 	<option value="West Virginia" <%=Util.selector("West Virginia",state)%>>West Virginia</option> 
			 	<option value="Wisconsin" <%=Util.selector("Wisconsin",state)%>>Wisconsin</option> 
			 	<option value="Wyoming" <%=Util.selector("Wyoming",state)%>>Wyoming</option> 
			</select> <p />
			
			
		
			
		Category:
			
			<select name="category">
				<option value="all_categories" selected="selected">All Categories</option>
				<%  //query for categories
					rs_4 = stmt_4.executeQuery("SELECT * FROM categories");
					ArrayList<String> categories = new ArrayList<String>();
				%>
				<%
				while(rs_4.next())
				{
					String cat = rs_4.getString("name");
					categories.add(cat);
				%>
					<option value="<%=cat%>" <%=Util.selector(cat,category)%>><%=cat%></option>
				<% 
				} 
				%>
			</select> <p/>
			
			
	<input type="submit" name="action" value="Run Query"/>
<%
	}
}
catch(Exception e)
{
	//out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");
  out.println(e.getMessage());
}
finally
{
	conn.close();
}	
%>	
</body>
</html>