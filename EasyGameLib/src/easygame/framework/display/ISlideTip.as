package easygame.framework.display
{
	import flash.display.BitmapData;
	
	 /**
	 * ...
	 * @author Mason
	 */
	public interface ISlideTip extends IPopUp
	{
		/**
		 * 设置滑屏提示信息
		 * @param	msg
		 * @param	image
		 */
		function setMessage(msg:String, image:BitmapData = null):void;
		
		/**
		 * 设置背景图片 
		 * @param value
		 * 
		 */		
		function set bgImage(value:BitmapData):void;
		
		/**
		 * 设置提示文字的颜色 
		 * @param value
		 * 
		 */		
		function set txtColor(value:uint):void;
	}

}