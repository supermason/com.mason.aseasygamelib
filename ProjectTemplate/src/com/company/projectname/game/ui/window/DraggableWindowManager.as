package com.company.projectname.game.ui.window
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 11:07:21 AM
	 * description 可拖拽窗体管理器基类 
	 **/
	public class DraggableWindowManager extends GameWindowManager
	{
		public function DraggableWindowManager(winClz:Class)
		{
			super(winClz);
			
			_tweenOnResize = true;
		}
	}
}