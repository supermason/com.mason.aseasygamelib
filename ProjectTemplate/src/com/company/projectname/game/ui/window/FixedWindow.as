package com.company.projectname.game.ui.window
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 11:05:27 AM
	 * description 位置固定的窗体基类
	 **/
	public class FixedWindow extends GameWindow
	{
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/	
		/**
		 * 构造方法 
		 * @param clazName 窗体对应皮肤中的as连接名称
		 * @param contentData 初始化窗体所需的数据
		 */	
		public function FixedWindow(clazName:String, contentData:Object)
		{
			super(clazName, contentData);
		}
	}
}