package com.company.projectname.game.ui.window.avatar
{
	import com.company.projectname.ResourceLocater;
	import com.company.projectname.game.ui.component.GameDisObjBase;
	import com.company.projectname.game.ui.component.GameDisObjSupportToolTip;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Jun 30, 2014 2:09:13 PM
	 * description: 	
	 **/
	public class Buff extends GameDisObjSupportToolTip
	{
		private var _activated:Boolean;
		
		public function Buff()
		{
			super(GameDisObjBase.IMAGE);
		}
		
		override protected function init():void
		{
			super.init();

			_$width = 81;
			_$height = 33;
			
			_disObj = new Bitmap();
			
			addChild(_disObj);
		}
		
		// public ////
		public function updateInfo(msg:String):void
		{
			if (!_activated)
			{
				_activated = true;
				resetBitmap();
				loadResByFullURL(ResourceLocater.BUFF_ROOT + (_index + 1) + getImg() + ".png");
			}
			
			_toolTip = msg;
		}
		
		override public function addEvt():void
		{
			super.addEvt();
			
			addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
		}
		
		override public function removeEvt():void
		{
			super.removeEvt();
			
			removeEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
		}
		
		override public function reset():void
		{
			super.reset();
			
			activated = false;
		}
		
		// event handler ////
		
		protected function mouseEventHandler(event:MouseEvent):void
		{
			if (_buziHandler != null)
				_buziHandler(this);
		}
		
		// private ////
		private function getImg():String
		{
			return _activated ? "_1" : "_2";
		}
		
		// getter && setter ////
		override public function set data(value:Object):void
		{
			this._showImg = false;
			
			_data = _dataParser.parseData(String(value), 2);
			_toolTip = _data[1];
			_activated = int(_data[0]) == 1;
			loadResByFullURL(ResourceLocater.BUFF_ROOT + (_index + 1) + getImg() + ".png");
			
			this.x -= _index * 5;
		}
		
//		override public function set selected(value:Boolean):void
//		{
//			super.selected = value;
//			
//			this.filters = value ? null : [_filterMgr.grayEffect];
//		}

		public function get activated():Boolean
		{
			return _activated;
		}

		public function set activated(value:Boolean):void
		{
			_activated = value;
			
//			selected = _activated;
		}
	}
}