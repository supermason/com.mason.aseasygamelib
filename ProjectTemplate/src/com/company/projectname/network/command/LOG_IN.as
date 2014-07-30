package com.company.projectname.network.command
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 15, 2013 9:34:03 AM
	 * description 登录相关功能ID常量类
	 **/
	public class LOG_IN
	{
		/**
		 * 功能类别：0 
		 */		
		public static const TYPE:int = 0;
		
		/**
		 * 登录游戏 - 3 
		 */		
		public static const LOG_IN:int = 3;
		
		/**
		 * 选择球队 - 1
		 */		
		public static const CHOOSE_CLUB:int = 1;
		
		/**
		 * 获取球队随机名称 - 2
		 */		
		public static const GET_RANDOM_NAME:int = 2;
		
		/**
		 * 创建球队 - 4
		 */		
		public static const CREATE_TEAM:int = 4;
		
		/**
		 * 断线重连 - 6 
		 */		
		public static const RECONNECT:int = 6;
		
		/**
		 * 保存玩家的fp版本号+屏幕分辨率  - 201 
		 */		
		public static const SAVE_CLIENT_SCREEN_INFO:int = 201;
	}
}