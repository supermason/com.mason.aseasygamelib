package easygame.framework.display
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 5:52:57 PM
	 * description 用于游戏定位的可视区域接口
	 **/
	public interface IViewport
	{
		/**
		 * 可视窗口的宽 
		 * @return 
		 * 
		 */		
		function get vpWidth():Number;
		/**
		 * 可视窗口的高 
		 * @return 
		 * 
		 */		
		function get vpHeight():Number;
		/**
		 * 游戏主窗体的X坐标 
		 * @return 
		 * 
		 */		
		function get gameX():Number;
		/**
		 * 游戏主窗体的Y坐标 
		 * @return 
		 * 
		 */		
		function get gameY():Number;
		
		/**
		 * 设置设定的游戏主界面宽度 
		 * @param value
		 * 
		 */		
		function set screenWidth(value:int):void;
		/**
		 * 设置设定的游戏主界面高度 
		 * @param value
		 * 
		 */		
		function set screenHeight(value:int):void;
		/**
		 * 设置舞台 
		 * @param value
		 * 
		 */		
		function set stage(value:Stage):void;
		/**
		 * 设置所有窗体的富容器
		 * @param value
		 * 
		 */		
		function set winParent(value:DisplayObjectContainer):void;
		
		
	}
}