package com.company.projectname.game.ui.window.bottombuttonbar
{
	import com.company.projectname.game.ui.window.PermanentFixedWindowManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 16, 2013 2:30:34 PM
	 * description: 	
	 **/
	public class UIBottomButtonBarManager extends PermanentFixedWindowManager
	{
		private var _winMgrMapping:Dictionary;
		private var _btnName:String = "";
		private var _dialogueCallBack:Function;
		
//		private var _testLeagueId:int = 1;
		
		public function UIBottomButtonBarManager()
		{
			super(UIBottomButtonBar);
			
			createWinMgrMapping();
		}
		
		// public ////
		override public function open(o:Object=null, parent:DisplayObjectContainer=null, modal:Boolean=false, x:int=-1, y:int=-1):void
		{
			super.open(o, parent, modal, 2, viewPortH - 111 - 2);
			//super.open(o, parent, modal, x, y);
		}
		
		override public function onResize(x:int = -1, y:int = -1):void
		{
			disObjWindow.y = viewPortH - disObjWindow.height - 2;
			// 暂定这个功能条与聊天挨在一起
			disObjWindow.x = 2;
			
			bottomButtonBar.onResize();
			
			checkRookie();
			
			if (_dialogueCallBack != null)
			{
				_dialogueCallBack.call();
				
				_dialogueCallBack = null;
			}
		}
		
		
		override public function checkRookie():void
		{
		}
		
		override public function showRookieArrow(direction:int = 0, subType:int=1):void
		{
		}
		
		override public function showWindow():void
		{
			
		}
		
		// win obj ////
		private function get bottomButtonBar():IUIBottomButtonBar
		{
			return IUIBottomButtonBar(_window);
		}
		
		// protected ////
		override protected function onWindowCreated():void
		{
			super.onWindowCreated();
			
			onResize();
		}
		
		// buzi handler ////
		override protected function winBuziEvtHandler(evtType:String, data:*= null):void
		{
			_winAutoCloseTool.closeOtherWindow(_winMgrMapping[evtType]);
			
//			removeRookieArrow();
			
			switch (evtType)
			{
			}
		}
		
		// private ////
		
		private function createWinMgrMapping():void
		{
		}
		
		// getter && setter ////
		
		public function set btnName(value:String):void 
		{
			_btnName = value;
		}

		/**
		 * 重定位后如果需要播放对话，则赋值 
		 * @param value
		 * 
		 */		
		public function set dialogueCallBack(value:Function):void
		{
			_dialogueCallBack = value;
		}

	}
}