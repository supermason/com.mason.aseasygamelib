package easygame.framework.cache.disobj
{
	import easygame.framework.core.easygame_internal;
	
	use namespace easygame_internal;
	
	/** 
	 * @author: mason
	 * @E-mail: jijiiscoming@hotmail.com
	 * @version 1.0.0 
	 * 创建时间：May 13, 2014 3:53:59 PM 
	 * 描述：
	 * */
	public class DisplayObjectCache
	{
		private var _ClzCached:Class;
		private var _pool:Vector.<ICachableDisplayObject>;
		
		public function DisplayObjectCache(clz:Class)
		{
			_ClzCached = clz;
			_pool = new <ICachableDisplayObject>[];
		}
		
		// private ////
		/**
		 * @private 
		 */		
		easygame_internal function fromPool(initEvt:Boolean):ICachableDisplayObject
		{
			var disObj:ICachableDisplayObject = null;
			
			if (_pool.length) disObj = _pool.pop();
			else 			  disObj = new _ClzCached();
			
			if (initEvt)	  disObj.addEvt();
			
			return disObj;
		}
		
		/**
		 * @private 
		 */		
		easygame_internal function toPool(disObj:ICachableDisplayObject):void
		{
			disObj.reset();
			_pool[_pool.length] = disObj;
		}
	}
}