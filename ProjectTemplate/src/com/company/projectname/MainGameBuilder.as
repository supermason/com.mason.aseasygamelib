package com.company.projectname
{
	import com.company.projectname.game.ui.rookie.RookieHelper;
	import com.company.projectname.game.tool.WebTool;
	import com.company.projectname.game.vo.User;
	

	/**
	 * ...
	 * @author Mason
	 */
	public class MainGameBuilder 
	{
		/**
		 * 一个标识，是否是新用户 
		 */		
		private static var _newComer:Boolean = false;
		
		/**
		 * 进入游戏主界面
		 * @param	o
		 */
		public static function enterGame(o:String):void
		{
			// 游戏流程：
			// 如果没有球队，则进入创建球队流程
			if (o == "-1")
			{
				_newComer = true;
//				SystemManager.Instance.uiMgr.createClubMgr.open();
//				SystemManager.Instance.uiMgr.sceneMgr.enter({}, 2);
			}
			else // 如果有球队了，则进入选择球队流程
			{
//				var temp:Array = SystemManager.Instance.dataParser.parseData(o, 0);
//				if (temp.length == 1) // 如果只有一只球队，则直接让玩家登录
//					SystemManager.Instance.nwMgr.loginReq.choseClub(SystemManager.Instance.dataParser.parseData(temp[0], 1)[0]);
//				else
//					SystemManager.Instance.uiMgr.choseClubMgr.open(o);
			}
		}
		
		/**
		 * 创建游戏主界面
		 * @param	o
		 */
		public static function buildGame(o:String = ""):void
		{
			// 赫塔菲|0|0|1|0|30|0|0|0|teamicon|声望|球探倒计时|球探等级|新手期|当前做在的联赛编号|球探大厅里球员的数量
			// |黄钻信息|是否有任务完成的状态|是否被禁言|是否有球会任务|是否有促销|活动信息|快捷通道|公告|buff
			
			// 活动信息：活动类型|活动类型
			// 快捷通道：每个快捷对应的编号|快捷名称|快捷当前次数
			// 公告：内容|时间|类型
			// buff：0未开启-1开启|描述
			
			var data:Array = SystemManager.Instance.dataParser.parseData(String(o), 0);
			
			if (!SystemManager.Instance.hasLogin)
			{
				SystemManager.Instance.hasLogin = true;
				RookieHelper.init();
				// 如果是新用户，则需要关闭注册页
//				if (_newComer)
//					SystemManager.Instance.uiMgr.createClubMgr.close();
//				else
//					SystemManager.Instance.uiMgr.sceneMgr.enter({}, 1);
//				
//				// 初始化游戏主界面
//				SystemManager.Instance.uiMgr.choseClubMgr.close();
				SystemManager.Instance.uiMgr.avatarMgr.open(data[24]);
//				SystemManager.Instance.uiMgr.activityButtonBarMgr.open({"activities": getOpenActivities(), "show": !_newComer});
//				SystemManager.Instance.uiMgr.fastAccessMgr.open({"openfastAccess": data[22]});
//				SystemManager.Instance.uiMgr.rightBtnBarMgr.open({"openActivities": /*"1├1┤2├1┤3├1┤4├1┤5"*/ data[21], "show": !_newComer});
				SystemManager.Instance.uiMgr.bottBtnBarMgr.open({"discountInProgress": data[20]});
				SystemManager.Instance.uiMgr.chatMgr.open();
//				
//				// 设置数据驱动相关方法
				SystemManager.Instance.userMgr.uiUpdator = function (user:User):void {
					SystemManager.Instance.uiMgr.avatarMgr.updateUI(user);
//					SystemManager.Instance.uiMgr.sceneMgr.updateBuildingState(BuildingCategory.YOUTH_CAMP, user);
//					SystemManager.Instance.uiMgr.sceneMgr.updateChallengeBtnListState(user);
				}
//				SystemManager.Instance.userMgr.expUpdator = SystemManager.Instance.uiMgr.avatarMgr.updateExpBar;
//				SystemManager.Instance.userMgr.lvlHandler = LvlUpHandler.handleLvlUp;
//				SystemManager.Instance.userMgr.scoutLvlChangeHandler = function (lvl:int):void {
//					SystemManager.Instance.uiMgr.sceneMgr.PlaneLvl = lvl;
//				};
//				SystemManager.Instance.userMgr.leagueChangeHandler = SystemManager.Instance.uiMgr.sceneMgr.setCurLeagueId;
//				SystemManager.Instance.userMgr.rookieChangeHandler = function (rookieStep:int):void {
//					//SystemManager.Instance.uiMgr.sceneMgr.updateBuildingBtnState(rookieStep);
//					// 完成了强制新手指引，则显示主界面的其他内容
//					if (rookieStep >= RookieStep.GET_FIRST_CHALLENGE_MATCH_REWARD)
//					{
//						RookieHelper.showMainUI();
//					}
//				}
			}
			
			// 初始化玩家VO对象
			SystemManager.Instance.userMgr.initUser(data);
			// 首次登录判断是否有之前的球探倒计时
//			if (SystemManager.Instance.userMgr.user.scoutCD > 0)
//			{
//				SystemManager.Instance.uiMgr.sceneMgr.scoutCD = SystemManager.Instance.userMgr.user.scoutCD;
//				SystemManager.Instance.uiMgr.sceneMgr.AlphaNull();
//			}
//			SystemManager.Instance.uiMgr.sceneMgr.playerInScoutCount = SystemManager.Instance.userMgr.user.scoutPlayerCount;
			// 判断是否有新手期
//			if (SystemManager.Instance.userMgr.newBie)
//			{
//				if (_newComer) // 有这个标识，说明是首次注册后进入游戏，弹出第一段对话
//					//SystemManager.Instance.timerMgr.addDelayCallBack("DELAY_DIALOGUE", DialogueHelper.instance.youthPlayerAsGiftForAllNewUser, 300);
//					SystemManager.Instance.timerMgr.addDelayCallBack("DELAY_DIALOGUE", DialogueHelper.instance.gotoScout, 150);
//				else
//					RookieStarter.startRookie(SystemManager.Instance.userMgr.user.rookieStep);
//			}
			
			// 检查登录的平台
			checkLoginPlatfrom();
			
			// 开始公告
			SystemManager.Instance.uiMgr.noticeMgr.noticeBgURL = "notice_bg.png";
			SystemManager.Instance.uiMgr.noticeMgr.start(data[23])
		}
		
		/**
		 * 获取开放的活动 
		 * @return 
		 * 
		 */		
		private static function getOpenActivities():String
		{
			// "1├1┤2├1┤3├1┤4├1┤5"
			if (SystemManager.Instance.platformInfo.isOnTencent)
			{
				return "1├1┤2├1┤3├1┤4├1┤5";
			}
			else
			{
				return "3├1┤4├1┤5├1┤6";
			}
		}
		
		/**
		 * 检查登录的平台 
		 * 
		 */		
		private static function checkLoginPlatfrom():void
		{
			if (SystemManager.Instance.platformInfo.isOnTencent)
			{
				WebTool.tencent.registerCallBack();
			}
		}
	}

}