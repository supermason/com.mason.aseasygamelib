package easygame.framework.display
{
	/** 
	 * @author moge 
	 * @E-mail: jijiiscoming@hotmail.com
	 * @version 1.0.0 
	 * 创建时间：May 12, 2014 5:02:55 PM 
	 * 描述：
	 * */
	public class NoEventSprite extends GameSprite
	{
		public function NoEventSprite()
		{
			super();
		}
		
		override protected function init():void
		{
			blockEvt();
		}
		
		/**
		 * 屏蔽鼠标事件 
		 * 
		 */		
		protected function blockEvt():void
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		
	}
}