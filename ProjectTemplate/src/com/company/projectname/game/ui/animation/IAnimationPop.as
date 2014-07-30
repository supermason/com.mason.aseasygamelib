package com.company.projectname.game.ui.animation
{
	import easygame.framework.display.IPopUp;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Mar 21, 2014 6:23:58 PM
	 * description: 	
	 **/
	public interface IAnimationPop extends IPopUp
	{
		function play(data:Object=null):void;
			
		function set endCallBack(value:Function):void;
		
		function get playing():Boolean;
	}
}