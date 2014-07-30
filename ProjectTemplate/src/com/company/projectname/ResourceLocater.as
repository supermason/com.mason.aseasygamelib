package com.company.projectname
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 3:37:29 PM
	 * description 资源路径常量类
	 **/
	public class ResourceLocater
	{
		/**
		 * 资源站路径
		 */
		static public const CDN:String = Config.CDN;
		/**
		 * 资源根路径
		 */
		static public const ASSETS_ROOT:String = "assets/";
		/**
		 * 图片资源根目录
		 */
		static public const IMG_ROOT:String = ASSETS_ROOT + "img/";
		/**
		 * 通用图标资源根目录 
		 */		
		static public const COMMON_IMG_ROOT:String = IMG_ROOT + "common/";
		/**
		 * swf资源根目录
		 */
		static public const SWF_ROOT:String = ASSETS_ROOT + "swf/";
		/**
		 * UI界面资源根目录 
		 */		
		static public const UI_ROOT:String = SWF_ROOT + "ui/";
		/**
		 * 物品图标资源根目录 
		 */		
		static public const ITEM_ICON_ROOT:String = IMG_ROOT + "item/";
		/**
		 * 公告资源根目录
		 */		
		static public const NOTICE_RES_ROOT:String = IMG_ROOT + "notice/";
		/**
		 * Buff图片资源
		 */
		static public const BUFF_ROOT:String = IMG_ROOT + "buff/";
		
		/**
		 * 获取默认球队图标
		 * @param url
		 * @return 
		 * 
		 */		
		public static function checkTeamIcon(url:String):String
		{
			return url.toLowerCase() == "null.png" ? "1001.png" : url;
		}
		
		///////////////////// 比赛引擎相关 ////////////////////////////////////////////////////////
		/**
		 * 比赛引擎资源根目录 
		 */		
		static public const MATCH_ENGINE_RES_ROOT:String = SWF_ROOT + "engine/";
		
		///////////////////// 资源配置文件 ////////////////////////////////////////////////////////
		/**资源版本配置文件*/
		public static var RES_VERSION:XML;
	}
}