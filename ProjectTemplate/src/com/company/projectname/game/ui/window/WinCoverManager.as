package com.company.projectname.game.ui.window
{
	import com.greensock.TweenMax;
	import easygame.framework.display.UICover;
	
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 6:16:53 PM
	 * description 模式窗体管理器基类
	 **/
	public class WinCoverManager extends WinManagerBase 
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		protected var _cover:UICover;
		/**
		 *  遮罩的默认alpha值 - .02
		 */
		protected var _coverAlpha:Number = .02;
		/**
		 * 遮罩默认的颜色 - 0x000000
		 */		
		protected var _coverColor:uint = 0x000000;
		/**
		 * 遮罩的出现与隐藏是否使用缓动效果 
		 */		
		protected var _tweenCover:Boolean;
		
		protected var _coverShown:Boolean;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 支持遮罩的窗体管理器
		 */
		public function WinCoverManager() 
		{
			super();
			
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                   */
		/*=======================================================================*/
		
		public function onResize(x:int=-1, y:int=-1):void
		{
			if (_coverShown) _cover.show(_uiMgr.stage, _coverAlpha, _coverColor);
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		protected function removeCover():void
		{
			if (_cover/* && _cover.parent*/)
			{
				if (_tweenCover)
				{
					TweenMax.killTweensOf(_cover);
					TweenMax.to(_cover, .1, {
						autoAlpha: 0,
						onComplete: $remove
					} );
				}
				else
				{
					$remove();
				}
			}
		}
		
		/**
		 * 每次获取遮罩时都会根据当前舞台的大小进行绘制 
		 * @param	endFill 是否调用<code>endFill()</code>方法，新手期模块，需要绘制镂空，所以不需要调用
		 */		
		protected function setCover(endFill:Boolean=true):void
		{
			if (!_cover)
				_cover = new UICover();
			
			_coverShown = true;
			
			// 每次调用show方法都会根据当前舞台的大小来绘制遮罩
			_cover.show(_uiMgr.stage, _coverAlpha, _coverColor, endFill);
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTION                                                      */
		/*=======================================================================*/
		private function $remove():void 
		{
			_coverShown = false;
			if (_cover.parent)
				_cover.parent.removeChild(_cover);
			_cover.remove();
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		protected function get cover():UICover
		{
			setCover();
			
			return _cover;
		}
		
	}

}