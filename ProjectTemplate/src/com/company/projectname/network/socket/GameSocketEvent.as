package com.company.projectname.network.socket
{
	import flash.events.Event;
	
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 9:13:15 AM
	 * description 游戏Socket事件类
	 **/
	public class GameSocketEvent extends Event
	{
		/**
		 * 接收到数据事件
		 */
		static public const RECEIVE_DATA:String = "receive_data";
		
		private var _data:*;
		
		public function GameSocketEvent(type:String, data:* = null)
		{
			super(type);
			
			_data = data;
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 获取本次事件的数据对象 
		 * @return 
		 */		
		public function get data():*
		{
			return _data;
		}
	}
}