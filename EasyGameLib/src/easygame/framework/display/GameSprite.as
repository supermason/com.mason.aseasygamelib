package easygame.framework.display
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/** 
	 * @author: mason
	 * @E-mail: jijiiscoming@hotmail.com
	 * @version 1.0.0 
	 * 创建时间：May 13, 2014 3:07:52 PM 
	 * 描述：
	 * */
	public class GameSprite extends Sprite implements IDisplay
	{
		public function GameSprite()
		{
			super();
			
			init();
		}
		
		// public ////
		
		public function reset():void
		{
		}
		
		public function destory():void
		{
		}
		
		// protected ////
		
		protected function init():void
		{
		}
		
		// getter && setter ////
		public function get displayContent():DisplayObjectContainer
		{
			return this;
		}
	}
}