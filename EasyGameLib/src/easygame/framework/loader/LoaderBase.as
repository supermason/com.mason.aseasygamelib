package easygame.framework.loader
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 4:09:32 PM
	 * description 加载器基类
	 **/
	public class LoaderBase extends LoaderAdapter
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		protected var _loader:Loader;
		protected var _loaderContext:LoaderContext;
		protected var _destory:Boolean = true;
		
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function LoaderBase(checkPolicyFile:Boolean=false, 
								   applicationDomain:ApplicationDomain=null, 
								   securityDomain:SecurityDomain=null)
		{
			_urlRequest = new URLRequest();
			initLoader(checkPolicyFile, applicationDomain, securityDomain);
		}
		
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		override public function initLoader(checkPolicyFile:Boolean=false, 
								   applicationDomain:ApplicationDomain=null, 
								   securityDomain:SecurityDomain=null):void 
		{
			if (!_loader) 
				_loader = new Loader();
			// checkPolicyFile: Use this property only when loading an image file (not a SWF file). 
			// securityDomain: Use this property only when loading a SWF file (not an image). 
			// applicationDomain: Use this property only when loading a SWF file written in ActionScript 3.0 
			//                    (not an image or a SWF file written in ActionScript 1.0 or 2.0). 
			if (!_loaderContext)
			{
				_loaderContext = new LoaderContext(checkPolicyFile, applicationDomain, securityDomain);
			}
			else
			{
				_loaderContext.checkPolicyFile = checkPolicyFile;
				if (_loaderContext.applicationDomain != applicationDomain)
					_loaderContext.applicationDomain = applicationDomain;
				if (_loaderContext.securityDomain != securityDomain)
					_loaderContext.securityDomain = securityDomain;
			}
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			_loaderInfo = _loader.contentLoaderInfo;
		}
		
		override public function load(resURL:String):void
		{
			if (resURL == null || resURL == "")
				throw new Error("URL CAN NOT BE NULL OR \"\"");
			
			_resourceURL = resURL;
			_urlRequest.url = _cdn + _resourceURL + "?v=" + _assetsVersion;
			_loader.load(_urlRequest, _loaderContext);
		}
		
		override public function unload():void
		{
			if (_loader) 
			{
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				_loader.unloadAndStop();
			}
			
			if (_destory) dispose();
		}
		
		override public function dispose():void
		{
			if (_loader) _loader = null;
			if (_loaderContext) _loaderContext = null;
		}
	}
}