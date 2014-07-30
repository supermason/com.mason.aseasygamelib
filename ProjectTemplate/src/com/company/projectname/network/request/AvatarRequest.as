package com.company.projectname.network.request
{
	import com.company.projectname.network.NetWrokConstants;
	import com.company.projectname.network.command.AVATAR;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 18, 2013 10:54:18 AM
	 * description: 	
	 **/
	public class AvatarRequest extends RequestBase
	{
		public function AvatarRequest(sendFun:Function, clubId:int, sendingStateHandler:Function=null)
		{
			super(sendFun, clubId, sendingStateHandler);
			
			formatProtcolHeader(NetWrokConstants.SYSTEM, NetWrokConstants.SYSTEM);
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		/**
		 * 打开信函界面
		 * 
		 */		
		public function checkLetter():void
		{
			send(AVATAR.OPEN_LETTER);
		}
	}
}