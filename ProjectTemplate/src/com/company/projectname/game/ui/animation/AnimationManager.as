package com.company.projectname.game.ui.animation
{
	import com.company.projectname.game.ui.window.PopUpManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Mar 21, 2014 5:06:36 PM
	 * description: 	
	 **/
	public class AnimationManager extends PopUpManager
	{
		private var _animations:Dictionary;
		
		public function AnimationManager()
		{
			super();
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		override public function init(parent:DisplayObjectContainer):void
		{
			super.init(parent);
			
			createAnimations();
		}
		
		/**
		 * 播放一个动画特效 
		 * @param animationType
		 * 
		 */		
		public function play(animationType:int, data:Object=null):void
		{
			if (!_animations[animationType].playing)
			{
				_animations[animationType].play(data);
				this.addPop(_animations[animationType]);
			}
		}
		
		// private ////
		
		private function createAnimations():void
		{
			_animations = new Dictionary();
			
		}
	}
}