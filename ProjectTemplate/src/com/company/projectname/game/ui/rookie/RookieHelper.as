package com.company.projectname.game.ui.rookie
{
	import com.company.projectname.SystemManager;
	import easygame.framework.timer.TimerManager;
	import com.company.projectname.game.ui.UIManager;
	import com.company.projectname.network.DataParser;
	import com.company.projectname.network.NetWorkManager;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Mar 25, 2014 10:22:19 AM
	 * description: 正常流程的新手指引
	 **/
	public class RookieHelper
	{
		private static var _uiMgr:UIManager;
		private static var _dataParser:DataParser;
		private static var _nwMgr:NetWorkManager;
		private static var _timerMgr:TimerManager;
		
		public static function init():void
		{
			_uiMgr = SystemManager.Instance.uiMgr;
			_dataParser = SystemManager.Instance.dataParser;
			_nwMgr = SystemManager.Instance.nwMgr;
			_timerMgr = SystemManager.Instance.timerMgr;
		}
		
		//=========================================================================================================//
		// pubilc
		//=========================================================================================================//
		
		/**
		 * 指引新手期下一步 
		 * @param s
		 * 
		 */			
		public static function moveToNextStep(s:String):void
		{
			var rookieData:Array =_dataParser.parseData(s, 99);
			rookieData[0] = _dataParser.parseData(rookieData[0], 1);
			SystemManager.Instance.userMgr.user.rookieStep = int(rookieData[0][0]);
			
			switch (int(rookieData[0][0]))
			{
				default:
					break;
			}
		}
		
		/**
		 * 更新新手数据 
		 * @param mainStep
		 * @param subStep
		 * 
		 */		
		public static function updateRookoieData(mainStep:int, subStep:int):void
		{
			_nwMgr.rookieReq.updateRookieData(mainStep, subStep);
		}
		
		/**
		 * 保存新手期玩家交互信息 
		 * @param mainStep
		 * @param subStep
		 * 
		 */		
		public static function saveRookieInteraction(mainStep:int, subStep:int=1):void
		{
			_nwMgr.rookieReq.saveRookieInteraction(mainStep, subStep);
		}
		
		private static var _mainUIShown:Boolean;
		
		/**
		 * 新手第一部分引导结束，显示主界面 
		 * 
		 */		
		public static function showMainUI():void
		{
			if (!_mainUIShown)
			{
				_mainUIShown = true;
				
//				_uiMgr.fastAccessMgr.showWindow();
//				_uiMgr.chatMgr.showWindow();
//				_uiMgr.bottBtnBarMgr.showWindow();
//				_uiMgr.activityButtonBarMgr.showWindow();
//				_uiMgr.rightBtnBarMgr.showWindow();
//				_uiMgr.sceneMgr.showSceneButtons();
			}
		}
		
		//=========================================================================================================//
		// private
		//=========================================================================================================//
	}
}