package com.company.projectname.game.ui.window
{
	import com.company.projectname.Config;
	import com.company.projectname.PlatformInfo;
	import com.company.projectname.SystemManager;
	import com.company.projectname.game.lang.Lang;
	import com.company.projectname.game.tool.UITool;
	import com.company.projectname.game.vo.UserManager;
	import com.company.projectname.network.DataParser;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Jun 12, 2014 1:23:33 PM
	 * description: 	
	 **/
	public class GameWindow extends SkinnableWindow
	{
		/**游戏缓存的玩家数据，用来在子窗体中刷新界面时获取数据用*/
		protected var _userMgr:UserManager;
		/**数据结构解析工具类*/
		protected var _dataParser:DataParser;
		/**语言包*/
		protected var _lang:XML;
		/**平台信息*/
		protected var _platformInfo:PlatformInfo;
		
		public function GameWindow(clazName:String, contentData:Object)
		{
			_userMgr = SystemManager.Instance.userMgr;
			_dataParser = SystemManager.Instance.dataParser;
			_lang = Lang.l;
			_platformInfo = SystemManager.Instance.platformInfo;
			
			if (_lang) _loadingInfo = _lang.loadRes; 
			
			super(clazName, contentData);
		}
		
		// protected ////
		
		override protected function initSkin():void
		{
			UITool.setAllTxtInDisObjCon(_skin);
			
			super.initSkin();
		}
		
		/**
		 * 
		 * @param txt
		 * 
		 */		
		protected static function setTxtFormat(txt:String):String
		{
			return UITool.setYaHeiTxt(txt);
		}
		
		// getter && setter ////
		public function get defaultGameWidth():int
		{
			return Config.MAX_GAME_WIDTH;
		}
		
		public function get defaultGameHeight():int
		{
			return Config.MAX_GAME_HEIGHT;
		}
	}
}