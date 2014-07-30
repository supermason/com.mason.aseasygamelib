package easygame.framework.display
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;

	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 5:38:51 PM
	 * description 可视区域获取器
	 **/
	public class ViewPort implements IViewport
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _screenWidth:int;
		private var _screenHeight:int;
		private var _stage:Stage;
		private var _winParent:DisplayObjectContainer;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
	
		public function ViewPort()
		{

		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 屏幕可视区域的宽
		 */
		public  function get vpWidth():Number
		{
			return Math.min(_screenWidth, _stage.stageWidth);
		}
		
		/**
		 * 屏幕可视区域的 高
		 */
		public  function get vpHeight():Number
		{
			return Math.min(_screenHeight, _stage.stageHeight);
		}
		
		/**
		 * 主游戏的X坐标
		 * @return
		 */
		public  function get gameX():Number
		{
			return _winParent.x;
		}
		
		/**
		 * 主游戏的Y坐标
		 * @return
		 */
		public  function get gameY():Number
		{
			return _winParent.y;
		}
		
		public  function set screenWidth(value:int):void
		{
			_screenWidth = value;
		}
			
	
		public  function set screenHeight(value:int):void
		{
			_screenHeight = value;
		}

		public  function set stage(value:Stage):void
		{
			_stage = value;	
		}
	
		public  function set winParent(value:DisplayObjectContainer):void
		{
			_winParent = value;
		}
	}
}