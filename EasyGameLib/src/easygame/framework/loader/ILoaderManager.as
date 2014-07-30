package easygame.framework.loader
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 4:00:00 PM
	 * description 
	 **/
	public interface ILoaderManager
	{
		/**
		 * 初始化加载器的各种处理函数
		 * @param	startHandler
		 * @param	progressHandler
		 * @param	progressByManualHandler
		 * @param	loadingInfoHandler
		 * @param	resetHandler
		 * @param	loadCompleteHandler
		 */
		function initLoaderHandlers(startHandler:Function,
									progressHandler:Function,
									progressByManualHandler:Function,
									loadingInfoHandler:Function,
									resetHandler:Function,
									loadCompleteHandler:Function):void;
		
		/**
		 * 外部调用，手动弹出loadBar界面
		 */
		function showLoadBar():void;
		
		/**
		 * 隐藏加载信息 
		 * 
		 */		
		function hideLoadingInfo():void;
		
		/**
		 * 手动设置当前的加载进度
		 * @param	current
		 * @param	total
		 * @param	description
		 */
		function manualSetProgress(current:int, total:int, description:String):void;
		
		/**
		 * 外部调用，手动隐藏loadBar界面
		 */
		function hideLoadBar():void;
		
		/**
		 * 添加一份加载信息
		 * @param assetsURL
		 * @param resType
		 * @param loadingInfo
		 * @param completeHandler
		 * @return 
		 * 
		 */		
		function addRawLoadContent(assetsURL:String="", resType:String="image", loadingInfo:String="", completeHandler:Function=null):ILoaderManager;
		
		/**
		 * 添加加载对象
		 * @param	loadContent: 加载信息对象
		 */
		function addLoadContent(loadContent:ILoadContent):ILoaderManager;
		
		/**
		 * 开始加载(默认显示加载进度提示)
		 * @param	behaviour: 1|2|3 - 详见LoadBehaviour常量类
		 * @param	completeHandler: 可选参数，加载结束时的回调方法
		 */
		function startLoad(behaviour:int=1, completeHandler:Function=null):void;
		
		/**
		 * 设置资源站路径 
		 * @param value
		 * 
		 */		
		function set cdn(value:String):void;
		
		/**
		 * 设置资源版本号 
		 * @param value
		 * 
		 */		
		function set version(value:String):void;
		
		/**
		 * 设置资源缓存处理方法 
		 * @param value
		 * 
		 */		
		function set resCacheHandler(value:Function):void;
		
		/**
		 * 设置 默认加载提示信息 
		 * @param value
		 * 
		 */		
		function set defaultLoadingTipTxt(value:String):void;
	}
}