package easygame.framework.cache.res
{
	import flash.display.BitmapData;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 2:24:56 PM
	 * description 图片、swf等资源缓存器
	 **/
	public class ResCache
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		protected var _pool:Array;
		protected var _keys:Array;
		protected var _index:int;
		/**
		 * 设置缓存的容量上限
		 */
		protected var _capacity:int = 500;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function ResCache()
		{
			_pool = [];
			_keys = [];
			_index = 0;
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		/**
		 * 将一个资源加入缓存池 
		 * @param key
		 * @param value
		 */		
		public function cache(key:*, value:Object):void
		{
			disposePreRes();
			
			_pool[_index] = value;
			_keys[_index] = key;
			_index++;
			_index %= _capacity;
		}
		
		/**
		 * 从缓存池中查找一个资源对象 
		 * @param key
		 * @return 
		 */		
		public function findAssets(key:*):Object
		{
			return _pool[_keys.indexOf(key)];
		}
		
		/**
		 * 资源缓存池中是否存在某个资源 
		 * @param key
		 * @return 
		 * 
		 */		
		public function hasAssets(key:*):Boolean
		{
			return getKeyIndex(key) > -1;
		}
		
		/**
		 * 从资源缓存池中移除某个资源对象 
		 * @param key
		 * 
		 */		
		public function removeAssets(key:*):void
		{
			var i:int = getKeyIndex(key);
			if (i > -1)
			{
				_keys.splice(i, 1);
				var removed:Array = _pool.splice(i, 1);
				
				for each (var item:* in removed)
				{
					if (item is BitmapData)
					{
						BitmapData(item).dispose();
						item = null;
					}
				}
			}
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 销毁缓存池中之前索引处的数据，防止内存泄漏 
		 * 
		 */		
		private function disposePreRes():void
		{
			if (_pool[_index])
			{
				if (_pool[_index] is BitmapData)
				{
					//					trace("销毁 缓存池之前的对象：" + _pool[_index]);
					BitmapData(_pool[_index]).dispose();
					_pool[_index] = null;
				}
			}
		}
		
		private function getKeyIndex(key:*):int
		{
			return _keys.indexOf(key);
		}
	}
}