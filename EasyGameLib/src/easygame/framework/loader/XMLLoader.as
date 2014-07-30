package easygame.framework.loader
{
	import flash.events.Event;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 4:07:07 PM
	 * description 文本加载器
	 **/
	public class XMLLoader extends URLLoaderBase
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _progressHandler:Function;
		private var _completeCallBack:Function;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function XMLLoader(completeCallBack:Function=null, 
								  progressHandler:Function=null)
		{
			super();
			
			this.progressHandler = progressHandler;
			_completeCallBack = completeCallBack;
		}
		
		/*=======================================================================*/
		/* EVNET HANDLER                                                         */
		/*=======================================================================*/
		override protected function onComplete(e:Event):void
		{
			super.onComplete(e);
			
			_progressHandler = null;
			_completeCallBack.call(null, getContent());
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		
		public function set completeCallBack(value:Function):void
		{
			_completeCallBack = value;
		}
	}
}