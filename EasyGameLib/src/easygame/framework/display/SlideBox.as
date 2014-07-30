package easygame.framework.display
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 24, 2013 4:37:32 PM
	 * description: 滑动盒子	
	 **/
	public class SlideBox extends MaskContainerBase
	{	
		private var _moveDistance:int;
		/**
		 * 用来动态计算移动距离的临时变量 
		 */		
		private var _dynDistance:int;
		private var _isMoving:Boolean;
		private var _moveEndCallBack:Function;
		
		public function SlideBox(target:DisplayObject)
		{
			super(target);
		}
		
		// public ////
		/**
		 * 向左移动
		 */		
		public function moveLeft():void
		{
			if (_isMoving) return;
			if (_target.x == _viewPort.width - _target.width) return;
			
			move(-1);
		}
		
		/**
		 * 向右移动
		 */		
		public function moveRight():void
		{
			if (_isMoving) return;
			if (_target.x == 0) return;
			
			move(1);
		}
		
		/**
		 * 直接缓动到指定的位置 
		 * @param targetX
		 * 
		 */		
		public function moveTo(targetX:int):void
		{
			_isMoving = true;
			TweenLite.killTweensOf(_target);
			TweenLite.to(_target, 1, { 
				x: targetX, 
				onComplete: adjustTargetXPos ,
				blurFilter: {blurX: 10, quality:3, remove: true}
			});
		}
		
		/**
		 * 直接设置到指定位置 
		 * @param targetX
		 * 
		 */		
		public function jumpTo(targetX:int):void
		{
			_target.x = adjustJumpToXPos(targetX);
		}
		
		// protected ////
		/**
		 * 移动结束调整目标的 x坐标
		 * @return 0-可以继续移动|-1隐藏右侧按钮|1-隐藏左侧按钮
		 */		
		override protected function adjustTargetXPos():int
		{
			var moveState:int = super.adjustTargetXPos()
			
			_isMoving = false;
			
			if (_moveEndCallBack != null)
				_moveEndCallBack(moveState);
			
			return moveState;
		}
		
		// private ////
		/**
		 * 移动目标 
		 * @param direction -1-左|1-右
		 * 
		 */		
		private function move(direction:int):void
		{
			if (direction == -1)
				_dynDistance = _target.width - Math.abs(_target.x) - _viewPort.width;
			else
				_dynDistance = Math.abs(_target.x);
			
			if (_dynDistance > _moveDistance)
				_dynDistance = 	_moveDistance;
			
			moveTo(_target.x + _dynDistance * direction);
		}
		

		// getter && setter ////
		/**
		 * 一次移动的距离 
		 * @return 
		 * 
		 */		
		public function get moveDistance():int
		{
			return _moveDistance;
		}
		/**
		 * 
		 * @param private
		 * 
		 */
		public function set moveDistance(value:int):void
		{
			_moveDistance = value;
		}

		/**
		 * 移动结束后的回调方法 
		 * @param value
		 * 
		 */		
		public function set moveEndCallBack(value:Function):void
		{
			_moveEndCallBack = value;
		}

		public function get isMoving():Boolean
		{
			return _isMoving;
		}


	}
}