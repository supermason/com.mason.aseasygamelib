package com.company.projectname.game.loader
{
	import easygame.framework.display.IPopUp;
	
	import flash.events.ProgressEvent;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 2:01:49 PM
	 * description 
	 **/
	public interface ILoadingBar extends IPopUp
	{
		/**
		 * 如果加载条中有动画需要播放，则在该方法内实现启动动画的机制 
		 * 
		 */		
		function prepareLoadingAnimation():void;
		/**
		 * 手动设置进度条进度 
		 * @param value
		 * @param total
		 * 
		 */		
		function progressByManual(value:Number, total:Number):void;
		/**
		 * progressEvent触发的进度条前行 
		 * @param source
		 * 
		 */		
		function progressHandler(source:ProgressEvent):void;
		/**
		 * 进度条上要显示的提示信息 
		 * @param info
		 * 
		 */		
		function loadingInfo(info:String):void;
		/**
		 * 窗体大小改变时的处理方法 
		 * @param nW
		 * @param nH
		 * 
		 */		
		function onResize(nW:int, nH:int):void;
		/**
		 * 加载结束时的回调方法 
		 * @param callBack
		 * 
		 */		
		function finishLoading(callBack:Function=null):void;
	}
}