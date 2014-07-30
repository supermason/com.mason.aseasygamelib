package com.company.projectname.network.request
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 1:36:57 PM
	 * description 用户请求对象基类
	 **/
	public class RequestBase
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _send:Function = null;
		/**
		 * 协议头 
		 */		
		private var _protcolHeader:String = "";
		/**
		 * 登录玩家的球队编号
		 */
		private var _clubId:int = 0;
		/**
		 * 数据传输状态处理方法
		 * 用于屏蔽玩家的疯狂点击
		 */
		private var _sendingStateHandler:Function = null;
		/**
		 * 是否在一次请求时进行遮罩屏蔽，通常情况下都需要 
		 * 
		 * <p><code>send</code>方法调用后自动将_needShield设置为true
		 */		
		protected var _needShield:Boolean = true;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function RequestBase(sendFun:Function, clubId:int, sendingStateHandler:Function=null)
		{
			_send = sendFun;
			_clubId = clubId;
			_sendingStateHandler = sendingStateHandler;
		}		
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		/**
		 * 格式化协议头 
		 * @param category 协议类型（0-系统|1-聊天室|2球队），默认都是0-系统
		 * @param receiverId 接受者编号与category对应，默认都是0-系统
		 * 
		 */		
		protected function formatProtcolHeader(category:int=0, receiverId:int=0):void
		{
			_protcolHeader = category + "," + receiverId + "," + _clubId + ",";
		}
		
		/**
		 * 发送请求(一次请求发出后，自动开启请求屏蔽设置)
		 * @param funcId: 功能id
		 * @param args
		 * 
		 */		
		protected function send(funcId:int, ...args):void
		{
			if (_needShield)
			{
				if (_sendingStateHandler == null || _sendingStateHandler.call())
					_send(_protcolHeader + funcId + "," + args.join(","));
			}
			else
			{
				_send(_protcolHeader + funcId + "," + args.join(","));
			}
			
			_needShield = true;
		}

		/**
		 * 登录玩家的球队编号
		 */
		public function get clubId():int
		{
			return _clubId;
		}

		/**
		 * @private
		 */
		public function set clubId(value:int):void
		{
			_clubId = value;
		}

	}
}