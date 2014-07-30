package com.company.projectname.network.socket
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 9:10:55 AM
	 * description Socket的4中状态常量类 
	 **/
	public class SocketState
	{
		/**
		 * 已连接
		 */
		public static const CONNECT:String = "socket_connect";
		/**
		 * 连接断开
		 */
		public static const DISCONNECT:String = "socket_disconnect";
		/**
		 * IO错误
		 */
		public static const IOERROR:String = "socket_ioerror";
		/**
		 * 安全沙箱错误
		 */
		public static const SECURITYERROR:String = "socket_sceurityerror";
	}
}