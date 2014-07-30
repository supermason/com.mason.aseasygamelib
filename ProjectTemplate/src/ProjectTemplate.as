package
{
	import com.company.projectname.Config;
	import com.company.projectname.MainGameBuilder;
	import com.company.projectname.SystemManager;
	import com.company.projectname.VersionController;
	import easygame.framework.dragdrop.DragManager;
	import easygame.framework.util.WebUtils;
	import com.company.projectname.game.lang.Lang;
	import com.company.projectname.game.tool.DragHelper;
	import com.company.projectname.game.tool.UITool;
	import com.company.projectname.network.response.ResponseManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	
	/** 
	 * @author: mason
	 * @E-mail: jijiiscoming@hotmail.com
	 * @version 1.0.0 
	 * 创建时间：Jul 4, 2014 10:54:02 AM 
	 * 描述：主游戏类--游戏采用2帧加载法  切记加入编译参数[-frames.frame ProjectName ProjectName]
	 * */
	public class ProjectTemplate extends Sprite
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _sceneParent:DisplayObjectContainer;
		private var _popUpParent:DisplayObjectContainer;
		
		// 版底信息
		private var _bottomInfo:TextField;
		private var _yourID:TextField;
		private var _openID:String;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		
		public function ProjectTemplate()
		{
			super();
			
			// 游戏显示列表分为3大层
			// OGZQ2 这个sprite做为所有窗体的父容器是中间一层
			// _sceneParent 这个sprite做为场景一层，是最下层
			// _popUpParent 这个sprite做为遮罩、弹出提示层的容器，是最上层 
			// 在整个游戏被加入到舞台后，开始做上述3层的按序添加工作
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 初始化游戏架构 
		 * @param $stage
		 * 
		 */		
		public function init($stage:Stage):void 
		{
			$stage.quality = flash.display.StageQuality.HIGH;
			
			// 设置游戏可视区域
			this.scrollRect = new Rectangle(0, 0, Config.MAX_GAME_WIDTH, Config.MAX_GAME_HEIGHT);
			// 场景层容器 -- 舞台最下层
			_sceneParent = new Sprite();
			_sceneParent.mouseEnabled = false;
			_sceneParent.scrollRect = this.scrollRect;
			// 弹出提示层容器 -- 在当前层之上
			_popUpParent = new Sprite(); 
			_popUpParent.mouseEnabled = false;
			_popUpParent.scrollRect = this.scrollRect;
			// 设置应用程序域
			//			Config.APPDOMAIN = appDomain;
			//			SystemManager.Instance.resCacheMgr.appDomain = appDomain;
			// 当前Sprite是所有的窗体层容器
			SystemManager.Instance.uiMgr.stage = $stage;
			SystemManager.Instance.uiMgr.SCENE_PARENT = _sceneParent;
			SystemManager.Instance.uiMgr.WIN_PARENT = this;
			SystemManager.Instance.uiMgr.POPUP_PARENT = _popUpParent;
			//			SystemManager.Instance.uiMgr.BG_COLOR_CONTAINER = _bgColorContainer;
			// 初始化可视区域对象
			SystemManager.Instance.uiMgr.initViewPort(Config.MAX_GAME_WIDTH, Config.MAX_GAME_HEIGHT);
			// 初始化加载条
			SystemManager.Instance.loaderMgr.singleLoaderMgr.initLoaderHandlers(
				SystemManager.Instance.uiMgr.fullScreenLBMgr.showLoading,
				SystemManager.Instance.uiMgr.fullScreenLBMgr.progressHandler,
				SystemManager.Instance.uiMgr.fullScreenLBMgr.progressByManual,
				SystemManager.Instance.uiMgr.fullScreenLBMgr.loadingInfo,
				SystemManager.Instance.uiMgr.fullScreenLBMgr.reset,
				SystemManager.Instance.uiMgr.fullScreenLBMgr.hideLoading);
			SystemManager.Instance.loaderMgr.queenLoaderMgr.initLoaderHandlers(
				SystemManager.Instance.uiMgr.simpleLBMgr.showLoading,
				SystemManager.Instance.uiMgr.simpleLBMgr.progressHandler,
				SystemManager.Instance.uiMgr.simpleLBMgr.progressByManual,
				SystemManager.Instance.uiMgr.simpleLBMgr.loadingInfo,
				SystemManager.Instance.uiMgr.simpleLBMgr.reset,
				SystemManager.Instance.uiMgr.simpleLBMgr.hideLoading);
			
			// 游戏疯狂点击屏蔽
			SystemManager.Instance.nwMgr.sendingStateMoniter = SystemManager.Instance.sendingStateMonitor;
			// 初始化拖拽管理器
			DragManager.init($stage, SystemManager.Instance.fitlerMgr.grayEffect);
			DragHelper.init();
			// 禁用tab键
			UITool.disableTab(_sceneParent);
			UITool.disableTab(_popUpParent);
			UITool.disableTab(this);
			
			// 设置底部信息组件
			createBottomInfo($stage);
			
		}
		
		/**
		 * 主程序初始化完毕后，连接服务端
		 * @param	callBack
		 * @param	infoHandler
		 */
		public function connectToServer(callBack:Function,
										infoHandler:Function):void
		{
			ResponseManager.bindingResponse();
			ResponseManager.gameOkCallBack = callBack;
			ResponseManager.infoHandler = infoHandler;
			
			SystemManager.Instance.nwMgr.init(Config.HOST_IP, (Config.PLATFORM_ID*1000+Config.SERVER_ID));
		}
		
		/**
		 * 获取到玩家数据后，开始游戏
		 */
		public function startGame(o:String):void
		{
			ResponseManager.gameOkCallBack = null;
			ResponseManager.infoHandler = null;
			
			MainGameBuilder.enterGame(o);
			
			onResize();
		}
		
		/*=======================================================================*/
		/* EVENT HANDLERS                                                        */
		/*=======================================================================*/
		/**
		 * 显示对象被添加到 舞台时触发该事件
		 * @param e
		 * 
		 */		
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			stage.addChildAt(_sceneParent, 0);
			stage.addChild(_popUpParent);
			stage.addChild(_bottomInfo);
			if (_yourID) stage.addChild(_yourID);
			
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		/**
		 * 舞台大小变化时，触发该事件 
		 * @param e
		 * 
		 */		
		private function onResize(e:Event=null):void 
		{
			if (SystemManager.Instance.uiMgr.stage.stageWidth > Config.MAX_GAME_WIDTH )
			{
				this.x = int((SystemManager.Instance.uiMgr.stage.stageWidth - Config.MAX_GAME_WIDTH) / 2);
				_popUpParent.x = this.x;
				_sceneParent.x = this.x;
			}
			else
			{
				this.x = 0;
				_popUpParent.x = 0;
				_sceneParent.x = 0;
			}
			
			if (SystemManager.Instance.uiMgr.stage.stageHeight > Config.MAX_GAME_HEIGHT)
			{
				this.y = int((SystemManager.Instance.uiMgr.stage.stageHeight - Config.MAX_GAME_HEIGHT) / 2);
				_sceneParent.y = this.y;
				_popUpParent.y = this.y;
			}
			else
			{
				this.y = 0;
				_sceneParent.y = 0;
				_popUpParent.y = 0;
			}
			
			calBottomInfoPos();
			
			SystemManager.Instance.uiMgr.onResize();
		}
		
		/**
		 * 设置底部信息 
		 * 
		 */		
		private function createBottomInfo(stage:Stage):void
		{
			_bottomInfo = createTF();
			_bottomInfo.htmlText = Lang.l.bottomInfo;
			_bottomInfo.addEventListener(TextEvent.LINK, onTextLinkClick);
			
			if (SystemManager.Instance.platformInfo.isOnTencent)
			{
				_bottomInfo.htmlText += Lang.l.forumURL;
				_yourID = createTF();
				_yourID.text = Lang.l.yourID + _openID;
			}
			
			calBottomInfoPos();
		}
		
		private function createTF():TextField
		{
			var tf:TextField = new TextField();
			tf.defaultTextFormat = SystemManager.Instance.txtFormatMgr.defaultTextFormat;
			tf.mouseWheelEnabled = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			return tf;
		}
		
		private function calBottomInfoPos():void
		{
			_bottomInfo.x = SystemManager.Instance.uiMgr.viewPort.gameX + (SystemManager.Instance.uiMgr.viewPort.vpWidth - _bottomInfo.textWidth) / 2;
			_bottomInfo.y = SystemManager.Instance.uiMgr.viewPort.vpHeight + SystemManager.Instance.uiMgr.viewPort.gameY;
			
			if (_yourID)
			{
				_yourID.x = SystemManager.Instance.uiMgr.viewPort.gameX + (SystemManager.Instance.uiMgr.viewPort.vpWidth - _yourID.textWidth) / 2;
				_yourID.y = SystemManager.Instance.uiMgr.viewPort.vpHeight + SystemManager.Instance.uiMgr.viewPort.gameY + _bottomInfo.textHeight;
			}
		}
		
		private function onTextLinkClick(event:TextEvent):void
		{
			var toURL:String = "";
			
			switch (event.text)
			{
				case "qqService":
					toURL = Lang.l.qqService;
					break;
				case "bbsURL":
					toURL = Lang.l.bbsURL;
					break;
			}
			
			if (toURL != "")
				WebUtils.Open(toURL);		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 在主swf创建后首先调用该方法，保证在SystemManager实例化之前Config已经被初始化
		 * @param	parameters
		 */
		public function setParams(parameters:Object):void
		{
			Config.APPDOMAIN = ApplicationDomain.currentDomain;
			Config.CDN = parameters["cdn"];
			Config.VERSION = parameters["ver"];
			Config.PLATFORM_ID = parameters["platform_id"];
			Config.SERVER_ID = parameters["server_id"];
			Config.HOST_IP = parameters["hostip"];
			Config.USER_TYPE = parameters.hasOwnProperty("usertype") ? int(parameters["usertype"]) : 0;
			_openID = parameters["openid"];
			Config.PLATFORM_UID = parameters["userid"];
		}
		
		/**
		 * 设置游戏内用到的语言包
		 */
		public function set lang(value:XML):void
		{
			Lang.l = value;
			Lang.init();
		}
		
		/**
		 * 设置游戏内用到的错误提示 
		 * @param value
		 * 
		 */		
		public function set error(value:XML):void
		{
			Lang.err = value;
		}
		
		
		/**
		 * 游戏内通信等的设置文件
		 */
		public function set setting(value:XML):void
		{
			Config.SETTING = value;
		}
		
		/**
		 * 资源版本配置文件 
		 * @param value
		 * 
		 */		
		public function set resVersion(value:String):void
		{
			VersionController.init(value);
		}
		
		/**
		 * 数据文件，解压缩后的语言包、错误提示文件、配置文件、资源版本信息文件 
		 * @param value
		 * 
		 */		
		public function set data(value:Object):void
		{
			Lang.l = XML(value["Chinese.xml"]);
			Lang.init();
			
			Lang.err = XML(value["Error.xml"]);
			
			Config.SETTING = XML(value["Config.xml"]);
			
			VersionController.init(value["version.txt"]);
		}
	}
}