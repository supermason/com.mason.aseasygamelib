package com.company.projectname.game.tool.platform
{
	import com.company.projectname.Config;
	import com.company.projectname.ResourceLocater;
	import com.company.projectname.SystemManager;
	
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.Dictionary;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Jun 24, 2014 9:48:13 AM
	 * description: 	
	 **/
	public class Tencent extends PlatfromToolBase
	{
		private var _callBackList:Dictionary = new Dictionary();
		private var _callBackVars:Dictionary = new Dictionary();
		
		public function Tencent()
		{
			
		}
		
		// public ////
		
		/**
		 * 打开购买QQ黄钻页面 
		 * @param openId
		 * @return 
		 * 
		 */		
		public function gotoQQPay(openId:String, type:int):void
		{
			try
			{
				ExternalInterface.call("openPay", openId, type);
			}
			catch (err:Error)
			{
				errInfo(err);
			}
		}
		
		/**
		 * 重写前往充值页--腾讯平台有自己的充值方法，该方法被屏蔽 
		 * @param clubId
		 * @param uid
		 * @param clubName
		 * @param platformId
		 * @param serverId
		 * @param userType
		 * 
		 */		
		override public function gotoChargePage(clubId:int, uid:String, clubName:String, platformId:int, serverId:int, userType:int):void
		{
			throw new Error("This method can not be invoked on Tencent-Platform!!");
		}
		
		/**
		 * 打开QQ活动
		 * @param openId
		 * @return 
		 * 
		 */		
		public function gotoQQActivity(clubid:int, Week:int,itemName:String,itemCount:int):void
		{
			coverAll();
			
			try
			{
				ExternalInterface.call("QQActivityBuy", clubid, Week,itemName,itemCount);
			}
			catch (err:Error)
			{
				handleError(err);
			}
		}
		/**
		 * 从商城中使用Q点购买道具
		 * @param itemCode
		 * @param price
		 * @param itemCount
		 * @param imgURL
		 * @param description
		 * 
		 */		
		public function buyGoldFromQQ(itemCode:int, price:int, itemCount:int, imgURL:String, description:String):void
		{
			coverAll();
			
			try
			{
				ExternalInterface.call("buyItem", 
					SystemManager.Instance.userMgr.clubId, 
					itemCode, 
					price, 
					itemCount, 
					ResourceLocater.CDN + ResourceLocater.ITEM_ICON_ROOT + imgURL,
					description);
			}
			catch (err:Error)
			{
				handleError(err);
			}
		}
		
		/**
		 * 注册供JS调用的回调方法 
		 * 
		 */		
		public function registerCallBack():void
		{
			flash.system.Security.allowDomain("*");
			
			// Q点购买道具回调
			try 
			{
				ExternalInterface.addCallback("buyItemOK", null); 
			}
			catch (err:Error)
			{
				errInfo(err);
			}
			// 移除遮罩的回调
			try
			{
				ExternalInterface.addCallback("removeCover", SystemManager.Instance.uiMgr.rookieMgr.removeRookie); 
			}
			catch (err:Error)
			{
				errInfo(err);
			}
			// 检查黄钻vip的回调
			try
			{
				ExternalInterface.addCallback("updateYellowVipState", checkYellowVipResult); 
			}
			catch (err:Error)
			{
				errInfo(err);
			}
			// 弹出提示的回调
			try
			{
				ExternalInterface.addCallback("popMessage", popMessage); 
			}
			catch (err:Error)
			{
				errInfo(err);
			}
		}
		
		
		
		/**
		 * 邀请好友 
		 * 
		 */		
		public function inviteFriends():void
		{
			coverAll();
			
			try
			{
				ExternalInterface.call("inviteFriends", Config.PLATFORM_UID);
			}
			catch (err:Error)
			{
				handleError(err);
			}
		}
		
		/**
		 * 检查黄钻vip等级 
		 * @param callName
		 * @param callFun
		 * @param callVars
		 */		
		public function checkYellowVipState(callName:String, callFun:Function, callVars:Object=null):void
		{
			coverAll();
			
			_callBackList[callName] = callFun;
			_callBackVars[callName] = callVars;
			
			try
			{
				ExternalInterface.call("checkYellowVipState", Config.PLATFORM_UID);
			}
			catch (err:Error)
			{
				handleError(err);
			}
		}
		
		/**
		 * QQ故事分享 
		 * @param title
		 * @param content
		 * 
		 */		
		public function shareStroyToMyFriend(title:String, content:String):void
		{
			coverAll();
			
			try
			{
				ExternalInterface.call("shareStory", title, content);
			}
			catch (err:Error)
			{
				handleError(err);
			}
		}
		
		// priavte //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**检查黄钻等级的返回结果*/
		private function checkYellowVipResult(value:String):void
		{
			var data:Array = value.split(",");
			
			SystemManager.Instance.userMgr.updateYellowVipInfo(data);
			
			var deleteKeys:Array = [];
			
			for (var k:String in _callBackList)
			{
				if (_callBackList[k])
				{
					if (_callBackVars.hasOwnProperty(k) && _callBackVars[k] != null)
						_callBackList[k].call(null, _callBackVars[k]);
					else
						_callBackList[k].call();
				}
				
				deleteKeys[deleteKeys.length] = k;
			}
			
			for each (k in deleteKeys)
			{
				_callBackList[k] = null;
				_callBackVars[k] = null;
				
				delete _callBackList[k];
				delete _callBackVars[k];
			}
		}
	}
}