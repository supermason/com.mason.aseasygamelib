package com.company.projectname.network
{
	import com.company.projectname.network.monitor.ISendingStateMonitor;
	import com.company.projectname.network.monitor.MonitorMode;
	import com.company.projectname.network.request.AvatarRequest;
	import com.company.projectname.network.request.BottomButtonBarRequest;
	import com.company.projectname.network.request.ChatRequest;
	import com.company.projectname.network.request.LoginRequest;
	import com.company.projectname.network.request.RookieRequest;
	import com.company.projectname.network.response.ResponseManager;
	import com.company.projectname.network.socket.GameSocketManager;
	
	import flash.utils.Dictionary;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 9:09:29 AM
	 * description 游戏内网络通信管理类
	 **/
	public class NetWorkManager
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		/**通讯对象*/
		private var _gameSocketMgr:GameSocketManager;
		/**该字典保存游戏内功能请求的管理器*/
		private var _requestDic:Dictionary;
		/**CLUB_ID -- 使用该客户端的球队编号*/
		private var _clubId:int;
		/**数据发送状态处理方法主要用于防止玩家的疯狂的点击行为*/
		private var _sendingStateMoniter:ISendingStateMonitor;
		/**监视模式可以由配置文件传入，这里先写死在程序里*/
		private var _moniterMode:int;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function NetWorkManager()
		{
			_requestDic = new Dictionary();
			
			_gameSocketMgr = new GameSocketManager();
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		/**
		 * 初始化游戏socket管理器
		 * @param	ip
		 * @param	ip_point
		 */
		public function init(ip:String, ip_point:uint):void
		{
			_gameSocketMgr.init(ip, ip_point);
			
			_gameSocketMgr.processDataHandler = ResponseManager.handleSocketResult;
			_gameSocketMgr.socketStateHandler = ResponseManager.socketStateHandler;
		}
		
		/**
		 * 重新连接服务器 
		 * 
		 */		
		public function reconnectToServer():void
		{
			_gameSocketMgr.reconnectToServer();
		}
		
		/**
		 * 重新连接后，取消重连标识 (处于重连状态时无法发送任何数据)
		 * 
		 */		
		public function connected():void
		{
			_gameSocketMgr.connected();
		}
		
		/**
		 * 主动断开连接 
		 * 
		 */		
		public function disconnectFromServer():void
		{
			_gameSocketMgr.disconnectFromServer();
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 获取数据发送状态处理方法
		 * @return
		 */
		protected function get sendingStateHandler():Function
		{
			if (_sendingStateMoniter)
			{
				if (_moniterMode == MonitorMode.COVER_MODE)
					return _sendingStateMoniter.coverMode;
				else if (_moniterMode == MonitorMode.TIMER_MODE)
					return _sendingStateMoniter.timerMode;
				else
					return null;
			}
			else
			{
				return null;
			}
		}
		/**
		 * 获取使用当前客户端的球队id
		 */
		public function get clubId():int 
		{
			return _clubId;
		}
		/**
		 * 设置使用当前客户端的玩家UID
		 */
		public function set clubId(value:int):void 
		{
			_clubId = value;
		}
		/**
		 * 设置数据发送监控器
		 */
		public function set sendingStateMoniter(value:ISendingStateMonitor):void 
		{
			_sendingStateMoniter = value;
		}
		/**
		 * 获取数据传输监听模式
		 */
		public function get moniterMode():int 
		{
			return _moniterMode;
		}
		/**
		 * 设置数据传输监听模式
		 */
		public function set moniterMode(value:int):void 
		{
			_moniterMode = value;
		}
		
		/*=======================================================================*/
		/* INSTANCES OF ALL REQUEST CLASS                                        */
		/*=======================================================================*/
		/**
		 * 获取登录请求类对象 
		 * @return 
		 * 
		 */		
		public function get loginReq():LoginRequest
		{
			if  (!_requestDic[LoginRequest])
				_requestDic[LoginRequest] = new LoginRequest(_gameSocketMgr.sendString, _clubId, null);
			return _requestDic[LoginRequest];
		}
		/**
		 * 获取Avatar请求类对象 
		 * @return 
		 * 
		 */		
		public function get avatarReq():AvatarRequest
		{
			if  (!_requestDic[AvatarRequest])
				_requestDic[AvatarRequest] = new AvatarRequest(_gameSocketMgr.sendString, _clubId, sendingStateHandler);
			return _requestDic[AvatarRequest];
		}
		/**
		 * 获取聊天请求类对象 
		 * @return 
		 * 
		 */		
		public function get chatReq():ChatRequest
		{
			if  (!_requestDic[ChatRequest])
				_requestDic[ChatRequest] = new ChatRequest(_gameSocketMgr.sendString, _clubId);
			return _requestDic[ChatRequest];
		}
		/**
		 * 获取底部动能按钮请求类对象 
		 * @return 
		 * 
		 */		
		public function get bottomButtonBarReq():BottomButtonBarRequest
		{
			if  (!_requestDic[BottomButtonBarRequest])
				_requestDic[BottomButtonBarRequest] = new BottomButtonBarRequest(_gameSocketMgr.sendString, _clubId, sendingStateHandler);
			return _requestDic[BottomButtonBarRequest];
		}
		/**
		 * 获取新手请求类对象
		 * @return 
		 * 
		 */		
		public function get rookieReq():RookieRequest
		{
			if  (!_requestDic[RookieRequest])
				_requestDic[RookieRequest] = new RookieRequest(_gameSocketMgr.sendString, _clubId, sendingStateHandler);
			return _requestDic[RookieRequest];
		}
	}
}