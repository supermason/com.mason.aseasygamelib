package easygame.framework.loader
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 4:03:35 PM
	 * description 文本、二进制文件加载器
	 **/
	public class URLLoaderBase extends LoaderAdapter
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		protected var _urlLoader:URLLoader;
		private var _content:*;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function URLLoaderBase()
		{
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			initLoader();
			_urlRequest = new URLRequest();
		}
		
		/**
		 * 获取加载的数据对象 
		 * @return 
		 * 
		 */		
		protected function getContent():*
		{
			return _content;
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		override public function initLoader(checkPolicyFile:Boolean=false, 
								   applicationDomain:ApplicationDomain=null, 
								   securityDomain:SecurityDomain=null):void
		{
			_urlLoader.addEventListener(Event.COMPLETE, onComplete);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		
		override public function load(url:String):void
		{
			_resourceURL = url;
			_urlRequest.url = _cdn + _resourceURL;
			_urlLoader.load(_urlRequest);
		}
		
		override public function unload():void
		{
			_urlLoader.removeEventListener(Event.COMPLETE, onComplete);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_urlLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		
		override public function dispose():void
		{
			unload();
			_urlLoader = null;
		}
		
		/*=======================================================================*/
		/* EVNET HANDLER                                                         */
		/*=======================================================================*/
		override protected function onComplete(event:Event):void
		{
			_content = _urlLoader.data;
			
			if (reuse) unload();
			else dispose();
		}
	}
}