package easygame.framework.util
{
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Feb 21, 2014 10:54:38 AM
	 * description: 	
	 **/
	public class DateTool
	{
		/**
		 * 用当前时间计算N豪秒后的时间 
		 * @param elapsedMillSec
		 * @return 
		 * 
		 */		
		public static function getFutrueByMillSec(elapsedMillSec:int):Date
		{
			var nextMillSec:Number = new Date().getTime() + elapsedMillSec;

			return new Date(nextMillSec);
		}
	}
}