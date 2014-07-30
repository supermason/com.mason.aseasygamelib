package easygame.framework.sound
{
	import flash.media.*;
	import flash.net.*;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 3:12:31 PM
	 * description 
	 **/
	public class SoundManager {
		
		private static var _mute:int = 1;
		private static var _bgVolume:int = 100;
		private static var _gameVolume:int = 100;
		private static var _soundList:Object = {};
		private static var _bgSound:soundObj = null;
		
		public static function set bgVolume(_arg1:int):void{
			_bgVolume = _arg1;
			upVolume();
		}
		public static function get bgVolume():int{
			return (_bgVolume);
		}
		public static function set gameVolume(_arg1:int):void{
			_gameVolume = _arg1;
		}
		public static function get gameVolume():int{
			return (_gameVolume);
		}
		public static function set mute(_arg1:int):void{
			_mute = _arg1;
			upVolume();
		}
		public static function get mute():int{
			return (_mute);
		}
		private static function upVolume():void{
			var _local1:int = (_bgVolume * _mute);
			if (_bgSound != null){
				_bgSound.updateSoundTransform(_local1);
			};
		}
		public static function playBgSound(_arg1:String):void{
			if(_mute == 0) return;
			var _local2:soundObj;
			if (_arg1 == ""){
				stopBgSound();
				return;
			};
			var _local3:int = (_bgVolume * _mute);
			if (_soundList[_arg1] != null){
				_local2 = _soundList[_arg1];
				_local2.updateSoundTransform(_local3);
			} else {
				_local2 = new soundObj();
				_soundList[_arg1] = _local2;
				_local2.PlayerUrl(_arg1, _local3);
			};
			if (((!((_bgSound == null))) && (!((_bgSound == _local2))))){
				_bgSound.stopSound();
			};
			_bgSound = _local2;
		}
		public static function stopBgSound():void{
			if (_bgSound != null){
				_bgSound.stopSound();
			};
			_bgSound = null;
		}
		public static function playGameSound(_arg1:*):SoundChannel{
			var _local2:Number = (_gameVolume * _mute);
			if (_local2 < 5){
				return (null);
			};
			var _local3:Sound = (_arg1 as Sound);
			if ((_arg1 is String)){
				_local3 = new Sound(new URLRequest(_arg1));
			} else {
				if ((_arg1 is Class)){
					_local3 = new (_arg1)();
				};
			};
			if (_local3 == null){
				return (null);
			};
			return (_local3.play(0, 1, soundObj.getSTF(_local2)));
		}
		
	}
}

import flash.events.*;
import flash.utils.*;
import flash.media.*;
import flash.net.*;

class soundObj extends Sound {
	
	private static var timer:Timer;
	private static var STFlist:Array = [];
	
	private var state:String = "stop";
	private var soundchannel:SoundChannel = null;
	private var soundurl:String = "";
	private var stf:int = 0;
	private var value:Number = 0;
	private var soundTime:int = 0;
	private var isWar:Boolean = false;
	private var isError:Boolean = false;
	
	public function soundObj(){
	}
	public static function getSTF(_arg1:int):SoundTransform{
		return (((STFlist[_arg1]) || ((STFlist[_arg1] = new SoundTransform((_arg1 * 0.01))))));
	}
	
	public function PlayerUrl(_arg1:String, _arg2:int):void{
		if (timer == null){
			timer = new Timer(100);
			timer.start();
		};
		this.isWar = !((_arg1.indexOf("War.mp3") == -1));
		this.soundurl = _arg1;
		this.stf = _arg2;
		this.load(new URLRequest(_arg1));
		this.addEventListener(Event.COMPLETE, this.completeFun);
		this.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
		this.state = "play";
	}
	public function stopSound():void{
		this.state = "stop";
		if (this.soundchannel != null){
			this.soundTime = this.soundchannel.position;
			this.value = (this.stf - (this.stf % 5));
			this.soundchannel.soundTransform = getSTF(this.value);
			timer.addEventListener(TimerEvent.TIMER, this.soundOut);
		};
	}
	public function updateSoundTransform(_arg1:int):void{
		this.stf = _arg1;
		if (this.soundchannel == null){
			return;
		};
		if (this.state == "play"){
			if (this.isError == true){
				return;
			};
			this.value = (_arg1 - (_arg1 % 5));
			this.soundchannel.soundTransform = getSTF(this.value);
		} else {
			this.state = "play";
			if (this.isError == true){
				return;
			};
			this.value = 0;
			if (this.soundchannel != null){
				this.soundchannel.stop();
			};
			this.soundchannel = play((this.isWar) ? 0 : this.soundTime, 1, getSTF(this.value));
			if (this.soundchannel == null){
				return;
			};
			this.soundchannel.addEventListener(Event.SOUND_COMPLETE, this.playSoundComplete);
			timer.addEventListener(TimerEvent.TIMER, this.soundIn);
		};
	}
	private function ioErrorHandler(_arg1:Event):void{
		this.isError = true;
	}
	private function completeFun(_arg1:Event):void{
		if (this.state == "play"){
			this.value = 0;
			this.soundchannel = play(0, 1, getSTF(this.value));
			if (this.soundchannel == null){
				return;
			};
			this.soundchannel.addEventListener(Event.SOUND_COMPLETE, this.playSoundComplete);
			timer.addEventListener(TimerEvent.TIMER, this.soundIn);
		};
	}
	private function playSoundComplete(_arg1:Event):void{
		var _local2:SoundChannel = (_arg1.currentTarget as SoundChannel);
		_local2.removeEventListener(Event.SOUND_COMPLETE, this.playSoundComplete);
		if ((((_local2 == this.soundchannel)) && ((this.state == "play")))){
			this.soundchannel = play(50, 1, getSTF(this.value));
			if (this.soundchannel == null){
				return;
			};
			this.soundchannel.addEventListener(Event.SOUND_COMPLETE, this.playSoundComplete);
		};
	}
	private function soundIn(_arg1:Event):void{
		if ((((this.state == "play")) && ((this.value < this.stf)))){
			this.value = (this.value + 5);
			this.soundchannel.soundTransform = getSTF(this.value);
			return;
		};
		timer.removeEventListener(TimerEvent.TIMER, this.soundIn);
	}
	private function soundOut(_arg1:Event):void{
		if ((((this.state == "stop")) && ((this.value > 0)))){
			this.value = (this.value - 10);
			this.soundchannel.soundTransform = getSTF(this.value);
			if (this.value <= 0){
				this.soundchannel.stop();
			};
			return;
		};
		timer.removeEventListener(TimerEvent.TIMER, this.soundOut);
	}
	
}