package com.company.projectname.game.ui.window.chat
{
//	import com.greensock.TweenLite;
	import com.company.projectname.SystemManager;
	import easygame.framework.text.ScrollRTA;
	import easygame.framework.util.StrUtil;
	import com.company.projectname.game.ui.component.PrettySimpleButton;
	import com.company.projectname.game.ui.window.FixedWindow;
	import com.company.projectname.game.tool.StringTool;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Nov 15, 2013 1:37:33 PM
	 * description: 聊天窗体	
	 **/
	public class UIChat extends FixedWindow implements IUIChat
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/		
		private var CHANNEL_NAME:Dictionary;
		private var CHANNEL_COLOR:Object;
		private var _channelButton:PrettySimpleButton;
		private var _txaWorld:ScrollRTA;
		private var _txaPrivate:ScrollRTA;
		private var _curTxa:ScrollRTA;
		private var _dicRta:Dictionary;
//		private var _blackBG:Shape;
		
		private var _toClubId:int;
		// 私聊规则：
		// 1、只有通过菜单的“与TA聊天”才能开始，一旦发送一条信息或者切换页签，则私聊结束
		// 2、通过菜单的“与TA聊天”开始私聊后，无需跳转页签
		private var _toName:String;
		
		private var _sendTime:int;
		private var _preSendTime:int;
		private var SEND_INTERVAL:int = 5000;
		
		private var _preMsg:String = "";
		private var _channelPanelShown:Boolean;
		private var HTML_BLOCK:RegExp = /<[^<>]*>/g;
		
		private var _toChannel:int;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 
		 * @param contentData
		 * 
		 */
		public function UIChat(contentData:Object)
		{
			_$width = 329;
			_$height = 224;
			
			super("com.xuyou.ogzq2.game.ui.window.chat.ChatSkin", contentData);
			_showWhenCreated = false;
			skinURL = "com.xuyou.ogzq2.game.ui.window.chat.ChatSkin";
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		public function receiveMessage(o:Object):void
		{
			if (o["D"] == "-1") // 说明私聊是对方不在线
			{
				_txaPrivate.appendRichText(getChannelName(Channel.SYSTEM) + "<font color='#fcff00'>" + _lang.notOnline + "</font>");
				receiveSysMsg("<font color='#fcff00'>" + _lang.notOnline + "</font>");
			}
			else
			{
				var temp:Array;
				
				// 包含分隔符1，则标识被禁言，分隔符后面是结束时间
				if (String(o["D"]).indexOf(_dataParser.getSeparater(1)) > -1) 
				{
					temp = _dataParser.parseData(o["D"], 1);
					_userMgr.user.talkForbiddenLeftSec = int(temp[1]);
					receiveTip(_lang.noTalk);
					
					startNoTalkCD();
					return;
				}
				
				// 内容|发送者昵称|接受者昵称
				temp = _dataParser.parseData(o["D"], 0);
				// 屏蔽所有的html格式语言
				temp[0] = String(temp[0]).replace(HTML_BLOCK, "");
				// 发给聊天室
				if (o["P"] == Channel.TO_CHAT_ROOM) 
				{
					_txaWorld.appendRichText(addChannelColor(Channel.WORLD, getChannelName(Channel.WORLD) + formatMsg(temp[1], o["S"], temp[0])));
				} // 发给个人
				else if (o["P"] == Channel.TO_PERSONAL)
				{
					if (temp[1] == _userMgr.user.nickname) // 发送人是自己的，是你对X说
					{
						temp[1] = say2Ta(temp[2], o["R"], temp[0]);
					}
					else // 否则就是X对你说
					{
						temp[1] = say2Me(temp[1], o["S"], temp[0]);
					}
					temp[1] = addChannelColor(Channel.P2P, getChannelName(Channel.P2P) + temp[1]);
					_txaWorld.appendRichText(temp[1]);
					_txaPrivate.appendRichText(temp[1]);
				}
				
				temp.length = 0;
				temp = null;
			}
		}
		
		public function receiveSysMsg(msg:String):void
		{
			_txaWorld.appendRichText(/*getChannelName(Channel.SYSTEM) + */msg + "\n");
		}
		
		public function receiveTip(msg:String):void
		{
			_txaWorld.appendRichText(msg + "\n");
		}
		
		public function hideBlackBG():void
		{
//			tweenTarget(_blackBG, 0);
		}
		
		public function p2p(clubId:int, toName:String):void
		{
			// 私聊无需切换页签了
			//changeRTA(_txaPrivate);
			
			clearPrivateChatData(); // 先清除发送数据，然后重新拼入
			
			_skin.input.text = String(_lang.say2U).replace("@", toName);
			
			_toChannel = Channel.P2P;
			_toClubId = clubId;
			_toName = toName;
			
			// 自动设置文本框焦点，并定位光标到文本最末端
			stage.focus = _skin.input;
			TextField(_skin.input).setSelection(_skin.input.text.length, _skin.input.length);
		}
		
		public function clearChat():void
		{
			for each (var v:ScrollRTA in _dicRta)
			{
				v.clearAllText();
			}
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		override protected function initComponent():void
		{
			super.initComponent()();
			
			this.mouseEnabled = false;
			_skin.mouseEnabled = false;
			
//			drawBlackBackground();
			
			_dicRta = new Dictionary();
			
			_txaWorld = createRTA(Channel.WORLD);
			_txaPrivate = createRTA(Channel.P2P);
			
			_dicRta[Channel.WORLD] = _txaWorld;
			_dicRta[Channel.P2P] = _txaPrivate;
			
			CHANNEL_NAME = new Dictionary();
			CHANNEL_NAME[Channel.WORLD] = _lang.cWorld;
			CHANNEL_NAME[Channel.P2P] = _lang.cPrivate;
			CHANNEL_NAME[Channel.SYSTEM] = _lang.cSystem;
			
			CHANNEL_COLOR = {};
			CHANNEL_COLOR[Channel.WORLD] = "#b3e6ff";
			CHANNEL_COLOR[Channel.P2P] = "#f777ff";
			
			_channelButton = new PrettySimpleButton(PrettySimpleButton.CHANNEL_BUTTON);
			_channelButton.x = 2;
			_channelButton.y = 184;
			_channelButton.labelX = 12;
			_channelButton.useHoverState = false;
			_channelButton.labelColor = 0x1f2234;
			_skin.addChild(_channelButton);
			
			initChannelSelection();
			
			changeRTA(_txaWorld);
		}
		
		override protected function addEvt():void
		{
			super.addEvt();
			
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseEvtHandler);
			_skin.btnSend.addEventListener(MouseEvent.MOUSE_UP, sendClickHandler);
			_skin.input.addEventListener(FocusEvent.FOCUS_IN, inputFocusIn);
			_skin.input.addEventListener(FocusEvent.FOCUS_OUT, inputFocusOut);
			
			_txaWorld.txa.textField.addEventListener(TextEvent.LINK, txtLinkHandler);
			_txaPrivate.txa.textField.addEventListener(TextEvent.LINK, txtLinkHandler);
			
			_channelButton.addEventListener(MouseEvent.MOUSE_UP, showPanel);
			_skin.mvChannelSelection.mvWorld.addEventListener(MouseEvent.MOUSE_UP, changeChannel);
			_skin.mvChannelSelection.mvPrivate.addEventListener(MouseEvent.MOUSE_UP, changeChannel);
			
			SystemManager.Instance.uiMgr.stage.addEventListener(MouseEvent.MOUSE_UP, hideChannelPanel);
		}
		
		protected function changeRTA(rta:ScrollRTA):void
		{
			_toChannel = rta.channelID;
			
			if (_curTxa == rta) return;
			
			if (_curTxa)
			{
				if (_skin.contains(_curTxa))
					_skin.removeChild(_curTxa);
			}
			
			_curTxa = rta;
			_channelButton.label = CHANNEL_NAME[rta.channelID];
			_skin.addChild(_curTxa);
			
			clearPrivateChatData(); // 切换了页签就清除私聊数据
		}
		
		/*=======================================================================*/
		/* EVENT HANDLER                                                         */
		/*=======================================================================*/
		private function sendClickHandler(event:MouseEvent=null):void
		{
			var msg:String = StrUtil.trim(_skin.input.text);
			
			// 先判断是否被禁言
			if (_userMgr.user.talkForbidden)
			{
				receiveTip(_lang.noTalk);
				return;
			}
			
			// 先判断是否为空
			if (msg != "")
			{
				_sendTime = getTimer();
				
				if (_preSendTime > 0 && _sendTime - _preSendTime < SEND_INTERVAL) //  发送时间间隔
				{
					receiveTip(_lang.cTip2);
				}
				else
				{
					_preSendTime = _sendTime;
				
					if (_preMsg == msg) // 不能连续发送同样的内容
					{
						receiveTip(_lang.cTip3);
					}
					else
					{
						// 这里要判断一下，如果是手动切换到的私聊频道，在发送信息时需要自动跳转到世界频道
						if (_toChannel == Channel.P2P)
						{
							if (_toClubId == 0)
								changeRTA(_txaWorld);
							else
								msg = msg.replace(String(_lang.say2U).replace("@", _toName), "");
						}
						_preMsg = msg;
						_winBuziEvtHandler(ChatEvent.SEND_MESSAGE, [msg, _toChannel/*_curTxa.channelID*/, _toClubId]);
						clearPrivateChatData();
					}
				}
			}
			else
			{
				receiveTip(_lang.cTip1);
			}
		}
		
		private function txtLinkHandler(linkInfo:String, event:MouseEvent):void 
		{
			_winBuziEvtHandler(ChatEvent.POP_MENU, linkInfo.split("&").concat(event));
		}
		
		private function talkAreaMouseUpHandler(event:MouseEvent):void
		{
			_winBuziEvtHandler(ChatEvent.REMOVE_MENU);
		}
		
		private function mouseEvtHandler(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.MOUSE_OVER)
			{
				e.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, mouseEvtHandler);
//				tweenTarget(_blackBG, 1);
			}
			else if (e.type == MouseEvent.MOUSE_OUT)
			{
				e.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, mouseEvtHandler);
//				tweenTarget(_blackBG, 0);
				
				//_skin.stage.removeEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
			}
		}
		
		private function inputFocusIn(e:FocusEvent):void 
		{
			if (Capabilities.hasIME)
			{
				try
				{
					IME.enabled = true;
//					if (IME.conversionMode != IMEConversionMode.CHINESE)
//						IME.conversionMode = IMEConversionMode.CHINESE;
				}
				catch (err:Error)
				{
//					this.receiveSysMsg(err.getStackTrace());
				}
			}
			
			_skin.input.setSelection(0, _skin.input.length);
			
			if (!_skin.stage.hasEventListener(KeyboardEvent.KEY_UP))
				_skin.stage.addEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
		}
		
		private function inputFocusOut(e:FocusEvent):void 
		{
			_skin.stage.removeEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
		}
		
		private function onStageKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER) 
			{
				//if (isTalking) 
				//{
				sendClickHandler(null);
				//} 
				//else 
				//{
				//if (!SystemMgr.Instance.UIStatusMgr.IsInFight)
				//{
				//stage.focus = rtaInput.textField
				//rtaInput.textField.setSelection(1,1);
				//}
				//}
			}
		}
		
		private function showPanel(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			_channelPanelShown = !_channelPanelShown;
			_skin.mvChannelSelection.visible = _channelPanelShown;
			_channelButton.toggle = _channelPanelShown;
			_skin.addChild(_skin.mvChannelSelection);
		}
		
		private function changeChannel(event:MouseEvent):void
		{
			_channelPanelShown = false;
			_skin.mvChannelSelection.visible = false;
			_channelButton.toggle = false;
			
			changeRTA(event.target == _skin.mvChannelSelection.mvWorld ? _txaWorld : _txaPrivate);
		}
		
		protected function hideChannelPanel(event:MouseEvent):void
		{
			_channelPanelShown = false;
			_skin.mvChannelSelection.visible = false;
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
//		/**
//		 * 绘制黑色背景 
//		 * 
//		 */		
//		private function drawBlackBackground():void
//		{
//			_blackBG = new Shape();
//			_blackBG.x = 4;
//			_blackBG.y = -ScrollRTA.MESSAGE_BOARD_HEIGHT - 10;
//			
//			var g:Graphics = _blackBG.graphics;
//			g.beginFill(0x000000, 0.3);
//			g.drawRect(0, 0, this.width - 8, ScrollRTA.MESSAGE_BOARD_HEIGHT +10 );
//			g.endFill();
//			_skin.addChildAt(_blackBG, 0);
//		}
//		
//		private function tweenTarget(currentTarget:Object, alpha:Number, duration:Number=.2):void 
//		{
//			TweenLite.killTweensOf(currentTarget);
//			TweenLite.to(currentTarget, duration, { "alpha": alpha } );
//		}
		
		private function initChannelSelection():void
		{
			_skin.mvChannelSelection.visible = false;
			_skin.mvChannelSelection.mvWorld.mouseChildren = false;
			_skin.mvChannelSelection.mvPrivate.mouseChildren = false;
			_skin.mvChannelSelection.mvWorld.buttonMode = true;
			_skin.mvChannelSelection.mvPrivate.buttonMode = true;
			_skin.mvChannelSelection.mvWorld.txtChannelName.text = _lang.cWorld;
			_skin.mvChannelSelection.mvPrivate.txtChannelName.text = _lang.cPrivate;
		}
		
		private function createRTA(channelId:int):ScrollRTA
		{
			var rta:ScrollRTA = new ScrollRTA();
			rta.init(new (SystemManager.Instance.resCacheMgr.getResourceFromMV("com.xuyou.ogzq2.game.ui.window.chat.TxtScrollbarSkin"))(), SystemManager.Instance.uiMgr.stage);
			rta.txtLinkHandler = txtLinkHandler;
			rta.y = /*-rta.height - */5;
			rta.x = 7;
			rta.channelID = channelId;
			rta.mouseUpHandler = talkAreaMouseUpHandler;
			//_skin.addChild(rta);
			
			return rta;
		}
		
		/**
		 * 清除私聊数据 
		 * 
		 */		
		private function clearPrivateChatData():void
		{
			_toName = "";
			_toClubId = 0;
			_skin.input.text = "";
		}
		
		/**
		 * 获取聊天频道的名称 
		 * @param channelId
		 * @return 
		 * 
		 */		
		private function getChannelName(channelId:int):String
		{
			return "[" + CHANNEL_NAME[channelId] + "]";
		}
		
		/**
		 * 添加频道颜色 
		 * @param channelId
		 * @param msg
		 * @return 
		 * 
		 */		
		private function addChannelColor(channelId:int, msg:String):String
		{
			return "<font color='" + CHANNEL_COLOR[channelId] + "'>" + msg + "</font>";
		}
		
		/**
		 * 组织聊天内容 
		 * @param nickName
		 * @param clubId
		 * @param content
		 * @return 
		 * 
		 */		
		private function formatMsg(nickName:String, clubId:int, content:String):String
		{
			return "<a href='event:" + nickName + "&" + clubId + "'><font color='#ffffff'>" + nickName + "</font></a>：" + StringTool.shieldStr(content) + "\n"
		}
		
//		/**
//		 * 组织私聊内容 
//		 * @param nickName
//		 * @param clubId
//		 * @param content
//		 * @return 
//		 * 
//		 */		
//		private function formatP2pMsg(nickName:String, clubId:int, content:String):String
//		{
//			if (nickName == _userMgr.user.nickname)
//				return String(_lang.say2U).replace("@", "<a href='event:" + nickName + "&" + clubId + "'>" + nickName + "</a>") + StrUtil.shieldStr(content) + "\n";
//			else
//				return "<a href='event:" + nickName + "&" + clubId + "'>" + nickName + "</a>" + _lang.say2M + StrUtil.shieldStr(content) + "\n";
//		}
		
		/**
		 * 你对X说 
		 * @param taNickName
		 * @param taClubId
		 * @param content
		 * @return 
		 * 
		 */		
		private function say2Ta(taNickName:String, taClubId:int, content:String):String
		{
			return "<font color='#f777ff'>" + String(_lang.say2U).replace("@", "<a href='event:" + taNickName + "&" + taClubId + "'><font color='#ffffff'>" + taNickName + "</font></a>") + StringTool.shieldStr(content) + "</font>\n";
		}
		
		/**
		 * X对你说 
		 * @param taNickName
		 * @param taClubId
		 * @param content
		 * @return 
		 * 
		 */		
		private function say2Me(taNickName:String, taClubId:int, content:String):String
		{
			return "<font color='#e7a8eb'><a href='event:" + taNickName + "&" + taClubId + "'><font color='#ffffff'>" + taNickName + "</font></a>" + _lang.say2M + StringTool.shieldStr(content) + "</font>\n";
		}
		
		// 禁言相关 ////
		
		private function startNoTalkCD():void
		{
			SystemManager.Instance.timerMgr.addLogicCallBack("TALK_FORBIDDEN_CD", noTalkCountDown);
		}
		
		private function noTalkCountDown():void
		{
			_userMgr.user.talkForbiddenLeftSec--;
			
			if (_userMgr.user.talkForbiddenLeftSec <= 0)
			{
				_userMgr.user.talkForbiddenLeftSec = 0;
				
				SystemManager.Instance.timerMgr.clearLogicCallBack("TALK_FORBIDDEN_CD");
			}
		}		
		
		// getter && setter ////
	}
}