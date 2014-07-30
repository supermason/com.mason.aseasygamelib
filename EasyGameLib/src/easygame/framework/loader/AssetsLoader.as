package easygame.framework.loader
{
	import easygame.framework.cache.res.ResCacheManager;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 4:13:20 PM
	 * description 游戏内资源加载器
	 **/
	public class AssetsLoader extends LoaderBase
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		/**
		 * 一次资源加载完毕且所有回调方法执行完毕的处理方法--该方法的执行标志着一个加载流程的结束 
		 */		
		protected var _procedureCompleteHandler:Function;
		/**
		 * 资源回调方法列表（当多处同时触发加载同一个URL的资源时，真实加载只会执行一次，但每个回调方法都会在资源加载完毕时被触发）
		 */		
		protected var _resInitHandlerList:Array;
		/**
		 * 资源加载器的类型（加载IMG还是SWF） 
		 */		
		protected var _loaderType:String;
		/**
		 * 缓存资源的处理方法 
		 */		
		protected var _cacheHandler:Function;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function AssetsLoader(procedureCompleteHandler:Function=null,
									 destory:Boolean=true,
									 checkPolicyFile:Boolean=false, 
									 applicationDomain:ApplicationDomain=null, 
									 securityDomain:SecurityDomain=null)
		{
			super(checkPolicyFile, applicationDomain, securityDomain);
			super._destory = destory;
			_procedureCompleteHandler = procedureCompleteHandler;
			
			_resInitHandlerList = [];
		}
		
		/*=======================================================================*/
		/* EVNET HANDLER                                                         */
		/*=======================================================================*/
		override protected function onComplete(e:Event):void
		{
			if (_needCache)
				cacheRes();
			else
				trace("无需缓存的就直接调用结束方法吧,传个参数进去");
			
			super.onComplete(e);
			
			if (_completeHandler != null)
				_completeHandler.call();
			
			invokeCallBack();
		}
		
		override protected function onIOError(e:IOErrorEvent):void
		{
			super.onIOError(e);
			
			invokeCallBack();
		}
		
		/**
		 * 获取加载的资源对象 
		 * @return 
		 * 
		 */		
		protected function getAssets():*
		{
			return _loader ? _loader.content : null;
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 对于<code>needCache</code>标识为true的，需要将加载的资源放入缓存池 
		 * 
		 */		
		private function cacheRes():void 
		{
			if (_cacheHandler != null)
			{
				if (_loaderType == LoaderType.IMAGE)
				{
					_cacheHandler(_resourceURL, ResCacheManager.IMAGE, getAssets().bitmapData);
				}
				else if (_loaderType == LoaderType.SWF)
				{
					var mc:* = getAssets()/* as MovieClip*/;
					// 这个缓存用来标识该SWF资源包已经加载了
					_cacheHandler(_resourceURL, ResCacheManager.SWF, _resourceURL);
					// 如果该SWF资源包有配置信息，则一并缓存
					if (mc.hasOwnProperty("config") && mc.config != undefined) // config 是舞台上的一个Textfield对象，它的text属性保存了配置信息
						_cacheHandler(_resourceURL, ResCacheManager.CONFIG, mc.config.text);
				}
			}
		}
		
		/**
		 * 资源加载结束，触发外部传入的回调方法 
		 * 
		 */		
		private function invokeCallBack():void
		{
			if (_resInitHandlerList && _resInitHandlerList.length > 0)
			{
				while (_resInitHandlerList.length > 0)
				{
					try
					{
						_resInitHandlerList.shift()();
					}
					catch (err:Error)
					{
						trace("EORROR IN ASSETSLOADER[LINE-100]::" + _resourceURL + "\nERROR INFO::" + err.getStackTrace());
					}
				}
			}
			
			if (_procedureCompleteHandler != null)
				_procedureCompleteHandler.call();
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 资源加载完毕切所有的回调方法执行完毕的处理方法--该方法的执行标志着一个加载流程的结束 
		 */	
		public function set procedureCompleteHandler(value:Function):void
		{
			_procedureCompleteHandler = value;
		}
		/**
		 * 缓存资源的处理方法 
		 */	
		public function get cacheHandler():Function 
		{
			return _cacheHandler;
		}
		public function set cacheHandler(value:Function):void 
		{
			_cacheHandler = value;
		}
		/**
		 * 资源加载器的类型（加载IMG还是SWF） 
		 */	
		public function get loaderType():String 
		{
			return _loaderType;
		}
		public function set loaderType(value:String):void 
		{
			_loaderType = value;
		}
		/**
		 * 资源回调方法列表（当多处同时触发加载同一个URL的资源时，真实加载只会执行一次，但每个回调方法都会在资源加载完毕时被触发）
		 */	
		public function set resInitHandlerList(value:Array):void 
		{
			_resInitHandlerList = value;
		}
	}
}