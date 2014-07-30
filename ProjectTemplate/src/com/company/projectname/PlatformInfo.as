package com.company.projectname
{
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Jun 12, 2014 1:38:38 PM
	 * description: 	
	 **/
	public class PlatformInfo
	{
		/**
		 * 官方平台编号 - 3 
		 */		
		public static const OFFICAL:int = 3;
		/**
		 * 腾讯平台编号 - 2 
		 */		
		public static const TENCENT:int = 2;
		/**
		 * 3366平台编号 - 1 
		 */		
		public static const THREE366:int = 1;
		
		public function PlatformInfo()
		{
			
		}
		
		// public ////
		
		// getter && setter ////
		
		/**
		 * 是否在官服 
		 * @return 
		 * 
		 */		
		public function get isOnOffical():Boolean
		{
			return Config.PLATFORM_ID == PlatformInfo.OFFICAL;
		}
		
		/**
		 * 是否在腾讯开平 
		 * @return 
		 * 
		 */		
		public function get isOnTencent():Boolean
		{
//			return true;
			
			return Config.PLATFORM_ID == PlatformInfo.TENCENT;
		}
		
		/**
		 * 是否在3366平台 
		 * @return 
		 * 
		 */		
		public function get isOn3366():Boolean
		{
			return Config.PLATFORM_ID == PlatformInfo.THREE366;
		}
		
		/**
		 * 游戏所在平台编号 
		 * @return 
		 * 
		 */		
		public function get PLATFORM_ID():int
		{
			return Config.PLATFORM_ID;
		}
	}
}