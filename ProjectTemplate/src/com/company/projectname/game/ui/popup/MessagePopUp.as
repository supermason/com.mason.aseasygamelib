package com.company.projectname.game.ui.popup
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 1:56:21 PM
	 * description 游戏内的信息提示弹出框
	 **/
	public class MessagePopUp extends PopUpBase
	{
		/**
		 * 游戏内的消息提示框
		 */
		public function MessagePopUp()
		{
			super(PopUpType.INFO);
		}
		
		override protected function init():void
		{
			super.init();
			
			_btnConfirm.x = 162;
			
			_skin.addChild(_skin.txtInfo);
			
			_txtInfo.selectable = true;
			_txtInfo.y += 20;			
		}
	}
}