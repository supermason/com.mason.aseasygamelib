package com.company.projectname.game.ui.window
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 11:07:50 AM
	 * description 不可拖拽窗体管理器基类
	 **/
	public class FixedWindowManager extends GameWindowManager
	{
		/**
		 *  
		 * @param winClz 要创建的窗体类
		 * 
		 */		
		public function FixedWindowManager(winClz:Class)
		{
			super(winClz);
		}
	}
}