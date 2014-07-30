package easygame.framework.animation
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 2:55:21 PM
	 * description 帧驱动事件处理方法管理器
	 **/
	public class FrameManager extends Sprite
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _callBackList:Dictionary;
		private var _callBackVars:Dictionary;
		private var _cbCount:int;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function FrameManager()
		{
			super();
			
			initDic();
		}
		
		protected function initDic():void
		{
			_callBackList = new Dictionary(true);
			_callBackVars = new Dictionary(true);
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		/**
		 * 添加一个需要enterframe调用的方法
		 * @param	cbFlag：方法唯一标识
		 * @param	callBack：方法对象
		 * @param	vars：可能用到的参数
		 */
		public function add(cbFlag:String, callBack:Function, vars:* = null):void
		{
			_cbCount++;
			_callBackList[cbFlag] = callBack;
			if (vars != null)
				_callBackVars[cbFlag] = vars;
			if (_cbCount > 0)
			{
				if (!this.hasEventListener(Event.ENTER_FRAME))
					this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		/**
		 * 移除一个不再需要enterframe调用的方法
		 * @param	cbFlag：方法唯一标识
		 */
		public function remove(cbFlag:String):void
		{
			if (_callBackList[cbFlag])
			{
				
				_callBackList[cbFlag] = null;
				_callBackVars[cbFlag] = null;
				
				delete _callBackList[cbFlag];
				delete _callBackVars[cbFlag];
				
				_cbCount--;
				if (_cbCount <= 0)
					this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		/*=======================================================================*/
		/* EVENT HANDLER                                                         */
		/*=======================================================================*/
		private function enterFrameHandler(e:Event):void 
		{
			for (var k:* in _callBackList)
			{
				if (_callBackVars.hasOwnProperty(k))
					_callBackList[k].call(null, _callBackVars[k]);
				else
					_callBackList[k].call();
			}
		}
	}
}