package easygame.framework.loader
{
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 4:19:36 PM
	 * description 串行加载器管理器
	 **/
	public class QueenLoaderManager extends LoaderManagerBase 
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _urlChecker:String = "";
		private var _loadingList:Vector.<ILoadContent>;
		private var _completeCallBackDic:Dictionary;
		private var _startLoading:Boolean;
		private var _duplicateResCallBackList:Vector.<Function>;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 构造方法
		 * 一次加载对应多个完成回调函数的加载管理器。用于游戏内无需全屏遮罩的资源加载。如打开界面、加载物品等
		 * @param	appDomain
		 * @param	cdn
		 */
		public function QueenLoaderManager(appDomain:ApplicationDomain, cdn:String) 
		{
			super(appDomain, cdn);
			
			_loadingList = new <ILoadContent>[];
			_duplicateResCallBackList = new <Function>[];
			_completeCallBackDic = new Dictionary();
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		
		override public function addLoadContent(loadContent:ILoadContent):ILoaderManager
		{
			checkLoadInfo(loadContent);
			
			return this;
		}
		
		/**
		 * 开始加载  （并行加载器会忽略传入的<code>completeHandler</code>方法）
		 * @param behaviour
		 * @param completeHandler -- 无效参数
		 * 
		 */		
		override public function startLoad(behaviour:int=1, completeHandler:Function=null):void
		{
			_behaviour = behaviour;
			var showBar:Boolean = _behaviour != LoadBehaviour.NO_LOADING_INFO;
			
			if (showBar)
			{
				showLoadBar();
				
				if (_assetsLaoder.progressHandler == null)
					_assetsLaoder.progressHandler = _progressHandler;
			}
			else
			{
				_assetsLaoder.progressHandler = null;
			}
			
			_total = _loadingList.length;
			
			if (!_startLoading)
			{
				_startLoading = true;
				loadNext();
			}
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		override protected function loadNext():void
		{
			if (_loadingList.length > 0)
			{
				_loadContent = _loadingList.shift();
				_loadingInfoHandler(_loadingTipTxt + _loadContent.loadingInfo);
				_assetsLaoder.resInitHandlerList = _completeCallBackDic[_loadContent.assetsURL];
				
				delete _completeCallBackDic[_loadContent.assetsURL];
				
				_assetsLaoder.loaderType = _loadContent.resType;
				_assetsLaoder.initLoader(_loadContent.resType == LoaderType.IMAGE, _loadContent.resType == LoaderType.SWF ? _appDomain : null);
				_assetsLaoder.load(_loadContent.assetsURL);
			}
			else
			{
				loadComplete();
				
				while (_duplicateResCallBackList.length > 0)
				{
					_duplicateResCallBackList.shift()();
				}
			}
		}
		
		override protected function reset():void
		{
			_startLoading = false;
			_urlChecker = "";
			super.reset();
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 检查新的加载对象是否已经存在于加在列表中
		 * @param	loadContent
		 */
		private function checkLoadInfo(loadContent:ILoadContent):void
		{
			// 新的加载地址
			if (_urlChecker.indexOf(loadContent.assetsURL) == -1)
			{
				_urlChecker += loadContent.assetsURL + "|";
				_loadingList[_loadingList.length] = loadContent;
				_completeCallBackDic[loadContent.assetsURL] = [loadContent.completeHandler];
			}
			else //已经存在的加载地址
			{
				_duplicateResCallBackList[_duplicateResCallBackList.length] = loadContent.completeHandler;
			}
		}
	}
}