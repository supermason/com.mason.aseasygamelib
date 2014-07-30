package com.company.projectname.network.response
{
	import com.company.projectname.game.ui.rookie.RookieHelper;
	import com.company.projectname.network.command.ROOKIE;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Mar 25, 2014 9:22:43 AM
	 * description: 	
	 **/
	public class RookieResponse extends ResponseBase
	{
		public function RookieResponse()
		{
			super();
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		override protected function createHandler():void
		{
			super.createHandler();
			
			_funDic[ROOKIE.UPDATE_ROOKIE_DATA] = updateRookieData;
			_funDic[ROOKIE.SAVE_ROOKIE_INTERACTION] = saveRookieInteraction;
		}
		
		/**
		 * 更新新手数据 
		 * @param o
		 * 
		 */		
		private function updateRookieData(o:Object):void
		{
			if (getOprState(o) == 0)
			{
				RookieHelper.moveToNextStep(getOprData(o));
			}
			else
			{
				
			}
		}
		
		/**
		 * 保存新手期交互信息 
		 * @param o
		 * 
		 */		
		private function saveRookieInteraction(o:Object):void
		{
			trace(getOprState(o));
		}
	}
}