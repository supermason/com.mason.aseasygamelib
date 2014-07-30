package easygame.framework.animation
{
	import flash.utils.getTimer;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 3:04:15 PM
	 * description 动画启动器
	 **/
	public class AnimationStarter
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private const RUN_JUGGLER:String = "RUN_JUGGLER";
		private var _frameMgr:FrameManager;
		/**上一帧的播放时间*/
		private var _lastFrameTimestamp:int;
		private var _juggler:Juggler;
		private var _started:Boolean;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 只负责<code>Juggler</code>的启动与停止
		 * 置于往Juggler里放置和移除对象，都通过Juggler的方法进行
		 */
		public function AnimationStarter()
		{
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		/**
		 * 启动Juggler
		 */
		public function start():void
		{
			if (_started) return;
			_started = true;
			_lastFrameTimestamp = getTimer();
			_frameMgr.add(RUN_JUGGLER, nextFrame);
		}
		
		/**
		 * 停止Juggler
		 */
		public function stop():void
		{
			_frameMgr.remove(RUN_JUGGLER);
			_juggler.purge();
			
			_started = false;
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		private function nextFrame():void
		{
			var now:int = getTimer();
			var passedTime:int = now - _lastFrameTimestamp;
			_lastFrameTimestamp = now;
			
			_juggler.advanceTime(passedTime);
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		public function set frameMgr(value:FrameManager):void 
		{
			_frameMgr = value;
		}
		
		public function set juggler(value:Juggler):void 
		{
			_juggler = value;
		}
	}
}