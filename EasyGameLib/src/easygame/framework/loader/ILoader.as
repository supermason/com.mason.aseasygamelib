package easygame.framework.loader
{
	import flash.display.LoaderInfo;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 3:59:33 PM
	 * description 
	 **/
	public interface ILoader
	{
		/**
		 * 初始化加载器 
		 * @param checkPolicyFile
		 * @param applicationDomain
		 * @param securityDomain
		 * 
		 */		
		function initLoader(checkPolicyFile:Boolean=false, 
							applicationDomain:ApplicationDomain=null, 
							securityDomain:SecurityDomain=null):void;
		
		/**
		 * 根据指定URL加载资源 
		 * @param resURL
		 * 
		 */		
		function load(resURL:String):void;
		/**
		 * 清理内存资源 
		 * 
		 */		
		function unload():void;
		/**
		 * 销毁加载器 
		 * 
		 */		
		function dispose():void;
		/**
		 * 设置是否加载器是多次使用的标识 
		 * @param value
		 * 
		 */		
		function set reuse(value:Boolean):void;
		function get reuse():Boolean;
		/**
		 * cdn资源站URL 
		 * @param value
		 * 
		 */		
		function set cdn(value:String):void;
		/**
		 * 设置加载进度处理方法 
		 * @return 
		 * 
		 */		
		function get progressHandler():Function;
		function set progressHandler(value:Function):void;
		/**
		 * 设置加载完成时的处理方法 
		 * @return 
		 * 
		 */		
		function get completeHandler():Function;
		function set completeHandler(value:Function):void;
		/**
		 * 资源版本号 
		 * @return 
		 * 
		 */		
		function get assetsVersion():String;
		function set assetsVersion(value:String):void;
		/**
		 * 是否需要缓存加在的资源 
		 * @return 
		 * 
		 */		
		function get needCache():Boolean;
		function set needCache(value:Boolean):void;
		/**
		 * 加载对象信息类（对于URLLoader，该值默认返回null） 
		 * @return 
		 * 
		 */		
		function get loaderInfo():LoaderInfo;
	}
}