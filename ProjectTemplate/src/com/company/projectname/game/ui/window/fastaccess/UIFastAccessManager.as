package com.company.projectname.game.ui.window.fastaccess
{
	import com.company.projectname.game.ui.window.PermanentFixedWindowManager;
	
	import flash.display.DisplayObjectContainer;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 16, 2013 2:33:16 PM
	 * description: 	
	 **/
	public class UIFastAccessManager extends PermanentFixedWindowManager
	{
		public function UIFastAccessManager()
		{
			super(UIFastAccess);
		}
		
		// public ////
		override public function open(o:Object=null, parent:DisplayObjectContainer=null, modal:Boolean=false, x:int=-1, y:int=-1):void
		{
			super.open(o, parent, modal, 0, _uiMgr.avatarMgr.winHeight + 40);
		}
		
		override public function onResize(x:int = -1, y:int = -1):void
		{
			// 快捷通道无需重定位
		}
		
		// win obj ////
		private function get fastAccess():IUIFastAccess
		{
			return  IUIFastAccess(_window);
		}
		
		// buzi handler ////
		override protected function winBuziEvtHandler(evtType:String, data:*= null):void
		{
			switch(evtType)
			{
					
			}
		}
	}
}