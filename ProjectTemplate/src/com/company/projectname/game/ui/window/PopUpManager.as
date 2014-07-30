package com.company.projectname.game.ui.window
{
	import easygame.framework.display.IPopUp;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 10:44:29 AM
	 * description 
	 **/
	public class PopUpManager extends WinCoverManager
	{
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function PopUpManager()
		{
			super();
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 初始化
		 * @param	parent
		 */
		public function init(parent:DisplayObjectContainer):void
		{
			_parent = parent;
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		/**
		 * 弹出一个PopUp类型的窗体 
		 * @param pop
		 * @param centered
		 * @param modal
		 * @param x
		 * @param y
		 * 
		 */		
		protected function addPop(pop:IPopUp, centered:Boolean=true, modal:Boolean=false, x:int=0, y:int=0):void
		{
			if (!pop.visible) pop.visible = true;
			if (pop.alpha != 1) pop.alpha = 1;
			$addPopUp(pop, modal);
			if (centered) {
				center(pop);
			} else {
				pop.x = x;
				pop.y = y;
			}
		}
		
		/**
		 * 将弹出的窗体置于最上层 
		 * @param pop
		 * 
		 */		
		protected function bringToFront(pop:IPopUp):void
		{
			_parent.setChildIndex(DisplayObject(pop), _parent.numChildren - 1);
		}
		
		/**
		 * 将弹出的窗体居中 
		 * @param pop
		 * 
		 */		
		protected function center(pop:IPopUp):void
		{
			pop.x = (_uiMgr.viewPort.vpWidth - pop.width) / 2;
			pop.y = (_uiMgr.viewPort.vpHeight - pop.height) / 2;
		}
		
		/**
		 * 根据给定 x和y 坐标设定弹出窗体的位置 
		 * @param pop
		 * @param nx
		 * @param ny
		 * 
		 */		
		protected function repositionPop(pop:IPopUp, nx:int, ny:int):void
		{
			pop.x = nx;
			pop.y = ny;
		}
		
		/**
		 * 移除弹出的窗体 
		 * @param pop
		 * 
		 */		
		protected function removePop(pop:IPopUp):void
		{
			super.removeCover();
			
			if (_parent.contains(DisplayObject(pop)))
				_parent.removeChild(DisplayObject(pop));
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		private function $addPopUp(pop:IPopUp, modal:Boolean):void
		{
			if (modal)
			{
				_parent.addChild(cover);
			}
			
			_parent.addChild(DisplayObject(pop));
		}
	}
}