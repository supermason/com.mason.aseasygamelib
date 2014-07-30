package com.company.projectname.game.ui.component
{
	import com.company.projectname.ResourceLocater;
	import easygame.framework.text.GameText;
	
	import flash.display.Sprite;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Mar 14, 2014 4:44:38 PM
	 * description: 	
	 **/
	public class CountTip extends Sprite
	{
		private var _$width:int = 20;
		private var _$height:int = 21;
		private var _redBg:Image;
		private var _txtCount:GameText;
		
		public function CountTip()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
			_redBg = new Image();
			_redBg.source = ResourceLocater.COMMON_IMG_ROOT + "redBg.png";
			
			_txtCount = new GameText();
			
			addChild(_redBg);
			addChild(_txtCount);
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		// getter && setter ////
		public function set count(value:String):void
		{
//			_txtCount.htmlText = "<font size='12'>" + value + "</font>";
			_txtCount.htmlText = "<b>" + value + "</b>";
			
			_txtCount.x = 5;
//			_txtCount.y = (_$height - _txtCount.textHeight) / 2;
			
			this.visible = value != "";
		}
		
		public function get count():String
		{
			return _txtCount.text;
		}
	}
}