package easygame.framework.loader
{
	import flash.system.ApplicationDomain;
	
	import easygame.framework.core.easygame_internal;
	
	use namespace easygame_internal; 
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 4:17:35 PM
	 * description 加载器管理器对象
	 **/
	public class LoaderManagerBase implements ILoaderManager
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		// 基础属性 ////
		protected var _assetsLaoder:AssetsLoader;
		protected var _total:int;
		protected var _current:int;
		protected var _loadContent:ILoadContent;
		protected var _loadingTipTxt:String;
		protected var _appDomain:ApplicationDomain;
		protected var _cdn:String;
		protected var _resInitHandlerList:String;
		
		// 加载器所需的各种处理函数 ////
		protected var _startHandler:Function; // 弹出loading界面
		protected var _progressHandler:Function; // 显示loading进度
		protected var _progressByManualHandler:Function; // 手动设置loading进度
		protected var _loadingInfoHandler:Function; // 如何显示loading进度信息
		protected var _resetHandler:Function; // 重置
		protected var _loadCompleteHandler:Function; // 加载完毕，隐藏加载界面
		
		// 标识 ////
		protected var _loadBarShown:Boolean;
		/**
		 * 1-加载完毕后隐藏|2-不显示加载界面|3-显示且加载完毕后不隐藏
		 */
		protected var _behaviour:int;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 构造方法
		 * @param	appDomain
		 * @param	cdn
		 */
		public function LoaderManagerBase(appDomain:ApplicationDomain, cdn:String) 
		{
			this._appDomain = appDomain;
			this._cdn = cdn;
			
			_assetsLaoder = new AssetsLoader(loadNext, false);
			_assetsLaoder.reuse = true;
			_assetsLaoder.cdn = _cdn;
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		/**
		 * 初始化加载器的各种处理函数
		 * @param	startHandler
		 * @param	progressHandler
		 * @param	progressByManualHandler
		 * @param	loadingInfoHandler
		 * @param	resetHandler
		 * @param	loadCompleteHandler
		 */
		public function initLoaderHandlers(startHandler:Function,
										   progressHandler:Function,
										   progressByManualHandler:Function,
										   loadingInfoHandler:Function,
										   resetHandler:Function,
										   loadCompleteHandler:Function):void
		{
			_startHandler = startHandler;
			_progressHandler = progressHandler;
			_progressByManualHandler = progressByManualHandler;
			_loadingInfoHandler = loadingInfoHandler;
			_resetHandler = resetHandler;
			_loadCompleteHandler = loadCompleteHandler;
			
			_assetsLaoder.progressHandler = _progressHandler;
			//_assetsLaoder.completeHandler = _loadCompleteHandler;
		}
		
		/**
		 * 外部调用，手动弹出loadBar界面
		 */
		public function showLoadBar():void
		{
			if (!_loadBarShown)
			{
				_loadBarShown = true;
				_startHandler();
			}
		}
		
		/**
		 * 隐藏加载信息 
		 * 
		 */	
		public function hideLoadingInfo():void
		{
			
		}
		
		/**
		 * 手动设置当前的加载进度
		 * @param	current
		 * @param	total
		 * @param	description
		 */
		public function manualSetProgress(current:int, total:int, description:String):void
		{
			_resetHandler();
			_progressByManualHandler(current, total);
			_loadingInfoHandler(description);
		}
		
		/**
		 * 外部调用，手动隐藏loadBar界面
		 */
		public function hideLoadBar():void
		{
			if (_loadBarShown)
			{
				_loadBarShown = false;
				_loadCompleteHandler();
			}
		}
		
		public function addRawLoadContent(assetsURL:String="", resType:String="image", loadingInfo:String="", completeHandler:Function=null):ILoaderManager
		{
			_loadContent = LoadContent.fromPool(assetsURL, resType, loadingInfo, completeHandler);
			
			addLoadContent(_loadContent);      
			
			return this;
		}
		
		public function addLoadContent(loadContent:ILoadContent):ILoaderManager
		{
			
			return this;
		}
		
		public function startLoad(behaviour:int=1, completeHandler:Function=null):void
		{
			
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		/**
		 * 加载下一个资源 
		 * 
		 */		
		protected function loadNext():void
		{
			
		}
		
		/**
		 * 全部资源加载完毕后，进行收尾工作 
		 * 
		 */		
		protected function loadComplete():void
		{
			if (_behaviour == LoadBehaviour.SHOW_AND_REMOVE_ON_COMPLETE)
			{
				if (_loadCompleteHandler != null)
					_loadCompleteHandler.call();
			}
			
			reset();
		}
		
		/**
		 * 重置资源加载器 
		 * 
		 */		
		protected function reset():void
		{
			LoadContent.toPool(_loadContent);
			_total = 0;
			_current = 0;
			_loadBarShown = false;
			_assetsLaoder.unload();
			_behaviour = LoadBehaviour.SHOW_AND_REMOVE_ON_COMPLETE;
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * cdn路径 
		 * @param value
		 * 
		 */		
		public function set cdn(value:String):void
		{
			this._cdn = value;
			if (_assetsLaoder)
				_assetsLaoder.cdn = value;
		}
		
		/**
		 * 资源版本号 
		 * @param value
		 * 
		 */		
		public function set version(value:String):void 
		{
			_resInitHandlerList = value;
			
			if (_assetsLaoder)
				_assetsLaoder.assetsVersion = value;
		}
		
		/**
		 *  缓存资源的处理方法
		 * @param value
		 * 
		 */		
		public function set resCacheHandler(value:Function):void
		{
			_assetsLaoder.cacheHandler = value;
		}
		
		/**
		 * 默认加载提示信息 
		 * @param value
		 * 
		 */		
		public function set defaultLoadingTipTxt(value:String):void 
		{
			_loadingTipTxt = value;
		}
	}
}