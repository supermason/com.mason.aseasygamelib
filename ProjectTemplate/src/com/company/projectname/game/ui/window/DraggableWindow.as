package com.company.projectname.game.ui.window
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 11:06:02 AM
	 * description 支持拖拽的窗体基类
	 **/
	public class DraggableWindow extends GameWindow
	{
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 构造方法 
		 * @param clazName 窗体对应皮肤中的as连接名称
		 * @param contentData 初始化窗体所需的数据
		 */	
		public function DraggableWindow(clazName:String, contentData:Object)
		{
			super(clazName, contentData);
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		/**添加基础事件，重写该方法时，必须加入<code>super.addEvt()</code>一行，否则出错*/
		override protected function addEvt():void
		{
			addDragEvtHandler();
		}
		
		/**移除基础事件，重写该方法时，必须加入<code>super.removeEvt()</code>一行，否则出错*/
		override protected function removeEvt():void
		{
			removeDragEvtHandler();
		}
		
		/**重写显示窗体方法，提前定位窗体*/
		override protected function $show(dispatchCreatedEvt:Boolean = true):void
		{
			x = (vpw - width) * .5;
			y = (vph - height) * .5;
			
			super.$show();
		}
	}
}