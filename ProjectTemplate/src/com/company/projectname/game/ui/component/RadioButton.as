package com.company.projectname.game.ui.component
{
	import com.company.projectname.SystemManager;
	import easygame.framework.text.BorderTextField;
	import com.company.projectname.game.tool.UITool;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Jan 3, 2014 3:32:12 PM
	 * description: 单选按钮
	 **/
	public class RadioButton extends Sprite
	{
		private var _skin:MovieClip;
		private var _label:BorderTextField;
		private var _selected:Boolean;
		private var _data:Object;
		
		public function RadioButton()
		{
			super();
			
			this.buttonMode = true;
			
			createSkin();
		}
		
		private function createSkin():void
		{
			_skin = new (SystemManager.Instance.resCacheMgr.getResourceFromMV("com.xuyou.ogzq2.game.ui.skin.RadioButton"))();
			_skin.mouseChildren = false;
			_skin.mouseEnabled = false;
			addChild(_skin);
			UITool.setAllTxtInDisObjCon(_skin);
			
			_label = new BorderTextField();
			_label.x = _skin.width + 2;
			_label.y = -3;
			_label.defaultTextFormat = SystemManager.Instance.txtFormatMgr.defaultTextFormat;
			_label.textColor = 0x001234;
			addChild(_label);
		}
		
		// public ////
		public function addEvt():void
		{
			this.addEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseEvtHandler);
		}
		
		public function removeEvt():void
		{
			this.removeEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseEvtHandler);
		}
		
		public function reset():void
		{
			removeEvt();
			
			selected = false;
		}
		
		// evnet handler ////
		protected function mouseEvtHandler(event:MouseEvent):void
		{
			if (event.type == MouseEvent.MOUSE_UP)
				selected = !_selected;
			else if (event.type == MouseEvent.MOUSE_DOWN)
				event.stopImmediatePropagation();
		}
		
		// private ////
		private function updateSkin():void
		{
			if (_skin) _skin.gotoAndStop(_selected ? 2 : 1);
		}

		// getter && setter ////
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			
			updateSkin();
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}
		
		public function set label(value:String):void
		{
			_label.text = value;
		}
		
		public function set labelColor(value:uint):void
		{
			_label.textColor = value;
		}
	}
}