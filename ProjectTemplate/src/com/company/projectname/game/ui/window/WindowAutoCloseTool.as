package com.company.projectname.game.ui.window
{
	import com.company.projectname.SystemManager;
	import com.company.projectname.game.ui.window.DraggableWindowManager;
	import com.company.projectname.game.ui.window.FixedWindowManager;
	
	import flash.utils.Dictionary;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 5:41:44 PM
	 * description 窗体连动关闭工具
	 **/
	public class WindowAutoCloseTool
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _winMgrDic:Dictionary;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function WindowAutoCloseTool(mgrPool:Dictionary)
		{
			_winMgrDic = mgrPool;
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 关闭其他窗体
		 * @param	excluedWin1 ：无需关闭窗体类1对象名
		 * @param	excluedWin2 ：无需关闭窗体类2对象名
		 */
		public function closeOtherWindow(excluedWin1:Class, excluedWin2:Class=null):void
		{
			for (var wcf:* in _winMgrDic)
			{
				if (_winMgrDic[wcf] is DraggableWindowManager || _winMgrDic[wcf] is FixedWindowManager)
				{
					if (excluedWin2)
					{
						if (wcf != excluedWin1 && wcf != excluedWin2)
						{
							if (_winMgrDic[wcf].active)
								_winMgrDic[wcf].close();
						}
					}
					else
					{
						if (wcf != excluedWin1)
						{
							if (_winMgrDic[wcf].active)
								_winMgrDic[wcf].close();
						}
					}
				}
			}
			
			SystemManager.Instance.uiMgr.gamePopUpMgr.removeGamePopUp();
		}
	}
}