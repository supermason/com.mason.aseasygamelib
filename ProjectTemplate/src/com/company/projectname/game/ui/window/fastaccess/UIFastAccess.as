package com.company.projectname.game.ui.window.fastaccess
{
	import com.company.projectname.game.ui.window.FixedWindow;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 16, 2013 2:32:20 PM
	 * description: 	
	 **/
	public class UIFastAccess extends FixedWindow implements IUIFastAccess
	{
		public function UIFastAccess(contentData:Object)
		{
			super("com.company.projectname.game.ui.window.fastaccess.UIFastAccessSkin", contentData);
			skinURL = "com.company.projectname.game.ui.window.fastaccess.UIFastAccessSkin";
			_showWhenCreated = false;
			
		}
		// public ////
		override public function reOpen(value:Object):void
		{
			super.reOpen(value);
			
			fillData();
		}
		
		override public function reset():void
		{
			super.reset();
		}
		
		// protected ////
		override protected function initComponent():void
		{
			super.initComponent();
			
			// 此处添加窗体内组件的初始化等
			
			fillData();
		}
		
		override public function refresh(value:*=null):void
		{
			_content = value;
			fillData();
		}
		
		override protected function addEvt():void
		{
			super.addEvt();
			
		}
		
		override protected function removeEvt():void
		{
			super.removeEvt();
		}
		
		// private ////
		private function fillData():void
		{
			
		}
	}
}