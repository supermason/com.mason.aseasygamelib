package com.company.projectname.game.ui.component
{
	/**
	 * ...
	 * @author Mason
	 */
	public class AlignList extends List 
	{
		protected var _align:String;
		
		public function AlignList(cacheClz:Class) 
		{
			super(cacheClz);
			
		}
		
		
		public function get align():String 
		{
			return _align;
		}
		
		public function set align(value:String):void 
		{
			_align = value;
		}
	}

}