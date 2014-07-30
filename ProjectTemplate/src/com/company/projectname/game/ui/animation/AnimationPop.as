package com.company.projectname.game.ui.animation
{
	import com.company.projectname.ResourceLocater;
	import com.company.projectname.SystemManager;
	import easygame.framework.cache.res.ResCacheManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Mar 21, 2014 6:23:00 PM
	 * description: 	
	 **/
	public class AnimationPop extends Sprite implements IAnimationPop
	{
		private const ANIMATION_CLASS_PATH:String = "com.company.projectname.game.ui.animation.";
		
		protected var _animationType:int
		protected var _animation:MovieClip;
		protected var _animationClassName:String;
		protected var _animationResURL:String;
		protected var _animationData:Object;
		protected var _playing:Boolean;
		protected var _endCallBack:Function;
		
		public function AnimationPop()
		{
			super();
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			//createAnimations();
		}
		
		// public ////
		public function play(data:Object=null):void
		{			
			if (!_animation)
			{
				_animationData = data;
				
				createAnimations();
			}
			else
			{
				doPlay(data);
			}
		}
		
		// event handler ////
		private function checkToRemove(event:Event):void
		{
			if (_animation.currentFrame == _animation.totalFrames)
			{
				_animation.removeEventListener(Event.ENTER_FRAME, checkToRemove);
				_playing = false;
				clearUpAni(_animation);
				
				if (_endCallBack != null)
				{
					_endCallBack.call(null, this);
				}
			}
		}
		
		// protected ////
		/**
		 * 子类需要给<code>_animationClassName</code>赋值先
		 * 
		 */		
		protected function createAnimations():void
		{
			if (SystemManager.Instance.resCacheMgr.hasClassInCurrentDomain(ANIMATION_CLASS_PATH + _animationClassName))
			{
				initAnimation();
			}
			else
			{
				SystemManager.Instance.loaderMgr.queenLoaderMgr.addLoadContent({
					type: ResCacheManager.SWF,
					url: ResourceLocater.ANIMATION_RES_ROOT + _animationResURL
				}, initAnimation).startLoad(2);
			}
		}
		
		protected function initAnimation():void
		{
			// 升级动画
			_animation = new (SystemManager.Instance.resCacheMgr.getResourceFromMV(ANIMATION_CLASS_PATH + _animationClassName))();
			clearUpAni(_animation);
			addChild(_animation);
			
			doPlay(_animationData);
		}
		
		protected function clearUpAni(mv:MovieClip):void
		{
			mv.mouseChildren = false;
			mv.mouseEnabled = false;
			mv.gotoAndStop(1);
		}
		
		// private ////
		private function doPlay(data:Object=null):void
		{
			if (!_playing)
			{
				_playing = true;
				_animation.addEventListener(Event.ENTER_FRAME, checkToRemove);
				
				if (data)
				{
					if (_animationType == AnimationType.LVL_UP)
						showNum(data["lvl"]);
					if (_animationType == AnimationType.RANK_UP)
						showNum(data["rank"]);
				}
				
				_animation.gotoAndPlay(1);
			}
		}
		
		private function showNum(lvl:String):void
		{
			_animation.mvNum2.visible = lvl.length > 1;
			_animation.mvNum3.visible = lvl.length > 2;
			
			_animation.mvNum1.gotoAndStop(int(lvl.charAt(0)));
			if (_animation.mvNum2.visible)
				_animation.mvNum2.gotoAndStop(getGotoFrame(int(lvl.charAt(1))));
			if (_animation.mvNum3.visible)
				_animation.mvNum3.gotoAndStop(getGotoFrame(int(lvl.charAt(2))));
			
			_animation.mvJI.x = calJiXPos(lvl);
		}
		
		private function getGotoFrame(num:int):int
		{
			return num == 0 ? 10 : num;
		}
		
		private function calJiXPos(lvl:String):int
		{
			switch (lvl.length)
			{
				case 1:
					return _animation.mvNum1.x + _animation.mvNum1.width + 2; 
				case 2:
					return _animation.mvNum2.x + _animation.mvNum2.width + 2;
				case 3:
					return _animation.mvNum3.x + _animation.mvNum3.width + 2;
				default:
					return _animation.mvJI.x;
			}
		}
		
		// getter && setter ////

		public function set endCallBack(value:Function):void
		{
			_endCallBack = value;
		}
		
		public function get playing():Boolean
		{
			return _playing;
		}
	}
}