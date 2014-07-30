package com.company.projectname.game.ui.rookie
{
	import com.company.projectname.SystemManager;
	import com.company.projectname.game.ui.window.WinCoverManager;
	
	import flash.display.MovieClip;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Mar 21, 2014 11:13:31 AM
	 * description: 	
	 **/
	public class RookieManager extends WinCoverManager
	{
		private var _rookieArrow:MovieClip;
//		private var _selectionFrame:MovieClip;
		private var _direction:int;
		private var _rookieRotation:Array = [0, 180, 90, -90];
		private var _xOffSet:Array = [0, 0, 36, -36];
		private var _yOffSet:Array = [-49, 49, 0, 0];
		
		// 备份用
		private var _fullScreenArrX:int;
		private var _fullScreenArrY:int;
		private var _fullScreenRect:Array;
		
		public function RookieManager() 
		{
			super();
			
			_coverAlpha = .05;
			
			createArrow();
		}
		
		// public ////
		/**
		 * 0-向下|1-向上|2-向左|3-向右
		 * @param	parent
		 * @param	x
		 * @param	y
		 * @param	direction 0-向下|1-向上|2-向左|3-向右
		 * @param	rect
		 * @param 	needCover
		 * @param	offSetPos
		 */
		public function showRookie(parent:*, arrX:int, arrY:int, direction:int, rect:Array, needCover:Boolean=true, offSetPos:Array=null):void
		{
			_active = true;
			
			_fullScreenArrX = arrX;
			_fullScreenArrY = arrY;
			_fullScreenRect = rect;
			
			_direction = direction;
			_rookieArrow.rotation = _rookieRotation[_direction];
			_rookieArrow.x = arrX + _xOffSet[_direction];
			_rookieArrow.y = arrY + _yOffSet[_direction];
			
			if (needCover)
			{
				// 绘制镂空
				drawCover(rect);
			}
			
			parent.addChild(_rookieArrow);
			_rookieArrow.play();
		}
		
		/**
		 * 屏蔽鼠标事件 
		 * 
		 */		
		public function shieldMouseEvt():void
		{
			removeRookie();
			coverAll();
		}
		
		/**
		 * 全屏遮罩 
		 * 
		 */		
		public function coverAll():void
		{
			_active = true;
			setCover();
			_parent.addChild(_cover);
		}
		
		public function removeRookie():void
		{
			if (_active)
			{
				_active = false;
				
				doRemove();
			}
		}
		
		// protected ////
		override protected function removeCover():void
		{
//			if (_parent.contains(_selectionFrame))
//				_parent.removeChild(_selectionFrame);
			
			super.removeCover();
		}
		
		// private ////
		private function createArrow():void 
		{
			_parent = SystemManager.Instance.uiMgr.POPUP_PARENT;
			
			_rookieArrow = new (SystemManager.Instance.resCacheMgr.getResourceFromMV("com.xuyou.ogzq2.game.ui.rookie.RookieArrowSkin"))();
			_rookieArrow.mouseChildren = false;
			_rookieArrow.mouseEnabled = false;
			
//			_selectionFrame = new (SystemManager.Instance.resCacheMgr.getResourceFromMV("com.xuyou.ogzq2.game.ui.rookie.RookieSelectionFrame"))();
//			_selectionFrame.mouseChildren = false;
//			_selectionFrame.mouseEnabled = false;
			
			doRemove();
		}
		
		private function drawCover(rect:Array):void
		{
//			_selectionFrame.x = rect[0] - 8;
//			_selectionFrame.y = rect[1] - 7;
//			_selectionFrame.width = rect[2] + 16;
//			_selectionFrame.height = rect[3] + 14;
			
			setCover(false);
			_cover.drawRect(rect[0]/*-_parent.x*/, rect[1]/*-_parent.y*/, rect[2], rect[3], 0x00ff00, 1);
			
			_parent.addChild(_cover);
//			_parent.addChild(_selectionFrame);
		}
		
		/**
		 * 内部调用清除指引 
		 * 
		 */		
		private function doRemove():void
		{
			_fullScreenArrX = 0;
			_fullScreenArrY = 0;
			if (_fullScreenRect) _fullScreenRect.length = 0;
			
			_direction = 0;
			_rookieArrow.gotoAndStop(1);
			if (_rookieArrow.rotation != 0) 
				_rookieArrow.rotation = 0;
			if (_rookieArrow.parent)
				_rookieArrow.parent.removeChild(_rookieArrow);
			
			removeCover();
		}
		
		// getter && setter ////
		public function get rookieWidth():int
		{
			return (_direction == 0 || _direction == 180) ? 39 : 80;
		}
		
		public function get rookieHeight():int
		{
			return (_direction == 0 || _direction == 180) ? 80 : 39;
		}
	}
}