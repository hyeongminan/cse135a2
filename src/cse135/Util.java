package cse135;

import javax.servlet.http.*;
//import java

public class Util {

	/*
	public static final String SERVERNAME = "ec2-54-187-115-171.us-west-2.compute.amazonaws.com";
	public static final String USERNAME = "ubuntu";
	public static final String PASSWORD = "ubuntu";
	public static final String DATABASE = "cse135";
	public static final String PORTNUMBER = "5432";
	*/
	public static final String SERVERNAME = "localhost";
	public static final String USERNAME = "postgres";
	public static final String PASSWORD = "postgres";
	public static final String DATABASE = "P1";
	public static final String PORTNUMBER = "5432";
	
	
	public static final String greeting(String username)
	{
		return "Hello " + username;
	}
	
	
	public static final void prev_rows(HttpSession session)
	{
		int offset = 0;
		if(session.getAttribute("row_offset") == null)
		{
			offset = 0;
		}
		else
		{
			offset = Integer.parseInt((String)session.getAttribute("row_offset")) - 20;
		}
		if (offset < 0)
		{
			offset = 0;
		}
		session.setAttribute("row_offset", Integer.toString(offset));
	}
	
	
	public static final void prev_cols(HttpSession session)
	{
		int offset = 0;
		if(session.getAttribute("col_offset") == null)
		{
			
			offset = 0;
		}
		else
		{
			offset = Integer.parseInt((String)session.getAttribute("col_offset")) - 10;
		}
		if (offset < 0)
		{
			offset = 0;
		}
		session.setAttribute("col_offset", Integer.toString(offset));
	}
	
	
	public static final void next_rows(HttpSession session)
	{
		int offset = 0;
		if(session.getAttribute("row_offset") == null)
		{
			offset = 20;
		}
		else
		{
			offset = Integer.parseInt((String)session.getAttribute("row_offset")) + 20;
		}
		session.setAttribute("row_offset", Integer.toString(offset));
	}
	
	
	public static final void next_cols(HttpSession session)
	{
		int offset = 0;
		if(session.getAttribute("col_offset") == null)
		{
			offset = 10;
		}
		else
		{
			offset = Integer.parseInt((String)session.getAttribute("col_offset")) + 10;
		}
		session.setAttribute("col_offset", Integer.toString(offset));
	}
	
	
	public static final void reset_rows(HttpSession session)
	{
		int reset = 0;
		session.setAttribute("row_offset", Integer.toString(reset));
	}
	
	
	public static final void reset_cols(HttpSession session)
	{
		int reset = 0;
		session.setAttribute("col_offset", Integer.toString(reset));
	}
	
	
	public static final boolean isLoggedin(HttpSession session)
	{
		if(session.getAttribute("username") != null)
		{
			return true;
		}
		return false;
	}
	
	
	public static final boolean isOwner(HttpSession session)
	{
		if(isLoggedin(session) && session.getAttribute("role").equals("owner"))
		{
			return true;
		}
		return false;
	}
	
	
	public static final boolean isCustomer(HttpSession session)
	{
		if(isLoggedin(session) && session.getAttribute("role").equals("customer"))
		{
			return true;
		}
		return false;
	}
	
	
}
