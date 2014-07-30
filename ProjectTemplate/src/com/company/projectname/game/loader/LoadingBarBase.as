package com.company.projectname.game.loader
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.ProgressEvent;
	
	import easygame.framework.display.GameDisplayObject;
	
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 2:04:20 PM
	 * description 带皮肤的加载条基类
	 **/
	public class LoadingBarBase extends GameDisplayObject implements ILoadingBar
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		protected var _loadingBar:MovieClip;
		protected var _barWidth:int = 219;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 根据指定的资源类名称创建加载器 
		 * @param clz
		 * @param barWidth
		 * 
		 */		
		public function LoadingBarBase(clz:Class, barWidth:int)
		{
			super();
			
			_barWidth = barWidth;
			
			createLoadingBar(clz);
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		/**
		 * 子类重写该方法，创建具体的显示组件
		 */
		protected function createLoadingBar(clz:Class):void 
		{
			_loadingBar = new clz();
			_loadingBar.mvAnimation.gotoAndStop(1);
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		
		public function prepareLoadingAnimation():void 
		{
			if (_loadingBar)
				_loadingBar.mvAnimation.gotoAndPlay(1);
		}
		
		public function progressByManual(value:Number, total:Number):void 
		{
			if (!_loadingBar.loadingContent.visible) _loadingBar.loadingContent.visible = true;
			_loadingBar.loadingContent.insideLoadingProgress.text = int(value * 100 / total) + "%";
			_loadingBar.loadingContent.bar.width = value / total * _barWidth;
			if (_loadingBar.loadingContent.bar.width > _barWidth)
				_loadingBar.loadingContent.bar.width = _barWidth;
		}
		
		public function progressHandler(source:ProgressEvent):void 
		{
			progressByManual(source.bytesLoaded, source.bytesTotal);
		}
		
		public function loadingInfo(info:String):void 
		{
			_loadingBar.loadingContent.insideLoadingInfo.text = info;
		}
		
		public function onResize(nW:int, nH:int):void 
		{
			
		}
		
		public function finishLoading(callBack:Function = null):void 
		{
			TweenMax.to(this, 1, {
				autoAlpha: 0,
				onComplete: callBack
			} );
		}
		
		override public function reset():void 
		{
			_loadingBar.mvAnimation.gotoAndStop(1);
			_loadingBar.loadingContent.visible = false;
			_loadingBar.loadingContent.insideLoadingProgress.text = "";
			_loadingBar.loadingContent.insideLoadingInfo.text = "";
			_loadingBar.loadingContent.bar.width = 1;
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		public function get isPopped():Boolean
		{
			return this.parent != null;
		}
		
		override public function get displayContent():DisplayObjectContainer
		{
			return _loadingBar;
		}
	}
}