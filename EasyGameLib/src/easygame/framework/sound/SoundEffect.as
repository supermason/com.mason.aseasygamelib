package easygame.framework.sound
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 3:07:40 PM
	 * description 音效
	 **/
	public class SoundEffect 
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		public static const BUTTON:int = 0;
		public static const ACCEPT_TASK:int = 1;
		public static const COMPLISH_TASK:int = 2;
		public static const ALCHMEY_OK:int = 3;
		public static const ERROR:int = 4;
		public static const LVL_UP:int = 5;

		private static var _sounds:Object = {};
		
		private static function init():void{
			//_sounds[BUTTON] = {
			//url:ResourceLocator.MP3_RES_ROOT + "button.wav",
			//sound:null
			//};
			//
			//_sounds[ACCEPT_TASK] = {
			//url:ResourceLocator.MP3_RES_ROOT + "acceptTask.wav",
			//sound: null
			//};
			//_sounds[COMPLISH_TASK] = {
			//url:ResourceLocator.MP3_RES_ROOT + "complishTask.wav",
			//sound: null
			//};
			
			
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		public static function load():void{
			var _local1:String;
			var sound:Sound;
			var url:String;
			for (_local1 in _sounds) 
			{
				sound = new Sound();
				_sounds[_local1]["sound"] = sound;
				sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				sound.addEventListener(Event.COMPLETE, completeHandler);
				url = (/*SoundEffect.url + */_sounds[_local1]["url"]);
				sound.load(new URLRequest(url));
			};
		}
		
		public static function play(type:int):void
		{
			if (SoundManager.mute == 0)
			{
				return;
			}
			
			var sound:* = _sounds[type]["sound"];
			if (sound)
			{
				try {
					sound.play(0, 0, new SoundTransform((SoundManager.gameVolume * 0.01)));
				} catch(e:*) {
					trace(e.toString());
				};
			}
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		private static function ioErrorHandler(event:IOErrorEvent):void
		{
			removeListener((event.currentTarget as Sound));
		}
		
		private static function completeHandler(event:Event):void
		{
			removeListener((event.currentTarget as Sound));
		}
		
		private static function removeListener(sound:Sound):void
		{
			sound.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			sound.removeEventListener(Event.COMPLETE, completeHandler);
		}
		
		
		init();
	}
}