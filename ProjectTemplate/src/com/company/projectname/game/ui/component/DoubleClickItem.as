package com.company.projectname.game.ui.component
{
	import com.company.projectname.SystemManager;
	
	import flash.events.MouseEvent;
	
	import easygame.framework.timer.TimerManager;
	
	/**提供实现双击的机制，但是子类必须将<code>doubleClickEnabled = true</code>才能开启双击事件*/
	public class DoubleClickItem extends GameDisObjSupportToolTip
	{
		private const DOUBLE_CLICK:String = "DOUBLE_CLICK";
		
		// 为了实现双击
		protected var _timerMgr:TimerManager;
		protected var _singleClickHandler:Function;
		
		public function DoubleClickItem(assetsType:int, buttonMode:Boolean=true)
		{
			super(assetsType, buttonMode);
			_timerMgr = SystemManager.Instance.timerMgr;
		}
		
		//****实现双击****//
		/**每次有单击事件，先延迟200，如果之后没有双击事件，则执行单击事件的处理方法*/
		protected function deferClickEvent(e:MouseEvent):void
		{
			_timerMgr.addDelayCallBack(DOUBLE_CLICK, handleClickEvent, 300, e);
		}
		
		/**延迟计时器结束时，执行单机事件的处理*/
		protected function handleClickEvent(e:MouseEvent):void
		{
			if (_singleClickHandler != null)
				_singleClickHandler(e);
		}
		
		
		/**执行双击事件*/
		protected function doubleClickHandler(e:MouseEvent):void
		{
			_timerMgr.clearDelayCB(DOUBLE_CLICK);
			if (_buziHandler != null)
				_buziHandler(this);
		}
		
		// interface ////
		
		override public function reset():void
		{
			_singleClickHandler = null;
			super.reset();
		}
	}
}