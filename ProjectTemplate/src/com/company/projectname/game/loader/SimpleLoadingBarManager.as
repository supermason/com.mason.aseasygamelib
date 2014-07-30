package com.company.projectname.game.loader
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 2:14:21 PM
	 * description 全屏遮罩（通常加载条很小，留有半透明可以看见后部界面）加载器管理器
	 **/
	public class SimpleLoadingBarManager extends LoadingBarManagerBase
	{
		public function SimpleLoadingBarManager()
		{
			super(SimpleLoadingBar);
		}
	}
}