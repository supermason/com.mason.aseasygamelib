package easygame.framework.loader
{
	/** 
	 * @author: mason
	 * @E-mail: jijiiscoming@hotmail.com
	 * @version 1.0.0 
	 * 创建时间：May 13, 2014 2:02:33 PM 
	 * 描述：加载资源获取器接口
	 * */
	
	public interface ILoadContent
	{
		/**加载的资源类型（IMG 或者 SWF）*/
		function get resType():String;
		/**
		 * @private
		 */
		function set resType(value:String):void;
		
		/**加载的资源地址*/
		function get assetsURL():String;
		/**
		 * @private
		 */
		function set assetsURL(value:String):void;
		
		/**资源加载完成时的处理方法*/
		function get completeHandler():Function;
		/**
		 * @private
		 */
		function set completeHandler(value:Function):void;
		
		/**加载进行中的提示信息*/
		function get loadingInfo():String;
		/**
		 * @private
		 */
		function set loadingInfo(value:String):void;
	}
}