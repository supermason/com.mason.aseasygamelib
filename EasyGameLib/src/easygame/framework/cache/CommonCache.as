package easygame.framework.cache
{
	import easygame.framework.core.easygame_internal;
	
	use namespace easygame_internal;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 2:03:07 PM
	 * description 通用缓存器
	 **/
	public class CommonCache
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		protected var _Clz:Class;
		protected var _pool:Vector.<ICachable>;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function CommonCache(clz:Class)
		{
			this._Clz = clz;
			_pool = new Vector.<ICachable>();
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		
		/**
		 * @private 
		 */		
		easygame_internal function fromPool():ICachable
		{
			var item:ICachable = null;
			
			if (_pool.length) item = _pool.pop();
			else 			  item = new _Clz();
			
			return item;
		}
		
		/**
		 * @private 
		 */		
		easygame_internal function toPool(disObj:ICachable):void
		{
			disObj.reset();
			_pool[_pool.length] = disObj;
		}
	}
}