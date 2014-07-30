package com.company.projectname.game.ui.window.chat
{
	import com.company.projectname.game.ui.menu.MenuType;
	import com.company.projectname.game.ui.window.PermanentFixedWindowManager;
	
	import flash.display.DisplayObjectContainer;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Nov 15, 2013 1:40:47 PM
	 * description: 	
	 **/
	public class UIChatManager extends PermanentFixedWindowManager
	{
		private var _testMsg:String = "天价前妻的简介：她叫薄荷，父亲是赫赫有名的外交官，母亲是溪海市第一位女市长，世人贴在她身上的标签是：市长千金，才貌双全，天之骄女。他叫关守恒，父不详，母亲肝癌晚期，他是高翻学院里唯一的平民，贫穷，冷漠，愤世嫉俗。十七岁，他们终以离婚收场。"; //"天价前妻的简介：她叫薄荷，父亲是赫赫有名的外交官，母亲是溪海市第一位女市长，世人贴在她身上的标签是：市长千金，才貌双全，天之骄女。他叫关守恒，父不详，母亲肝癌晚期，他是高翻学院里唯一的平民，贫穷，冷漠，愤世嫉俗。十七岁，他们认为爱情大过天，但爱情还没开花，苦果就已到来，美丽的誓言抵不过柴米油盐，他们终以离婚收场。十年后，她家破人亡，为生计四处奔波，他却成为高翻局里一等一的精英，傲视群雄，拥有一切。再见时，他将支票砸在她头上，“亲爱的前妻，十年前因为我穷，所以你拿掉了我的孩子，现在我再买一个回来，如何？”——谁的青春没有浅浅的淤青？谁的初恋没有刻骨的疼痛？谁能任性不认命？有多少爱可以重来？谁放了谁的手，谁比谁更难受";
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function UIChatManager()
		{
			super(UIChat);
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		override public function open(o:Object=null, parent:DisplayObjectContainer=null, modal:Boolean=false, x:int=-1, y:int=-1):void
		{
			super.open(o, parent, modal, 9, viewPortH - 226);
		}
		
		/**
		 * 重定位窗体 
		 * @param x
		 * @param y
		 * 
		 */		
		override public function onResize(x:int = -1, y:int = -1):void
		{
			disObjWindow.x = 9;
			disObjWindow.y = viewPortH - 226;
		}
		
		public function p2p(clubId:int, toName:String):void
		{
			chat.p2p(clubId, toName);
		}
		
		public function joinOK():void
		{
			// 正常情况下，这里什么都不用做
			// 测试情况下，这里可以开始测试了
//			trace("");
			//SystemManager.Instance.frameMgr.add("TEST_SOCKET_PRESSURE", sendMsg);
		}
		
		public function clearChat():void
		{
			chat.clearChat();
		}
		
		/**
		 * 加入默认聊天室 
		 * 
		 */		
		public function joinChat():void
		{
			_nwMgr.chatReq.curChatRoomId = 1;
			_nwMgr.chatReq.joinChatRoom(1);
		}
		
		/**
		 * 接收聊天信息 
		 * @param o -- 聊天信息
		 * 
		 */	
		public function receiveMessage(o:Object):void
		{
			chat.receiveMessage(o);
		}
		
		/**
		 * 接收系统消息 
		 * @param msg
		 * 
		 */		
		public function receiveSysMsg(msg:String):void
		{
			chat.receiveSysMsg(msg); 
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		override protected function onWindowCreated():void
		{
			super.onWindowCreated();
			
			// 加入聊天室
			joinChat();
			
			chat.hideBlackBG();
			chat.clearChat();
			
			onResize();
		}
		
		override protected function winBuziEvtHandler(evtType:String, data:*=null):void
		{
			switch (evtType)
			{
				case ChatEvent.SEND_MESSAGE:
					if (data[1] == Channel.WORLD)
						_nwMgr.chatReq.sendMsg(data[0]);
					else
						_nwMgr.chatReq.sendP2P(data[2], data[0]);
					break;
				case ChatEvent.POP_MENU:
					//自己的编号不能交互
					if (int(data[1]) == _userMgr.clubId) return;
					
					_uiMgr.menuMgr.pop( {
							"id": data[1],
							"name": data[0].replace("event:", "")
						}, 
						data[2].stageX - _uiMgr.viewPort.gameX + 10, 
						data[2].stageY - _uiMgr.viewPort.gameY + 10, 
						[{
							menuInfo: String(_lang.viewTeam),
							menuType: MenuType.VIEW_TEAM
						},{
							menuInfo: String(_lang.p2p),
							menuType: MenuType.CHAT
						},{
							menuInfo: String(_lang.sendLetter),
							menuType: MenuType.SEND_EMAIL
						}]
					);
					break;
				case ChatEvent.REMOVE_MENU:
					_uiMgr.menuMgr.remove();
					break;
			}
		}
		
		/*=======================================================================*/
		/* PRIVATAE  FUNCTIONS                                                     */
		/*=======================================================================*/
		
		private function sendMsg():void
		{
			_nwMgr.chatReq.sendMsg(_testMsg);
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		private function get chat():IUIChat
		{
			return IUIChat(_window);
		}
	}
}