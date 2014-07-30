package com.company.projectname.game.loader
{
	import com.company.projectname.game.ui.window.PopUpManager;
	
	import flash.display.DisplayObjectContainer;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 2:08:16 PM
	 * description 加载条管理器基类
	 **/
	public class LoadingBarManagerBase extends PopUpManager
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _loadingBar:ILoadingBar;
		private var _claz:Class;
		private var _defaultTips:String;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function LoadingBarManagerBase(claz:Class, defaultTips:String="") 
		{
			super();
			
			_claz = claz;
			_defaultTips = defaultTips;
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		override public function init(parent:DisplayObjectContainer):void
		{
			if (!_loadingBar) 
			{
				super.init(parent);
				_loadingBar = new _claz();
				_coverAlpha = .01;
			}
		}
		
		/**
		 * 窗体大小改变时，调整加载条，使其始终居中显示 
		 * @param nW
		 * @param nH
		 * 
		 */		
		override public function onResize(nW:int=-1, nH:int=-1):void
		{
			if (_active) 
			{
				_loadingBar.onResize(nW, nH);
				center(_loadingBar);
			}
		}
		
		/**
		 * 设置加载时的提示信息 
		 * @param info
		 * 
		 */		
		public function loadingInfo(info:String):void
		{
			_loadingBar.loadingInfo(info);
		}
		
		/**
		 * 手动修改加载进度 
		 * @param value
		 * @param total
		 * 
		 */		
		public function progressByManual(value:Number, total:Number):void
		{
			_loadingBar.progressByManual(value, total);
		}
		
		/**
		 * 显示加载条 
		 * 
		 */		
		public function showLoading():void
		{
			if (!_active) 
			{
				addPop(_loadingBar, true, true);
				_active = true;
				_loadingBar.prepareLoadingAnimation();
			} 
			else 
			{
				bringToFront(_loadingBar);
			}
		}
		
		/**
		 * 隐藏加载条 
		 * @param cb
		 * 
		 */		
		public function hideLoading(cb:Function=null):void
		{
			removeLoadBar();
			if (cb != null) {
				cb();
			}
		}
		
		/**
		 * 加载结束，清理资源 
		 * 
		 */		
		public function reset():void
		{
			if (_active) {
				_loadingBar.reset();
			}
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		/**
		 * 移除加载条  
		 * 
		 */		
		protected function removeLoadBar():void
		{
			if (_active) 
			{
				_active = false;
				_loadingBar.reset();
				removePop(_loadingBar);
				_loadingBar.loadingInfo(_defaultTips);
			}
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 获取加载条进度显示处理方法
		 * @return 
		 * 
		 */		
		public function get progressHandler():Function
		{
			return _loadingBar.progressHandler;
		}
	}
}