package com.company.projectname.game.ui.window
{
	import easygame.framework.display.IWindow;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 9:43:41 AM
	 * description 窗体管理器基类，继承WinCoverManager，提供模式窗体的管理
	 **/
	public class WindowManager extends WinCoverManager
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		/**
		 * 窗体对象 
		 */		
		protected var _window:IWindow = null;
		protected var _windowClass:Class;
		protected var _shown:Boolean;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function WindowManager(winClz:Class)
		{
			super();
			
			_windowClass = winClz;
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 刷新窗体内的数据 
		 * @param v
		 */		
		public function refresh(v:*=null):void 
		{
			if (_active)
				_window.refresh(v);
		}
		
		/**
		 * 显示窗体 
		 * 
		 */		
		public function showWindow():void
		{
			_window.visible = true;
			_window.alpha = 1;
			
			this.onWindowCreated();
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		/**
		 * 创建一个窗体对象 
		 * @param windowClass
		 * @param wx
		 * @param wy
		 * @param contentData
		 * 
		 */		
		protected function create(windowClass:Class, 
								  wx:int=-1,
								  wy:int=-1,
								  contentData:Object=null):void
		{
			_window = new windowClass(contentData) as IWindow;
			if (wx != -1) DisplayObject(_window).x = wx;
			if (wy != -1) DisplayObject(_window).y = wy;
			_window.winEvtBuziHandler= winBuziEvtHandler;
			_window.winCreated = onWindowCreated;
			_window.winClosing = onClose;
			_window.winClosed = onClosed;
			_window.viewPort = _uiMgr.viewPort;
		}
		
		protected function winBuziEvtHandler(evtType:String, data:*=null):void
		{
			
		}
		
		/**
		 * 在窗体创建前触发该方法 
		 * 
		 */		
		protected function beforeWindowCreated():void
		{
			
		}
		
		/**
		 * 窗体创建后调用该方法
		 */
		protected function onWindowCreated():void
		{
			_shown = true;
		}
		/**
		 *窗体关闭时调用该方法
		 */
		protected function onClose():void
		{
			_window.close(true);
			
			_active = false;
			_shown = false;
		}
		/**
		 * 窗体关闭后调用该方法
		 */
		protected function onClosed():void
		{
			
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 获取窗体对象是否已经创建的标识 
		 * @return 
		 * 
		 */		
		public function get created():Boolean
		{
			return _window != null;
		}
		
		public function get window():IWindow
		{
			return _window;
		}
		
		public function get disObjWindow():DisplayObject
		{
			return DisplayObject(_window);
		}
		/**
		 * 窗体是否处于打开状态 
		 * @return 
		 * 
		 */		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function set active(value:Boolean):void 
		{
			_active = value;
		}
		
		/**
		 * 屏幕实际可视区域的宽
		 */
		public function get viewPortW():Number
		{
			return _uiMgr.viewPort.vpWidth;
		}
		
		/**
		 * 屏幕实际可视区域的高
		 */
		public function get viewPortH():Number
		{
			return _uiMgr.viewPort.vpHeight;
		}

		/**
		 * 标识窗体是否已经显示出来 
		 */
		public function get shown():Boolean
		{
			return _shown;
		}
		
		/**
		 *  获取窗体的皮肤对象
		 * @return 
		 * 
		 */		
		public function get winSkin():DisplayObjectContainer
		{
			return created ? _window.skin : null;
		}
	}
}