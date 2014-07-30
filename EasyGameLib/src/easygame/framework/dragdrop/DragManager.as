package easygame.framework.dragdrop
{
	import com.greensock.TweenMax;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 2:45:00 PM
	 * description 拖拽管理器[静态类]
	 **/
	public class DragManager
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		/**拖拽的父容器*/
		private static var _stage:Stage;
		/**拖拽代理图片*/
		private static var _proxyImg:ProxyImage;
		/**拖拽触发者*/
		private static var _initiator:DisplayObject;
		/**拖拽接收者*/
		private static var _accepter:IAcceptable;
		/**是否拖拽中*/
		private static var _isDragging:Boolean;
		
		/**开始拖拽时的舞台X坐标*/
		private static var _startStageX:Number;
		/**开始拖拽时的舞台Y坐标*/
		private static var _startStageY:Number;
		
		/**触发组件在拖拽工程中呈现的灰色效果*/
		private static var _grayEffect:ColorMatrixFilter;
		
		/**放置在格子内时的业务处理方法 -- 比如去后台校验是否拖拽成功等*/
		public static var dropInHandler:Function;
		/**放置在格子外时的业务处理方法 -- 比如弹出是否丢弃的提示等*/
		public static var dropOutHandler:Function;
		/**拖拽中需要处理的方法*/		
		public static var whenDragging:Function;
		
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		/**
		 * 初始化拖拽管理器 
		 * @param stage
		 * @param grayEffect
		 * 
		 */		
		static public function init(stage:Stage, grayEffect:ColorMatrixFilter):void
		{
			_stage = stage;
			_proxyImg = new ProxyImage();
			_isDragging = false;
			_grayEffect = grayEffect;
		}
		
		/**
		 * 开始拖拽
		 * @param	initiator
		 * @param	proxyImg
		 * @param	event
		 */
		static public function doDrag(initiator:DisplayObject, proxyImg:BitmapData, event:MouseEvent, proxyImgAlpha:Number=1):void
		{
			event.stopImmediatePropagation();
			
			_isDragging = true;
			
			if (whenDragging) whenDragging.call(null, _isDragging);
			
			_startStageX = event.stageX - (proxyImg.width / 2);
			_startStageY = event.stageY - (proxyImg.height / 2);
			
			_initiator = initiator;
			// 拼接一个滤镜
			_initiator.filters = [_grayEffect];
			_proxyImg.imageData = proxyImg;
			_proxyImg.visible = true;
			_proxyImg.alpha = proxyImgAlpha;
			_proxyImg.x = _startStageX;
			_proxyImg.y = _startStageY;
			
			_stage.addChild(_proxyImg);
			_proxyImg.startDrag();
			
			_stage.addEventListener(MouseEvent.MOUSE_UP, tryToAccept);
//			_stage.mouseChildren = false;
		}
		/**
		 * 取消拖拽
		 */
		static public function cancel():void
		{
			_proxyImg.stopDrag();
			
			TweenMax.killTweensOf(_proxyImg);
			
			TweenMax.to(_proxyImg, .2, { 
				x: _startStageX, 
				y: _startStageY, 
				autoAlpha: 0,
				onComplete: DragManager.reset 
			} );
		}
		/**
		 * 拖拽结束，重置数据
		 */
		static public function reset():void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_UP, tryToAccept);
			
			_proxyImg.stopDrag();
			
			if (_stage.contains(_proxyImg))
				_stage.removeChild(_proxyImg);
			
			if (_initiator)
			{
				_initiator.filters = [];
				_initiator = null;
			}
			
			_accepter = null;
			
			_proxyImg.reset();
			
			_startStageX = 0;
			_startStageY = 0;
			
			_isDragging = false;

			if (whenDragging) whenDragging.call(null, _isDragging);
		}
		
		/*=======================================================================*/
		/* EVNET HANDLER                                                         */
		/*=======================================================================*/
		static private function tryToAccept(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			var blCancel:Boolean = true;
			var dropOut:Boolean = false;
			// 如果是支持接收的组件，则进行判断
			if (event.target is IAcceptable)
			{
				blCancel = checkAccept(IAcceptable(event.target));
			} // 如果是可拖拽组件，则判断其父容器是否是可接收组件
				// 这一步判断用于拖拽组件的交换
			else if (event.target is IDraggable)
			{
				if (event.target.parent)
				{
					if (event.target.parent is IAcceptable)
					{
						blCancel = checkAccept(IAcceptable(event.target.parent));
					}
				}
			}
			else
			{
				blCancel = false;
				dropOut = true;
			}
			
			if (blCancel)
			{
				DragManager.cancel();
			}
			else
			{
				if (dropOut)
				{
					if (dropOutHandler != null) dropOutHandler(_initiator, event);
				}
				else
				{
					if (dropInHandler != null) dropInHandler(_initiator, _accepter);
				}
				
				DragManager.reset();
			}
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 检测接收
		 * @param	acceptable
		 */
		static private function checkAccept(acceptable:IAcceptable):Boolean
		{
			if (acceptable.canAccept(_initiator))
			{
				_accepter = acceptable;
				//acceptable.accept(_initiator);
				return false; // 拖拽成功，无需取消
			}
			
			return true; // 拖拽失败，进入取消流程
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 是否在拖拽中
		 * */
		static public function get isDragging():Boolean 
		{
			return _isDragging;
		}
	}
}