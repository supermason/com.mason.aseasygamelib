package com.company.projectname.game.ui.window.avatar
{
	import com.company.projectname.game.ui.window.PermanentFixedWindowManager;
	import com.company.projectname.game.vo.User;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 16, 2013 2:25:19 PM
	 * description: 	
	 **/
	public class UIAvatarManager extends PermanentFixedWindowManager
	{
		public function UIAvatarManager()
		{
			super(UIAvatar);
		}
		
		// public ////
		override public function onResize(x:int = -1, y:int = -1):void
		{
			// 左上角的LeftTop无需重置位置
		}
		
		/**
		 * 刷新界面 
		 * @param user
		 * 
		 */		
		public function updateUI(user:User):void
		{
			avatar.updateUI(user);
		}
		
		// win obj ////
		private function get avatar():IUIAvatar
		{
			return IUIAvatar(_window);
		}
		
		// protected ////
		override protected function onWindowCreated():void
		{
			// 登录后 查看是否有未读消息
		}
		
		// buzi handler ////
		override protected function winBuziEvtHandler(evtType:String, data:*= null):void
		{
			switch (evtType)
			{
			}
		}
		
	}
}