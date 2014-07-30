package com.company.projectname.game.ui.window
{
	import com.greensock.TweenMax;
	import com.company.projectname.Config;
	import easygame.framework.display.IWindowManager;
	import com.company.projectname.game.lang.Lang;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 10:37:07 AM
	 * description 游戏内窗体管理器基类，负责窗体的打开、关闭、刷新数据级窗体与窗体间、窗体与服务器的交互管理
	 **/
	public class GameWindowManager extends WindowManager implements IWindowManager
	{
		protected var _lang:XML;
		/**
		 * 是否在响应浏览器窗体的OnResize事件时，使用缓动来重定位，默认false 
		 */		
		protected var _tweenOnResize:Boolean;
		private var _winBgColor:uint = 0x000000;
		private var _needChangeBgColor:Boolean;
		private var _g:Graphics;
		
		/**
		 * 是否在界面打开期间弹出了球员
		 */		
		public var isScoutOver:Boolean;
		
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		/**
		 * 遮罩是否和窗体同时显示--true同时显示|false先遮罩，后窗体
		 */
		protected var _showCoverWithWin:Boolean;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 *  
		 * @param winClz 要创建的窗体类
		 * 
		 */		
		public function GameWindowManager(winClz:Class)
		{
			super(winClz);
			
			_coverAlpha = .6;
			
			_showCoverWithWin = true;
			
			_lang = Lang.l;
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 打开窗体 
		 * @param o
		 * @param parent
		 * @param modal
		 * @param x
		 * @param y
		 * 
		 */		
		public function open(o:Object=null, 
							 parent:DisplayObjectContainer=null, 
							 modal:Boolean=false, 
							 x:int=-1, 
							 y:int=-1):void
		{
			beforeWindowCreated();
			
			if (created) {
				rePopup(o, x, y, modal);
			} else {
				popUpWindow(o, _windowClass, parent, modal, x, y);
			}
		}
		
		/**
		 * 可视区域大小改变时，随之改变窗体的位置 
		 * @param x
		 * @param y
		 * 
		 */		
		override public function onResize(x:int=-1, y:int=-1):void
		{
			super.onResize(x, y);
			
			if (!created) return;
			
			if ( x == -1 && y == -1 )
			{
				center();
			}
			else
			{
				if (_tweenOnResize)
				{
					moveTo(_window, {
						x: x,
						y: y
					});
				}
				else
				{
					_window.x = x;
					_window.y = y;
				}
				
			}
		}
		
		/**
		 * 是否屏蔽组件的事件响应 
		 * @param block
		 * 
		 */		
		public function blockEvt(block:Boolean):void
		{
			if (_window) _window.mouseChildren = !block;
		}
		
		/**
		 * 移动窗体到指定位置 
		 * @param tx
		 * @param ty
		 * 
		 */		
		public function moveWindow(tx:int=-1, ty:int=-1):void
		{
			var vars:Object = { };
			
			if (tx != -1) vars["x"] = tx;
			if (ty != -1) vars["y"] = ty;
			
			moveTo(_window, vars, .7);
		}
		
		/**
		 * 设置窗体处于所有窗体的最上层 
		 * 
		 */		
		public function bringToFront():void
		{
			if (created)
				_parent.setChildIndex(DisplayObject(window), _parent.numChildren - 1);
		}
		
		/**
		 * 检查是否有新手指引，子类具体实现 
		 * 
		 */		 
		public function checkRookie():void
		{
			
		}
		
		/**
		 * 显示新手箭头，需要子类自行实现
		 * 0-向下|1-向上|2-向左|3-向右
		 * @param direction
		 * @param subStep
		 */
		public function showRookieArrow(direction:int=0, subStep:int=1):void
		{
			
		}
		
		/**
		 * 移除新手指引箭头 
		 * 
		 */		
		public function removeRookieArrow():void
		{
			if (_userMgr.newBie)
			{
				_uiMgr.rookieMgr.removeRookie();
			}
		}
		
		/**
		 * 关闭窗体 
		 * 
		 */		
		public function close():void
		{
			if (active) 
			{
				onClose();
			}
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		override protected function beforeWindowCreated():void
		{
			if (_needChangeBgColor) drawBgColor(_winBgColor);
		}
		
		/**
		 * 开始关闭窗体，子类中重写该方法时，切记编写<code>super.onClose();</code>代码行，否则将无法关闭窗体 
		 * 
		 */		
		override protected function onClose():void
		{
			super.removeCover();
			
			super.onClose();
		}
		
		/**
		 * 关闭窗体时执行的方法 
		 * 
		 */		
		override protected function onClosed():void
		{
			super.onClosed();
			
			if (_needChangeBgColor) drawBgColor(Config.DEFAULT_GAME_BG_COLOR);
		}
		
		/**
		 * 绘制窗体背景色 
		 * @param bgColor
		 * 
		 */		
		protected function drawBgColor(bgColor:uint):void
		{
			_g.clear();
			
			_g.beginFill(bgColor);
			_g.drawRect(0, 0, _uiMgr.stage.stageWidth, _uiMgr.stage.stageHeight);
			_g.endFill();
		}
		
		/**
		 * 创建并弹出窗体对象 
		 * @param content
		 * @param clazz
		 * @param parent
		 * @param modal
		 * @param wx
		 * @param wy
		 * 
		 */		
		protected function popUpWindow(content:Object,
									   clazz:Class,
									   parent:DisplayObjectContainer = null,
									   modal:Boolean=false,
									   wx:int=-1, 
									   wy:int=-1):void
		{
			_parent = parent;
			if (!_parent)
				_parent = _uiMgr.WIN_PARENT;
			
			create(clazz, wx, wy, content);
			// 在皮肤加载后触发位置调整事件
			_window.skinCreated = onResize;
			
			rePopup(content, wx, wy, modal, true);
			
		}
		
		/**
		 * 重新打开关闭的窗体 
		 * @param content
		 * @param x
		 * @param y
		 * @param modal
		 * @param init
		 * 
		 */		
		protected function rePopup(content:Object=null, 
								   x:int=-1, 
								   y:int = -1,
								   modal:Boolean=false,
								   init:Boolean=false):void
		{
			if (modal)
			{
				if (_tweenCover)
				{
					setCover();
					_cover.alpha = 0;
					_cover.visible = false;
					_parent.addChild(_cover);
					TweenMax.killTweensOf(_cover);
					if (_showCoverWithWin)
					{
						TweenMax.to(_cover, .3, { autoAlpha: 1 } );
					}
					else
					{
						TweenMax.to(_cover, .3, {
							autoAlpha: 1,
							onComplete: addWindowContent,
							onCompleteParams: [content, x, y, init]
						} );
					}
				}
				else
				{
					_parent.addChild(cover);
				}
			}
			
			if (_showCoverWithWin)
				addWindowContent(content, x, y, init);
		}
		
		/**
		 * 将窗体加载到显示列表 
		 * @param content
		 * @param x
		 * @param y
		 * @param init
		 * 
		 */		
		protected function addWindowContent(content:Object=null, 
											x:int=-1, 
											y:int = -1,
											init:Boolean=false):void
		{
			_parent.addChild(disObjWindow);
			
			if (!init)
				window.reOpen(content);
			
			active = true;
			
			//onResize(x, y);
		}
		
		/**
		 * 设置窗体全屏居中 
		 * 
		 */		
		protected function center():void
		{
			if (_tweenOnResize)
			{
				moveTo(_window, {
					x: (viewPortW - _window.width) * .5,
					y: (viewPortH - _window.height) * .5
				});
			}
			else
			{
				_window.x = (viewPortW - _window.width) * .5;
				_window.y = (viewPortH - _window.height) * .5;
			}
			
		}
		
		/**
		 * 缓动到 
		 * @param target
		 * @param dest
		 * @param duration
		 * 
		 */		
		protected function moveTo(target:Object, dest:Object, duration:Number=.3):void
		{
			TweenMax.to(target, duration, dest);
		}
		
		// getter && setter ////
		public function get winWidth():int
		{
			return _window.width;
		}
		
		public function get winHeight():int
		{
			return _window.height;
		}
		
		public function get winX():int
		{
			return _window.x;
		}
		
		public function get winY():int
		{
			return _window.y;
		}

		/**
		 * 窗体打开时的背景色 
		 */
		public function set winBgColor(value:uint):void
		{
			_winBgColor = value;
			_needChangeBgColor = true;
			
			_g = _uiMgr.BG_COLOR_CONTAINER.graphics;
		}

	}
}