package easygame.framework.timer
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 3:20:33 PM
	 * description 计时器对象管理器[提供延迟调用、间隔调用的方法]
	 **/
	public class TimerManager
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		// 延迟调用相关
		private var DELAY_INTERVAL:int = 100;
		private var _delayTimer:Timer;
		private var _delayCbList:Dictionary;
		private var _delayCbVars:Dictionary;
		private var _delayInterval:Dictionary;
		private var _delayCount:int;
		// 逻辑相关
		private var LOGIC_INTERVAL:Number = 1000;
		private var _logicTimer:Timer;
		private var _callBackList:Dictionary;
		private var _callBackVars:Dictionary;
		private var _callBackCount:int;
		
		// 前端加速检查
		private var _lastTriggerTime:Number = 0;
		private var _offSet:Number = 0;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function TimerManager()
		{
			initTimer();
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 添加一个需要延迟调用的方法<br>延迟最低100毫秒
		 * @param delayName: 延迟调用的标识名称
		 * @param callBack: 需要延迟调用的方法
		 * @param delay: 延迟调用的时间[毫秒]
		 * @param cbVars: 延迟调用方法需要的参数[可选]
		 * */
		public function addDelayCallBack(delayName:String, 
										 callBack:Function, 
										 delay:int, 
										 cbVars:*=null):void
		{
			
			if (!_delayCbList[delayName])
			{
				//trace("添加[" + delayName + "]");
				_delayCount++;
			}
			//else
			//{
			//trace("[" + delayName + "]已存在");
			//}
			
			_delayCbList[delayName] = callBack;
			// 这里特别注意不能直接写 if (cbVars)
			// 因为这么写的话0或者false类型的参数会被忽略导致错误
			if (cbVars != null)
				_delayCbVars[delayName] = cbVars;
			_delayInterval[delayName] = delay;
			if (!_delayTimer.running)
			{
				_delayTimer.start();
				//trace("计时器启动");
			}
			//else
			//{
			//trace("计时器运行中");
			//}
		}
		
		/**
		 * 清除延迟的调用[请勿在回调方法中调用该方法，自动到时的延时调用会自动清理资源]
		 * @param delayName：延迟调用的标识名称
		 * */
		public function clearDelayCB(delayName:String):void
		{
			if (_delayInterval.hasOwnProperty(delayName))
			{
				//trace("清理["+delayName+"]");
				_delayCbVars[delayName] = null;
				_delayCbList[delayName] = null;
				delete _delayCbVars[delayName];
				delete _delayCbList[delayName];
				delete _delayInterval[delayName];
				_delayCount--;
				if (_delayCount < 0)
					_delayCount = 0;
			}
		}
		
		/**
		 * 添加游戏内需要计时器支持的逻辑回调方法和该方法使用的参数
		 * 游戏内逻辑调用的最短间隔为1秒
		 * @param cbName: 调用标识名称
		 * @param callBack: 反复被调用的回调方法
		 * @param cbVars: 可能用到的参数
		 * */
		public function addLogicCallBack(cbName:String, callBack:Function, cbVars:*=null):void
		{
			if (_logicTimer.running)
				_logicTimer.stop();
			if (!_callBackList[cbName])
				_callBackCount++;
			_callBackList[cbName] = callBack;
			if (cbVars)
				_callBackVars[cbName] = cbVars;
			_logicTimer.start();
			_lastTriggerTime = new Date().time;
		}
		
		/**
		 * 清理到期的逻辑回调方法
		 * @param cbName: 调用标识名称
		 * */
		public function clearLogicCallBack(cbName:String):void
		{
			if (_callBackList[cbName])
			{
				_logicTimer.stop();
				_callBackList[cbName] = null;
				_callBackVars[cbName] = null;
				delete _callBackList[cbName];
				delete _callBackVars[cbName];
				_callBackCount--;
				_callBackCount > 0 ? _logicTimer.start() : _logicTimer.reset();
			}
		}
		
		/**
		 * 调用该方法后，整个游戏内的计时器将被停止
		 * */
		public function stop():void
		{
			_delayTimer.reset();
			_logicTimer.reset();
		}
		
		/*=======================================================================*/
		/* EVNET HANDLER                                                         */
		/*=======================================================================*/
		private function ondelayTimer(event:TimerEvent):void
		{
			for (var k:* in _delayInterval)
			{
				_delayInterval[k] -= DELAY_INTERVAL;
				if (_delayInterval[k] <= 0)
				{
					//trace("执行[" + k + "]");
					if (_delayCbVars.hasOwnProperty(k))
						_delayCbList[k](_delayCbVars[k]);
					else
						_delayCbList[k]();
					_delayCbVars[k] = null;
					_delayCbList[k] = null;
					delete _delayCbVars[k];
					delete _delayCbList[k];
					delete _delayInterval[k];
					_delayCount--;
				}
			}
			
			if (_delayCount <= 0)
			{
				_delayCount = 0;
				//trace("停止计时器");
				_delayTimer.reset();
			}
		}
		
		/**
		 * 逻辑计时器onTimer[1秒一触发]
		 * @param	e
		 */
		private function onLogicTimer(event:TimerEvent):void
		{
			// 加入加速检测[对于加速系统时间的情况无效]
			var now:Number = new Date().time;
			var timeSpan:Number = now - _lastTriggerTime;
			_lastTriggerTime = now;
			
			_offSet = _offSet + timeSpan;
			
			if (_offSet > LOGIC_INTERVAL)
			{
				_offSet = _offSet - LOGIC_INTERVAL;
				
				for (var k:* in _callBackList)
				{
					if (_callBackVars.hasOwnProperty(k))
						_callBackList[k](_callBackVars[k]);
					else
						_callBackList[k]();
				}
			}
		}
		
		/*=======================================================================*/  
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		private function initTimer():void
		{
			_delayTimer = new Timer(DELAY_INTERVAL);
			_delayTimer.addEventListener(TimerEvent.TIMER, ondelayTimer);
			_delayCbList = new Dictionary();
			_delayCbVars = new Dictionary();
			_delayInterval = new Dictionary();
			
			_logicTimer = new Timer(LOGIC_INTERVAL);
			_logicTimer.addEventListener(TimerEvent.TIMER, onLogicTimer);
			_callBackList = new Dictionary();
			_callBackVars = new Dictionary();
		}
	}
}