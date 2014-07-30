package com.company.projectname.game.ui.window
{
	import com.company.projectname.PlatformInfo;
	import com.company.projectname.SystemManager;
	import com.company.projectname.game.ui.UIManager;
	import com.company.projectname.game.vo.UserManager;
	import com.company.projectname.network.DataParser;
	import com.company.projectname.network.NetWorkManager;
	
	import flash.display.DisplayObjectContainer;
	
	import easygame.framework.timer.TimerManager;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 6:12:45 PM
	 * description 所有窗体管理器的基类，提供一些管理器的访问
	 **/
	public class WinManagerBase 
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		protected var _uiMgr:UIManager;
		protected var _winAutoCloseTool:WindowAutoCloseTool;
		protected var _nwMgr:NetWorkManager;
		protected var _userMgr:UserManager;
		protected var _dataParser:DataParser;
		protected var _timerMgr:TimerManager;
		protected var _platformInfo:PlatformInfo;
		/**
		 * 窗体的父容器 
		 */		
		protected var _parent:DisplayObjectContainer;
		
		protected var _active:Boolean;
		
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function WinManagerBase() 
		{
			with (SystemManager.Instance)
			{
				_uiMgr = uiMgr;
				_winAutoCloseTool = winAutoCloseTool;
				_nwMgr = nwMgr;
				_userMgr = userMgr;
				_dataParser = dataParser;
				_timerMgr = timerMgr;
				_platformInfo = platformInfo;
			}
		}
	}
}