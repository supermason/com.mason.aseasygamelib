package  easygame.framework.cache
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 2:01:54 PM
	 * description 所有可以缓存对象的抽象接口
	 **/
	public interface ICachable
	{
		/**
		 * 显示对象重置 
		 */	
		function reset():void;
		
		/**
		 * 销毁对象 
		 * 
		 */		
		function destory():void;
	}
}