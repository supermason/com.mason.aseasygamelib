package com.company.projectname.game.ui.menu
{
	import com.company.projectname.game.lang.Lang;
	import com.company.projectname.game.ui.component.Item;
	import com.company.projectname.game.ui.window.PopUpManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Mason
	 */
	public class MenuManager extends PopUpManager 
	{
		private var _menu:Menu;
		private var _isShown:Boolean;
		private var _initiator:*;
		private var _menuContents:Array;
		
		public function MenuManager() 
		{
			super();
			
		}
		
		override public function init(parent:DisplayObjectContainer):void
		{
			if (!_menu) 
			{
				super.init(parent);
				_menu = new Menu();
				_menu.businessHandler = menuItemClickHandler;
			}
		}
		
		// public ////
		/**
		 * 弹出菜单
		 * @param initiator: 触发菜单弹出的对象【一般是{Item}或者点击{玩家的名称}】
		 * @param x:
		 * @param y:
		 * @param _menuContents: 
		 * */
		public function pop(initiator:*, x:int, y:int, _menuContents:*=null):void
		{
			if (!_isShown) 
			{
				_isShown = true;
				addPop(_menu, false);
				_uiMgr.stage.addEventListener(MouseEvent.MOUSE_UP, hide);
			} 
			else 
			{
				bringToFront(_menu);
				_menu.reset();
			}
			
			_initiator = initiator;
			_menu.contents = _menuContents ? _menuContents : createDefaultMenuItemList();
			
			updateMenuPos(x , y );
		}
		
		/**
		 * 移除菜单
		 */
		public function remove():void
		{
			_uiMgr.stage.removeEventListener(MouseEvent.MOUSE_UP, hide);
			
			if (_isShown) 
			{
				_isShown = false;
				_menu.reset();
				removePop(_menu);
				_initiator = null;
			}
		}
		
		// event handler ////
		private function hide(event:MouseEvent):void
		{
			remove();
		}
		
		private function menuItemClickHandler(menuItem:MenuItemRender):void
		{
			switch (menuItem.menuType) 
			{
				case MenuType.VIEW_TEAM:
//					_nwMgr.formationReq.checkOtherFormation(_initiator["id"]);
					//_uiMgr.teamMgr.open();
					break;
				case MenuType.CHAT:
					break;
				case MenuType.MAKE_FRIENDS:
					break;
				case MenuType.SEND_EMAIL:
					break;
			}
		}
		
		// private ////
		private function createDefaultMenuItemList():Array
		{
			_menuContents = [];
			
			if (_initiator) 
			{
				if (_initiator is Item) // 点击的物品 
				{
					
				} // 点击的人物名称
				else 
				{ 
					_menuContents.push({
						menuInfo: String(Lang.l.viewPlayer),
						menuType: MenuType.VIEW_TEAM
					});
					_menuContents.push({
						menuInfo: String(Lang.l.chat),
						menuType: MenuType.CHAT
					});
					_menuContents.push({
						menuInfo: String(Lang.l.makeFriends),
						menuType: MenuType.MAKE_FRIENDS
					});
				}
			} 
			
			return _menuContents;
		}
		
		/**
		 * 设置菜单xy坐标
		 * @param	mx
		 * @param	my
		 */
		private function updateMenuPos(mx:int, my:int):void
		{
			var sw:int = _uiMgr.viewPort.vpWidth;
			var sh:int = _uiMgr.viewPort.vpHeight;
			var tw:int = _menu.width;
			var th:int = _menu.height;
			
			var left:Boolean = tw + mx > sw;
			if (left)
				mx = mx - tw;
			if (my + th > sh)
				my = sh - th;
			
			_menu.x = mx < 0 ? 0 : mx;
			_menu.y = my < 0 ? 0 : my;
		}
	}
}