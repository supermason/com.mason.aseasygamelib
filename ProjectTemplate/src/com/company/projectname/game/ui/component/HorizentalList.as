package com.company.projectname.game.ui.component
{
	import easygame.framework.cache.disobj.ICachableDisplayObject;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 11:21:58 AM
	 * description 
	 **/
	public class HorizentalList extends AlignList 
	{
		
		/**
		 * 元素水平排布的列表[默认向左扩展]
		 * @param	cacheClz
		 */
		public function HorizentalList(cacheClz:Class) 
		{
			super(cacheClz);
			
			_align = ListAlignMode.LEFT;
			
			gap = 6;
		}
		
		// protected ////
		override protected function adjustRender():void
		{
			// 从第二个元素开始自动布局
			if (contentList.length > 1)
			{
				_render.x = contentList[_index - 1].x + (contentList[_index - 1].width + gap) * (_align == ListAlignMode.LEFT ? 1 : -1);
			}
			else 
			{
				// 如果是向右排序，
				if (_align == ListAlignMode.RIGHT)
					_render.x = -_render.width;
			}
		}
		
		// getter && setter ////
		override public function get width():Number
		{
			var $width:Number = 0;
			
			for each (var ic:ICachableDisplayObject in contentList)
			{
				$width += ic.width;
			}
			
			$width += (contentList.length - 1) * gap;
			
			return $width;
		}
	}
}