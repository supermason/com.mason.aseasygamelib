package easygame.framework.display
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Dec 19, 2013 2:10:23 PM
	 * description 
	 **/
	public class ScrollBar extends MaskContainerBase
	{
		private var _bar:MovieClip; 
		private var _movableRec:Rectangle;
		
		/**
		 * 鼠标按下的时间 
		 */		
		private var _downTime:int;
		/**
		 * 连续滚动的方向: 1向上|-1向下 
		 */		
		private var _dirction:int;
		private var _mouseWheelSpeed:int = 5;
		/**
		 * 大于该时间间隔，开始连续滚动 - 500毫秒
		 */
		private const TIEM_SPAN:int = 500;
		/**
		 * 默认滚动的行距 - 3 
		 */		
		private const DEFAULT_DELTA:int = 3;
		/**
		 * 向上 
		 */		
		private const UPWARDS:int = 1;
		/**
		 * 向下 
		 */		
		private const DOWNWARDS:int = -1;
		
		private var _duration:Number = .5;
		
		/**
		 * 创建一个滚动条容器（没有上下按钮） -- 只支持竖向滚动 
		 * 
		 * @param barSkin 滚动条皮肤（需要至少包含一个滑块+底槽，且他们的实例名分别对应thumb + track）
		 * @param target 需要被滚动的对象
		 * 
		 */		
		public function ScrollBar(barSkin:MovieClip, target:DisplayObject)
		{
			_bar = barSkin;
			_bar.visible = false;
			
			super(target);
			
			if (!_bar.hasOwnProperty("thumb"))
				throw new Error("Thumb is a required component in a ScrollBar!");
			if (!_bar.hasOwnProperty("track"))
				throw new Error("Track is a required component in a ScrollBar!");
			_bar.thumb.buttonMode = true;
		}
		
		// public ////
		
		/**
		 * 组建回收
		 * 
		 */		
		override public function reset():void
		{
			_bar.thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumb_onMouseDown);
			_bar.track.removeEventListener(MouseEvent.MOUSE_UP, track_mouseEvtHandler);
			_bar.track.removeEventListener(MouseEvent.MOUSE_DOWN, track_mouseEvtHandler);
			
			if (_bar["arrowDown"])
			{
				_bar["arrowDown"].removeEventListener(MouseEvent.MOUSE_UP, arrowDown_mouseEvtHandler);
				_bar["arrowDown"].removeEventListener(MouseEvent.MOUSE_DOWN, arrowDown_mouseEvtHandler);
			}
			
			if (_bar["arrowUp"])
			{
				_bar["arrowUp"].removeEventListener(MouseEvent.MOUSE_UP, arrowUp_mouseEvtHandler);
				_bar["arrowUp"].removeEventListener(MouseEvent.MOUSE_DOWN, arrowDown_mouseEvtHandler);
			}
			
			removeEventListener(MouseEvent.MOUSE_WHEEL, scrollBar_onMouseWheel);
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_onMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_onMouseMove);
			stage.removeEventListener(Event.ENTER_FRAME, continousScroll);
			
			_bar.thumb.y = 0;
			_target.y = 0;
			
			super.reset();
		}
		
		/**
		 * 设置可视区域的宽和高  
		 * @param vpW
		 * @param vpH
		 * 
		 */		
		override public function initViewPort(vpW:int, vpH:int):void
		{
			_viewPort.width = vpW + _bar.width;
			_viewPort.height = vpH;
			_bar.x = vpW;
			
			this.scrollRect = _viewPort;
		}
		
		/**
		 * 在target填充数据后，判断是否需要出现滚动条 
		 * 
		 */		
		public function wheatherToShow():void
		{
			if (width < _target.width)
				width = _target.width;
			
			_bar.visible = needScroll;
			
			if (_bar.visible) // 无需滚动条，则不用添加事件
				addEvt();
		}
		
		/**
		 * 直接滚动到目标位置 (会自动调整位置为viewport的中心)
		 * @param toY - target的y坐标
		 * 
		 */		
		public function scrollTo(toY:int):void
		{
			if (toY < _viewPort.height / 2) return;
			
			_bar.thumb.y = getThumbY(adjustJumpToYPos(_viewPort.height / 2 - toY));
			
			$scroll();
		}
		
		// protected ////
		/**
		 * 创建所需对象
		 * 
		 */		
		override protected function init():void
		{
			super.init();
			
			addChild(_bar);
			_movableRec = new Rectangle();
		}
		
		// event handler ////
		
		/**
		 * 滑块按下后，添加滚动等相关事件 
		 * @param event
		 * 
		 */		
		protected function thumb_onMouseDown(event:Event):void
		{
			event.stopImmediatePropagation();
			
			if (needScroll)
			{
				_bar.thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumb_onMouseDown);
			
				_bar.thumb.startDrag(false, _movableRec);
				
				stage.addEventListener(MouseEvent.MOUSE_UP, stage_onMouseUp);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_onMouseMove);
			}
		}
		
		/**
		 * 鼠标在stage上移动时，实现滚动效果 
		 * @param event
		 * 
		 */		
		protected function stage_onMouseMove(event:MouseEvent):void
		{
			$scroll();
		}
		
		/**
		 * 鼠标抬起后，取消滚动效果
		 * @param event
		 * 
		 */		
		protected function stage_onMouseUp(event:Event):void
		{
			_bar.thumb.stopDrag();
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_onMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_onMouseMove);
			stage.removeEventListener(Event.ENTER_FRAME, continousScroll);
			
			_bar.thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumb_onMouseDown);
		}
		
		/**
		 * 当鼠标在视图区域滚轮时，自动滚动scrollBar的内容 
		 * @param event
		 * 
		 */		
		protected function scrollBar_onMouseWheel(event:MouseEvent):void
		{
			tryToScroll(event.delta * _mouseWheelSpeed);
		}
		
		/**
		 * 下箭头点击事件
		 * @param event
		 * 
		 */		
		protected function arrowDown_mouseEvtHandler(event:MouseEvent):void
		{
			tryToScroll(DEFAULT_DELTA * -1);
			
			if (event.type == MouseEvent.MOUSE_UP)
			{
				stage.removeEventListener(Event.ENTER_FRAME, continousScroll);
			}
			else if (event.type == MouseEvent.MOUSE_DOWN)
			{
				_downTime = getTimer();
				_dirction = DOWNWARDS;
				stage.addEventListener(Event.ENTER_FRAME, continousScroll);
			}
		}
		
		/**
		 * 上箭头点击事件
		 * @param event
		 * 
		 */		
		protected function arrowUp_mouseEvtHandler(event:MouseEvent):void
		{
			tryToScroll(DEFAULT_DELTA);
			
			if (event.type == MouseEvent.MOUSE_UP)
			{
				stage.removeEventListener(Event.ENTER_FRAME, continousScroll);
			}
			else if (event.type == MouseEvent.MOUSE_DOWN)
			{
				_downTime = getTimer();
				_dirction = UPWARDS;
				stage.addEventListener(Event.ENTER_FRAME, continousScroll);
			}
		}
		
		/**
		 * 鼠标在上按钮或下按钮长时间按住时，自动滚动 
		 * @param event
		 * 
		 */		
		protected function continousScroll(event:Event):void
		{
			if (getTimer() - _downTime > TIEM_SPAN)
			{
				if (!tryToScroll(DEFAULT_DELTA * _dirction))
					stage.removeEventListener(Event.ENTER_FRAME, continousScroll);
			}
		}

		/**
		 * 滚动条底槽点击时，内容自动滚动到响应的位置 
		 * @param event
		 * 
		 */		
		protected function track_mouseEvtHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			if (event.type == MouseEvent.MOUSE_UP)
				tryToScroll(_bar.thumb.y - _bar.mouseY);
		}
				
		
		// private ////
		/**
		 * 添加必要的事件 
		 * 
		 */		
		private function addEvt():void
		{
			_bar.thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumb_onMouseDown);
			_bar.track.addEventListener(MouseEvent.MOUSE_UP, track_mouseEvtHandler);
			_bar.track.addEventListener(MouseEvent.MOUSE_DOWN, track_mouseEvtHandler);
			if (_bar["arrowDown"])
			{
				_bar["arrowDown"].addEventListener(MouseEvent.MOUSE_UP, arrowDown_mouseEvtHandler);
				_bar["arrowDown"].addEventListener(MouseEvent.MOUSE_DOWN, arrowDown_mouseEvtHandler);
			}
			if (_bar["arrowUp"])
			{
				_bar["arrowUp"].addEventListener(MouseEvent.MOUSE_UP, arrowUp_mouseEvtHandler);
				_bar["arrowUp"].addEventListener(MouseEvent.MOUSE_DOWN, arrowDown_mouseEvtHandler);
			}
			
			addEventListener(MouseEvent.MOUSE_WHEEL, scrollBar_onMouseWheel);
		}
		
		/**
		 * 尝试滚动 (正值向上滚|负值向下滚)
		 * 
		 * <p> 如果可以滚动，则在对应方向上滚动DEFAULT_DELTA的距离且返回true；如果不能滚动，不做任何操作，并返回false
		 * 
		 * @param delta
		 * @return 
		 * 
		 */		
		private function tryToScroll(delta:int):Boolean
		{
			if (delta == 0) return false;
			
			if (delta > 0) // 向上滚动
			{
				if (_bar.thumb.y == 0) return false;
				_bar.thumb.y -= delta;
				if (_bar.thumb.y < 0) _bar.thumb.y = 0;
			}
			else // 向下滚动
			{
				if (_bar.thumb.y == _movableRec.height) return false;
				_bar.thumb.y -= delta;
				if (_bar.thumb.y > _movableRec.height) _bar.thumb.y = _movableRec.height;
			}
			
			$scroll();
			
			return true;
		}
		
		/**
		 * 根据target的最终目标Y计算thumb的Y坐标 
		 * @param toY
		 * @return 
		 * 
		 */		
		private function getThumbY(toY:int):Number
		{
			return Math.abs(toY) * (_movableRec.height/* - _bar.thumb.height*/) / (_target.height - _viewPort.height);
		}
		
		/**
		 * 实现滚动 
		 * 
		 */		
		private function $scroll():void
		{
			var toY:int = _bar.thumb.y / _movableRec.height * (_target.height - _viewPort.height) * -1;
			TweenLite.killTweensOf(_target);
			TweenLite.to(_target, _duration, { y: toY });
		}
		
		// getter && setter ////
		/**
		 * @private
		 * 
		 */		
		override public function set width(value:Number):void
		{
			if (value < _target.width)
				value = _target.width;
			
			_viewPort.width = value + _bar.width;
			//_bar.x = value;
			
			_isVPWSet = true;
			if (_isVPHSet)
				this.scrollRect = _viewPort;
		}
		
		/**
		 * 
		 * @private
		 * 
		 */		
		override public function set height(value:Number):void
		{
			_viewPort.height = value;
			_bar.track.height = value;
			
			_movableRec.height = _viewPort.height - _bar.thumb.height;
			
			_isVPHSet = true;
			if (_isVPWSet)
				this.scrollRect = _viewPort;
		}
		
		/**
		 * 设置滚动条的位置 
		 * @param value
		 * 
		 */		
		public function set scrollBarX(value:int):void
		{
			_bar.x = value;
		}
		
		/**
		 * 是否需要滚动（内容高度>可视区域高度） 
		 * @return 
		 * 
		 */		
		private function get needScroll():Boolean
		{
			return _target.height > _viewPort.height;
		}

		/**
		 * 鼠标滚轮的数度比率 ，默认是3，表示滚动的距离是系统默认的3倍
		 */
		public function get mouseWheelSpeed():int
		{
			return _mouseWheelSpeed;
		}

		/**
		 * @private
		 */
		public function set mouseWheelSpeed(value:int):void
		{
			_mouseWheelSpeed = value;
		}

		/**
		 * 内容滚动的缓动时间 - 默认 .5秒 
		 */
		public function get duration():Number
		{
			return _duration;
		}

		/**
		 * @private
		 */
		public function set duration(value:Number):void
		{
			_duration = value;
		}

		/**
		 * 可视区域的高度 
		 * @return 
		 * 
		 */		
		public function get viewPortHeight():int
		{
			return _viewPort.height;
		}
	}
}