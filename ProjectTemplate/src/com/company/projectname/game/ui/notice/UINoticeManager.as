package com.company.projectname.game.ui.notice
{
	import easygame.framework.display.IPopUp;
	import com.company.projectname.game.ui.window.PopUpManager;
	
	import flash.display.DisplayObjectContainer;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Jun 11, 2014 3:11:24 PM
	 * description: 	
	 **/
	public class UINoticeManager extends PopUpManager
	{
		private var DEFAULT_Y:int = 63;
		
		private var _notice:IUINotice;
		
		public function UINoticeManager()
		{
			super();
		}
		
		// public ////
		override public function init(parent:DisplayObjectContainer):void
		{
			if (!_notice)
			{
				super.init(parent);
				
				_notice = new UINotice();
				_notice.endCallBack = remove;
			}
		}
		
		public function start(notices:String):void
		{
			if (notices && notices != "")
			{
				showNotice();
				
				_notice.start(notices);
			}
		}
		
		public function loopNotice(notice:String):void
		{
			showNotice();
			
			if (notice != "")
				_notice.loopNotice(notice);
			else
				_notice.clearPermanent();
		}
		
		override public function onResize(x:int=-1, y:int=-1):void
		{
			if (_active)
			{
				IPopUp(_notice).x = (_uiMgr.viewPort.vpWidth - _notice.noticeWidth) / 2;
				IPopUp(_notice).y = DEFAULT_Y;
			}
		}
		
		public function remove():void
		{
			_active = false;
			
			removePop(_notice);
		}
		
		// private /////
		
		private function showNotice():void
		{
			if (!_active)
			{
				_active = true;
				addPop(_notice, false, false, (_uiMgr.viewPort.vpWidth - _notice.noticeWidth) / 2, DEFAULT_Y);
			}
		}
		
		// getter && setter ////
		public function set noticeBgURL(value:String):void
		{
			_notice.noticeBgURL = value;
		}
	}
}