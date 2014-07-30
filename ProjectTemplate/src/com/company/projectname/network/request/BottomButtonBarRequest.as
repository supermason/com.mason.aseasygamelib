package com.company.projectname.network.request
{
	import com.company.projectname.network.NetWrokConstants;
	import com.company.projectname.network.command.BOTTOM_BUTTON_BAR;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 17, 2013 2:56:28 PM
	 * description: 	
	 **/
	public class BottomButtonBarRequest extends RequestBase
	{
		public function BottomButtonBarRequest(sendFun:Function, clubId:int, sendingStateHandler:Function=null)
		{
			super(sendFun, clubId, sendingStateHandler);
			
			formatProtcolHeader(NetWrokConstants.SYSTEM, NetWrokConstants.SYSTEM);
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		/**
		 * 打开任务界面
		 * 
		 */		
		public function openTask():void
		{
			send(BOTTOM_BUTTON_BAR.OPEN_TASK);
		}
		
		/**
		 * 打开好友界面
		 * 
		 */		
		public function openFriend():void
		{
			send(BOTTOM_BUTTON_BAR.OPEN_FRIEND);
		}
		
		/**
		 * 打开联盟界面
		 * 
		 */		
		public function openUnion():void
		{
			send(BOTTOM_BUTTON_BAR.OPEN_UNION);
		}
		
		/**
		 * 打开球员球队训练页
		 * 
		 */		
		public function openTraining():void
		{
			send(BOTTOM_BUTTON_BAR.OPEN_TRAINING);
		}
		
		/**
		 * 打开阵形
		 * 
		 */		
		public function openFormation():void
		{
			send(BOTTOM_BUTTON_BAR.OPEN_FORMATION);
		}
		
		/**
		 * 打开背包
		 * 
		 */		
		public function openPack():void
		{
			send(BOTTOM_BUTTON_BAR.OPEN_PACK);
		}
	}
}