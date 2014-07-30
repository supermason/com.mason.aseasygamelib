package easygame.framework.util
{
	import flash.external.ExternalInterface;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 3:26:08 PM
	 * description JS 交互工具类
	 **/
	public class ExternalUtil
	{
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 刷新网页
		 */
		public static function F5():void
		{
			ExternalInterface.call("location.reload");
		}
	}
}