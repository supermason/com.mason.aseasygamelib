package easygame.framework.cache.disobj
{
	import easygame.framework.display.GameDisplayObject;
	
	/** 
	 * @author: mason
	 * @E-mail: jijiiscoming@hotmail.com
	 * @version 1.0.0 
	 * 创建时间：May 13, 2014 3:19:39 PM 
	 * 描述：
	 * */
	public class CachableDisplayObject extends GameDisplayObject implements ICachableDisplayObject
	{
		protected var _data:Object;
		protected var _selected:Boolean;
		protected var _buziHandler:Function;
		protected var _hasEvent:Boolean;
		protected var _index:int;
		
		public function CachableDisplayObject()
		{
			init();
		}
		
		// public ////
		
		public function addEvt():void
		{
		}
		
		public function removeEvt():void
		{
		}
		
		public function dispose():void
		{
		}
		
		override public function reset():void
		{
			super.reset();
			
			removeEvt();
			
			_data = {};
			_selected = false;
			_buziHandler = null;
			_index = 0;
		}
		
		// protected ////
		/**
		 * 初始化内部组件的方法 ，构造方法中默认调用 
		 * 
		 */		
		protected function init():void
		{
			
		}
		
		// getter && setter ////
		
		public function set data(d:Object):void
		{
		}
		
		public function set buziHandler(value:Function):void
		{
			_buziHandler = value;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
	}
}