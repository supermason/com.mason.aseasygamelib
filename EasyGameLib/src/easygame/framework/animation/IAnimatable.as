package easygame.framework.animation
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 3:02:48 PM
	 * description 能够通过时间流逝进行动画的类对象接口
	 **/
	public interface IAnimatable
	{
		/** 
		 * Advance the time by a number of seconds. 
		 * @param time in millionseconds. 
		 * */
		function advanceTime(passedTime:Number):void;
	}
}