package com.company.projectname.game.tool.platform
{
	import com.company.projectname.Config;
	import com.company.projectname.SystemManager;
	
	import flash.external.ExternalInterface;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Jun 24, 2014 9:49:18 AM
	 * description: 	
	 **/
	public class PlatfromToolBase
	{
		private var _coverShown:Boolean;
		
		public function PlatfromToolBase()
		{
		}
		
		
		/**
		 * 前往充值页面
		 * @param clubId
		 * @param uid
		 * @param clubName
		 * @param platformId
		 * @param serverId
		 * @param userType
		 * 
		 */		
		public function gotoChargePage(clubId:int, uid:String, clubName:String, platformId:int, serverId:int, userType:int):void
		{
			try
			{
				ExternalInterface.call("gotoChargePage", clubId, uid, clubName, platformId, serverId, userType);
			}
			catch (err:Error)
			{
				errInfo(err);
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////
		// 工具方法
		///////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**显示遮罩*/
		public function coverAll():void
		{
			_coverShown = true;
			
			SystemManager.Instance.uiMgr.rookieMgr.coverAll();
		}
		
		/**移除遮罩*/
		public function removeCover():void
		{
			if (_coverShown)
			{
				_coverShown = false;
				
				SystemManager.Instance.uiMgr.rookieMgr.removeRookie();
			}
		}
		
		/**
		 * 弹出提示 
		 * @param msg
		 * 
		 */		
		public function popMessage(message:String):void
		{
			SystemManager.Instance.uiMgr.gamePopUpMgr.createGamePopUp({msg: message});
		}
		
		/**
		 * 弹出可能的JS安全沙箱错误 
		 * 
		 */		
		public function errInfo(err:Error):void
		{
			if (Config.isDebug) SystemManager.Instance.uiMgr.gamePopUpMgr.createGamePopUp({msg: err.getStackTrace()});
		}
		
		/**
		 * 处理异常 
		 * @param err
		 * 
		 */		
		public function handleError(err:Error):void
		{
			removeCover();
			
			errInfo(err);
			
		}
	}
}