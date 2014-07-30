package com.company.projectname.game.ui.menu
{
	import easygame.framework.cache.disobj.CachableDisplayObject;
	import easygame.framework.text.BorderTextField;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Mason
	 */
	public class MenuItemRender extends CachableDisplayObject 
	{
		private var _menuInfo:BorderTextField;
		private var _menuInfoX:int = 1;
		private var _menuInfoY:int = 1;
		private var _width:int;
		private var _height:int;
		private var _g:Graphics;
		
		public function MenuItemRender() 
		{
			super();
			
		}
		
		override protected function init():void
		{
			this.buttonMode = true;
			
			_menuInfo = new BorderTextField();
			_menuInfo.x = _menuInfoX;
			_menuInfo.y = _menuInfoY
			addChild(_menuInfo);
			
			_g = this.graphics;
		}
		
		// public ////
		override public function addEvt():void
		{
			addEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
		}
		
		override public function removeEvt():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
		}
		
		override public function reset():void
		{
			super.reset();
			_menuInfo.text = "";
			_width = 0;
			_height = 0;
			x = 0;
			y = 0;
			_g.clear();
		}
		
		// event handler ////
		
		private function mouseEventHandler(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.MOUSE_UP) 
			{
				if (_buziHandler != null)
					_buziHandler(this);
			}
			else if (e.type == MouseEvent.MOUSE_OVER)
			{
				drawBackground();
			}
			else if (e.type == MouseEvent.MOUSE_OUT)
			{
				_g.clear();
			}
		}
		
		// private ////
		private function drawBackground():void
		{
			_g.clear();
			_g.lineStyle();
			_g.beginFill(0x666666);
			_g.drawRect(0, 0, _width, _height);
			_g.endFill();
		}
		
		// getter && setter ////
		override public function set data(o:Object):void
		{
			_data = o;
			_menuInfo.text = _data["menuInfo"];
			
			_width = _menuInfo.x + _menuInfo.textWidth + 4;
			_height = _menuInfo.y + _menuInfo.textHeight + 4;
		}
		
		public function get menuType():int 
		{
			return _data["menuType"];
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function get width():Number
		{
			return _width;
		}
	}

}