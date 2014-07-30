package com.company.projectname.network.monitor
{
	import com.company.projectname.SystemManager;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 1:27:30 PM
	 * description 数据发送状态监听器具体实现类
	 **/
	public class SendingStateMonitor implements ISendingStateMonitor
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _curMode:uint;
		private var _canSend:Boolean;
		
		// 计时器模式
		private const CANCEL_TIMER_MODE:String = "cancel_timer_mode";
		private var _interval:uint;
		
		// 遮罩模式
		private var DELAY_NAME:String = "HIDE_OPERATION_COVER";
		private var _coverShown:Boolean;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function SendingStateMonitor()
		{
			_canSend = true; // 一上来是可以发送数据的
		}
		
		/*=======================================================================*/
		/* PUBLICS                                                               */
		/*=======================================================================*/
		public function coverMode():Boolean
		{
			//SystemManager.Instance.uiMgr.oprCoverMgr.showCover();
			if (!_coverShown)
			{
				_coverShown = true;
				SystemManager.Instance.loaderMgr.singleLoaderMgr.showLoadBar();
				// 开启一个10秒的计时器，如果10秒没有响应，则自动移除遮罩
				SystemManager.Instance.timerMgr.addDelayCallBack(DELAY_NAME, $removeOprCover, 10000);
			}
			return true;
		}
		
		public function timerMode():Boolean
		{
			if (_canSend)
			{
				_canSend = false;
				SystemManager.Instance.timerMgr.addDelayCallBack(CANCEL_TIMER_MODE, resetFlag, _interval);
				
				return true;
				
			}
			
			return false;
		}
		
		public function cancel():void
		{
			if (_curMode == MonitorMode.COVER_MODE)
			{
				$removeOprCover(false);
			}
			else if (_curMode == MonitorMode.TIMER_MODE)
			{
				SystemManager.Instance.timerMgr.clearDelayCB(CANCEL_TIMER_MODE);
				resetFlag();
			}
		}
		
		/*=======================================================================*/
		/* PRIVATE                                                               */
		/*=======================================================================*/
		private function resetFlag():void
		{
			_canSend = true;
		}
		
		private function $removeOprCover(autoInvoke:Boolean=true):void
		{
			if (!autoInvoke)
				SystemManager.Instance.timerMgr.clearDelayCB(DELAY_NAME);
			SystemManager.Instance.loaderMgr.singleLoaderMgr.hideLoadBar();
			_coverShown = false;
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		public function get curMode():int
		{
			return _curMode;
		}
		
		public function set curMode(value:int):void
		{
			_curMode = value;
		}
		
		public function get interval():int
		{
			return _interval;
		}
		
		public function set interval(value:int):void
		{
			_interval = value;
		}
	}
}