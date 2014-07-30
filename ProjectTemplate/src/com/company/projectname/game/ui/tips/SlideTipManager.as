package com.company.projectname.game.ui.tips
{
	import com.company.projectname.SystemManager;
	import com.company.projectname.game.ui.window.PopUpManager;
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	
	import easygame.framework.cache.CommonCache;
	import easygame.framework.core.easygame_internal;
	import easygame.framework.display.ISlideTip;
	import easygame.framework.display.SlideTip;
	
	use namespace easygame_internal;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 2, 2013 9:07:15 AM
	 * description: 游戏内滑屏提示管理器
	 **/
	public class SlideTipManager extends PopUpManager
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _slideTipCache:CommonCache;
		private var _activeST:ISlideTip;
		private var _tempST:ISlideTip;
		private var _slideTipBgData:BitmapData;
		private var _slideTipIcon:BitmapData;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function SlideTipManager()
		{
			super();
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		override public function init(parent:DisplayObjectContainer):void
		{
			super.init(parent);
			
			_slideTipCache = new CommonCache(SlideTip);
			
			_slideTipBgData = new (SystemManager.Instance.resCacheMgr.getResourceFromMV("com.company.projectname.game.ui.tips.SlideMsgSkin"))();
			
			_slideTipIcon = new (SystemManager.Instance.resCacheMgr.getResourceFromMV("com.company.projectname.game.ui.tips.SlideMsgIcon"))();
		}
		
		/**
		 * 开始滑屏提示 
		 * @param	tips
		 * @param	needImg
		 * @param	tipImage
		 * @param	callBack
		 * @param	callBackParams
		 * @param	delay
		 */
		public function slideTip(tips:String, needImg:Boolean=true, tipImage:BitmapData=null, callBack:Function=null, callBackParams:Object=null, delay:Number=1.0):void
		{
			_activeST = ISlideTip(_slideTipCache.fromPool());
			_activeST.bgImage = _slideTipBgData;
			_activeST.setMessage(tips, needImg ? _slideTipIcon.clone() : null);
			addPop(_activeST);
			if (delay > 0) 
			{
				_activeST.y -= 100;
				
				TweenLite.to(
					_activeST,
					0.6, {
						autoAlpha: 1,
						y: "-70",
//						ease: Quart.easeOut,
						onComplete: hideSlideTip,
						onCompleteParams: [_activeST, callBack, callBackParams, delay]
					});
			} 
			else 
			{
				TweenLite.to(
					_activeST,
					1, {
					alpha: 0,
					y: "-250",
//					ease: Quart.easeIn,
					onComplete: removeSlideTip,
					onCompleteParams: [_activeST, callBack, callBackParams]
				});
				//hideSlideTip(_activeST, callBack, callBackParams, 0);
			}
		}
		
		/**
		 * 窗体大小改变事件
		 */
		override public function onResize(x:int=-1, y:int=-1):void
		{
			for (var i:int = 0, len:int = _parent.numChildren; i < len; i++)
			{
				_tempST = _parent.getChildAt(i) as ISlideTip;
				
				if (_tempST)
					center(_tempST);
			}
		}
		
		// private ////
		/**
		 * 隐藏滑屏提示
		 * @param	st
		 * @param	callBack
		 * @param	callBackParams
		 * @param	delay
		 */
		private function hideSlideTip(st:ISlideTip, callBack:Function, callBackParams:Object, delay:Number):void
		{
			TweenLite.to(
				st,
				0.6, {
					"alpha": 0,
					"y": "-250",
//					"ease": Quart.easeIn,
					"delay": delay,
					"onComplete": removeSlideTip,
					"onCompleteParams": [st, callBack, callBackParams]
				});
		}
		
		
		/**
		 * 移除滑屏提示
		 * @param	tF
		 * @param	callBack
		 * @param	callBackParams
		 */
		private function removeSlideTip(st:ISlideTip, callBack:Function, callBackParams:Object):void
		{
			removePop(st);
			_slideTipCache.toPool(st);
			
			if (callBack != null) 
			{
				if (callBackParams != null) 
					callBack(callBackParams);
				else 
					callBack();
				
			}
		}
	}
}