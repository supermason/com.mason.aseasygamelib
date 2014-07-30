package com.company.projectname.network.response
{
	import com.company.projectname.Config;
	import com.company.projectname.SystemManager;
	import easygame.framework.util.ExternalUtil;
	import com.company.projectname.game.lang.Lang;
	import com.company.projectname.network.command.LOG_IN;
	import com.company.projectname.network.socket.SocketState;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 1:47:09 PM
	 * description 服务器响应基类[静态类，提供静态方法]
	 **/
	public class ResponseManager
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		public static const PROTCOL:String = "p";
		public static const RECEIVER:String = "R";
		public static const SENDER:String = "S";
		public static const DATA:String = "D";
		
		/**
		 * 使用preloader显示游戏进度信息的处理方法
		 */
		static public var infoHandler:Function;
		
		/**
		 * 服务器是否已满的标识 
		 */		
		static public var server_is_full:Boolean;
		
		/**
		 * 是否是第一次登录游戏
		 */
		static private var isFirstConnect:Boolean = true;
		/**
		 * 根据对应的Header存储对应的response管理器
		 */
		static private var _responseDic:Dictionary;
		/**
		 * 是否正在重新连接服务器 
		 */		
//		static private var _reconnecting:Boolean;
		/**
		 * 重连服务器的次数 
		 */		
		static private var _reconnectCount:int;
		/**
		 * 两次断线的时间间隔 
		 */		
		static private var _disconnect_interval:int;
	
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		/**
		 * 将响应处理方法与对应功能ID绑定
		 */
		static public function bindingResponse():void
		{
			_responseDic = new Dictionary();
			for each (var fr:Array in ResponseConfig.FunctionType_ResponseHandler)
			{
				_responseDic[fr[0]] = new fr[1](); 
			}
		}
		/**
		 * 服务器响应玩家请求回传数据的的主入口
		 * @param retStr
		 */		
		static public function handleSocketResult(retStr:String):void
		{
			//SystemManager.Instance.sendingStateMonitor.cancel();
			
			var data:Array = retStr.split(",");
			var funcType:uint = int(data[3])/100;
			// 长度大于5，说明后续数据中还有逗号，这时需要把后面的数据全部拼接为一个整体
			if (data.length > 5)
			{
				for (var i:int = 5; i < data.length; i++)
				{
					data[4] += "," + data[i];
				}
			}
			
			if (_responseDic.hasOwnProperty(funcType))
				_responseDic[funcType].handleResponse(data[3], {
							"P": data[0], // 协议类型（0-系统|1-聊天室|2球队），默认都是0-系统
							"S": data[2], // 发送者编号
							"R": data[1], // 接受者编号
							"D": data[4] // 数据
				});
		}
		
		/**
		 * 游戏socket各种状态的处理方法
		 * @param	state
		 * @param	data
		 */
		static public function socketStateHandler(state:String, data:Object = null):void
		{
			switch (state)
			{
				case SocketState.CONNECT: // 一旦连接服务器，则去获取登陆数据
					if (isFirstConnect)
					{
						isFirstConnect = false;
						infoHandler(Lang.l.getUserInfo);
						SystemManager.Instance.nwMgr.loginReq.login(Config.PLATFORM_UID);
					}
					else
					{
//						_reconnecting = false;
						_reconnectCount = 0;
						SystemManager.Instance.nwMgr.connected();
						// 连接成功后，重新设置一下服务端的状态
						SystemManager.Instance.nwMgr.loginReq.reconnect();
					}
					break;
				case SocketState.DISCONNECT:
//					trace("断线了");
//					// 第一断线或者两次断线时间的间隔超过5秒钟，则尝试重新连接
//					if (_disconnect_interval == 0 || getTimer() - _disconnect_interval > 5000) 
//						_disconnect_interval = getTimer();
//					else // 否则怎么处理呢？
//						_reconnectCount = 5;
//					tryToReconnect();
					if (!server_is_full)
					{
						SystemManager.Instance.uiMgr.gamePopUpMgr.createGamePopUp({
							msg: Lang.l.disconnected,
							cbFun: ExternalUtil.F5
						});
					}
					break;
				case SocketState.IOERROR:
//					trace("IO错误");
					SystemManager.Instance.uiMgr.gamePopUpMgr.createGamePopUp({msg: Lang.l.ioErr});
					break;
				case SocketState.SECURITYERROR:
//					trace("SECURITY错误");
//					if (infoHandler) 
//					{
//						infoHandler(data);
//					}
//					else
//					{
//						SystemManager.Instance.uiMgr.gamePopUpMgr.createGamePopUp( {
//							msg: data
//						} );
//					}
//					tryToReconnect();
					SystemManager.Instance.uiMgr.gamePopUpMgr.createGamePopUp({msg: Lang.l.secErr});
					break;
			}
		}
		
		/**
		 * 检测到服务器已满，则自动断开连接 
		 * 
		 */		
		static public function disconnectFromServer():void
		{
			server_is_full = true;
			
			SystemManager.Instance.nwMgr.disconnectFromServer();
		}
		
		/**
		 * 获取到登录数据后，通知移除prelaoder并开始游戏
		 */
		static public function set gameOkCallBack(value:Function):void
		{
			_responseDic[LOG_IN.TYPE].loginCallBack = value;
		}
		
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                      */
		/*=======================================================================*/
		/**
		 * 断线重连的方法 ，检测到连接5次连接失败的话，弹出提示
		 * 
		 */		
		static public function tryToReconnect():void
		{
			trace("尝试次数：", _reconnectCount);
			// 5次尝试均失败的话，则弹出断线提示
			if (_reconnectCount == 5)
			{
				SystemManager.Instance.uiMgr.gamePopUpMgr.createGamePopUp( {
					msg: Lang.l.disconnected,
					cbFun: ExternalUtil.F5
				} );
			}
			else
			{
//				if (!_reconnecting) 
//				{
//					_reconnecting = true;
					SystemManager.Instance.nwMgr.reconnectToServer();
					_reconnectCount++;
//				}
			}
		}
	}
}