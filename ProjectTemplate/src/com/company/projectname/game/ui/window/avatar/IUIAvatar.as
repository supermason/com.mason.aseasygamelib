package com.company.projectname.game.ui.window.avatar
{
	import easygame.framework.display.IWindow;
	import com.company.projectname.game.vo.User;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 16, 2013 2:23:59 PM
	 * description: 	
	 **/
	public interface IUIAvatar extends IWindow
	{
		/**
		 * 刷新界面 
		 * @param user
		 * 
		 */		
		function updateUI(user:User):void;
	}
}