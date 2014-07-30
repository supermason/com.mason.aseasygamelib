package  com.company.projectname.game.tool
{	
	import com.company.projectname.Config;
	import com.company.projectname.PlatformInfo;
	import com.company.projectname.SystemManager;
	import com.company.projectname.game.tool.platform.Offical;
	import com.company.projectname.game.tool.platform.Tencent;

	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: May 16, 2014 10:01:01 AM
	 * description: 	
	 **/
	public class WebTool
	{
		/**腾讯平台*/
		private static var _tencent:Tencent;
		/**官网*/
		private static var _offical:Offical;
		
		
		// public ////
		/**
		 * 前往充值页面 
		 * 
		 */		
		public static function gotoChargePage():void
		{
			switch (Config.PLATFORM_ID)
			{
				case PlatformInfo.TENCENT:
					break;
				case PlatformInfo.OFFICAL:
					offical.gotoChargePage(SystemManager.Instance.userMgr.clubId, 
						Config.PLATFORM_UID, 
						SystemManager.Instance.userMgr.user.nickname,
						Config.PLATFORM_ID,
						Config.SERVER_ID,
						Config.USER_TYPE);
					break;
				case PlatformInfo.THREE366:
					break;
			}
		}
		
		// private ////
		/**
		 * 检查是否当前平台是否与要跳转的充值页是统一的平台  
		 * @param curPlatform
		 * 
		 */		
		private static function checkPlatform(curPlatform:int):void
		{
			if (!Config.isDebug && (curPlatform != Config.PLATFORM_ID))
			{
				throw new Error("Your operation is not allowed on current platform!");
			}
		}
		
		// getter && setter ////
		/**
		 * 腾讯平台 
		 * @return 
		 * 
		 */		
		public static function get tencent():Tencent
		{
			checkPlatform(PlatformInfo.TENCENT);
			
			if (!_tencent) _tencent = new Tencent();
			
			return _tencent;
		}
		
		/**
		 * 官方平台 
		 * @return 
		 * 
		 */		
		public static function get offical():Offical
		{
			checkPlatform(PlatformInfo.OFFICAL);
			
			if (!_offical) _offical = new Offical();
			
			return _offical;
		}
	}
}