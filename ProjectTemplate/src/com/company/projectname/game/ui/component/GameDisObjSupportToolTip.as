package com.company.projectname.game.ui.component
{
	import com.company.projectname.SystemManager;
	
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 1:41:52 PM
	 * description 支持悬停的显示对象基类
	 **/
	public class GameDisObjSupportToolTip extends GameDisObjBase
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		/**悬停文字描述*/
		protected var _toolTip:String;
		/**悬停框是否已经显示*/
		protected var _toolTipShown:Boolean;
		/**是否在悬停中显示图片*/
		protected var _showImg:Boolean;
		/**toolTip中可能使用到的一些参数*/
		protected var _vars:Object;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function GameDisObjSupportToolTip(assetsType:int, buttonMode:Boolean=true)
		{
			super(assetsType, buttonMode);
			
			_showImg = true;
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		override public function addEvt():void
		{
			super.addEvt();
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		override public function removeEvt():void
		{
			super.removeEvt();
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		override public function reset():void
		{
			super.reset();
			
			_toolTip = "";
			_toolTipShown = false;
			_showImg = true;
		}
		
		/**
		 * 弹出tooltip 
		 * @param event 
		 * 
		 */		
		public function showToolTip(event:MouseEvent):void
		{
			_toolTipShown = true;
			
			SystemManager.Instance.uiMgr.toolTipMgr.setTip(
				(_showImg &&_disObj is Bitmap) ? Bitmap(_disObj).bitmapData : null, 
				_toolTip.split("|"), 
				event.stageX + 20,
				event.stageY + 30,
				_vars
			);
		}
		
		/**
		 * 移除tooltip 
		 * 
		 */		 
		public function hideToolTip():void
		{
			SystemManager.Instance.uiMgr.toolTipMgr.clear();
		}
		
		/*=======================================================================*/
		/* EVENT  HANDLER                                                        */
		/*=======================================================================*/
		protected function onMouseOver(event:MouseEvent):void
		{
			//event.stopImmediatePropagation();
			
			if (_toolTip && _toolTip != "")
			{
				addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				showToolTip(event);
			}
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			hideToolTip();
			
			_toolTipShown = false;
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			if (_toolTipShown)
			{
				SystemManager.Instance.uiMgr.toolTipMgr.reposition(event.stageX + 20, event.stageY + 30);
			}
		}
	}
}