package com.company.projectname.game.ui.window.bottombuttonbar
{
	import com.company.projectname.game.tool.UITool;
	import com.company.projectname.game.ui.window.FixedWindow;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 16, 2013 2:29:23 PM
	 * description: 	
	 **/
	public class UIBottomButtonBar extends FixedWindow implements IUIBottomButtonBar
	{
		private var _eventDic:Dictionary;
		private var _shiningFlag:Dictionary;
		
		private var _minX:int = 329; // 聊天的宽度
		private var _maxX:int = 730; // 屏幕可视宽度大于1288时 的x坐标
		
		
		public function UIBottomButtonBar(contentData:Object)
		{
			_$width = 1288;
			_$height = 111;
			
			super("com.company.projectname.game.ui.window.bottombuttonbar.BottomButtonBarSkin", contentData);
			
			skinURL = "com.company.projectname.game.ui.window.bottombuttonbar.BottomButtonBarSkin";
		}
		
		// public ////
		public function onResize():void
		{
		}
		
		// protected ////
		override protected function initComponent():void
		{
			super.initComponent();
			
			
			fillData();
			
		}
		
		override protected function addEvt():void
		{
			super.addEvt();
			
		}
		
		private function bindEvent():void
		{
		}
		
		// event handler ////
		protected function mouseEvtHandler(event:MouseEvent):void
		{
		}
		
		// private ////
		
		private function fillData():void
		{
		}
		
		// getter && setter ////
		
	}
}