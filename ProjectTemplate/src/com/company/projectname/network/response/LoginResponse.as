package com.company.projectname.network.response
{
	import com.company.projectname.MainGameBuilder;
	import easygame.framework.util.ExternalUtil;
	import com.company.projectname.network.DataParser;
	import com.company.projectname.network.command.LOG_IN;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Nov 15, 2013 11:04:42 AM
	 * description: 登录相关操作的服务器响应处理类
	 **/
	public class LoginResponse extends ResponseBase
	{
		/**
		 * 用于在第一次登录后初始化游戏界面
		 */
		public var loginCallBack:Function;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function LoginResponse()
		{
			super();
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		override protected function createHandler():void
		{
			super.createHandler();
			
			_funDic[LOG_IN.LOG_IN] = login;
			_funDic[LOG_IN.GET_RANDOM_NAME] = getRandomName;
			_funDic[LOG_IN.CREATE_TEAM] = createTeam;
			_funDic[LOG_IN.CHOOSE_CLUB] = choseClub;
			_funDic[LOG_IN.RECONNECT] = reconnect;
			_funDic[LOG_IN.SAVE_CLIENT_SCREEN_INFO] = saveClientInfo;
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 处理服务器对登录请求的响应 
		 * @param o
		 * 
		 */		
		private function login(o:Object):void
		{
			if (loginCallBack != null)
				loginCallBack(getOprData(o));
			
			if (getOprState(o) == 0)
			{
				
			}
			else
			{
				if (_flag == DataParser.SERVER_IS_FULL)
					ResponseManager.disconnectFromServer();
				
				popMsg(getErrMsg("login", _flag), function():void{
					ExternalUtil.F5();
				});
			}
		}
		
		/**
		 * 获取随机球队名称 
		 * @param o
		 * 
		 */		
		private function getRandomName(o:Object):void
		{
			if (getOprState(o) == 0)
			{
			}
			else
			{
				
			}
		}
		
		/**
		 * 创建球队成功 
		 * @param o
		 * 
		 */		
		private function createTeam(o:Object):void
		{
			if (getOprState(o) == 0)
			{
			}
			else
			{
			}
		}
		
		/**
		 * 处理服务器对选择球队请求的响应 
		 * @param o
		 * 
		 */		
		private function choseClub(o:Object):void
		{
			if (getOprState(o) == 0)
			{
				MainGameBuilder.buildGame(getOprData(o));
			}
			else
			{
				if (_flag == DataParser.ACCOUNT_FORBIDDEN)
				{
					var msg:String = _lang.accountForbidden;
					if (_dParser.plusInfo != "")
					{
						msg = msg.replace("@", _dParser.plusInfo);
						_dParser.plusInfo = "";
					}
					popMsg(msg);
				}
			}
		}
		
		/**
		 * 断线重连后的结果 
		 * @param o
		 * 
		 */		
		private function reconnect(o:Object):void
		{
			if (getOprState(o) == 0)
			{
				_uiMgr.chatMgr.joinChat();
			}
			else
			{
				trace(getOprData(o));
			}
		}
		
		/**
		 * 保存客户端fp版本号+屏幕分辨率 
		 * @param o
		 * 
		 */		
		private function saveClientInfo(o:Object):void
		{
			trace(getOprState(o));
		}
	}
}