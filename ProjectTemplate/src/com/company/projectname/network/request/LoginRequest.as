package com.company.projectname.network.request
{
	import com.company.projectname.Config;
	import com.company.projectname.SystemManager;
	import com.company.projectname.network.NetWrokConstants;
	import com.company.projectname.network.command.LOG_IN;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Nov 15, 2013 10:21:38 AM
	 * description: 登录请求类
	 **/
	public class LoginRequest extends RequestBase
	{
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 构造方法 
		 * @param sendFun
		 * @param clubId
		 * @param sendingStateHandler
		 * 
		 */		
		public function LoginRequest(sendFun:Function, clubId:int, sendingStateHandler:Function=null)
		{
			super(sendFun, clubId, sendingStateHandler);
			
			formatProtcolHeader(NetWrokConstants.SYSTEM, NetWrokConstants.SYSTEM);
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		/**
		 * 登录游戏 
		 * @param uid -- 加密的角色编号
		 * 
		 */				
		public function login(uid:String):void
		{
			send(LOG_IN.LOG_IN, uid);
		}
		
		/**
		 * 选择球队 
		 * @param clubId -- 选择的球队编号
		 * 
		 */		
		public function choseClub(clubId:int):void
		{
			// 保存全局球队编号数据，这里不用在后台回传时赋值，因为如果后台不接受该编号，不会让玩家进入游戏
			SystemManager.Instance.nwMgr.clubId = clubId;
			SystemManager.Instance.userMgr.clubId = clubId;
			// 这个方法需要重写一下_protcolHeader
			this.clubId = clubId;
			formatProtcolHeader(NetWrokConstants.SYSTEM, NetWrokConstants.SYSTEM);
			
			send(LOG_IN.CHOOSE_CLUB/*, Config.PLATFORM_UID*/);
		}
		
		/**
		 * 获取随机球队名称
		 * 
		 */		
		public function getRandomName():void
		{
			send(LOG_IN.GET_RANDOM_NAME);
		}
		
		/**
		 * 创建球队
		 * @param clubName
		 * 
		 */		
		public function createTeam(clubName:String, userTyp:int=0):void
		{
			send(LOG_IN.CREATE_TEAM, "'" + clubName + "'", userTyp);
		}
				
		
		/**
		 * 断线后的重连 
		 * 
		 */		
		public function reconnect():void
		{
			send(LOG_IN.RECONNECT, Config.PLATFORM_UID);
		}
		
		/**
		 * 需要更新资源的时候调用该方法 
		 * 
		 */		
		public function getClubData():void
		{
			send(LOG_IN.CHOOSE_CLUB);
		}
		
		/**
		 * 保存玩家fp版本号+屏幕分辨率 
		 * 
		 */		
		public function saveClientScreenInfo():void
		{
			send(LOG_IN.SAVE_CLIENT_SCREEN_INFO, "'" + Config.clientInfo + "'");
		}
	}
}