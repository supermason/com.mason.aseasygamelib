package com.company.projectname.game.ui
{
	import com.company.projectname.game.loader.FullScreenLoadingBarManager;
	import com.company.projectname.game.loader.SimpleLoadingBarManager;
	import com.company.projectname.game.ui.animation.AnimationManager;
	import com.company.projectname.game.ui.menu.MenuManager;
	import com.company.projectname.game.ui.notice.UINoticeManager;
	import com.company.projectname.game.ui.popup.GamePopUpManager;
	import com.company.projectname.game.ui.rookie.RookieManager;
	import com.company.projectname.game.ui.scene.SceneManager;
	import com.company.projectname.game.ui.tips.SlideTipManager;
	import com.company.projectname.game.ui.tips.ToolTipManager;
	import com.company.projectname.game.ui.window.avatar.UIAvatarManager;
	import com.company.projectname.game.ui.window.bottombuttonbar.UIBottomButtonBarManager;
	import com.company.projectname.game.ui.window.chat.UIChatManager;
	import com.company.projectname.game.ui.window.fastaccess.UIFastAccessManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	
	import easygame.framework.display.IViewport;
	import easygame.framework.display.IWindowManager;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 5:35:44 PM
	 * description UI窗体管理器集合
	 **/
	public class UIManager
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		// 基础属性  
		private var _stage:Stage; // 舞台对象
		private var _bgColorContainer:Shape; // 背景色层
		private var _sceneParent:DisplayObjectContainer; // 放置场景的容器
		private var _winParent:DisplayObjectContainer; // 放置所有窗体的容器
		private var _popUpParent:DisplayObjectContainer; // 放置弹出提示层的容器
		private var _viewPort:IViewport;
		
		// 加载器管理器对象
		private var _fullScreenLoadingBarMgr:FullScreenLoadingBarManager;
		private var _simpleLoadingBarMgr:SimpleLoadingBarManager;
		// 悬停提示管理器
		private var _toolTipMgr:ToolTipManager;
		// 滑屏提示管理器
		private var _slideTipMgr:SlideTipManager;
		// 弹出对话框管理器
		private var _gamePopUpMgr:GamePopUpManager;
		// 菜单管理器
		private var _menuMgr:MenuManager;
		// 场景管理器
		private var _sceneMgr:SceneManager;
		// 比赛引擎管理器
//		private var _matchMgr:UIMatchManager;
		// 新手箭头管理器
		private var _rookieMgr:RookieManager;
		// 动画管理器
		private var _animationMgr:AnimationManager;
		// 公告管理器
		private var _noticeMgr:UINoticeManager;
		
		// 所有窗体的管理器对象集合
		private var _winMgrDic:Dictionary;
		
		/**
		 * 当前需要显示的背景色 
		 */		
		public var bgColor:uint = 0x233a49;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function UIManager()
		{
			_winMgrDic = new Dictionary();
			
			_viewPort = new ViewPort();
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 舞台大小改变的监听事件处理方法，所有打开状态的窗体全部重新定位 
		 * 
		 */		
		public function onResize():void
		{			
			for each (var mgr:IWindowManager in _winMgrDic)
			{
				if (mgr.active) mgr.onResize();
			}

			_fullScreenLoadingBarMgr.onResize(_stage.stageWidth, _stage.stageHeight);
			_simpleLoadingBarMgr.onResize(_stage.stageWidth, _stage.stageHeight);
			_gamePopUpMgr.onResize();

			
			if (_sceneMgr) _sceneMgr.onResize();
			if (_noticeMgr) _noticeMgr.onResize();
		}
		/**
		 * 初始化可视区域对象 
		 * @param screenWidth
		 * @param screenHeight
		 * 
		 */		
		public function initViewPort(screenWidth:int, screenHeight:int):void
		{
			_viewPort.screenWidth = screenWidth;
			_viewPort.screenHeight = screenHeight;
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		public function get stage():Stage 
		{
			return _stage;
		}
		
		public function set stage(value:Stage):void 
		{
			_stage = value;
			
			_viewPort.stage = value;
		}
		/**
		 * 游戏内所有窗体管理器集合
		 * */
		public function get winMgrDic():Dictionary 
		{
			return _winMgrDic;
		}
		/**
		 * 
		 * @priavte
		 * 
		 */			
		public function set BG_COLOR_CONTAINER(value:Shape):void
		{
			_bgColorContainer = value;
		}
		/**
		 * 游戏背景色层  
		 * 
		 */		
		public function get BG_COLOR_CONTAINER():Shape
		{
			return _bgColorContainer;
		}
		/**
		 * 获取游戏内场景父容器
		 */
		public function get SCENE_PARENT():DisplayObjectContainer
		{
			return _sceneParent;
		}
		/**
		 * @private
		 */
		public function set SCENE_PARENT(value:DisplayObjectContainer):void
		{
			_sceneParent = value;
			
			// 公告管理器
			_noticeMgr = new UINoticeManager();
			_noticeMgr.init(_sceneParent);
		}
		
		/**
		 * 获取游戏内所有窗体的父容器
		 */
		public function get WIN_PARENT():DisplayObjectContainer
		{
			return _winParent;
		}
		/**
		 * @private
		 */
		public function set WIN_PARENT(value:DisplayObjectContainer):void
		{
			_winParent = value;
			
			_viewPort.winParent = value;
		}
		
		/**
		 * 获取游戏内提示、系统公告等处于最高层组件的容器<br>
		 * 同时初始化所有以该容器为父容器的组件管理器
		 */
		public function get POPUP_PARENT():DisplayObjectContainer
		{
			return _popUpParent;
		}
		
		public function set POPUP_PARENT(value:DisplayObjectContainer):void
		{
			_popUpParent = value;
			
			// 初始化加载条
			_fullScreenLoadingBarMgr = new FullScreenLoadingBarManager();
			_fullScreenLoadingBarMgr.init(_popUpParent);
			_simpleLoadingBarMgr = new SimpleLoadingBarManager();
			_simpleLoadingBarMgr.init(_popUpParent);
			// 初始化游戏内的弹出对话框
			_gamePopUpMgr = new GamePopUpManager();
			_gamePopUpMgr.init(_popUpParent);
//			// 初始化游戏内的滑屏提示组件
			_slideTipMgr = new SlideTipManager();
			_slideTipMgr.init(_popUpParent);
//			// 初始化游戏的悬停提示组件
			_toolTipMgr = new ToolTipManager();
			_toolTipMgr.init(_popUpParent);
//			// 初始化游戏的菜单组件
			_menuMgr = new MenuManager();
			_menuMgr.init(_popUpParent);
			// 初始化比赛
//			_matchMgr = new UIMatchManager();
//			_matchMgr.init(_popUpParent);
			// 初始化动画特效管理器
			_animationMgr = new AnimationManager();
			_animationMgr.init(_popUpParent);
		}
		
		/**
		 * 获取游戏可视区域监视对象
		 * @return 
		 */		
		public function get viewPort():IViewport
		{
			return _viewPort;
		}
		
		/**
		 * 获取全屏加载器管理器 
		 * @return 
		 * 
		 */		
		public function get fullScreenLBMgr():FullScreenLoadingBarManager
		{
			return _fullScreenLoadingBarMgr;
		}
		
		/**
		 * 获取简单加载器管理器
		 * @return 
		 * 
		 */		
		public function get simpleLBMgr():SimpleLoadingBarManager
		{
			return _simpleLoadingBarMgr;
		}
		
		/**
		 * 悬停提示管理器 
		 * @return 
		 * 
		 */		
		public function get toolTipMgr():ToolTipManager
		{
			return _toolTipMgr;
		}
		
		/**
		 * 菜单管理器
		 */
		public function get menuMgr():MenuManager
		{
			return _menuMgr;
		}
		
		/**
		 * 滑屏提示管理器 
		 * @return 
		 * 
		 */		
		public function get slideTipMgr():SlideTipManager
		{
			return _slideTipMgr;
		}
		
		/**
		 * 弹出层窗体管理器 
		 * @return 
		 * 
		 */		
		public function get gamePopUpMgr():GamePopUpManager
		{
			return _gamePopUpMgr;
		}
		
		/**
		 * 场景管理器
		 * @return 
		 * 
		 */		
		public function get sceneMgr():SceneManager
		{
			if (!_sceneMgr)
				_sceneMgr = new SceneManager();
			
			return _sceneMgr;
		}
		
//		/**
//		 * 比赛模块UI管理器 
//		 * @return 
//		 * 
//		 */		
//		public function get matchMgr():UIMatchManager
//		{
//			return _matchMgr;
//		}
		
		/**
		 * 新手箭头管理器 
		 * @return 
		 * 
		 */		
		public function get rookieMgr():RookieManager
		{
			if (!_rookieMgr)
				_rookieMgr = new RookieManager();
			
			return _rookieMgr;
		}
		
		/**
		 * 游戏内动画特效管理器 
		 * @return 
		 * 
		 */		
		public function get animationMgr():AnimationManager
		{
			return _animationMgr;
		}
		
		/**
		 * 公告管理器 
		 * @return 
		 * 
		 */		
		public function get noticeMgr():UINoticeManager
		{
			return _noticeMgr;
		}
		
		/*=======================================================================*/
		/* INSTANCES OF ALL WINDOW_MANAGER CLASS                                 */
		/*=======================================================================*/
		/**
		 * 获取聊天模块UI管理器 
		 * @return 
		 * 
		 */		
		public function get chatMgr():UIChatManager
		{
			if (!_winMgrDic[UIChatManager])
				_winMgrDic[UIChatManager] = new UIChatManager();
			return _winMgrDic[UIChatManager];
		}
		
		/**
		 * 左上角玩家头像模块UI管理器 
		 * @return 
		 * 
		 */		
		public function get avatarMgr():UIAvatarManager
		{
			if (!_winMgrDic[UIAvatarManager])
				_winMgrDic[UIAvatarManager] = new UIAvatarManager();
			return _winMgrDic[UIAvatarManager];
		}
		
		/**
		 * 底部功能按钮条模块UI管理器 
		 * @return 
		 * 
		 */		
		public function get bottBtnBarMgr():UIBottomButtonBarManager
		{
			if (!_winMgrDic[UIBottomButtonBarManager])
				_winMgrDic[UIBottomButtonBarManager] = new UIBottomButtonBarManager();
			return _winMgrDic[UIBottomButtonBarManager];
		}
		
		/**
		 * 快速通道模块UI管理器 
		 * @return 
		 * 
		 */		
		public function get fastAccessMgr():UIFastAccessManager
		{
			if (!_winMgrDic[UIFastAccessManager])
				_winMgrDic[UIFastAccessManager] = new UIFastAccessManager();
			return _winMgrDic[UIFastAccessManager];
		}
	}
}