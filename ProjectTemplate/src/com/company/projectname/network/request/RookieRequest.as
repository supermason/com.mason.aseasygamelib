package com.company.projectname.network.request
{
	import com.company.projectname.network.NetWrokConstants;
	import com.company.projectname.network.command.ROOKIE;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Mar 25, 2014 9:21:07 AM
	 * description: 	
	 **/
	public class RookieRequest extends RequestBase
	{
		public function RookieRequest(sendFun:Function, clubId:int, sendingStateHandler:Function=null)
		{
			super(sendFun, clubId, sendingStateHandler);
			
			formatProtcolHeader(NetWrokConstants.SYSTEM, NetWrokConstants.SYSTEM);
		}
		
		/**
		 * 更新新手数据 
		 * @param mainStep
		 * @param subStep
		 * @param index
		 */		
		public function updateRookieData(mainStep:int, subStep:int, index:int=0):void
		{
			send(ROOKIE.UPDATE_ROOKIE_DATA, mainStep, subStep, index);
		}
		
		/**
		 * 保存新手期交互 
		 * @param mainStep
		 * @param subStep
		 * 
		 */		
		public function saveRookieInteraction(mainStep:int, subStep:int=1):void
		{
			_needShield = false;
			send(ROOKIE.SAVE_ROOKIE_INTERACTION, mainStep, subStep);
		}
	}
}