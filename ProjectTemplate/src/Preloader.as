package 
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 3:40:32 PM
	 * description 游戏预加载器
	 **/
	[SWF(backgroundColor="#1e3e63")]
	public class Preloader extends MovieClip
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _mainSwfInfo:TextField;
		private var _loader:Loader;
		private var _urlRequest:URLRequest;
		private var _cdn:String;
		private var _loaderUI:MovieClip;
		private var _resLoader:ResLoader;
		private var _maxBarLen:int = 700;
		private var _url:String = "assets/swf/preloader/preLoaderUI.swf";
		private var _isMainLoaded:Boolean;
		private var _isLoaderUILoaded:Boolean;
		private var _startTime:int;
		private var _totalBytesLoaded:Number = 0;
		private var _isOnline:Boolean;
		private var _version:String;
		// 这里不能明确指定类型，否则会将OGZQ2引用的所有资源全部载入第一帧，从而导致两帧加载法失败
		private var game:*; 
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function Preloader()
		{
			stop();
			Security.allowDomain("*");// 
			
			_cdn = loaderInfo.parameters["cdn"];
			_isOnline = loaderInfo.parameters["online"] == 1;
			_version = loaderInfo.parameters["ver"];
			
			_startTime = getTimer();
			
			// 设置stage的默认属性
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onResize);
			
			// 在logo加载前用于显示进度的简单文本框
			_mainSwfInfo = new TextField();
			_mainSwfInfo.textColor = 0xFFFFFF;
			_mainSwfInfo.autoSize = TextFieldAutoSize.LEFT;
			_mainSwfInfo.text = "正在加载主程序：0%";
			addChild(_mainSwfInfo);
			
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, mainGameProgress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			loaderInfo.addEventListener(Event.COMPLETE, mainGameCompleteHandler);
			
			// TODO show loader
			createLogoLoader();
			
			onResize();
		}
		
		/*=======================================================================*/
		/* EVNET HANDLER                                                         */
		/*=======================================================================*/
		private function mainGameCompleteHandler(e:Event=null):void
		{
			if (_isMainLoaded)
				return;
			
			_isMainLoaded = true;
			
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, mainGameProgress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			loaderInfo.removeEventListener(Event.COMPLETE, mainGameCompleteHandler);
			
			nextFrame();
			
			// 主程序加载完毕时，
			// 如果预加载界面ok，
			// 则开始加载游戏所需资源
			if (_isLoaderUILoaded)
			{
				loadResource();
			}
		}
		
		/**
		 * prelaoder加载完毕，创建UI界面
		 * @param	e
		 */
		private function onLogoComplete(e:Event):void 
		{
			// 创建loading界面
			_loaderUI = new (_loader.contentLoaderInfo.applicationDomain.getDefinition("LoadingBar"))();
			//			_loaderUI = MovieClip(_loader.content);
			addChild(_loaderUI);
			
			// 移除简单加载信息
			removeChild(_mainSwfInfo);
			_mainSwfInfo = null;
			
			// 设置刷新按钮
			initRefreshPageTxf();
			
			_isLoaderUILoaded = true;
			
			onResize();
			
			// 清理loader
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLogoComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// 当预加载界面加载完毕时，
			// 如果主程序已经加载完毕，
			// 则开始加载游戏所需资源
			if (_isMainLoaded)
			{
				loadResource();
			}
		}
		
		/**
		 * 主程序加载时出现IO错误
		 * @param	e
		 */
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		/**
		 * 主程序的加载进度
		 * @param	e
		 */
		private function mainGameProgress(e:ProgressEvent):void 
		{
			updateProgressBar(e.bytesLoaded, e.bytesTotal);
		}
		
		/**
		 * 每帧都检测是否主程序加载完毕
		 * @param	e
		 */
		private function checkFrame(e:Event):void 
		{			
			if (loaderInfo.bytesLoaded == loaderInfo.bytesTotal)
				mainGameCompleteHandler();
		}
		
		/**
		 * stag的resize事件
		 * @param	e
		 */
		private function onResize(e:Event=null):void
		{
			if (_isLoaderUILoaded)
			{
				_loaderUI.x = (stage.stageWidth - _loaderUI.width) * .5;
				_loaderUI.y = (stage.stageHeight - _loaderUI.height) * .5;
			}
			else
			{
				if (_mainSwfInfo)
				{
					_mainSwfInfo.x = (stage.stageWidth - _mainSwfInfo.textWidth) * .5;
					_mainSwfInfo.y = (stage.stageHeight - _mainSwfInfo.textHeight) * .5;
				}
			}
		}
		/**
		 * 刷新页面
		 * @param	e
		 */
		private function refreshBrowser(e:MouseEvent):void
		{
			ExternalInterface.call("location.reload");
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 加载预加载界面
		 */
		private function createLogoLoader():void 
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLogoComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			_urlRequest = new URLRequest();
			
			_urlRequest.url = _cdn + _url;
			
			_loader.load(_urlRequest);
		}
		
		/**
		 * 设置预加载界面上的刷新文本
		 */
		private function initRefreshPageTxf():void
		{
			_loaderUI.refreshLink.mouseWheelEnabled = false;
			_loaderUI.refreshLink.htmlText = "<a href='event:#'>若加载不成功，请点此刷新</a>";
			_loaderUI.refreshLink.addEventListener(MouseEvent.MOUSE_UP, refreshBrowser);
		}
		/**
		 * 加载各种所需的资源
		 */
		private function loadResource():void
		{
			// 开始加载配置文件、语言包、UI资源
			_resLoader = new ResLoader(_isOnline, _version);
			_resLoader.cdn = _cdn;
			_resLoader.loader = _loader;
			_resLoader.urlRequest = _urlRequest;
			_resLoader.startLoadRes(updateProgressBar, updateLoadingInfo, startup);
		}
		
		/**
		 * 更新loading界面的文字信息
		 * @param	info
		 */
		private function updateLoadingInfo(info:String):void
		{
			if (_isLoaderUILoaded) {
				_loaderUI.txtInfo.text = info;
				//				_loaderUI.txfErrorInfo.text = info;
			}
		}
		
		/**
		 * 更新loading界面的百分比进度
		 * @param	current
		 * @param	total
		 */
		private function updateProgressBar(current:Number, total:Number):void
		{
			_totalBytesLoaded += current;
			
			if (_isLoaderUILoaded)
			{
				if (current < 0) current = 0;
				if (total <= 0) total = 1;
				if (current > total) current = total;
				_loaderUI.bar.barBody.width = current / total * _maxBarLen;
				_loaderUI.bar.barRight.x = _loaderUI.bar.barBody.x + _loaderUI.bar.barBody.width;
				_loaderUI.bar.txtProgressInfo.text = int(current / total * 100) + "%";
				_loaderUI.txtLoadingSpeed.text = Number((_totalBytesLoaded / (getTimer() - _startTime)) / 1024).toFixed(2) + "/kbs";
			}
			else
			{
				if (_mainSwfInfo)
				{
					_mainSwfInfo.text = "正在加载主程序：" + int(current / total * 100) + "%";
				}
			}
		}
		
		/**
		 * 创建主程序，进入游戏
		 */
		private function startup():void 
		{
			updateLoadingInfo("创建游戏中...");
			
			var mainClass:Class = getDefinitionByName("ProjectTemplate") as Class;
			game = new mainClass();
			// 先初始化setting，因为setParams中需要使用配置数据
			if (_isOnline)
			{
				game.data = _resLoader.data;
			}
			else
			{
				game.setting = _resLoader.config;
				game.lang = _resLoader.language;
				game.error = _resLoader.error;
				game.resVersion = _resLoader.resVersion;
			}
			game.setParams(loaderInfo.parameters);
			game.init(this.stage);
			
			// 连接游戏服务器
			updateLoadingInfo("正在连接服务器，请耐心等待...");
			game.connectToServer(showGame, updateLoadingInfo);
		}
		
		/**
		 * 服务器连接成功并取回数据
		 * @param	o
		 */
		private function showGame(o:String):void
		{
			stage.removeEventListener(Event.RESIZE, onResize);
			
			game.startGame(o);
			
			stage.addChild(game);
			
			clearGameLoader();
			
			
		}
		
		/**
		 * 清除预加载器
		 */
		private function clearGameLoader():void
		{
			_resLoader.dispose();
			_resLoader = null;
			
			_loaderUI.refreshLink.removeEventListener(MouseEvent.MOUSE_UP, refreshBrowser);
			_loaderUI.stop();
			this.removeChild(_loaderUI);
			_loaderUI = null;
			
			if (parent)
				parent.removeChild(this);
		}
	}
}