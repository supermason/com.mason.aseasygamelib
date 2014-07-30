package com.company.projectname.game.ui.component
{
	/**
	 * ...
	 * @author Mason
	 */
	public class VerticalTileList extends TileList 
	{
		protected var _curContentHeight:int;
		protected var _nextLineX:int;
		
		public function VerticalTileList(cacheClz:Class) 
		{
			super(cacheClz);
			
		}
		// protected ////
		override protected function adjustRender():void
		{
			// 从第二个元素开始自动布局
			if (contentList.length > 1)
			{
				if (gotoNewLine(_render.height))
				{
					if (_align == ListAlignMode.LEFT)
						_nextLineX = contentList[_index - 1].x + contentList[_index - 1].width + _horizentalGap;
					else
						_nextLineX = contentList[_index - 1].x - contentList[_index - 1].width - _horizentalGap;
						
					_curContentHeight = _render.height + _verticalGap;
				}
				else
				{
					_render.y = contentList[_index - 1].y + contentList[_index - 1].height + _verticalGap;
					_curContentHeight += (_render.height + _verticalGap);
				}
				
				_render.x = _nextLineX;
				
			}
			else
			{
				_nextLineX = 0;
				_curContentHeight = contentList[0].height + _verticalGap;
				// 如果是向右排序，
				if (_align == ListAlignMode.RIGHT)
					_render.x = -_render.width;
			}
		}
		
		/**
		 * 检查加入下一个元素是否会超出目标宽度高度
		 * @param	plusWidth
		 * @return
		 */
		override protected function gotoNewLine(plusHeight:Number):Boolean
		{
			return _curContentHeight + plusHeight >= _tlHeight;
		}
		
	}

}