package com.company.projectname.network.monitor
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 1:25:17 PM
	 * description 数据发送状态监听器接口
	 **/
	public interface ISendingStateMonitor
	{
		/**
		 * 遮罩模式，该方法必须返回true
		 * @return
		 */
		function coverMode():Boolean;
		
		/**
		 * 操作时间间隔判断模式
		 * @return
		 */
		function timerMode():Boolean;
		
		/**
		 * 取消屏蔽模式
		 */
		function cancel():void;
		
		function get curMode():int;
		function set curMode(value:int):void;
		function get interval():int ;
		function set interval(value:int):void ;
	}
}