package com.company.projectname.network.response
{
	import com.company.projectname.network.command.AVATAR;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 18, 2013 10:57:28 AM
	 * description: 	
	 **/
	public class AvatarResponse extends ResponseBase
	{
		public function AvatarResponse()
		{
			super();
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		override protected function createHandler():void
		{
			super.createHandler();
			
			_funDic[AVATAR.OPEN_LETTER] = openLetter;
			
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 服务端响应后，打开信函界面 
		 * @param s
		 * 
		 */		
		private function openLetter(o:Object):void
		{
			
		}
	}
}