package com.company.projectname.game.ui.component
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 11:21:01 AM
	 * description 垂直排列的列表
	 **/
	public class VerticalList extends List
	{
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 元素垂直排布的列表
		 * @param	cacheClz
		 */
		public function VerticalList(cacheClz:Class) 
		{
			super(cacheClz);
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		override protected function adjustRender():void
		{
			// 从第二个元素开始自动布局
			if (contentList.length > 1)
			{
				_render.y = contentList[_index - 1].y + contentList[_index - 1].height + gap;
			}
		}
	}
}