package com.conco.concotrade.email;

import java.net.InetAddress;
import java.net.UnknownHostException;

public class test {
	
	public static String IPaddr() throws UnknownHostException{
		InetAddress address = InetAddress.getLocalHost();
		
		String IpAddr = address.getHostAddress();
		System.out.println("####"+IpAddr);
		return IpAddr;
		
	}
}
