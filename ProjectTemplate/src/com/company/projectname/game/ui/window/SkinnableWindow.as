package com.company.projectname.game.ui.window
{
	import com.company.projectname.SystemManager;
	import com.company.projectname.VersionController;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	import easygame.framework.cache.res.ResCacheManager;
	import easygame.framework.display.Window;
	import easygame.framework.loader.LoadBehaviour;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 10:56:12 AM
	 * description 游戏内所有窗体的基类 
	 **/
	public class SkinnableWindow extends Window
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		/**窗体的背景对象在子类中根据需要进行初始化*/
		protected var _skin:MovieClip;
		protected var _clazName:String;
		
		/**窗体皮肤加载时的提示语言*/
		protected var _loadingInfo:String = "";
		/**窗体加载后，是否隐藏加载进度条[默认1，隐藏]*/
		protected var _hideAfterLoad:int;
		
		/**设定的窗体的宽 -- 当组件内部有滚动容器时，通常需要设置该值*/
		protected var _$width:int;
		/**设定的窗体的高-- 当组件内部有滚动容器时，通常需要设置该值*/
		protected var _$height:int;
		
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 构造方法 
		 * @param clazName 窗体对应皮肤中的as连接名称
		 * @param contentData 初始化窗体所需的数据
		 */		
		public function SkinnableWindow(clazName:String, contentData:Object) 
		{
			super(contentData);
			
			_clazName = clazName;
			_hideAfterLoad = LoadBehaviour.SHOW_AND_REMOVE_ON_COMPLETE;
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		private function createSkin():void
		{
			if (_clazName != "")
			{
				_skin = new (SystemManager.Instance.resCacheMgr.getResourceFromMV(_clazName))();
				addChildAt(_skin, 0);
			}
			initSkin();
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 窗体使用皮肤的路径(如果是as连接名称，则无需加载资源，而直接创建窗体的皮肤) 
		 * @param url
		 * 
		 */		
		override public function set skinURL(url:String):void
		{
			if (url == _clazName)
			{
				createSkin();
			}
			else
			{
//				SystemManager.Instance.loaderMgr.queenLoaderMgr.addLoadContent({
//					type: ResCacheManager.SWF,
//					info: _loadingInfo, /*_lang ? String(_lang.loadRes) : ""*/
//					url: url + "?v=" + VersionController.fileVersion[url]
//				}, createSkin).startLoad(_hideAfterLoad);
				
//				SystemManager.Instance.loaderMgr.singleLoaderMgr.addLoadContent({
//					type: ResCacheManager.SWF,
//					info: _loadingInfo, /*_lang ? String(_lang.loadRes) : ""*/
//					url: url + "?v=" + VersionController.fileVersion[url]
//				}).startLoad(createSkin, _hideAfterLoad);
				
				SystemManager.Instance.loaderMgr.singleLoaderMgr.addRawLoadContent(
					url + "?v=" + VersionController.fileVersion[url],
					ResCacheManager.SWF,
					_loadingInfo,
					createSkin).startLoad(_hideAfterLoad);
			}
		}
		
		override public function get height():Number
		{
			return _$height != 0 ? _$height : (_skin ? _skin.height : super.height);
		}
		
		override public function get width():Number
		{
			return _$width != 0 ? _$width : (_skin ? _skin.width : super.width);
		}
		
		override public function get displayContent():DisplayObjectContainer
		{
			return _skin;
		}
	}
}