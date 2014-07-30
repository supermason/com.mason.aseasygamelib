package com.xuyou.ogzq2.game.ui.window.dialogue
{
	import com.xuyou.ogzq2.game.ui.rookie.RookieHelper;
	import com.xuyou.ogzq2.game.ui.rookie.RookieStep;
	import com.xuyou.ogzq2.game.ui.window.PermanentFixedWindowManager;
	
	import flash.display.DisplayObjectContainer;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Mar 21, 2014 9:43:34 AM
	 * description: 	
	 **/
	public class UIDialogueManager extends PermanentFixedWindowManager
	{
		private var _funcID:String;
		
		public function UIDialogueManager()
		{
			super(UIDialogue);
		}
		
		
		// public ////
		override public function open(o:Object=null, 
									  parent:DisplayObjectContainer=null, 
									  modal:Boolean=false, 
									  x:int=-1, 
									  y:int=-1):void
		{
			hideMainUI();
			
			super.open(o, parent, modal, x, y);
		}
		
		// protected ////
		override protected function onWindowCreated():void
		{
			super.onWindowCreated();
		}
		
		override protected function onClosed():void
		{
			super.onClosed();
			restoreMainUI();
			
			if (_funcID && _funcID != "")
			{
				// 执行对话结束的一些方法
				DialogueCallBackList.instance.call(_funcID);
				
				_funcID = "";
			}
			
			// 临时保存新手交互数据
			if (_userMgr.user.rookieStep <= RookieStep.FIRST_CHALLENGE_MATCH_START
				&& _userMgr.user.rookieStep != RookieStep.FIND_FIRST_PLAYER_FROM_SCOUT)
				RookieHelper.saveRookieInteraction(_userMgr.user.rookieStep);
		}
		
		// private ////
		private function get dialogue():IUIDialgoue
		{
			return IUIDialgoue(_window);
		}
		
		// buzi handler ////
		override protected function winBuziEvtHandler(evtType:String, data:*= null):void
		{
			switch (evtType)
			{
				case DialogueEvent.SAVE_DIALOGUE_OVER_CALLBACK_ID:
					// 先保存，在窗体关闭后再执行
					_funcID = data;
					break;
				case DialogueEvent.GOTO_DO_SOMETHING:
					_uiMgr.leagueMgr.close();
					this.close();
					doSomething(data);
					break;
				
			}
		}
		
		private function doSomething(type:int):void
		{
			// 派遣球探|4,训练球员|1,挑战赛|3,更换阵容|2
			switch (type)
			{
				case 1:
					_nwMgr.playerReq.openPlayer();
					break;
				case 2:
					_nwMgr.formationReq.openFormation();
					break;
				case 3:
					_nwMgr.challengeReq.openChallenge();
					break;
				case 4:
					_nwMgr.ScoutReq.openScout();
					break;
			}
		}
		
		// private ////
		private function hideMainUI():void
		{
			_uiMgr.avatarMgr.moveWindow(-_uiMgr.avatarMgr.winWidth-6, -_uiMgr.avatarMgr.winHeight-6);
			_uiMgr.chatMgr.moveWindow(_uiMgr.chatMgr.winX-_uiMgr.chatMgr.winWidth-9, _uiMgr.chatMgr.winY + _uiMgr.chatMgr.winHeight);
			_uiMgr.bottBtnBarMgr.moveWindow(-1, _uiMgr.bottBtnBarMgr.winY + 200);
			_uiMgr.fastAccessMgr.moveWindow(_uiMgr.fastAccessMgr.winX-_uiMgr.fastAccessMgr.winWidth-9, -1);
			_uiMgr.activityButtonBarMgr.moveWindow(-1, -_uiMgr.activityButtonBarMgr.winHeight-10);
			_uiMgr.rightBtnBarMgr.moveWindow(_uiMgr.rightBtnBarMgr.winX + _uiMgr.rightBtnBarMgr.winWidth + 5, -1);
		}
		
		private function restoreMainUI():void
		{
			_uiMgr.avatarMgr.moveWindow(6, 6);
			_uiMgr.chatMgr.moveWindow(9, viewPortH-226);
			_uiMgr.bottBtnBarMgr.moveWindow(-1, viewPortH - _uiMgr.bottBtnBarMgr.winHeight - 2);
			_uiMgr.fastAccessMgr.moveWindow(0, -1);
			_uiMgr.activityButtonBarMgr.moveWindow(-1, -_uiMgr.activityButtonBarMgr.winHeight-10);
			_uiMgr.activityButtonBarMgr.moveWindow(-1, 10);
			_uiMgr.rightBtnBarMgr.moveWindow(viewPortW - _uiMgr.rightBtnBarMgr.winWidth, -1);
		}
	}
}