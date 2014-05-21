package cse135;

import javax.servlet.http.*;

public class Util {

	
	public static final String SERVERNAME = "ec2-54-187-115-171.us-west-2.compute.amazonaws.com";
	public static final String USERNAME = "ubuntu";
	public static final String PASSWORD = "ubuntu";
	public static final String DATABASE = "cse135";
	public static final String PORTNUMBER = "5432";
	
	public static final String greeting(String username)
	{
		return "Hello " + username;
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
