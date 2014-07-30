package com.company.projectname.game.ui.menu
{
	import com.company.projectname.SystemManager;
	import com.company.projectname.game.ui.component.VerticalList;
	
	import flash.display.DisplayObjectContainer;
	
	import easygame.framework.display.IPopUp;
	
	/**
	 * ...
	 * @author Mason
	 */
	public class Menu extends VerticalList implements IPopUp
	{
		private var _background:*;
		private const CONTENT_X:int = 6;
		private const CONTENT_Y:int = 4;
		
		public function Menu() 
		{
			super(MenuItemRender);
			
			init();
		}
		
		protected function init():void
		{
			gap = 0;
			
			_background = new (SystemManager.Instance.resCacheMgr.getResourceFromMV("com.company.projectname.game.ui.tips.ToolTipSkin"))();
			
			renderFinishCallBack = drawBackground;
		}
		
		// public ////
		override public function addRawItem(d:Object):void
		{
			super.addRawItem(d);
			
			_render.x = CONTENT_X;
		}
		
		override public function reset():void
		{
			super.reset();
			
			//_background.width = 0;
			//_background.height = 0;
		}
		
		public function destory():void
		{
			
		}
		
		// protected ////
		override protected function adjustRender():void
		{
			if (contentList.length == 1)
				_render.y = CONTENT_Y;
				
			super.adjustRender();
		}
		
		// private ////
		
		private function drawBackground():void 
		{
			_background.width = this.width + CONTENT_X * 3;
			_background.height = this.height + CONTENT_Y * 3;
			addChildAt(_background, 0);
		}
		
		// getter && setter ////
		public function get isPopped():Boolean
		{
			return this.parent != null;
		}
		
		public function get displayContent():DisplayObjectContainer
		{
			return this;
		}
	}

}