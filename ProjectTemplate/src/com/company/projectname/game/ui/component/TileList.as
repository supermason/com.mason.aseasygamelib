package com.company.projectname.game.ui.component
{
	/**
	 * ...
	 * @author Mason
	 */
	public class TileList extends AlignList 
	{
		/**
		 * 垂直方向间距
		 */
		protected var _verticalGap:Number = 0;
		/**
		 * 水平方向间距
		 */
		protected var _horizentalGap:Number = 0;
		/**
		 * tileList的宽[用来判断何时换行]
		 */
		protected var _tlWidth:Number = 0;
		/**
		 * tileList的高
		 */
		protected var _tlHeight:Number = 0;
		/**
		 * 当前加入元素后的宽度
		 */
		protected var _curContentWidth:Number = 0;
		/**
		 * 下一行元素的Y坐标
		 */
		protected var _nextLineY:Number = 0;
		
		/**
		 * 元素成Tile状排列的列表
		 * @param	cacheType
		 */
		public function TileList(cacheClz:Class) 
		{
			super(cacheClz);
			
			gap = 6;
			_align = ListAlignMode.LEFT;
		}
		
		// protected ////
		override protected function adjustRender():void
		{
			// 从第二个元素开始自动布局
			if (contentList.length > 1)
			{
				if (gotoNewLine(_render.width))
				{
					// 如果是向右排序，
					if (_align == ListAlignMode.LEFT)
						_render.x = 0;
					else
						_render.x = -_render.width;
					_nextLineY = contentList[_index - 1].y + contentList[_index - 1].height + _verticalGap;
					_curContentWidth = _render.width + _horizentalGap;
				}
				else
				{
					if (_align == ListAlignMode.LEFT)
						_render.x = contentList[_index - 1].x + contentList[_index - 1].width + _horizentalGap;
					else
						_render.x = contentList[_index - 1].x - contentList[_index - 1].width - _horizentalGap;
					_curContentWidth += (_render.width + _horizentalGap);
				}
				
				_render.y = _nextLineY;
				
			}
			else
			{
				_nextLineY = 0;
				_curContentWidth = contentList[0].width + _horizentalGap;
				// 如果是向右排序，
				if (_align == ListAlignMode.RIGHT)
					_render.x = -_render.width;
			}
		}
		
		/**
		 * 检查加入下一个元素是否会超出目标宽度
		 * @param	plusWidth
		 * @return
		 */
		protected function gotoNewLine(plusWidth:Number):Boolean
		{
			return _curContentWidth + plusWidth >= _tlWidth;
		}
		
		// getter && setter 
		public function get verticalGap():Number 
		{
			return _verticalGap;
		}
		
		public function set verticalGap(value:Number):void 
		{
			_verticalGap = value;
		}
		
		public function get horizentalGap():Number 
		{
			return _horizentalGap;
		}
		
		public function set horizentalGap(value:Number):void 
		{
			_horizentalGap = value;
		}
		
		public function get tlWidth():Number 
		{
			return _tlWidth;
		}
		
		public function set tlWidth(value:Number):void 
		{
			_tlWidth = value;
		}
		
		public function get tlHeight():Number 
		{
			return _tlHeight;
		}
		
		public function set tlHeight(value:Number):void 
		{
			_tlHeight = value;
		}
		
	}

}