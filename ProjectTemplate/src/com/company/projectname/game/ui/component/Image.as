package com.company.projectname.game.ui.component
{
	import com.company.projectname.SystemManager;
	import com.company.projectname.VersionController;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import easygame.framework.cache.res.ResCacheManager;
	import easygame.framework.loader.GameLoaderManager;
	import easygame.framework.loader.LoadBehaviour;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 1:19:12 PM
	 * description 自加载的图片类
	 **/
	public class Image extends Bitmap
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _resMgr:ResCacheManager;
		private var _loaderMgr:GameLoaderManager;
		private var $source:Object;
		private var _sourceLoadedCallBack:Function;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function Image()
		{
			super();
			
			_resMgr = SystemManager.Instance.resCacheMgr;
			_loaderMgr = SystemManager.Instance.loaderMgr;
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 清理资源  
		 * 
		 */		
		public function dispose():void
		{
			if (this.bitmapData)
			{
				this.bitmapData.dispose();
				this.bitmapData = null;
			}
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		private function sourceLoadComplete():void
		{
			if (_resMgr.hasResource($source, ResCacheManager.IMAGE))
				this.bitmapData = _resMgr.findImage($source).clone();
			if (_sourceLoadedCallBack != null)
				_sourceLoadedCallBack();
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 设置图片的资源路径（可以是图片所在的URL，也可以是一个BitmapData对象） 
		 * @param value
		 * 
		 */		
		public function set source(value:*):void
		{
			if (value is String)
			{
				$source = value;
				
				if (String($source).indexOf("?v=") == -1)
					$source += ("?v=" + VersionController.fileVersion[$source]);
				
				if (_resMgr.hasResource($source, ResCacheManager.IMAGE))
				{
					dispose();
					
					sourceLoadComplete();
				}
				else
				{
					_loaderMgr.queenLoaderMgr.addRawLoadContent(String($source), 
						ResCacheManager.IMAGE,
						"",
						sourceLoadComplete).startLoad(LoadBehaviour.NO_LOADING_INFO);
				}
			}
			else
			{
				if (value is BitmapData)
					this.bitmapData = value;
			}
		}
		
		public function get source():*
		{
			return this.bitmapData;
		}

		/**
		 * 如果需要在资源加载完毕后做特殊处理，则给该方法赋值
		 *  
		 * @param value
		 * 
		 */		
		public function set sourceLoadedCallBack(value:Function):void
		{
			_sourceLoadedCallBack = value;
		}

	}
}