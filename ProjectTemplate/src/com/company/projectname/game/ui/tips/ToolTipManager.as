package com.company.projectname.game.ui.tips
{
	import com.company.projectname.game.ui.window.PopUpManager;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 1:32:12 PM
	 * description tooltip管理器
	 **/
	public class ToolTipManager extends PopUpManager
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _toolTip:ToolTip;
		private var _ttForComparison:ToolTip;
		private var _compare:Boolean;
		private var _left:Boolean;
		private var _shown:Boolean;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function ToolTipManager()
		{
			super();
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 初始化 
		 * @param parent
		 * 
		 */		
		override public function init(parent:DisplayObjectContainer):void
		{
			if (!_toolTip && !_ttForComparison) 
			{
				super.init(parent);
				_toolTip = new ToolTip();
				_ttForComparison = new ToolTip();
			}
		}
		
		/**
		 * 为tooltip赋值，支持装备等类型的对比模式 
		 * @param image
		 * @param tip
		 * @param mouseX
		 * @param mouseY
		 * @param stars
		 * @param isDisplay
		 * @param showTipImg
		 * @param compareImg
		 * @param compareTip
		 * @param compareStars
		 * 
		 */		
		public function setTip(image:BitmapData, 
							   tip:Array,
							   mouseX:int,
							   mouseY:int,
							   vars:Object=null,
							   stars:*=null,
							   isDisplay:Boolean=false,
							   showTipImg:Boolean=false,
							   compareImg:String=null,
							   compareTip:Array=null,
							   compareStars:*=null):void
		{
			_shown = true;
			_toolTip.setTips(image, tip, vars, stars, showTipImg);
			_compare = compareTip != null;
			if (_compare) _ttForComparison.setTips(compareImg, compareTip, vars, compareStars, true);
			addPop(_toolTip, false);
			if (_compare) addPop(_ttForComparison, false);
			updateToolTipPos(mouseX, mouseY, isDisplay);
			
		}
		
		/**
		 * 为tooltip重新定位 
		 * @param nX
		 * @param nY
		 * 
		 */		
		public function reposition(nX:int, nY:int):void
		{
			if (_shown) 
			{
				updateToolTipPos(nX, nY);
			}
		}
		
		/**
		 * 移除tooltip时清理资源 
		 * 
		 */		
		public function clear():void
		{
			if (_shown) 
			{
				_toolTip.reset();
				removePop(_toolTip);
				if (_compare) 
				{
					_ttForComparison.reset();
					removePop(_ttForComparison);
					_compare = false;
				}
				_shown = false;
			}
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 计算tooltip及对比tooltip的位置 
		 * @param mx
		 * @param my
		 * @param isDisplay
		 * 
		 */		
		private function updateToolTipPos(mx:int, my:int, isDisplay:Boolean=false):void
		{
			mx -= _uiMgr.viewPort.gameX;
			my -= _uiMgr.viewPort.gameY;
			var sw:int = _uiMgr.viewPort.vpWidth;
			var sh:int = _uiMgr.viewPort.vpHeight;
			if (mx > sw)
				mx = sw;
			if (my > sh)
				my = sh;
			var tw:int = _toolTip.width + (_compare ? _ttForComparison.width : 0);
			var th:int = _toolTip.realHeight;
			if (_compare)
				th = _ttForComparison.realHeight > th ? _ttForComparison.realHeight : th;
			_left = tw + mx > sw;
			if (_left)
				mx = mx - tw;
			if (my + th > sh)
				my = sh - th;
			
			if (isDisplay)
			{
				_toolTip.x += 30;
				_toolTip.y -= 100;
			}
			if (_compare) 
			{
				if (_left)
				{
					_ttForComparison.x = _toolTip.x;
					//_toolTip.x = _ttForComparison.x + _toolTip.width * (_left ? -1 : 1) + 5;
					_toolTip.x = _ttForComparison.x + _toolTip.width + 5;
				}
				else
				{
					//_ttForComparison.x = _toolTip.x + _toolTip.width * (_left ? -1 : 1) + 5;
					_ttForComparison.x = _toolTip.x + _toolTip.width + 5;
				}
				
				_ttForComparison.y = my;
			}
			else
			{
				_toolTip.x = mx < 0 ? 0 : mx;
				_toolTip.y = my < 0 ? 0 : my;
			}
		}
	}
}