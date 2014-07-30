package com.company.projectname.network.request
{
	import com.company.projectname.network.NetWrokConstants;
	import com.company.projectname.network.command.CHAT;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Nov 15, 2013 1:07:38 PM
	 * description: 聊天相关请求类
	 **/
	public class ChatRequest extends RequestBase
	{
		
		private var _curChatRoomId:int;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 构造方法 
		 * @param sendFun
		 * @param uid
		 * @param sendingStateHandler 聊天的无需交互遮罩
		 * 
		 */	
		public function ChatRequest(sendFun:Function, clubId:int, sendingStateHandler:Function=null)
		{
			super(sendFun, clubId, sendingStateHandler);
			
			formatProtcolHeader(NetWrokConstants.CHAT, NetWrokConstants.CHAT);
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		/**
		 * 加入聊天室 
		 * @param roomId -- 聊天室编号
		 * 
		 */		
		public function joinChatRoom(roomId:int):void
		{
			send(CHAT.JOIN_CHAT_ROOM, roomId);
		}
		
		/**
		 * 离开聊天室
		 * @param roomId -- 聊天室编号
		 * 
		 */		
		public function leaveChatRoom(roomId:int):void
		{
			send(CHAT.LEAVE_CHAT_ROOM, roomId);
		}
		
		/**
		 * 发送聊天信息 
		 * @param msg: 
		 */		
		public function sendMsg(msg:String):void
		{
			formatProtcolHeader(NetWrokConstants.CHAT, NetWrokConstants.CHAT);
			
			send(CHAT.SEND_MSG, msg);
		}
		
		/**
		 * 发送私聊 
		 * @param toClubId
		 * @param msg
		 * 
		 */		
		public function sendP2P(toClubId:int, msg:String):void
		{
			formatProtcolHeader(NetWrokConstants.CLUB, toClubId);
			
			send(CHAT.SEND_MSG, msg);
		}

		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 当前聊天室编号 
		 * @return 
		 * 
		 */		
		public function get curChatRoomId():int
		{
			return _curChatRoomId;
		}
		/**
		 * @private 
		 * 
		 */
		public function set curChatRoomId(value:int):void
		{
			_curChatRoomId = value;
			
			formatProtcolHeader(NetWrokConstants.CHAT, _curChatRoomId);
		}

	}
}