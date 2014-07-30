package easygame.framework.loader
{
	/** 
	 * @author: mason
	 * @E-mail: jijiiscoming@hotmail.com
	 * @version 1.0.0 
	 * 创建时间：May 13, 2014 11:18:44 AM 
	 * 描述：
	 * */
	public class LoadBehaviour
	{
		/**
		 * 显示加载信息--加载结束时默认移除加载信息 [1]
		 */		
		public static const SHOW_AND_REMOVE_ON_COMPLETE:int = 1;
		/**
		 * 不显示加载信息 [2]
		 */		
		public static const NO_LOADING_INFO:int = 2;
		/**
		 * 显示加载信息--结束时不移除加载信息[3] 
		 */		
		public static const SHOW_BUT_NOT_REMOVE_ON_COMPLETE:int = 3;
	}
}