package easygame.framework.cache.res
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 2:32:39 PM
	 * description 资源缓存器对象管理器
	 **/
	public class ResCacheManager
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		/**
		 * SWF类型资源
		 */
		static public const SWF:String = "swf";
		/**
		 * 图片类型资源 
		 */		
		static public const IMAGE:String = "image";
		/**
		 * 配置文件类型资源[多为TXT] 
		 */		
		static public const CONFIG:String = "config";
		/**
		 * 持久性的图片资源 
		 */		
		static public const PERMANENT_IMAGE:String = "permanent_image"; 
		
		private var _cachePool:Dictionary;
		private var _appDomain:ApplicationDomain;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function ResCacheManager()
		{
			_appDomain = ApplicationDomain.currentDomain;
			
			_cachePool = new Dictionary();
			_cachePool[ResCacheManager.SWF] = new ResCache(); // 这个缓存列表并不会真正保存任何资源，就是一个swf是否已经加载的判断标识
			_cachePool[ResCacheManager.CONFIG] = new ResCache(); // 这个缓存列表用于缓存资源SWF中的配置信息
			_cachePool[ResCacheManager.IMAGE] = new ResCache(); // 这个缓存列表用于存放游戏内的各种物品图片
			_cachePool[ResCacheManager.PERMANENT_IMAGE] = new ResCache(); // 这个缓存列表用于存放游戏内的各种只加载一次的图片资源
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		/**
		 * 缓存一个资源。如果指定的identifier不存在，则抛出异常
		 * 对于资源SWF，不用手动缓存，加载时已经存入ApplicationDomain中了.
		 * @param key:
		 * @param identifier:
		 * @param value:
		 * */
		public function cache(key:*, identifier:String, value:*):void
		{
			if (_cachePool[identifier])
				_cachePool[identifier].cache(key, value);
			else
				throw new Error("Identifier not found::::Current Identifier[" + identifier + "]");
		}
		
		/**
		 * 缓存中是否有要查找的资源。如果指定的identifier不存在，则抛出异常
		 * @param key：资源名称
		 * @param identifier：缓存类型。ResCacheManager类中常量[SWF|IMAGE|CONFIG|EQUIP_ATTRIS]等的一个
		 * */
		public function hasResource(key:*, identifier:String):Boolean
		{
			if (_cachePool[identifier])
				return _cachePool[identifier].hasAssets(key);
			
			throw new Error("Identifier not found::::Current Identifier[" + identifier + "]");
		}
		
		/**
		 * 从缓存中获取图片资源[BitmapData]
		 * @param key: 
		 * */
		public function findImage(key:*):BitmapData
		{
			return _cachePool[ResCacheManager.IMAGE].findAssets(key) as BitmapData;
		}
		
		/**
		 * 从缓存池中获取持久化图片资源 [BitmapData]
		 * @param key
		 * @return 
		 * 
		 */		
		public function findPermanentImg(key:*):BitmapData
		{
			return _cachePool[ResCacheManager.PERMANENT_IMAGE].findAssets(key) as BitmapData;
		}
		
		/**
		 * 从缓存中获取图片资源[*]
		 * @param key: 
		 * */
		public function findRawImage(key:*):*
		{
			return _cachePool[ResCacheManager.IMAGE].findAssets(key);
		}
		
		/**删除缓存中的图片*/
		public function removeImage(key:*):void
		{
			_cachePool[ResCacheManager.IMAGE].removeAssets(key);
		}
		
		/**当前域名下是否存在某个类名*/
		public function hasClassInCurrentDomain(rsName:String):Boolean
		{
			return _appDomain.hasDefinition(rsName);
		}
		
		/**
		 * 从加载的资源SWF中提取资源。如果资源名称不存在，则抛出错误
		 * @param rsName: 要提取的资源名称
		 * @return 
		 * */
		public function getResourceFromMV(rsName:String):Class
		{
			if (_appDomain.hasDefinition(rsName))
				return _appDomain.getDefinition(rsName) as Class;
			
			throw new Error("Resource not found::::Resource Name[" + rsName + "]");
		}
		
		/**
		 * 从资源创建镜片剪辑 
		 * @param clazName
		 * @return 
		 * 
		 */		
		public function createMVByClazName(clazName:String):MovieClip
		{
			return new (getResourceFromMV(clazName))();
		}
		
		/**
		 * 提取缓存的配置文件
		 * @param key
		 * @return XML
		 * */
		public function getConfig(key:*):XML
		{
			return XML(_cachePool[ResCacheManager.CONFIG].findAssets(key));
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 应用程序域，里面保存了所有已类名方式存在的资源 
		 */
		public function set appDomain(value:ApplicationDomain):void
		{
			_appDomain = value;
		}
	}
}