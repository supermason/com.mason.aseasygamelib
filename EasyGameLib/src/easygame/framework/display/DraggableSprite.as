package easygame.framework.display
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 5:51:10 PM
	 * description 可拖拽的sprite
	 **/
	public class DraggableSprite extends DisplayObjectTemplate
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		protected var _draggable:Boolean;
		protected var _bounds:Rectangle;
		protected var _setTopWhenMouseDown:Boolean;
		protected var _viewport:IViewport;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function DraggableSprite()
		{
			super();
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		/**
		 * 添加拖拽相应事件
		 */
		protected function addDragEvtHandler():void
		{
			if (!_bounds)
				_bounds = new Rectangle();
			_draggable = true;
			_setTopWhenMouseDown = true;
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		/**
		 * 移除拖拽相应事件
		 */
		protected function removeDragEvtHandler():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		/**
		 * 设置窗体最前端
		 */
		protected function setTop():void
		{
			this.parent.setChildIndex(this.displayContent, parent.numChildren - 1);
		}
		
		/**
		 * 更新窗体可以拖拽的范围
		 */
		protected function updateDragBounds():void 
		{
			_bounds.width = vpw - this.width;
			_bounds.height = vph - this.height;
		}
		
		/*=======================================================================*/
		/* EVENT HANDLER                                                         */
		/*=======================================================================*/
		protected function mouseDownHandler(event:MouseEvent):void
		{
			if (_setTopWhenMouseDown)
				setTop();
			
			if (!_draggable)
				return;
			
			Mouse.cursor = MouseCursor.HAND;
			
			if (parent) 
				parent.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			updateDragBounds();
			startDrag(false, _bounds);
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			// 这是auto，系统会自动 判断buttonMode的设置情况
			Mouse.cursor = MouseCursor.AUTO;
			stopEvent(event);
			stopDrag();
			if (parent)
				parent.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			//trace(x, y);
		}
		
		protected function stopEvent(event:Event):void
		{
			event.stopImmediatePropagation();
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 是否支持拖拽
		 */
		public function get draggable():Boolean 
		{
			return _draggable;
		}
		/**
		 * 是否支持拖拽
		 */
		public function set draggable(value:Boolean):void 
		{
			_draggable = value;
		}
		/**
		 * 是否支持鼠标按下时将当前窗体设置为最上层
		 */
		public function get setTopWhenMouseDown():Boolean 
		{
			return _setTopWhenMouseDown;
		}
		/**
		 * 是否支持鼠标按下时将当前窗体设置为最上层
		 */
		public function set setTopWhenMouseDown(value:Boolean):void 
		{
			_setTopWhenMouseDown = value;
		}
		/**
		 * 可视区域的宽
		 */
		protected function get vpw():Number
		{
			return _viewport.vpWidth;
		}
		/**
		 * 可视区域的高
		 */
		protected function get vph():Number
		{
			return _viewport.vpHeight;
		}

		/**
		 * 设置可视区域对象
		 */
		public function set viewPort(value:IViewport):void
		{
			_viewport = value;
		}

	}
}