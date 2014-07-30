package com.company.projectname.network.socket
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 9:52:20 AM
	 * description 游戏socket对象管理器
	 **/
	public class GameSocketManager
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _socket:GameSocket;
		private var _host:String;
		private var _port:uint;
		private var _processDataHandler:Function;
		private var _socketStateHandler:Function;
		private var _reconnecting:Boolean;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function GameSocketManager()
		{
		}
		
		/*=======================================================================*/
		/* PUBLICS                                                               */
		/*=======================================================================*/
		/**
		 * 初始化游戏socket对象，并添加事件监听 
		 * @param host
		 * @param port
		 */		
		public function init(host:String, port:uint):void
		{
			_host = host;
			_port = port;
			_socket = new GameSocket(_host, _port);
			_socket.addEventListener(GameSocketEvent.RECEIVE_DATA, receiveDataHandler);
			_socket.reconnect();
		}
		
		/**
		 * 发送数据 
		 * @param data
		 */		
		public function sendString(data:String):void
		{
			if (_reconnecting) return;
			
			_socket.buff2Send.clear();
			_socket.buff2Send.writeUTFBytes(data);
			_socket.buff2Send.compress();
			_socket.writeInt(_socket.buff2Send.length);
			_socket.writeBytes(_socket.buff2Send);
			_socket.flush();
		}
		
		/**
		 * 断线后重新连接服务器 
		 * 
		 */		
		public function reconnectToServer():void
		{
//			if (_reconnecting) return;
//			
			_reconnecting = true;
//			_socket.removeEventListener(GameSocketEvent.RECEIVE_DATA, receiveDataHandler);
//			_socket.dispose();
//			_socket = null;
//			
//			_socket = new GameSocket(_host, _port);
//			_socket.addEventListener(GameSocketEvent.RECEIVE_DATA, receiveDataHandler);
//			_socket.socketStateHandler = _socketStateHandler;
			_socket.reconnect();
		}
		
		/**
		 * 连接后，取消重连标识 
		 * 
		 */		
		public function connected():void
		{
			_reconnecting = false;
		}
		
		/**
		 * 主动断开连接 
		 * 
		 */		
		public function disconnectFromServer():void
		{
//			_socket.dispose();
//			_socket.close();
		}		
		
		/*=======================================================================*/
		/* EVENT HANDLER                                                         */
		/*=======================================================================*/
		protected function receiveDataHandler(event:GameSocketEvent):void
		{
			_processDataHandler(event.data);
		}

		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 设置数据接受处理方法 
		 * @param value
		 * 
		 */		
		public function set processDataHandler(value:Function):void
		{
			_processDataHandler = value;
		}
		
		/**
		 * 设置socket状态处理方法（连接、断开、IO错误等）
		 * @param value
		 */		
		public function set socketStateHandler(value:Function):void
		{
			_socketStateHandler = value;
			_socket.socketStateHandler = value;
		}
	}
}