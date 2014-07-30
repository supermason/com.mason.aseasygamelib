package com.company.projectname.game.ui.component
{
	import com.company.projectname.SystemManager;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 20, 2013 10:52:45 AM
	 * description: 文本列表渲染器的基类，提供一个皮肤，实现鼠标悬停等的不同状态切换 
	 **/
	public class SelectionRenderBase extends DataRenderBase
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		protected const NORMAL_STATE:String = "normal";
		protected const HOVER_STATE:String = "hover";
		
		protected var _skinClzName:String;
		/**皮肤对象*/
		protected var _skin:DisplayObject;
		/**是否使用默认皮肤，默认皮肤由一个Shpae绘制，否则使用movieClip*/
		protected var _useDefaultSkin:Boolean;
		/**是否显示边框，默认不显示，仅对默认皮肤有效*/
		protected var _borderEnabled:Boolean;
		/**边框颜色，默认黑色，仅对默认皮肤有效*/
		protected var _borderColor:uint = 0x000000;
		/**边框透明度，默认50%，仅对默认皮肤有效*/
		protected var _borderAlpha:Number = .5;
		/**选中时的底色，仅对默认皮肤有效*/
		protected var _selection_color:uint;
		/**正常状态的底色，仅对默认皮肤有效*/
		protected var _default_color:uint = 0xFFFFFF;
		/**底色的透明图，默认不透明，仅对默认皮肤有效*/
		protected var _skin_alpha:Number = 1.0;
		/**皮肤的宽，在init方法中设置，避免没有添加组件前，宽度为0，绘制失败的情况，仅对默认皮肤有效*/
		protected var _skin_width:int;
		/**皮肤的高，在init方法中设置，避免没有添加组件前，高度为0，绘制失败的情况，仅对默认皮肤有效*/
		protected var _skin_height:int;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 构造函数 
		 * @param skinClzName 如果传入的值为空字符串，则使用绘制的方式设置背景  
		 * 
		 */		
		public function SelectionRenderBase(skinClzName:String="")
		{
			super();
			
			_skinClzName = skinClzName;
		}
		
		/**
		 * 创建皮肤，如果使用默认皮肤，则可以在此方法中设置默认的底色、悬停或选中后的底色 
		 * 
		 */		
		override protected function init():void
		{
			super.init();
			
			_useDefaultSkin = _skinClzName != "";
			
			_skin = _useDefaultSkin ? new Shape() : new (SystemManager.Instance.resCacheMgr.getResourceFromMV(_skinClzName))();
			
			addChild(_skin);
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		
		override public function addEvt():void
		{
			addEventListener(MouseEvent.MOUSE_OVER, mouseEvtHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseEvtHandler);
		}
		
		override public function removeEvt():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, mouseEvtHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseEvtHandler);
		}
		
		override public function reset():void
		{
			super.reset();
			
			if (_useDefaultSkin)
				clearSkin();
			else 
				MovieClip(_skin).gotoAndStop(NORMAL_STATE);
		}
		
		/*=======================================================================*/
		/* EVENT HANDLER                                                         */
		/*=======================================================================*/
		
		protected function mouseEvtHandler(event:MouseEvent):void
		{
			if (event.type == MouseEvent.MOUSE_OVER)
			{
				changeSkinByState(false);
			}
			else if (event.type == MouseEvent.MOUSE_OUT)
			{
				changeSkinByState(true);
			}
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 根据状态切换皮肤
		 * @param normal
		 * 
		 */		
		protected function changeSkinByState(normal:Boolean=true):void
		{
			if (normal)
			{
				if (!_selected)
				{
					if (_useDefaultSkin)
						drawBg(_default_color);
					else
						MovieClip(_skin).gotoAndStop(NORMAL_STATE);
				}
			}
			else
			{
				if (_useDefaultSkin)
					drawBg(_selection_color);
				else
					MovieClip(_skin).gotoAndStop(HOVER_STATE);
			}
		}
		
		/**
		 * 绘制背景色  -- 仅对默认皮肤有效
		 * @param color
		 * 
		 */		
		private function drawBg(color:uint):void
		{
			var g:Graphics = Shape(_skin).graphics;
			g.clear();
			// 绘制边框
			if (_borderEnabled)
				g.lineStyle(1, _borderColor, _borderAlpha);
			// 绘制背景
			g.beginFill(color, _skin_alpha);
			g.drawRect(0, 0, _skin_width, _skin_height);
			g.endFill();
		}
		
		/**
		 * 清除背景色， 仅对默认皮肤有效
		 * 
		 */		
		private function clearSkin():void
		{
			Shape(_skin).graphics.clear()
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			
			changeSkinByState(!_selected);
		}
	}
}