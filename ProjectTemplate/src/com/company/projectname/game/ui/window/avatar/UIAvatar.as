package com.company.projectname.game.ui.window.avatar
{
	import com.company.projectname.ResourceLocater;
	import com.company.projectname.SystemManager;
	import com.company.projectname.game.tool.UITool;
	import com.company.projectname.game.ui.component.Image;
	import com.company.projectname.game.ui.component.VerticalList;
	import com.company.projectname.game.ui.window.FixedWindow;
	import com.company.projectname.game.vo.User;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 16, 2013 2:24:39 PM
	 * description: 	
	 **/
	public class UIAvatar extends FixedWindow implements IUIAvatar
	{
		private var EXP_BAR_WIDTH:int = 113;
		private var _ttMapping:Dictionary;
		private var _avatarImgFrame:Sprite;
		private var _avatarImg:Image;
		private var _chargeButtonRemoved:Boolean;
		
		private var _buffList:VerticalList;
		
		public function UIAvatar(contentData:Object)
		{
			super("com.company.projectname.game.ui.window.avatar.UIAvatarSkin", contentData);
			
			skinURL = "com.company.projectname.game.ui.window.avatar.UIAvatarSkin";
		}
		
		// public ////
		public function updateUI(user:User):void
		{
		}
		
		override public function refresh(value:*=null):void
		{
			_content = value;
			
			fillData();
		}
		
		// protected ////
		override protected function initComponent():void
		{
			super.initComponent();
			
			this.x = 6;
			this.y = 6;
			
			fillData();
		}
		
		override protected function addEvt():void
		{
			super.addEvt();
			
		}
		
		// event handler ////
		protected function mouseEvtHandler(event:MouseEvent):void
		{
			
		}
		
		// private ////
		
		private function fillData():void
		{
		}
	}
}