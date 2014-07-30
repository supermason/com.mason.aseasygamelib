package easygame.framework.loader
{
	import easygame.framework.core.easygame_internal;
	
	use namespace easygame_internal;
	
	/** 
	 * @author: mason
	 * @E-mail: jijiiscoming@hotmail.com
	 * @version 1.0.0 
	 * 创建时间：May 13, 2014 10:30:38 AM 
	 * 描述：加载信息对象
	 * */
	public class LoadContent implements ILoadContent
	{
		private var _resType:String;
		private var _assetsURL:String;
		private var _loadingInfo:String;
		private var _completeHandler:Function;
		
		private static var _sContentPool:Vector.<LoadContent> = new <LoadContent>[];
		
		/**
		 * 创建一个空的加载信息对象 
		 * @param assetsURL
		 * @param resType
		 * @param info
		 * @param completeHandler
		 * 
		 */		
		public function LoadContent(assetsURL:String="", resType:String="image", loadingInfo:String="", completeHandler:Function=null)
		{
			_assetsURL = assetsURL;
			_resType = resType;
			_loadingInfo = loadingInfo;
			_completeHandler = completeHandler;
		}
		
		// getter && setter /////
		
		/**加载的资源类型（IMG 或者 SWF）*/
		public function get resType():String
		{
			return _resType;
		}
		
		/**
		 * @private
		 */
		public function set resType(value:String):void
		{
			_resType = value;
		}

		/**加载的资源地址*/
		public function get assetsURL():String
		{
			return _assetsURL;
		}

		/**
		 * @private
		 */
		public function set assetsURL(value:String):void
		{
			_assetsURL = value;
		}

		/**资源加载完成时的处理方法*/
		public function get completeHandler():Function
		{
			return _completeHandler;
		}

		/**
		 * @private
		 */
		public function set completeHandler(value:Function):void
		{
			_completeHandler = value;
		}

		/**加载进行中的提示信息*/
		public function get loadingInfo():String
		{
			return _loadingInfo;
		}

		/**
		 * @private
		 */
		public function set loadingInfo(value:String):void
		{
			_loadingInfo = value;
		}

		// content pooling
		/**
		 * @private
		 */
		easygame_internal static function fromPool(assetsURL:String="", resType:String="image", loadingInfo:String="", completeHandler:Function=null):ILoadContent
		{
			if (_sContentPool.length) return _sContentPool.pop().reset(assetsURL, resType, loadingInfo, completeHandler);
			else return new LoadContent(assetsURL, resType, loadingInfo, completeHandler);
		}
		
		/**
		 * @private
		 */
		easygame_internal static function toPool(loadContent:ILoadContent):void
		{
			loadContent.resType = "image";
			loadContent.assetsURL = loadContent.loadingInfo = "";
			loadContent.completeHandler = null;
			
			_sContentPool[_sContentPool.length] = loadContent;
		}
		
		/**
		 * @private
		 */
		easygame_internal function reset(assetsURL:String="", resType:String="image", loadingInfo:String="", completeHandler:Function=null):ILoadContent
		{
			_assetsURL = assetsURL;
			_resType = resType;
			_loadingInfo = loadingInfo;
			_completeHandler = completeHandler;
			
			return this;
		}
	}
}