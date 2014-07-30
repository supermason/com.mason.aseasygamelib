package com.company.projectname
{
	import com.company.projectname.game.lang.Lang;
	import com.company.projectname.game.tool.DragHelper;
	import com.company.projectname.game.ui.UIManager;
	import com.company.projectname.game.ui.window.WindowAutoCloseTool;
	import com.company.projectname.game.vo.UserManager;
	import com.company.projectname.network.DataParser;
	import com.company.projectname.network.NetWorkManager;
	import com.company.projectname.network.monitor.ISendingStateMonitor;
	import com.company.projectname.network.monitor.SendingStateMonitor;
	
	import easygame.framework.animation.AnimationStarter;
	import easygame.framework.animation.FrameManager;
	import easygame.framework.animation.Juggler;
	import easygame.framework.cache.disobj.DisObjCacheManager;
	import easygame.framework.cache.res.ResCacheManager;
	import easygame.framework.dragdrop.DragManager;
	import easygame.framework.filter.FilterManager;
	import easygame.framework.loader.GameLoaderManager;
	import easygame.framework.sound.SoundManager;
	import easygame.framework.text.TxtFormatManager;
	import easygame.framework.timer.TimerManager;
	
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 3:38:00 PM
	 * description 整个游戏的系统管理器[其它所有模块的管理器均从这里获取]
	 **/
	public class SystemManager
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		/**
		 * 单例对象  
		 */		
		static private var _instance:SystemManager;
		
		private var _fitlerMgr:FilterManager;
		private var _textFormatMgr:TxtFormatManager;
		private var _frameMgr:FrameManager;
		private var _juggler:Juggler;
		private var _animationStarter:AnimationStarter;
		private var _loaderMgr:GameLoaderManager;
		private var _resCacheMgr:ResCacheManager;
		private var _soundMgr:SoundManager;
		private var _timerMgr:TimerManager;
		private var _uiMgr:UIManager;
		private var _winAutoCloseTool:WindowAutoCloseTool;
		private var _nwMgr:NetWorkManager;
		private var _dataParser:DataParser;
		private var _userMgr:UserManager;
		private var _disObjCacheMgr:DisObjCacheManager;
		private var _sendingStateMonitor:ISendingStateMonitor;
		private var _platformInfo:PlatformInfo;
		
		/**
		 * 是否已经登录 
		 */		
		public var hasLogin:Boolean;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function SystemManager(singleton:SingletonEnforcer) 
		{
			initializeManager();
		}
		
		protected function initializeManager():void 
		{
			_fitlerMgr = FilterManager.Instance;
			_frameMgr = new FrameManager();
			_textFormatMgr = TxtFormatManager.instance;
			_juggler = new Juggler();
			_animationStarter = new AnimationStarter();
			_animationStarter.frameMgr = _frameMgr;
			_animationStarter.juggler = _juggler;
			_loaderMgr = new GameLoaderManager(Config.APPDOMAIN, Config.CDN);
			_loaderMgr.version = Config.VERSION;
			_loaderMgr.defaultLoadingTxt = Lang.l.defLoadTxt;
			_resCacheMgr = new ResCacheManager();
			_loaderMgr.resCacheHandler = _resCacheMgr.cache;
			_soundMgr = new SoundManager();
			_timerMgr = new TimerManager();
			_uiMgr = new UIManager();
			_winAutoCloseTool = new WindowAutoCloseTool(_uiMgr.winMgrDic);
			_userMgr = new UserManager();
			_disObjCacheMgr = new DisObjCacheManager();
			_nwMgr = new NetWorkManager();
			_nwMgr.moniterMode = int(Config.SETTING.monitermode);
			_dataParser = new DataParser();
			_sendingStateMonitor = new SendingStateMonitor();
			_sendingStateMonitor.curMode = int(Config.SETTING.monitermode);
			_sendingStateMonitor.interval = int(Config.SETTING.requestInvterval);
			_platformInfo = new PlatformInfo();
			
			// 对接拖拽
			DragManager.dropInHandler = DragHelper.serverAuthentication;
			DragManager.dropOutHandler = DragHelper.popupOperationUI;
			DragManager.whenDragging = DragHelper.smoothDragHandler;
			
			//
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 获取单例对象 
		 * @return 
		 * 
		 */		
		static public function get Instance():SystemManager
		{
			if (!_instance)
			{
				_instance = new SystemManager(new SingletonEnforcer());
			}
			
			return _instance;
		}
		/**
		 * 滤镜管理器
		 */
		public function get fitlerMgr():FilterManager 
		{
			return _fitlerMgr;
		}
		/**
		 * 字体格式管理器
		 */
		public function get txtFormatMgr():TxtFormatManager
		{
			return _textFormatMgr;
		}
		/**
		 * 帧频管理器（游戏内所有的enterFrameHandler都由该对象管理）
		 */
		public function get frameMgr():FrameManager 
		{
			return _frameMgr;
		}
		/**
		 * 加载管理器（游戏内所有资源的加载都从这里开始）
		 */
		public function get loaderMgr():GameLoaderManager 
		{
			return _loaderMgr;
		}
		/**
		 * 音效管理器
		 */
		public function get soundMgr():SoundManager 
		{
			return _soundMgr;
		}
		/**
		 * 计时器管理器（游戏内所有的onTimer事件处理方法均由该类管理）
		 */
		public function get timerMgr():TimerManager 
		{
			return _timerMgr;
		}
		/**
		 * UI界面管理器的总管理器（所有UI界面管理器的获取入口）
		 */
		public function get uiMgr():UIManager 
		{
			return _uiMgr;
		}
		/**
		 * 窗体自动关闭工具类
		 */
		public function get winAutoCloseTool():WindowAutoCloseTool 
		{
			return _winAutoCloseTool;
		}
		/**
		 * 游戏内玩家数据的管理器
		 */
		public function get userMgr():UserManager 
		{
			return _userMgr;
		}
		/**
		 * 游戏内资源管缓存管理器
		 */
		public function get resCacheMgr():ResCacheManager 
		{
			return _resCacheMgr;
		}
		/**
		 * 游戏数据传输与接收管理器
		 */
		public function get nwMgr():NetWorkManager 
		{
			return _nwMgr;
		}
		/**
		 * 服务器回传数据检测类及解析工具类
		 * @return 
		 * 
		 */		
		public function get dataParser():DataParser
		{
			return _dataParser;
		}
		/**
		 * 可缓存的显示对象管理器
		 */
		public function get disObjCacheMgr():DisObjCacheManager 
		{
			return _disObjCacheMgr;
		}
		/**
		 * 动画播放器
		 */
		public function get juggler():Juggler 
		{
			return _juggler;
		}
		/**
		 * 动画启动、停止控制器
		 */
		public function get animationStarter():AnimationStarter
		{
			return _animationStarter;
		}
		/**
		 * 网络数据传输状态监视器
		 */
		public function get sendingStateMonitor():ISendingStateMonitor 
		{
			return _sendingStateMonitor;
		}
		/**
		 *  平台信息辅助类
		 * @return 
		 * 
		 */		
		public function get platformInfo():PlatformInfo
		{
			return _platformInfo;
		}


	}
}
/**
 * 单例强制类 
 * @author Administrator
 * 
 */
class SingletonEnforcer {}