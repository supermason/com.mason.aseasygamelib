package com.company.projectname.game.ui.popup
{
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 1:55:25 PM
	 * description 包含{确定}{取消}两个按钮的弹出提示框
	 **/
	public class ConfirmPopUp extends PopUpBase
	{
		/**
		 * 游戏内的确认对话框
		 */
		public function ConfirmPopUp()
		{
			super(PopUpType.CONFIRM);
		}
		
		override protected function init():void
		{
			super.init();
			
			updateBtnXPos();
			_txtInfo.y += 20;
			
			_closeBtn.visible = false;
		}
		
		override public function updatePopData(data:Object):void
		{
			_btnConfirm.label = data["newLbl"];
		}
	}
}