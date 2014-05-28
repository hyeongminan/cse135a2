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
	public static final String USERNAME = "ehdee";
	public static final String PASSWORD = "ehdee";
	public static final String DATABASE = "p1";
	public static final String PORTNUMBER = "5432";
	
	
	public static final String greeting(String username)
	{
		return "Hello " + username;
	}
	
	public static final String selector(String selected, String passed_through)
	{
		if(selected.equals(passed_through))
			return "selected=\"selected\"";
		else
			return "";
	}
	
	public static final int prev_rows(int row_offset)
	{
		int offset = 0;
		if(row_offset == 0)
		{
			offset = 0;
		}
		else
		{
			offset = row_offset - 20;
		}
		if (offset < 0)
		{
			offset = 0;
		}
		return offset;
	}
	
	
	public static final int prev_cols(int col_offset)
	{
		int offset = 0;
		if(col_offset == 0)
		{
			
			offset = 0;
		}
		else
		{
			offset = col_offset - 10;
		}
		if (offset < 0)
		{
			offset = 0;
		}
		return offset;
	}
	
	
	public static final int next_rows(int row_offset)
	{
		int offset = 0;
		offset = row_offset + 20;
		return offset;
	}
	
	
	public static final int next_cols(int col_offset)
	{
		int offset = 0;
		offset = col_offset + 10;
		return offset;
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
