package com.company.projectname.network.response
{
	import com.company.projectname.network.command.LOG_IN;
	import com.company.projectname.network.command.CHAT;
	import com.company.projectname.network.command.BOTTOM_BUTTON_BAR;
	import com.company.projectname.network.command.ROOKIE;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Nov 15, 2013 11:14:34 AM
	 * description: 服务器响应处理方法配置文件	
	 **/
	public class ResponseConfig
	{
		/**
		 * 功能编号对应的响应处理方法列表
		 */		
		public static const FunctionType_ResponseHandler:Array = [
			// 样例
			[LOG_IN.TYPE, LoginResponse],
			[CHAT.TYPE, ChatResponse],
			[BOTTOM_BUTTON_BAR.TYPE, BottomButtonBarResponse],
			[ROOKIE.TYPE, RookieResponse]
			
		];
	}
}