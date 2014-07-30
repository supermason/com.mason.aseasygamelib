package easygame.framework.cache.disobj
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 5:43:28 PM
	 * description 可视化组建缓存管理器
	 **/
	public class DisObjCacheManager
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _pool:Dictionary;
		private const INTERFACE_DEFINITION:String = "easygame.framework.cache.disobj::ICachableDisplayObject";
		private static var _instance:DisObjCacheManager;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function DisObjCacheManager()
		{			
			if (_instance) throw new Error("Can not initialize twice!!");
			
			_pool = new Dictionary();
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		/**
		 * 检查一个需要缓存的显示对象类型已经开启了缓存池 
		 * 
		 * <p>如果没有，则为其创建一个 
		 * 
		 * @param cacheClz 实现了ICachableDisObjItem接口的显示对象类
		 * 
		 */		
		public function checkCache(cacheClz:Class):void
		{
			// 如果不存在这个类型的缓存池
			if (!_pool.hasOwnProperty(cacheClz))
			{
				// 检查是否实现了ICachableDisObjItem接口
				if (String(describeType(cacheClz)..implementsInterface.@type).indexOf(INTERFACE_DEFINITION) != -1)
				{
					_pool[cacheClz] = new DisplayObjectCache(cacheClz);
				}
				else
				{
					throw new Error("Any Class not implementing [ICachableDisplayObject] interface can not be cached!");
				}
			}
		}
		
		/**
		 * 根据缓存类型，获取对应的显示对象 
		 * @param cacheClz
		 * @param addEvt
		 * @return 
		 */		
		public function getDisObj(cachedClz:Class, addEvt:Boolean=true):ICachableDisplayObject
		{
			if (_pool[cachedClz]) {
				return _pool[cachedClz].fromPool(addEvt);
			}
			
			throw new Error("cacheClz not found>>>[" + cachedClz + "]");
		}
		
		/**
		 * 将显示对象放回池中 
		 * @param cachedClz
		 * @param disObj
		 * 
		 */		
		public function restoreDisObj(cachedClz:Class, disObj:ICachableDisplayObject):void
		{
			if (_pool[cachedClz]) {
				_pool[cachedClz].toPool(disObj);
			}
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 获取显示对象缓存管理器对象 
		 * @return 
		 * 
		 */		
		public static function get instance():DisObjCacheManager
		{
			if (!_instance)
				_instance = new DisObjCacheManager();
			
			return _instance;
		}
	}
}