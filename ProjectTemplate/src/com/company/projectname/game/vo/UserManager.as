package com.company.projectname.game.vo
{
	import com.company.projectname.SystemManager;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 5:07:18 PM
	 * description 玩家实体类管理器
	 **/
	public class UserManager
	{

		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _user:User;
		public var clubId:int;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function UserManager()
		{
			_user = new User();
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		public function initUser(data:Array):void
		{
			// 赫塔菲|0|0|1|0|30|0|0|0
			_user.init(data);
		}
		
		/**
		 * 自动更新资源线 
		 * @param r
		 * 
		 */		
		public function updateUserResource(r:String):void
		{
			// 金币├0┤欧元├0┤声望├0┤等级├0┤当前经验├0┤当前等级经验上限├0┤实力├0┤训练点├0┤战术点
			_user.updateRes(SystemManager.Instance.dataParser.parseData(String(r), 0));
		}
		
		/**
		 * 更新金币和绑定金币 
		 * @param value
		 * 
		 */		
		public function updateGoldAndGoldBound(value:Array):void
		{
			_user.updateGoldAndGoldBount(value, true);
		}
		
		/**
		 * 更新黄钻信息
		 * @param value [黄钻|年费黄钻|高级黄钻] 
		 * 
		 */		
		public function updateYellowVipInfo(value:Array):void
		{
			_user.updateYellowInfo(value, true);
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		public function get user():User
		{
			return _user;
		}
		/**
		 * 设置刷新界面的方法 
		 * @param value
		 * 
		 */		
		public function set uiUpdator(value:Function):void
		{
			_user.updateUI = value;
		}
		/**
		 * 设置刷新经验条的方法
		 * @param value
		 * 
		 */		
		public function set expUpdator(value:Function):void
		{
			_user.updateExpBar = value;
		}
		
		/**
		 * 升级时的回调方法 
		 * @param value
		 * 
		 */		
		public function set lvlHandler(value:Function):void
		{
			_user.lvlUpHandler = value;
		}
		
		/**
		 *  球探等级改变时的回调方法 
		 * @param value
		 * 
		 */		
		public function set scoutLvlChangeHandler(value:Function):void
		{
			_user.scoutLvlChangeHandler = value;
		}
		
		/**
		 * 联赛编号改变时的回调方法 
		 * @param value
		 * 
		 */		
		public function set leagueChangeHandler(value:Function):void
		{
			_user.leagueChangeHandler = value;
		}
		
		/**
		 * 是否还是新手 
		 * @return 
		 * 
		 */		
		public function get newBie():Boolean
		{
			return false;
		}
		
		public function set rookieChangeHandler(value:Function):void
		{
			_user.rookieChangeHandler = value;
		}
				
	}
}