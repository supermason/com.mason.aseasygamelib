package easygame.framework.loader
{
	import flash.system.ApplicationDomain;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 4:23:09 PM
	 * description 统一管理串行加载器和并行加载器
	 **/
	public class GameLoaderManager 
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _singleLoaderMgr:ILoaderManager;
		private var _queenLoaderMgr:ILoaderManager;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 游戏内所有资源的加载管理器。提供单列对和并行列队两种加载方式。
		 */
		public function GameLoaderManager(appDomain:ApplicationDomain, cdn:String) 
		{
			_singleLoaderMgr = new SingleLoaderManager(appDomain, cdn);
			_queenLoaderMgr = new QueenLoaderManager(appDomain, cdn);
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 获取单列队加载管理器对象[负责全屏遮罩式加载]
		 */
		public function get singleLoaderMgr():ILoaderManager 
		{
			return _singleLoaderMgr;
		}
		/**
		 * 获取多列队加载管理器对象[负责窗体UI、物品等无需全屏遮罩式加载]
		 */
		public function get queenLoaderMgr():ILoaderManager 
		{
			return _queenLoaderMgr;
		}
		/**
		 * 游戏版本号，用于在加载时绕开浏览器缓存导致的不能自动获取最新资源的问题
		 */
		public function set version(value:String):void
		{
			_singleLoaderMgr.version = value;
			_queenLoaderMgr.version = value;
		}
		/**
		 * 默认加载提示信息
		 */
		public function set defaultLoadingTxt(value:String):void
		{
			_singleLoaderMgr.defaultLoadingTipTxt = value;
			_queenLoaderMgr.defaultLoadingTipTxt = value;
		}
		/**
		 * 这是加载器的缓存处理器
		 */
		public function set resCacheHandler(value:Function):void
		{
			_singleLoaderMgr.resCacheHandler = value;
			_queenLoaderMgr.resCacheHandler = value;
		}
	}
}