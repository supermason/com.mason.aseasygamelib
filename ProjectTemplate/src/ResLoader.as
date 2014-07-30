package 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 3:41:25 PM
	 * description 游戏资源加载器
	 **/
	public class ResLoader
	{		
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		// 此时没有语言包可用
		// 为了方便修改， 所以把类中用到的语言全部提取放在类的最开始
		private var LOADING_CONFIG_FILE:String = "正在加载游戏配置文件...";
		private var LOADING_LANGUAGE_FILE:String = "正在加载游戏语言包...";
		private var LOADING_ERROR_INFO_FILE:String = "正在加游戏提示资源包...";
		private var LAODING_GAME_RESOURCE_FILE:String = "正在加载游戏资源文件...";
		private var LOADING_RES_VERSION:String = "正在加载游戏资源配置文件...";
		private var LOADING_DATA_FILE:String = "正在加载数据文件...";
		
		// 用于加载语言包|配置文件 【开发使用】
		private var _urlLoader:URLLoader;
		private var _config:XML;
		private var _language:XML;
		private var _error:XML;
		private var _resVersion:String;
		// 用于加载数据文件【上线使用】
		private var _urlStream:URLStream;
		private var _data:Object;
		// 用于加载通用UI资源
		private var _loader:Loader;
		private var _context:LoaderContext;
		// 资源加载路径
		private var _resURL:String;
		private var _cdn:String;
		// 
		private var _urlRequest:URLRequest;
		// 加载阶段
		private var _loadingStep:int;
		// 回调方法
		private var _progressHandler:Function;
		private var _infoHandler:Function;
		private var _resCompleteHandler:Function;
		
		private var _isOnline:Boolean;
		private var _version:String = "";
		
//		private var _applicationDomain:ApplicationDomain;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function ResLoader(isOnline:Boolean, version:String)
		{
			_isOnline = isOnline;
			_version = version;
			
			initLoader();
		}
		
		protected function initLoader():void 
		{
			if (_isOnline)
			{
				_urlStream = new URLStream();
				_urlStream.addEventListener(Event.COMPLETE, onUrlStreamComplete);
				_urlStream.addEventListener(ProgressEvent.PROGRESS, onProgress);
				_urlStream.addEventListener(IOErrorEvent.IO_ERROR, onIoErrer);
			}
			else
			{
				_urlLoader = new URLLoader();
				_urlLoader.dataFormat = URLLoaderDataFormat.TEXT
				_urlLoader.addEventListener(Event.COMPLETE, onUrlLoaderComplete);
				_urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
				_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoErrer);
			}
			
			_context = new LoaderContext(true, ApplicationDomain.currentDomain);
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		public function startLoadRes(progressHandler:Function, 
									 infoHandler:Function,
									 completeHandler:Function):void
		{
			this._progressHandler = progressHandler;
			this._infoHandler = infoHandler;
			this._resCompleteHandler = completeHandler;
			
			if (_isOnline)
				loadDataFile();
			else
				loadConfig();
		}
		
		public function dispose():void
		{
			_progressHandler = null;
			_infoHandler = null;
			_resCompleteHandler = null;
			
			_urlRequest = null;
			_context = null;
			
			_language = null;
			_config = null;
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		/**加载配置文件*/
		private function loadConfig():void
		{
			_loadingStep = LoadingStep.LOADING_CONFIG;
			_resURL = _cdn + "config/Config.xml?t=" + _version ; //new Date().time * Math.random();
			_urlRequest.url = _resURL;
			_urlLoader.load(urlRequest);
			_infoHandler(LOADING_CONFIG_FILE);
		}
		
		/**加载语言包*/
		private function loadLanguage():void
		{
			_loadingStep = LoadingStep.LOADING_LANGUAGE;
			_resURL = _cdn + "language/Chinese.xml?t=" + _version ; //new Date().time * Math.random();
			_urlRequest.url = _resURL;
			_urlLoader.load(urlRequest);
			_infoHandler(LOADING_LANGUAGE_FILE);
		}
		
		/**加载错误提示文件*/
		private function loadErrFile():void
		{
			_loadingStep = LoadingStep.LOADING_ERROR_FILE;
			_resURL = _cdn + "language/Error.xml?t=" + _version ; //new Date().time * Math.random();
			_urlRequest.url = _resURL;
			_urlLoader.load(urlRequest);
			_infoHandler(LOADING_ERROR_INFO_FILE);
		}
		
		/**加载游戏资源配置文件*/
		private function loadResVersion():void
		{
			_loadingStep = LoadingStep.LOADING_RES_VERSION;
			_resURL = _cdn + "config/version.txt?t=" + _version ; //new Date().time * Math.random();
			_urlRequest.url = _resURL;
			_urlLoader.load(urlRequest);
			_infoHandler(LOADING_RES_VERSION);
		}
		
		/**加载界面资源文件*/
		private function loadUIResource():void
		{
			_loadingStep = LoadingStep.LOADING_UI_RES;
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoErrer);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			_resURL = _cdn + "assets/swf/ui/mainUI.swf?t=" + _version ; //new Date().time * Math.random();
			
			_urlRequest.url = _resURL;
			_loader.load(urlRequest, _context);
			_infoHandler(LAODING_GAME_RESOURCE_FILE);
		}
		
		/**加载数据文件*/
		private function loadDataFile():void
		{
			_loadingStep = LoadingStep.LOADING_DATA_FILE;
			
			_resURL = _cdn + "data/data.zip?t=" + _version ; //new Date().time * Math.random();
			_urlRequest.url = _resURL;
			_urlStream.load(_urlRequest);
			_infoHandler(LOADING_DATA_FILE);
		}
		
		/**解压缩数据文件*/
		private function unZipDataModel():void
		{
			var zipFile:ZipFile = new ZipFile(_urlStream);
			_data = { };
			for each (var entry:ZipEntry in zipFile.entries)
			{
				_data[entry.name.split("/").pop()] = zipFile.getInput(entry).toString();
			}
			
			zipFile.entries.length = 0;
			zipFile = null;
		}
		
		private function disposeUrlLoader():void
		{
			_urlLoader.removeEventListener(Event.COMPLETE, onUrlLoaderComplete);
			_urlLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIoErrer);
			
			_urlLoader = null;
		}
		
		private function disposUrlStream():void
		{
			_urlStream.removeEventListener(Event.COMPLETE, onUrlStreamComplete);
			_urlStream.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			_urlStream.removeEventListener(IOErrorEvent.IO_ERROR, onIoErrer);
			
			_urlStream = null;
		}
		
		private function disposeLoader():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoErrer);
			_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			_loader.unloadAndStop();
			_loader = null;
		}
		
		/*=======================================================================*/
		/* EVNET HANDLER                                                         */
		/*=======================================================================*/
		private function onProgress(e:ProgressEvent):void 
		{
			_progressHandler(e.bytesLoaded, e.bytesTotal);
		}
		
		private function onUrlLoaderComplete(e:Event):void 
		{
			if (_loadingStep == LoadingStep.LOADING_CONFIG) // 配置文件
			{
				_config = XML(_urlLoader.data);
				
				loadLanguage();
			}
			else if (_loadingStep == LoadingStep.LOADING_LANGUAGE) // 语言包
			{
				_language = XML(_urlLoader.data);
				
				loadErrFile();
				
			}
			else if (_loadingStep == LoadingStep.LOADING_ERROR_FILE) // 错误提示资源包
			{
				_error = XML(_urlLoader.data);
				
				loadResVersion();
				
//				disposeUrlLoader();
//				
//				loadUIResource();
				
			}
			else if (_loadingStep == LoadingStep.LOADING_RES_VERSION) // 资源配置文件
			{
				_resVersion = String(_urlLoader.data);
				
				disposeUrlLoader();
				
				loadUIResource();
				
				//loadFont();
			}
		}
		
		private function onUrlStreamComplete(event:Event):void
		{
			unZipDataModel();
			
			disposUrlStream();
			
			loadUIResource();
		}
		
		private function onLoaderComplete(e:Event):void 
		{
			if (_loadingStep == LoadingStep.LOADING_UI_RES) // 游戏UI资源
			{
				disposeLoader();
				
				_resCompleteHandler();
			}
		}
		
		private function onIoErrer(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void
		{
			trace(event.text);
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		public function get language():XML 
		{
			return _language;
		}
		
		public function get error():XML 
		{
			return _error;
		}
		
		public function get config():XML 
		{
			return _config;
		}
		
		public function get resVersion():String
		{
			return _resVersion;
		}

		public function get loader():Loader 
		{
			return _loader;
		}
		
		public function set loader(value:Loader):void 
		{
			_loader = value;
		}
		
		public function get urlRequest():URLRequest 
		{
			return _urlRequest;
		}
		
		public function set urlRequest(value:URLRequest):void 
		{
			_urlRequest = value;
		}

		public function get cdn():String
		{
			return _cdn;
		}

		public function set cdn(value:String):void
		{
			_cdn = value;
		}

		public function get data():Object
		{
			return _data;
		}

	}
}

class LoadingStep
{
	public static const LOADING_CONFIG:int = 1;
	
	public static const LOADING_LANGUAGE:int = 2;
	
	public static const LOADING_ERROR_FILE:int = 3;
	
	public static const LOADING_UI_RES:int = 4;
	
	public static const LOADING_RES_VERSION:int = 5;
	
	public static const LOADING_DATA_FILE:int = 6;
}