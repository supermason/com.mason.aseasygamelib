package com.company.projectname.game.ui.window.chat
{
	import easygame.framework.display.IWindow;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Nov 15, 2013 1:37:11 PM
	 * description: 聊天模块接口 
	 **/
	public interface IUIChat extends IWindow
	{
		/**
		 * 接收聊天信息 
		 * @param msg -- 聊天信息
		 * 
		 */		
		function receiveMessage(o:Object):void;
		
		/**
		 * 隐藏黑色背景 
		 * 
		 */		
		function hideBlackBG():void;
		
		/**
		 * 接收系统消息 
		 * @param msg
		 * 
		 */		
		function receiveSysMsg(msg:String):void;
		
		/**
		 * 切换到p2p模式 
		 * @param clubId
		 * @param toName
		 * 
		 */		
		function p2p(clubId:int, toName:String):void;
		
		function clearChat():void;
	}
}