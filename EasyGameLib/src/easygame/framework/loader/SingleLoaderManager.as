package easygame.framework.loader
{
	import flash.system.ApplicationDomain;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 4:21:39 PM
	 * description 列队加载器管理器
	 **/
	public class SingleLoaderManager extends LoaderManagerBase 
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		/**资源加载对象列表*/
		private var _loadContentList:LoadContentList;
		/**加载完成时处理方法*/
		private var _completeHandler:Function;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 构造方法
		 * 一个加载列队对应一次回调函数的加载管理器。主要用于游戏内部需要全屏遮罩方式的加载情况。与LoadContentList配合使用
		 * @param	appDomain
		 * @param	cdn
		 */
		public function SingleLoaderManager(appDomain:ApplicationDomain, cdn:String) 
		{
			super(appDomain, cdn);
			
			_loadContentList = new LoadContentList();
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		override public function addLoadContent(loadContent:ILoadContent):ILoaderManager
		{
			if (_loadContentList.indexOf(loadContent) == -1)
				_loadContentList[_loadContentList.length] = loadContent;
			
			return this;
		}
		
		/**
		 * 开始加载
		 * <p> 如果<code>completeHandler</code>为null则会抛出错误 
		 * @param behaviour
		 * @param completeHandler
		 * 
		 */		
		override public function startLoad(behaviour:int=1, completeHandler:Function=null):void
		{
			if (completeHandler == null)
				throw new ArgumentError("argument [COMPLETEHANDLER] can not be null!");
			
			showLoadBar();
			_total = _loadContentList.length;
			_completeHandler = completeHandler;
			_behaviour = behaviour;
			loadNext();
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		/**
		 * 继续加载列队中的下一个资源，直至列队为空
		 */
		override protected function loadNext():void
		{
			if (_loadContentList.length > 0) 
			{
				_current++;
				
				if (_current > _total) // 如果超出最大加载数量，则默认加载结束
				{
					loadComplete();
					return;
				}
				
				_loadContent = _loadContentList.shift();
				_loadingInfoHandler(_loadingTipTxt + _loadContent.loadingInfo + "  [" + _current + "/" + _total + "]");
				_assetsLaoder.loaderType = _loadContent.resType;
				_assetsLaoder.initLoader(_loadContent.resType == LoaderType.IMAGE, _loadContent.resType == LoaderType.SWF ? _appDomain : null);
				_assetsLaoder.load(_loadContent.assetsURL);
			} 
			else 
			{
				loadComplete();
			}
		}
		
		override protected function loadComplete():void
		{
			super.loadComplete();
			
			if (_completeHandler != null)
			{
				_completeHandler.call();
				_completeHandler = null;
			}
		}
		
		override protected function reset():void
		{
			_loadContentList.clear();
			super.reset();
		}
	}
}