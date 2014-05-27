<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
<script type="text/javascript" src="js/js.js" language="javascript"></script>
</head>
<body>
<%@ page import="cse135.Util" %>
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
Statement stmt,stmt_2,stmt_3, stmt_4;
ResultSet rs=null,rs_2=null,rs_3=null,rs_4=null;
String SQL=null;
String rows=null, age=null, state=null, category=null, action=null;
String rows_sql=null, age_sql=null, state_sql=null, category_sql=null, action_sql=null;
int age_min, age_max;
try
{
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	/*String url="jdbc:postgresql://127.0.0.1:5432/P1";
	String user="postgres";
	String password="880210";
	conn =DriverManager.getConnection(url, user, password);
	
	//this one is for local host testing to see if faster than server db
	conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost/P1?" +
            "user=postgres&password=postgres");*/
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
		action = request.getParameter("action");
		rows = request.getParameter("rows");
		age = request.getParameter("age");
		state = request.getParameter("state");
		category = request.getParameter("category");
		
		if(action.equals("Prev20Rows"))
		{
			Util.prev_rows(session);
		}
		else if(action.equals("Next20Rows"))
		{
			Util.next_rows(session); 
		}
		else if(action.equals("Prev10Cols"))
		{
			Util.prev_cols(session);
		}
		else if(action.equals("Next10Cols"))
		{
			Util.next_cols(session);
		}
		else
		{
			Util.reset_rows(session);
			Util.reset_cols(session);
		}
		
	}
	else {
		Util.reset_rows(session);
		Util.reset_cols(session);
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
		age_min = Integer.parseInt(age);
		age_min = 10*age_min;
		age_max = age_min + 9;
		age_sql = "and '" + age_min + "'<=u.age and '" + age_max + "'>=u.age ";
	}
	
	if(state.equals("all"))
	{
		state_sql = "";
	}
	else
	{
		state_sql = "and '" + state + "'=u.state";
	}
	
	if(category.equals("all_categories"))
	{
		category_sql = "";
	}
	else
	{
		category_sql = "and '" + category + "'=p.name ";
	}
	
	String SQL_1="select p.id, p.name, sum(s.quantity*p.price) as amount from products p, sales s "+
				 "where s.pid=p.id "+age_sql+state_sql+category_sql+
				 "group by p.name,p.id "+
				 "order by  p.name asc "+
				 "limit 10 " +
				 "offset "+ session.getAttribute("col_offset") +
				 ";";
	String SQL_2="select  "+rows_sql+", sum(s.quantity*p.price) as amount from users u, sales s,  products p "+
				  "where s.uid=u.id and s.pid=p.id "+age_sql+state_sql+category_sql+
				  "group by "+rows_sql+" "+ 
				  "order by "+rows_sql+" asc "+
				  "limit 20 " +
				  "offset "+ session.getAttribute("row_offset") +
		   		  ";";

	rs=stmt.executeQuery(SQL_1);
	int p_id=0;
	String p_name=null;
	float p_amount_price=0;
	while(rs.next())
	{
		p_id=rs.getInt(1);
		p_name=rs.getString(2);
		p_amount_price=rs.getFloat(3);
		item=new Item();
		item.setId(p_id);
		item.setName(p_name);
		item.setAmount_price(p_amount_price);
		p_list.add(item);
	
	}
	
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
//    out.println("product #:"+p_list.size()+"<br>state #:"+s_list.size()+"<p>");
	int i=0,j=0;
	String SQL_3="";	
	float amount=0;
%>
	<table align="center" width="98%" border="1">
		<tr align="center">
			<td><strong><font color="#FF0000"><%=rows%> </font></strong></td>
<%	
	for(i=0;i<p_list.size();i++)
	{
		p_id			=   p_list.get(i).getId();
		p_name			=	p_list.get(i).getName();
		p_amount_price	=	p_list.get(i).getAmount_price();
		out.print("<td> <strong>"+p_name+"<br>["+p_amount_price+"]</strong></td>");
	}
%>
		</tr>
<%	
	for(i=0;i<s_list.size();i++)
	{
		s_name			=	s_list.get(i).getName();
		s_amount_price	=	s_list.get(i).getAmount_price();
		out.println("<tr  align=\"center\">");
		out.println("<td><strong>"+s_name+"["+s_amount_price+"]</strong></td>");
		for(j=0;j<p_list.size();j++) 
		{
			p_id			=   p_list.get(j).getId();
			p_name			=	p_list.get(j).getName();
			p_amount_price	=	p_list.get(j).getAmount_price();
			
			SQL_3="select sum(s.quantity*p.price) as amount from users u, products p, sales s "+
				 "where s.uid=u.id and s.pid=p.id and u.state='"+s_name+"' and p.id='"+p_id+"' group by u.state, p.name";

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

		}
		out.println("</tr>");
	}
	
	session.setAttribute("TOP_10_Products",p_list);
