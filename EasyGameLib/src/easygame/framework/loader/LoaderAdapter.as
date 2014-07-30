package easygame.framework.loader
{
	/** 
	 * @author: mason
	 * @E-mail: jijiiscoming@hotmail.com
	 * @version 1.0.0 
	 * 创建时间：May 13, 2014 9:28:32 AM 
	 * 描述：空实现接口中的各种方法，并设置对应的类属性
	 * */
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	
	public class LoaderAdapter implements ILoader
	{
		/**加载器是否重复使用的标识*/
		protected var _resuse:Boolean;
		/**cdn路径*/
		protected var _cdn:String;
		/**加载进程处理方法*/
		protected var _progressHandler:Function;
		/**加载结束的处理方法*/
		protected var _completeHandler:Function;
		/**资源版本号*/
		protected var _assetsVersion:String;
		/**是否需要将本次加载的资源放入缓存池*/
		protected var _needCache:Boolean;
		/**加载器信息对象（对于URLLoader，该值永远为null）*/
		protected var _loaderInfo:LoaderInfo;
		/**加载辅助对象*/
		protected var _urlRequest:URLRequest;
		/**资源地址*/
		protected var _resourceURL:String;
		
		public function LoaderAdapter()
		{
		}
		
		/*=======================================================================*/
		/* PUBLIC                                                                */
		/*=======================================================================*/
		public function initLoader(checkPolicyFile:Boolean=false, applicationDomain:ApplicationDomain=null, securityDomain:SecurityDomain=null):void
		{
		}
		
		public function load(resURL:String):void
		{
		}
		
		public function unload():void
		{
		}
		
		public function dispose():void
		{
		}
		
		
		/*=======================================================================*/
		/* EVNET HANDLER                                                         */
		/*=======================================================================*/
		/**
		 * 资源加载完毕触发 
		 * @param event
		 * 
		 */		
		protected function onComplete(event:Event):void
		{
			unload();
		}
		/**
		 * 资源加载中触发 
		 * @param event
		 * 
		 */		
		protected function onProgress(event:ProgressEvent):void
		{
			if (_progressHandler != null)
				_progressHandler.call(null, event);
		}
		/**
		 * 加载发生IO错误时发生 
		 * @param event
		 * 
		 */		
		protected function onIOError(event:IOErrorEvent):void
		{
			unload();
			
			trace(_urlRequest.url + " not exist!");
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		public function set reuse(value:Boolean):void
		{
			_resuse = value;
		}
		
		public function get reuse():Boolean
		{
			return _resuse;
		}
		
		public function get cdn():String 
		{
			return _cdn;
		}
		
		public function set cdn(value:String):void
		{
			_cdn = value;
		}
		
		public function get progressHandler():Function
		{
			return _progressHandler;
		}
		
		public function set progressHandler(value:Function):void
		{
			_progressHandler = value;
		}
		
		public function get completeHandler():Function
		{
			return _completeHandler;
		}
		
		public function set completeHandler(value:Function):void
		{
			_completeHandler = value;
		}
		
		public function get assetsVersion():String
		{
			return _assetsVersion;
		}
		
		public function set assetsVersion(value:String):void
		{
			_assetsVersion = value;
		}
		
		public function get needCache():Boolean
		{
			return _needCache;
		}
		
		public function set needCache(value:Boolean):void
		{
			_needCache = value;
		}
		
		public function get loaderInfo():LoaderInfo
		{
			return _loaderInfo;
		}
	}
}