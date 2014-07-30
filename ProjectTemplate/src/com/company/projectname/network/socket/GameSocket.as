package com.company.projectname.network.socket
{
	import com.company.projectname.Config;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
//	import flash.utils.Endian;
	
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 9:19:56 AM
	 * description 
	 **/
	public class GameSocket extends Socket
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _host:String;
		private var _port:int;
		
		private var _buff2Send:ByteArray;
		private var _isReading:Boolean;
		private var _dataLen:int;
		private var _buff:ByteArray;
		private var _socketStateHandler:Function;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function GameSocket(host:String=null, port:int=0)
		{
			_host = host;
			_port = port;
			_isReading = false;
			_dataLen = 0;
			_buff = new ByteArray();
			_buff2Send = new ByteArray();
			//this.endian = flash.utils.Endian.LITTLE_ENDIAN;
			
			super(_host, _port);
			
			initEvt();
		}
		
		private function initEvt():void
		{
			this.addEventListener(Event.CONNECT , connectHandler);
			this.addEventListener(Event.CLOSE , closeHandler);
			this.addEventListener(ProgressEvent.SOCKET_DATA , receiveDataHandler);
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR , securityHandler);
			this.addEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler);
		}
		
		/*=======================================================================*/
		/* PUBLICS                                                               */
		/*=======================================================================*/
		/**
		 * 发送数据 
		 */		
		public function sendBuff():void
		{
			this.writeBytes(this._buff2Send);
			this.flush();
			this._buff2Send.clear();
		}
		
		/**
		 * 重新连接服务器 
		 */		
		public function reconnect():void
		{
			//flash.system.Security.allowDomain("*");
			//flash.system.Security.loadPolicyFile("xmlsocket://172.16.0.14:843");
			this.connect(_host, _port);
		}
		
		/**
		 * 释放资源 
		 * 
		 */		
		public function dispose():void
		{
			this.removeEventListener(Event.CONNECT , connectHandler);
			this.removeEventListener(Event.CLOSE , closeHandler);
			this.removeEventListener(ProgressEvent.SOCKET_DATA , receiveDataHandler);
			this.removeEventListener(SecurityErrorEvent.SECURITY_ERROR , securityHandler);
			this.removeEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler);
		}
		
		/*=======================================================================*/
		/* EVENT HANDLER                                                         */
		/*=======================================================================*/
		protected function connectHandler(event:Event):void
		{
			if (Config.isDebug)
				trace(_host + ":" + _port + "连接成功");	
			_buff2Send.clear();
			_socketStateHandler(SocketState.CONNECT);
		}
		
		protected function closeHandler(event:Event):void
		{
			if (Config.isDebug)
				trace(_host + ":" + _port + "连接断开");
			_buff2Send.clear();
			_socketStateHandler(SocketState.DISCONNECT);
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
//			trace(event.text);
			_buff2Send.clear();
			_socketStateHandler(SocketState.IOERROR, event.text);
		}
		
		protected function securityHandler(event:SecurityErrorEvent):void
		{
//			trace(event.text);
			_buff2Send.clear();
			_socketStateHandler(SocketState.SECURITYERROR, event.type + ">>>" + event.text);
		}
		
		protected function receiveDataHandler(event:Event):void
		{
//			trace("收到的数据："+this.bytesAvailable+"bytes");
			
			parseDataBuff();
		}
		
		/*=======================================================================*/
		/* PRIVATE                                                               */
		/*=======================================================================*/
		
		private function parseDataBuff():void
		{
			if (this.bytesAvailable <= 0)
			{
				_isReading = false;
				return;
			}
			
			// 拆包处理时，只有第一次需要读取数据包长度
			if (!_isReading)
			{
				_buff.clear();
				if (this.bytesAvailable < 4)
				{
					this._dataLen = -1;
					return;
				}
				_isReading = true;
				this._dataLen = this.readInt();
			}
			else
			{
//				trace("包头长度：" + this._dataLen);
			}
			
			if (Config.isDebug)
				trace("包头长度: ", _dataLen);
			// 解析包内容
			if (this.bytesAvailable == this._dataLen)
			{
				cpData2Buff(this._dataLen);
				this.dispatchEvent(new GameSocketEvent(GameSocketEvent.RECEIVE_DATA, getStringFromBytes(_buff)));
				_isReading = false;
			}
			else if (this.bytesAvailable < this._dataLen)
			{
//				trace("<");
			}
			else
			{
//				trace(">" + this._dataLen);
				
				var readLen:int = 0;
				
				while (true)
				{
					cpData2Buff(_dataLen);
					this.dispatchEvent(new GameSocketEvent(GameSocketEvent.RECEIVE_DATA, getStringFromBytes(_buff)));
					
					readLen += this._dataLen;
					_buff.clear();
					_buff.position = 0;
					
					if (this.bytesAvailable <= 0)
					{
						_isReading = false;
						return;
					}
					else if (this.bytesAvailable < 4)
					{
						this._dataLen = -1;
						return;
					}
					else
					{
						this._dataLen = this.readInt();
						
						if (this.bytesAvailable < this._dataLen)
						{
							return;
						}
					}
				}
			}
		}
		
		/**
		 * 将数据拷贝到缓存 
		 * @param contentLen
		 * 
		 */		
		private function cpData2Buff(contentLen:int):void
		{
			this.readBytes(_buff, _buff.position, contentLen);
//			_buff.position += contentLen;
		}
		
		/**
		 * 从字节数组中读取String数据
		 * @param bytes 不带包头的数据
		 * @return 
		 * 
		 */
		private function getStringFromBytes(bytes:ByteArray):String
		{
			bytes.uncompress();
			var s:String = bytes.readUTFBytes(bytes.bytesAvailable);
			if (Config.isDebug) trace("s=", s);
			return s;
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 设置socket状态处理方法
		 */
		public function set socketStateHandler(value:Function):void
		{
			_socketStateHandler = value;
		}

		/**
		 * 获取发送数据缓存池
		 */
		public function get buff2Send():ByteArray
		{
			return _buff2Send;
		}

	}
}