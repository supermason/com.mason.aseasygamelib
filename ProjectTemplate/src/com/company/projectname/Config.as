package com.company.projectname
{
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 3:33:35 PM
	 * description 游戏配置文件类
	 **/
	public class Config
	{
		/**
		 * 平台用户编号
		 */
		public static var PLATFORM_UID:String = "0";
		/**
		 * 平台编号 
		 */		
		public static var PLATFORM_ID:int;
		/**
		 * 服务器编号
		 */		
		public static var SERVER_ID:int;
		/**
		 * 用户类型 
		 */		
		public static var USER_TYPE:int;
		/**
		 * 服务器IP 
		 */		
		public static var HOST_IP:String = "";
		/**
		 *  游戏配置文件
		 */
		public static var SETTING:XML;
		/**
		 * 游戏资源站
		 */
		public static var CDN:String = "";
		/**
		 * 游戏版本号
		 */
		public static var VERSION:String = "";
		/**
		 * 游戏应用程序域
		 */
		public static var APPDOMAIN:ApplicationDomain;
		/**
		 * 最大游戏宽度 - 1440
		 */
		public static var MAX_GAME_WIDTH:int = 1440;
		/**
		 * 最大游戏高度 - 800
		 */
		public static var MAX_GAME_HEIGHT:int = 800;
		/**
		 * 默认的背景色
		 */		
		public static var DEFAULT_GAME_BG_COLOR:uint = 0x233a49;
		/**
		 * 是否为debug状态 
		 * @return 
		 * 
		 */		
		public static function get isDebug():Boolean
		{
			return int(Config.SETTING.isDebug) == 1;
		}
		
		/**
		 * 获取客户端的fp版本号+屏幕分辨率 
		 * @return 
		 * 
		 */		
		public static function get clientInfo():String
		{
			return "[" + Capabilities.version.replace(" ", "") + "][" + Capabilities.screenResolutionX + "*" + Capabilities.screenResolutionY + "]";
		}
	}
}