package easygame.framework.display
{
	import flash.display.DisplayObjectContainer;

	/** 
	 * @author: mason
	 * @E-mail: jijiiscoming@hotmail.com
	 * @version 1.0.0 
	 * 创建时间：May 13, 2014 5:22:30 PM 
	 * 描述：
	 * */
	public class GameDisplayObject extends DisplayObjectTemplate
	{
		protected var _sprite:GameSprite;
		
		public function GameDisplayObject()
		{
			super();
		}
		
		// public ////
		
		// getter && setter ////
		/**
		 *  
		 * @return 
		 * 
		 */		
		override public function get displayContent():DisplayObjectContainer
		{
			return _sprite;
		}
	}
}