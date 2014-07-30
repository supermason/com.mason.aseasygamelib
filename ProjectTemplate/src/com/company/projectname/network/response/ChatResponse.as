package com.company.projectname.network.response
{
	import com.company.projectname.network.command.CHAT;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Nov 15, 2013 11:30:06 AM
	 * description: 聊天相关操作的服务器响应处理类	
	 **/
	public class ChatResponse extends ResponseBase
	{
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function ChatResponse()
		{
			super();
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		override protected function createHandler():void
		{
			super.createHandler();
			
			_funDic[CHAT.SEND_MSG] = receiveMsg;
			_funDic[CHAT.JOIN_CHAT_ROOM] = joinChatRoom;
			_funDic[CHAT.LEAVE_CHAT_ROOM] = leaveChatRoom;
			_funDic[CHAT.SYSTEM_MESSAGE] = receiveSysMsg;
			
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 加入聊天室 
		 * @param o
		 * 
		 */		
		private function joinChatRoom(o:Object):void
		{
			_uiMgr.chatMgr.joinOK();
		}
		
		/**
		 * 离开聊天室 
		 * 
		 */		
		private function leaveChatRoom():void
		{
			
		}
		
		/**
		 * 接收到聊天信息 
		 * @param o
		 * 
		 */		
		private function receiveMsg(o:Object):void
		{
			_uiMgr.chatMgr.receiveMessage(o);
		}
		
		/**
		 * 接收系统消息 
		 * @param o
		 * 
		 */		
		private function receiveSysMsg(o:Object):void
		{
			_uiMgr.chatMgr.receiveSysMsg(getOprData(o));
		}
	}
}