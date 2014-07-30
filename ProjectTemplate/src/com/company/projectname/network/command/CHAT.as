package com.company.projectname.network.command
{
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Nov 15, 2013 11:24:57 AM
	 * description: 聊天相关功能ID常量类
	 **/
	public class CHAT
	{
		/**
		 * 功能类别：1 
		 */		
		public static const TYPE:int = 1;
		/**
		 * 加入聊天室 - 100 
		 */		
		public static const JOIN_CHAT_ROOM:int = 100;
		/**
		 * 离开聊天室 - 101
		 */		
		public static const LEAVE_CHAT_ROOM:int = 101;
		
		/**
		 * 发起聊天  - 102
		 */		
		public static const SEND_MSG:int = 102;
		
		/**
		 * 接收系统消息 - 105 
		 */		
		public static const SYSTEM_MESSAGE:int = 105;
		
		
	}
}