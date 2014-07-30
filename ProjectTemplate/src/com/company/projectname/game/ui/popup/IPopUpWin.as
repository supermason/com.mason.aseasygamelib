package com.company.projectname.game.ui.popup
{
	import easygame.framework.display.IPopUp;
	
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 1:47:59 PM
	 * description 弹出提示窗体类型接口
	 **/
	public interface IPopUpWin extends IPopUp
	{
		/**
		 * 初始化弹出窗体所需事件 
		 * 
		 */		
		function initEvt():void;
		/**
		 * 设置弹出窗体需要的数据 
		 * @param popData
		 * 
		 */		
		function set popInfo(popData:Object):void;
		/**
		 * 更新打开对话框中的数据 
		 * @param data
		 * 
		 */		
		function updatePopData(data:Object):void;
		/**
		 * 弹出窗体关闭时，清理资源 
		 * 
		 */		
		function dispose():void;
		/**
		 * 弹出窗体关闭时需要调用的方法 
		 * @param value
		 * 
		 */		
		function setCloseHandler(value:Function):void;
		/**
		 * 超链接点击事件的处理方法
		 * @param value
		 * 
		 */		
		function setTextLinkClickHandler(value:Function):void;
	}
}