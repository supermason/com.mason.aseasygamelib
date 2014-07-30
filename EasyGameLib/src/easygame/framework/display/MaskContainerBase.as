package easygame.framework.display
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 24, 2013 4:40:08 PM
	 * description: 实现遮罩效果的容器
	 **/
	public class MaskContainerBase extends GameSprite
	{
		protected var _target:DisplayObject;
		protected var _viewPort:Rectangle;
		protected var _isVPWSet:Boolean;
		protected var _isVPHSet:Boolean;
		
		public function MaskContainerBase(target:DisplayObject)
		{
			super();
			
			_target = target;
		}
		
		// public ////
		
		/**
		 * 设置可视区域的宽和高  
		 * @param vpW
		 * @param vpH
		 * 
		 */		
		public function initViewPort(vpW:int, vpH:int):void
		{
			_viewPort.width = vpW;
			_viewPort.height = vpH;

			this.scrollRect = _viewPort;
			
			drawEvtReceiveBg();
		}
		
		// protected ////
		/**
		 * 创建显示区域
		 * 
		 */		
		override protected function init():void
		{
			_viewPort = new Rectangle();
			addChild(_target);
		}
		
		/**
		 * 绘制一层几乎不可见的背景，用于让滚动条容器无时无刻不响应鼠标滚动事件 
		 * 
		 */		
		protected function drawEvtReceiveBg():void
		{
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, .005);
			g.drawRect(_viewPort.x, _viewPort.y, _viewPort.width, _viewPort.height);
			g.endFill();
		}
		
		/**
		 * 验证目标X的有效性 
		 * @param toX
		 * @return 
		 * 
		 */		
		protected function adjustJumpToXPos(toX:int):int
		{
			if (Math.abs(toX) > (_target.width - _viewPort.width))
			{
				toX = (_target.width - _viewPort.width);
				if (toX > 0) toX *= -1;
			}
			
			return toX;
		}
		
		/**
		 * 验证目标X的有效性 
		 * @param toX
		 * @return 
		 * 
		 */		
		protected function adjustJumpToYPos(toY:int):int
		{
			if (Math.abs(toY) > (_target.height - _viewPort.height))
			{
				toY = (_target.height - _viewPort.height);
				if (toY > 0) toY *= -1;
			}
			
			return toY;
		}
		
		/**
		 * 移动结束调整目标的 x坐标
		 * @return 0-可以继续移动|-1隐藏右侧按钮|1-隐藏左侧按钮
		 */		
		protected function adjustTargetXPos():int
		{
			if (_target.x > 0) { _target.x = 0; }
			if (_target.x < _viewPort.width - _target.width) { _target.x = _viewPort.width - _target.width; }
			
			if (_target.x == 0)
				return -1;
			else if (_target.x == _viewPort.width - _target.width)
				return 1;
			else
				return 0;
		}
		
		/**
		 * 移动结束调整目标的y坐标
		 * 
		 */		
		protected function ajustTargetYPos():void
		{
			if (_target.y > 0) _target.y = 0;
			if (_target.y < _viewPort.height - _target.height) _target.y = _viewPort.height - _target.height;
		}
		
		// getter && setter ////
		/**
		 * 可视区域的宽
		 * 
		 * <p> 对于有滚动条的容器，设置的宽度中无需考虑滚动条自身的宽，内部会自己计算
		 * 
		 * <p> 如果设置的宽度小于需要滚动对象的宽，则自动设置为需要滚动对象的宽度
		 * 
		 * @return 
		 * 
		 */		
		override public function get width():Number
		{
			return _viewPort.width;
		}
		/**
		 * @private
		 * 
		 */		
		override public function set width(value:Number):void
		{
			if (value < _target.width)
				value = _target.width;
			
			_viewPort.width = value;
			
			_isVPWSet = true;
			if (_isVPHSet)
				this.scrollRect = _viewPort;
			
			drawEvtReceiveBg();
		}
		
		/**
		 * 可视区域的高 
		 * @return 
		 * 
		 */		
		override public function get height():Number
		{
			return _viewPort.height;
		}
		/**
		 * 
		 * @private
		 * 
		 */		
		override public function set height(value:Number):void
		{
			_viewPort.height = value;
			
			_isVPHSet = true;
			if (_isVPWSet)
				this.scrollRect = _viewPort;
			
			drawEvtReceiveBg();
		}
		
		/**
		 * 被遮罩 目标的x坐标 - 相对应Container的 
		 * @param value
		 * 
		 */		
		public function set targetX(value:int):void
		{
			_target.x = value;
		}
		
		/**
		 * 被遮罩 目标的y坐标 - 相对应Container的 
		 * @param value
		 * 
		 */		
		public function set targetY(value:int):void
		{
			_target.y = value;
		}
	}
}