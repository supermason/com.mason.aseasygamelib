package easygame.framework.display
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 10:51:59 AM
	 * description 弹出显示对象类型接口
	 **/
	public interface IPopUp extends IDisplay
	{
		/**
		 * 是否已经弹出 
		 * @return 
		 * 
		 */		
		function get isPopped():Boolean;
	}
}