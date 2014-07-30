package com.company.projectname.game.ui.component
{
	import com.company.projectname.SystemManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import easygame.framework.text.GameText;
	
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 11:24:16 AM
	 * description 试用flashcs系列制作皮肤的简单按钮
	 **/
	public class PrettySimpleButton extends Sprite
	{
		public static const BIG_BLUE_BUTTON:String = "BigBlueButton";
		public static const BIG_TAB:String = "BigTab";
		public static const BIG_YELLOW_BUTTON:String = "BigYellowButton";
		public static const CLOSE_BUTTON:String = "CloseButton";
		public static const PLUS_BUTTON:String = "PlusButton";
		public static const SMALL_BUTTON:String = "SmallButton";
		public static const SMALL_YELLOW_BUTTON:String = "SmallYellowButton";
		public static const SMALL_RED_BUTTON:String = "SmallRedButton";
		public static const SMALL_GREEN_BUTTON:String = "SmallGreenButton";
		public static const SMALL_TAB:String = "SmallTab";
		public static const SPECIAL_BUTTON:String = "SpecialButton";
		public static const SUPER_BIG_BUTTON:String = "SuperBigButton";
		public static const SUPER_BIG_PURPLE_BUTTON:String = "SuperBigPurpleButton";
		public static const SUPER_BIG_YELLOW_BUTTON:String = "SuperBigYellowButton";
		public static const SUPER_TAB:String = "SuperTab";
		public static const TINY_BLUE_BUTTON:String = "TinyBlueButton";
		public static const TINY_RED_BUTTON:String = "TinyRedButton";
		public static const TINY_YELLOW_BUTTON:String = "TinyYellowButton";
		public static const CHANNEL_BUTTON:String = "ChannelButton";
		public static const SCENE_BUTTON:String = "SceneButton";
		public static const LEAUGE_BUTTON:String = "LeagueButton";
		public static const TINY_SEMI_TRANSPARENT_BUTTON:String = "TinySemiTransparentButton";
		public static const LVL_UP_BUTTON:String = "LvlUpButton";
		public static const ARROW_BUTTON:String = "ArrowButton";
		public static const DIAMON_YELLOW_SMALL_BUTTON:String = "YellowDiamonButton";
		public static const TRANSPARENT_BUTTON:String = "TransparentButton";
		public static const LITTLE_RED_BUTTON:String = "LittleRedButton";
		
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		protected const CLASS_PATH:String = "com.xuyou.ogzq2.game.ui.skin.";
		protected var _buttonSkin:MovieClip;
		protected var _enabled:Boolean;
		private var _supportTxt:Boolean;
		private var _toggle:Boolean;
		private var _evtInit:Boolean;
		/**按钮的状态数量*/
		private var _stateCount:int;
		private var _useHoverState:Boolean = true;;
		
		private var _skinName:String;
		
		protected var _btnTxt:GameText;
		protected var _label:String;
		
		private var _$labelWidth:int = -999;
		private var _$labelHeight:int = -999;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 通过资源名称创建一个由MovieClip组成的按钮。
		 * MovieClip本身需要至少有2帧来标识按钮的[正常][悬停]状态
		 * @param	btnType
		 * @param	needTxt
		 * @param	useFilter
		 * @param	initEvtWhenCreate
		 */
		public function PrettySimpleButton(btnType:String="SmallButton", needTxt:Boolean=true, useFilter:Boolean=true, initEvtWhenCreate:Boolean=true)
		{
			super();
			_enabled = true;
			buttonMode = true;
			drawButton(btnType, false/*useFilter*/);
			if (initEvtWhenCreate)
				initBasicEvt();
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		public function initBasicEvt():void
		{
			if (_evtInit) return;
			_evtInit = true;
			addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseHandler);
		}
		
		public function removeEvt():void
		{
			_evtInit = false;
			removeEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseHandler);
		}
		
		public function destory():void
		{
			removeEvt();
			_buttonSkin.stop();
			if (_supportTxt)
				_buttonSkin.btnTxt.filters = [];
			_buttonSkin = null;
			_skinName = "";
		}
		
		/*=======================================================================*/
		/* EVENT HANDLER                                                         */
		/*=======================================================================*/
		private function mouseHandler(e:MouseEvent):void
		{
			if (!_enabled) return;
			if (_toggle) return;
			if (e.type == MouseEvent.MOUSE_OVER) 
			{
				if (_useHoverState) setHover();
			} 
			else if (e.type == MouseEvent.MOUSE_DOWN)
			{
				e.stopImmediatePropagation();
				if (_stateCount > 2)
					_buttonSkin.gotoAndStop(3);
			}
			else if (e.type == MouseEvent.MOUSE_MOVE)
			{
				e.stopImmediatePropagation();
			}
			else // MOUSE_OUT && MOUSE_UP
			{
				goBackToNormal();
			}
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		private function drawButton(btnType:String, useFilter:Boolean, needTxt:Boolean=true):void
		{
			_skinName = btnType;
			_buttonSkin = new (SystemManager.Instance.resCacheMgr.getResourceFromMV(CLASS_PATH + _skinName))();
			_buttonSkin.mouseEnabled = false;
			_buttonSkin.mouseChildren = false;
			_stateCount = _buttonSkin.totalFrames;
			addChild(_buttonSkin);
//			if (_buttonSkin.btnTxt)
//			{
//				_supportTxt = true;
////				if (useFilter)
////					_buttonSkin.btnTxt.filters = [SystemManager.Instance.fitlerMgr.black];
////				_buttonSkin.btnTxt.textColor = 0xffec81;
//				_btnTxt = new BorderTextField();
//				//_btnTxt.defaultTextFormat = SystemManager.Instance.txtFormatMgr.dtf_bold_italic_22;
//				_btnTxt.filters = [SystemManager.Instance.fitlerMgr.black, SystemManager.Instance.fitlerMgr.dropDown];
//				addChild(_btnTxt);
//				
//			}
			
			_supportTxt = needTxt;
			if (_supportTxt)
			{
				_btnTxt = new GameText();
				_btnTxt.defaultTextFormat = SystemManager.Instance.txtFormatMgr.defaultTextFormat;
				_btnTxt.filters = [/*SystemManager.Instance.fitlerMgr.black, */SystemManager.Instance.fitlerMgr.dropDown];
				addChild(_btnTxt);
			}
			
			_buttonSkin.gotoAndStop(1);
		}
		
		private function setHover():void
		{
			_buttonSkin.gotoAndStop(2);
//			if (_supportTxt) 
//				_buttonSkin.btnTxt.textColor = 0xffffff;
		}
		
		private function setToggle():void
		{
			if (_stateCount > 1)
				_buttonSkin.gotoAndStop(2);
		}
		
		private function goBackToNormal():void
		{
			_buttonSkin.gotoAndStop(1);
//			if (_supportTxt) 
//				_buttonSkin.btnTxt.textColor = 0xffec81;
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		public function set label(txt:String):void
		{
//			if (_supportTxt)
//				_buttonSkin.btnTxt.text = txt;
			
			_label = txt;
			
			if (_btnTxt)
			{
				_btnTxt.text = txt;
				if (_$labelWidth == -999)
					_btnTxt.x = (_buttonSkin.width - _btnTxt.textWidth) / 2;
				if (_$labelHeight == -999)
					_btnTxt.y = (_buttonSkin.height - _btnTxt.textHeight) / 2 - 2;
			}
		}
		
		public function set labelX(value:int):void
		{
			_$labelWidth = value;
			_btnTxt.x = value;
		}
		
		public function set labelY(value:int):void
		{
			_$labelHeight = value;
			_btnTxt.y = value;
		}
		
		public function get label():String
		{
//			if (_supportTxt)
//				return _buttonSkin.btnTxt.text;
//			else
//				return "";
			if (_btnTxt)
				return _btnTxt.text;
			else
				return "";
		}
		
		override public function get width():Number
		{
			return _buttonSkin.width;
		}
		
		override public function get height():Number
		{
			return _buttonSkin.height;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if (_enabled)
			{
				_buttonSkin.gotoAndStop(1);
				//if (_supportTxt) _buttonSkin.btnTxt.textColor = 0xffec81;
			}
			else
			{
				if (_stateCount > 3)
					_buttonSkin.gotoAndStop(4);
				//if (_supportTxt) _buttonSkin.btnTxt.textColor = 0xa3a2a2;
			}
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function get toggle():Boolean
		{
			return _toggle;
		}
		
		public function set toggle(value:Boolean):void
		{
			_toggle = value;
			if (_toggle)
			{
				setToggle();
			}
			else
			{
				if (_enabled)
					goBackToNormal();
			}
		}
		
		public function set textFormat(value:TextFormat):void
		{
			if (_supportTxt)
			{
				_btnTxt.defaultTextFormat = value;
				//_buttonSkin.btnTxt.defaultTextFormat = value;
				_btnTxt.text = _label;
			}
		}
		
		public function set labelColor(color:uint):void
		{
			if (_supportTxt)
			{
				_btnTxt.textColor = color;
			}
		}
		
		public function set textFileter(value:Array):void
		{
			_btnTxt.filters = value;
		}

		/**
		 * 是否使用悬停状态，对于无需悬停状态的按钮，将该值设置为false，默认是true 
		 * @return 
		 * 
		 */		
		public function get useHoverState():Boolean
		{
			return _useHoverState;
		}
		/**
		 * 
		 * @private
		 * 
		 */
		public function set useHoverState(value:Boolean):void
		{
			_useHoverState = value;
		}

	}
}