%>
		<tr>
			<td colspan="5">
				<form method="GET" action="do_Analysis_States_3.jsp" value="Prev20Rows">
					<input type="hidden" name="action" value="Prev20Rows">
					<input type="hidden" name="rows" value="<%=rows%>">
					<input type="hidden" name="age" value="<%=age%>">
					<input type="hidden" name="state" value="<%=state%>">
					<input type="hidden" name="category" value="<%=category%>">
					<input type="submit" value="Previous 20 <%=rows%>">
				</form>
			</td>
			<td colspan="6">
				<form method="GET" action="do_Analysis_States_3.jsp" value="Next20Rows">
					<input type="hidden" name="action" value="Next20Rows">
					<input type="hidden" name="rows" value="<%=rows%>">
					<input type="hidden" name="age" value="<%=age%>">
					<input type="hidden" name="state" value="<%=state%>">
					<input type="hidden" name="category" value="<%=category%>">
					<input type="submit" value="Next 20 <%=rows%>">
				</form>
			</td>
		</tr>
		<tr>
			<td colspan="5">
				<form method="GET" action="do_Analysis_States_3.jsp" value="Prev10Cols">
					<input type="hidden" name="action" value="Prev10Cols">
					<input type="hidden" name="rows" value="<%=rows%>">
					<input type="hidden" name="age" value="<%=age%>">
					<input type="hidden" name="state" value="<%=state%>">
					<input type="hidden" name="category" value="<%=category%>">
					<input type="submit" value="Previous 10 Products">
				</form>
			</td>
			<td colspan="6">
				<form method="GET" action="do_Analysis_States_3.jsp" value="Next10Cols">
					<input type="hidden" name="action" value="Next10Cols">
					<input type="hidden" name="rows" value="<%=rows%>">
					<input type="hidden" name="age" value="<%=age%>">
					<input type="hidden" name="state" value="<%=state%>">
					<input type="hidden" name="category" value="<%=category%>">
					<input type="submit" value="Next 10 Products">
				</form>
			</td>
		</tr>
	</table>
	
	<form method="GET" action="do_Analysis_States_3.jsp">
	
		<h3> Row Selection </h3>
		
		Row:
				<select name="rows">
		
				<option value="customers">Customers</option>
				<option value="states">States</option>
				
				</select> <p />
				
		<h3> Filters </h3>
				
		Age:
			<select name="age">
				<option value="all" selected="selected">All</option>
				<option value="0">0-9</option>
				<option value="1">10-19</option>
				<option value="2">20-29</option>
				<option value="3">30-39</option>
				<option value="4">40-49</option>
				<option value="5">50-59</option>
				<option value="6">60-69</option>
				<option value="7">70-79</option>
				<option value="8">80-89</option>
				<option value="9">90-99</option>
			</select> <p/>
		
		State: 
			<select name="state">
				<option value="all">All States</option>
				<option value="al">AL</option>
				<option value="ak">AK</option>
				<option value="az">AZ</option>
				<option value="ar">AR</option>
				<option value="ca">CA</option>
				<option value="co">CO</option>
				<option value="ct">CT</option>
				<option value="de">DE</option>
				<option value="dc">DC</option>
				<option value="fl">FL</option>
				<option value="ga">GA</option>
				<option value="hi">HI</option>
				<option value="id">ID</option>
				<option value="il">IL</option>
				<option value="ia">IA</option>
				<option value="in">IN</option>
				<option value="ks">KS</option>
				<option value="ky">KY</option>
				<option value="la">LA</option>
				<option value="me">ME</option>
				<option value="md">MD</option>
				<option value="ma">MA</option>
				<option value="mi">MI</option>
				<option value="mn">MN</option>
				<option value="ms">MS</option>
				<option value="mo">MO</option>
				<option value="mt">MT</option>
				<option value="ne">NE</option>
				<option value="nv">NV</option>
				<option value="nh">NH</option>
				<option value="nm">NM</option>
				<option value="my">MY</option>
				<option value="nc">NC</option>
				<option value="nd">ND</option>
				<option value="oh">OH</option>
				<option value="ok">OK</option>
				<option value="or">OR</option>
				<option value="pa">PA</option>
				<option value="ri">RI</option>
				<option value="sc">SC</option>
				<option value="sd">SD</option>
				<option value="tn">TN</option>
				<option value="tx">TX</option>
				<option value="ut">UT</option>
				<option value="vt">VT</option>
				<option value="va">VA</option>
				<option value="wa">WA</option>
				<option value="wv">WV</option>
				<option value="wi">WI</option>
				<option value="wy">WY</option>			
			</select> <p />
			
			
		
			
		Category:
			
			<select name="category">
				<option value="all_categories">All Categories</option>
				<%  //query for categories
					rs_4 = stmt_4.executeQuery("SELECT * FROM categories");
					ArrayList<String> categories = new ArrayList<String>();
				%>
				<%
				while(rs_4.next())
				{
					categories.add(rs_4.getString("name"));
				%>
					<option value="<%=rs_4.getString("name")%>"><%=rs_4.getString("name")%></option>
				<% 
				} 
				%>
			</select> <p/>
			
			
	<input type="submit" name="action" value="Run Query"/>
<%
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