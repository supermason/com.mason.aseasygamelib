package com.company.projectname.game.ui.component
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 26, 2013 10:08:55 AM
	 * description: 	
	 **/
	public class PackGrid extends AcceptableGrid
	{
		/**
		 * 创建一个包裹格子 
		 * 
		 */		
		public function PackGrid()
		{
			super(GameDisObjBase.SWF, false);
		}
		
		override protected function init():void
		{
			super.init();
			
			_acceptType = Item;
			_resetSwfRes = false;
			
		}
		
		// public ////
		override public function addEvt():void
		{
			super.addEvt();
			
			addEventListener(MouseEvent.MOUSE_OVER, mousEvtHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mousEvtHandler);
		}
		
		override public function removeEvt():void
		{
			super.removeEvt();
			
			removeEventListener(MouseEvent.MOUSE_OVER, mousEvtHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, mousEvtHandler);
		}
		
		/**
		 * 新入包的物品高亮显示下 
		 * 
		 */		
		public function highligth():void
		{
			skin.gotoAndStop("hover");
		}
		
		override public function reset():void
		{
			_index = 0;
			
			removeItem();
			
			super.reset();
		}
		
		/**
		 * 添加一个物品
		 * @param	item
		 */
		override public function addItem(item:DisplayObject):void
		{
			super.addItem(item);
			
			item.x = 2;
			item.y = 2;
			
			Item(item).removedHandler = null;
			Item(item).updateSize(true);
			Item(item).packIndex = _index;
			
//			addChild(item);
		}
		/**
		 * 移除一个物品
		 */
		override public function removeItem():void
		{
			if (isOcuppied)
			{
				Item(content).reset();
			}
			
			skin.gotoAndStop("normal");
		}
		
		// event handler ////
		private function mousEvtHandler(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			
			if (_disObj)
			{
				if (e.type == MouseEvent.MOUSE_OVER)
				{
					skin.gotoAndStop("hover");
				}
				else if (e.type == MouseEvent.MOUSE_OUT)
				{
					skin.gotoAndStop("normal");
				}
			}
		}
		
		// getter && setter ////
		
		override public function set data(o:Object):void
		{
			if (!_disObj)
			{
				_disObj = new (_resCacheMgr.getResourceFromMV("com.xuyou.ogzq2.game.ui.window.pack.GridSkin"))();
				skin.mouseChildren = false;
				skin.mouseEnabled = false;
				addChild(_disObj);
			}
			
			_index = int(o);
		}
		
		override public function get width():Number
		{
			return 46;
		}
		
		override public function get height():Number
		{
			return 46;
		}
	}
}