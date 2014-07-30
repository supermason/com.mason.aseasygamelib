package com.company.projectname.game.vo
{
	import com.company.projectname.SystemManager;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 4:32:22 PM
	 * description 玩家数据实体类
	 **/
	public class User
	{
		private var _nickname:String = "ogzq2-customer";
		
		private var _gold:int; // 金币
		private var _goldBound:int; // 绑定金币
		private var _money:int; // 银币
		private var _power:int; // 实力
		private var _trainingPoint:int; // 训练点
		private var _tacticPoint:int; // 战术点
		
		private var _lvl:int; // 当前等级
		private var _exp:int; // 当前经验
		private var _expMax:int; // 当前经验上限
		private var _energy:int; //当前体力
		private var _energy_max:int; //体力上限
		private var _reputation:int; // 声望
		private var _scoutCD:int; // 球探倒计时的剩余时间
		private var _scoutLvl:int = 1; // 球探等级
		
		private var _teamIcon:String = "";
		
		private var _rookieStep:int = -1; // 新手期步骤
		
		private var _curLeagueId:int = 1; // 默认是1
		
		private var _updateUI:Function; // 每当有上述数据变化时，用于同步刷新界面的方法
		private var _updateExpBar:Function; // 每当经验有变化时，用于同步界面经验条
		private var _lvlUpHandler:Function;
		private var _scoutLvlChangeHandler:Function; // 球探等级改变时的回调方法
		private var _leagueChangeHandler:Function; // 联赛编号改变时的回调方法
		private var _rookieChangeHandler:Function; // 新手期步骤改变时的回调方法
		private var _firstLogin:Boolean = true;
		
		// 腾讯平台，以下3个值标识黄钻
		// 3366平台 以下3个值标识蓝钻
		// 其他平台   以下三个默认为0
		private var _yellowVipLvl:int; // 黄钻等级 0-表示不是黄钻
		private var _isYellowYearVip:Boolean; // 是否年黄钻
		private var _isYellowHighVip:Boolean; // 是否高级黄钻
		
		private var _hasFinishedTask:Boolean;
		private var _hasFinishedGangTask:Boolean;
		
		private var _scoutPlayerCount:int;
		
		private var _talkForbiddenLeftSec:int;
		
		public function User()
		{
		}
		
		// public
		public function init(data:Array):void
		{
			if (!data) return;
			
			// 赫塔菲|0|0|1|0|30|0|0|0|teamicon|声望|球探倒计时|球探等级|新手期|当前做在的联赛编号|球探大厅里球员的数量
			// |黄钻信息|是否有任务完成的状态|是否被禁言|是否有球会任务|
			_nickname = data[0];
			updateGoldAndGoldBount(data[1].split(SystemManager.Instance.dataParser.getSeparater(1)));
			_money = data[2];
			checkLvlUp(data[3]);
			_exp = data[4];
			_expMax = data[5];
			_power = data[6];
			_trainingPoint = data[7];
			_tacticPoint = data[8];
			_teamIcon = data[9];
			if (_teamIcon.toLowerCase() == "null.png")
				_teamIcon = "1001.png";
			_reputation = data[10];
			_scoutCD = data[11];
			scoutLvl = data[12];
//			_energy = data[9];
//			_energy_max = data[10];
			rookieStep = data[13];
			
			_scoutPlayerCount = data[15];
			
			if (int(data[14]) != 0)
				curLeagueId = data[14];
			
			updateYellowInfo(data[16].split(SystemManager.Instance.dataParser.getSeparater(1)));
			
			_hasFinishedTask = data[17] == "1";
			_talkForbiddenLeftSec = data[18];
			_hasFinishedGangTask = data[19] == "1";
			
			updateGameUI();
		}
		
		public function updateRes(data:Array):void
		{
			//   0     1     2      3     4      5       6        7          8
			// 金币├0┤欧元├0┤声望├0┤等级├0┤实力├0┤训练点├0┤战术点├0┤当前经验├0┤当前等级经验上限
//			_gold = data[0];
			updateGoldAndGoldBount(data[0].split(SystemManager.Instance.dataParser.getSeparater(1)));
			_money = data[1];
			_reputation = data[2];
			checkLvlUp(data[3]);
			_power = data[4];
			_trainingPoint = data[5];
			_tacticPoint = data[6];
			_exp = data[7];
			_expMax = data[8];
			
			updateGameUI();
		}
		
		public function updateYellowInfo(info:Array, updateUI:Boolean=false):void
		{
			_yellowVipLvl = int(info[0]);
			_isYellowYearVip = int(info[1]) == 1;
			_isYellowHighVip = int(info[2]) == 1;
			
			if (updateUI) updateGameUI();
		}
		
		public function updateGoldAndGoldBount(value:Array, updateUI:Boolean=false):void
		{
			_gold = value[0];
			_goldBound = value[1]; 
			
			if (updateUI) updateGameUI();
		}
		
		// private ////
		private function updateGameUI():void
		{
			_updateUI.call(null, this);
			_updateExpBar.call(null, _exp, _expMax);
		}
		
		private function checkLvlUp(newLvl:int):void
		{
			if (newLvl > _lvl)
			{
				if (!_firstLogin && _lvlUpHandler != null)
				{
					_lvlUpHandler(1, {"lvl": newLvl});
				}
				
				_firstLogin = false;
			}
			
			lvl = newLvl;
		}
		
		// getter && setter ////
		/**
		 * 球队名称 
		 * @return 
		 * 
		 */	
		public function get nickname():String
		{
			return _nickname;
		}
		/**
		 * 
		 * @param private
		 * 
		 */
		public function set nickname(value:String):void
		{
			_nickname = value;
		}
		/**
		 * 金币 
		 * @return 
		 * 
		 */		
		public function get gold():int
		{
			return _gold;
		}
		/**
		 * 
		 * @param private
		 * 
		 */
		public function set gold(value:int):void
		{
			_gold = value;
			
			_updateUI(this);
		}
		/**
		 * 绑定金币 
		 * @return 
		 * 
		 */		
		public function get goldBound():int
		{
			return _goldBound;
		}
		/**
		 * 
		 * @param private
		 * 
		 */
		public function set goldBound(value:int):void
		{
			_goldBound = value;
			
			_updateUI(this);
		}
		/**
		 * 金币总数 
		 * @return 
		 * 
		 */		
		public function get allGold():int
		{
			return _gold + _goldBound;
		}
		/**
		 * 银币 
		 * @return 
		 * 
		 */
		public function get money():int
		{
			return _money;
		}
		/**
		 * 
		 * @param private
		 * 
		 */
		public function set money(value:int):void
		{
			_money = value;
			
			_updateUI(this);
		}
		/**
		 * 实力 
		 * @return 
		 * 
		 */
		public function get power():int
		{
			return _power;
		}
		/**
		 * 
		 * @param private
		 * 
		 */
		public function set power(value:int):void
		{
			_power = value;
			
			_updateUI(this);
		}
		/**
		 * 训练点 
		 * @return 
		 * 
		 */
		public function get trainingPoint():int
		{
			return _trainingPoint;
		}
		/**
		 * 
		 * @param private
		 * 
		 */
		public function set trainingPoint(value:int):void
		{
			_trainingPoint = value;
			
			_updateUI(this);
		}
		/**
		 * 战术点 
		 * @return 
		 * 
		 */
		public function get tacticPoint():int
		{
			return _tacticPoint;
		}
		/**
		 * 
		 * @param private
		 * 
		 */
		public function set tacticPoint(value:int):void
		{
			_tacticPoint = value;
			
			_updateUI(this);
		}
		/**
		 * 玩家等级 
		 * @return 
		 * 
		 */
		public function get lvl():int
		{
			return _lvl;
		}
		/**
		 * 
		 * @param private
		 * 
		 */
		public function set lvl(value:int):void
		{
			_lvl = value;
			
			_updateUI(this);
		}
		/**
		 * 玩家当前经验 
		 * @return 
		 * 
		 */
		public function get exp():int
		{
			return _exp;
		}
		/**
		 * 
		 * @param private
		 * 
		 */
		public function set exp(value:int):void
		{
			_exp = value;
			
			_updateExpBar(_exp, _expMax);
		}
		/**
		 * 玩家当前等级的经验上限 
		 * @return 
		 * 
		 */
		public function get expMax():int
		{
			return _expMax;
		}
		/**
		 * 
		 * @private
		 * 
		 */
		public function set expMax(value:int):void
		{
			_expMax = value;
			
			_updateExpBar(_exp, _expMax);
		}
		/**
		 * 玩家的体力值
		 * @return 
		 * 
		 */		
		public function get energy():int
		{
			return _energy;
		}
		/**
		 * 
		 * @private
		 * 
		 */		
		public function set energy(value:int):void
		{
			_energy = value;
		}
		/**
		 * 体力上限
		 * @return 
		 * 
		 */		
		public function get energyMax():int
		{
			return _energy_max;
		}
		/**
		 * 
		 * @private
		 * 
		 */	
		public function set energyMax(value:int):void
		{
			_energy_max = value;
		}
		/**
		 * 声望 
		 * @return 
		 * 
		 */		
		public function get reputation():int
		{
			return _reputation;
		}
		/**
		 * 
		 * @private
		 * 
		 */	
		public function set reputation(value:int):void
		{
			_reputation = value;
		}
		/**
		 * 球队icon 
		 * @return 
		 * 
		 */		
		public function get teamIcon():String
		{
			return _teamIcon;
		}
		/**
		 * 
		 * @private
		 * 
		 */	
		public function set teamIcon(value:String):void
		{
			if (_teamIcon != value)
			{
				_teamIcon = value;
				
				_updateUI(this);
			}
		}
		/**
		 * 用于更新UI界面的方法 
		 * @param value
		 * 
		 */
		public function set updateUI(value:Function):void
		{
			_updateUI = value;
		}
		/**
		 * 用于刷新经验条的方法 
		 * @param value
		 * 
		 */		
		public function set updateExpBar(value:Function):void
		{
			_updateExpBar = value;
		}

		public function get scoutCD():int
		{
			return _scoutCD;
		}
		/**
		 * 球探等级 
		 * @return 
		 * 
		 */		
		public function get scoutLvl():int
		{
			return _scoutLvl;
		}
		
		public function set scoutLvl(value:int):void
		{
			if (_scoutLvl != value)
			{
				_scoutLvl = value;
				if (_scoutLvl < 1)
					_scoutLvl = 1;
				
				if (_scoutLvlChangeHandler != null) 
					_scoutLvlChangeHandler.call(null, _scoutLvl);
			}
		}
		/**
		 * 当前的 新手期步骤 
		 * @return 
		 * 
		 */		
		public function get rookieStep():int
		{
			return _rookieStep;
		}

		public function set rookieStep(value:int):void
		{
			_rookieStep = value;
			
			if (_rookieChangeHandler != null)
				_rookieChangeHandler.call(null, _rookieStep);
		}

		/**
		 * 当前所在的联赛编号 
		 * @return 
		 * 
		 */		
		public function get curLeagueId():int
		{
			return _curLeagueId;
		}
		
		public function set curLeagueId(value:int):void
		{
			_curLeagueId = value;
			
			if (_leagueChangeHandler != null)
				_leagueChangeHandler(_curLeagueId);
		}
		
		/**
		 * 升级时的回调方法 
		 * @param value
		 * 
		 */		
		public function set lvlUpHandler(value:Function):void
		{
			_lvlUpHandler = value;
		}
		/**
		 * 球探等级改变时的回调方法 
		 * @param value
		 * 
		 */
		public function set scoutLvlChangeHandler(value:Function):void
		{
			_scoutLvlChangeHandler = value;
		}

		/**
		 * 联赛编号改变时的回调方法 
		 * @param value
		 * 
		 */		
		public function set leagueChangeHandler(value:Function):void
		{
			_leagueChangeHandler = value;
		}
		
		/**
		 * 新手期步骤改变时的回调方法 
		 * @param value
		 * 
		 */		
		public function set rookieChangeHandler(value:Function):void
		{
			_rookieChangeHandler = value;
		}

		/**
		 * 球员大厅里球员的数量 
		 * @return 
		 * 
		 */		
		public function get scoutPlayerCount():int
		{
			return _scoutPlayerCount;
		}

		/**
		 * 黄钻等级 
		 * @return 
		 * 
		 */		
		public function get yellowVipLvl():int
		{
			return _yellowVipLvl;
		}

		public function set yellowVipLvl(value:int):void
		{
			_yellowVipLvl = value;
			
			_updateUI(this);
		}

		/**
		 * 是否是黄钻用户 
		 * @return 
		 * 
		 */		
		public function get isYellowVip():Boolean
		{
			return _yellowVipLvl > 0;
		}
		
		/**
		 * 是否年黄钻 
		 * @return 
		 * 
		 */		 
		public function get isYellowYearVip():Boolean
		{
			return _isYellowYearVip;
		}

		public function set isYellowYearVip(value:Boolean):void
		{
			_isYellowYearVip = value;
		}
		
		/**
		 * 是否高级黄钻
		 * @return 
		 * 
		 */
		public function get isYellowHighVip():Boolean
		{
			return _isYellowHighVip;
		}

		public function set isYellowHighVip(value:Boolean):void
		{
			_isYellowHighVip = value;
		}

		/**
		 * 是否有完成任务的状态 
		 * @return 
		 * 
		 */		
		public function get hasFinishedTask():Boolean
		{
			return _hasFinishedTask;
		}

		/**
		 * 是否被禁言 
		 * @return 
		 * 
		 */		
		public function get talkForbidden():Boolean
		{
			return _talkForbiddenLeftSec > 0;
		}

		/**
		 * 被禁言的时间（剩余秒数表示法） 
		 * @return 
		 * 
		 */		
		public function get talkForbiddenLeftSec():int
		{
			return _talkForbiddenLeftSec;
		}

		public function set talkForbiddenLeftSec(value:int):void
		{
			_talkForbiddenLeftSec = value;
		}

		/**
		 * 是否有完成的球会任务 
		 * @return 
		 * 
		 */		
		public function get hasFinishedGangTask():Boolean
		{
			return _hasFinishedGangTask;
		}

	}
}