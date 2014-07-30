package com.company.projectname.game.ui.popup
{
	import com.company.projectname.SystemManager;
	import easygame.framework.display.DraggableSprite;
	import com.company.projectname.game.lang.Lang;
	import com.company.projectname.game.ui.component.PrettySimpleButton;
	import com.company.projectname.game.tool.UITool;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 1:49:51 PM
	 * description 
	 **/
	public class PopUpBase extends DraggableSprite implements IPopUpWin
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		public static const POP_UP_WIDTH:int = 408;
		// 以下都是skin皮肤内的组件引用
		protected var _skin:MovieClip;
		protected var _btnConfirm:PrettySimpleButton;
		protected var _btnCancel:PrettySimpleButton;
		protected var _closeBtn:PrettySimpleButton;
		protected var _txtInfo:TextField;
		protected var _txtTitle:TextField;
		protected var _txtInput:TextField;
		protected var _txtCostInfo:TextField;
		
		protected var _data:Object;
		protected var _popType:int;
		protected var _popUpBaseWidth:int = 408; // 根据实际皮肤的宽度修改
		protected var _popUpBaseHeight:int = 216; //根据实际皮肤的高度修改
		
		private var _closeHandler:Function;
		private var _textLickClickHandler:Function;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 该弹出窗体的类型（类型详见PopUpType常量类）
		 * @param type
		 * 
		 */		
		public function PopUpBase(type:int) 
		{
			super();
			
			_popType = type;
			
			init();
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		public function initEvt():void 
		{
			_btnConfirm.addEventListener(MouseEvent.MOUSE_UP, btnClickHandler);
			_closeBtn.addEventListener(MouseEvent.MOUSE_UP, btnClickHandler);
			if (_popType != PopUpType.INFO)
				_btnCancel.addEventListener(MouseEvent.MOUSE_UP, btnClickHandler);
			
			super.viewPort = SystemManager.Instance.uiMgr.viewPort;
			
			addDragEvtHandler();
			
			_txtInfo.addEventListener(TextEvent.LINK, textLinkHandler);
		}
		
		public function updatePopData(data:Object):void
		{
			
		}
		
		public function dispose():void 
		{
			_btnConfirm.label = Lang.l.confirm;
			
			if (_btnCancel)
			{
				_btnCancel.label = Lang.l.cancel;
			}
			_btnConfirm.removeEventListener(MouseEvent.MOUSE_UP, btnClickHandler);
			_closeBtn.removeEventListener(MouseEvent.MOUSE_UP, btnClickHandler);
			if (_popType != PopUpType.INFO)
				_btnCancel.removeEventListener(MouseEvent.MOUSE_UP, btnClickHandler);
			
			removeDragEvtHandler();
			
			_txtInfo.text = "";
			_txtInfo.removeEventListener(TextEvent.LINK, textLinkHandler);
			_data = { };
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		protected function init():void
		{
			_skin = new (SystemManager.Instance.resCacheMgr.getResourceFromMV("com.xuyou.ogzq2.game.ui.popup.PopUpSkin"))();
			UITool.setAllTxtInDisObjCon(_skin);
			_skin.txiCount.visible = false;
			_skin.txtCountTitle.visible = false;
			_txtInfo = _skin.txtInfo;
			_txtTitle = _skin.txtOprTitle;
			
//			if (_popType == PopUpType.INFO)
//			{
//				_btnConfirm.x = 132;
//				_btnCancel.parent.removeChild(_btnCancel);
//			}
			
			addChild(_skin);
			_btnConfirm = new PrettySimpleButton(PrettySimpleButton.SMALL_BUTTON);
			_btnConfirm.y = 175;
			_btnConfirm.label = Lang.l.confirm;
//			_btnConfirm.labelColor = 0x000000;
			addChild(_btnConfirm);
			_closeBtn = new PrettySimpleButton(PrettySimpleButton.CLOSE_BUTTON);
			_closeBtn.x = _skin.width - 43;
			_closeBtn.y = 6;
			addChild(_closeBtn);
			if (_popType != PopUpType.INFO)
			{
				_btnCancel = new PrettySimpleButton(PrettySimpleButton.SMALL_BUTTON);
				_btnCancel.y = 175;
				_btnCancel.label = Lang.l.cancel;
//				_btnCancel.labelColor = 0x000000;
				addChild(_btnCancel);
			}
		}
		
		/**
		 * 初始化输入框样式 
		 * @param maxChar
		 * @param restric
		 * @param border
		 * @param borderColor
		 * @param background
		 * @param backgroundColor
		 * @param textColor
		 * 
		 */		
		protected function initInput(maxChar:int=3, restric:String="0-9", 
									 border:Boolean=true, borderColor:uint=0x666666,
									 background:Boolean=true, backgroundColor:uint=0xCCCCCC,
									 textColor:uint=0x000000):void
		{
			_txtInput = _skin.txiCount;
			_txtInput.restrict = restric;
			_txtInput.maxChars = maxChar;
			_txtInput.border = border;
			_txtInput.borderColor = borderColor;
			_txtInput.background = background;
			_txtInput.backgroundColor = backgroundColor;
			_txtInput.textColor = textColor;
		}
		
		/**
		 * 初始化输入提示 
		 * @param tip
		 * 
		 */		
		protected function initInputTip(tip:String):void
		{
			_skin.txiCount.visible = true;
			_skin.txtCountTitle.visible = true;
			_skin.txtCountTitle.text = tip;
		}
		
		/**
		 * 初始化费用提示 
		 * 
		 */		
		protected function initCostTip():void
		{
			_txtCostInfo = _skin.txtCost;
		}
		
		/**
		 * 调整确定、取消按钮的x坐标 
		 * @param confirmBtnX
		 * @param cancelBtnX
		 * 
		 */		
		protected function updateBtnXPos(confirmBtnX:int=105, cancelBtnX:int=227):void
		{
			_btnConfirm.x = 105;
			_btnCancel.x = 227;
		}
		
		/*=======================================================================*/
		/* EVENT  HANDLER                                                        */
		/*=======================================================================*/
		private function btnClickHandler(event:MouseEvent):void
		{
			if (event.currentTarget == _btnConfirm)
			{
				doBusiness();
			}
			else if (event.currentTarget == _btnCancel)
			{
				cancelBusiness();
			}
			else if (event.currentTarget == _closeBtn)
			{
				
			}
			
			_closeHandler(this);
		}
		
		protected function doBusiness():void
		{
			if (_data["cbFun"]) {
				_data["vars"] != null // 这里判断不为null是为了避免 参数为0的情况
					? _data["cbFun"](_data["vars"]) 
					: _data["cbFun"]();
			}
		}
		
		protected function cancelBusiness():void
		{
			if (_data["cancelFun"]) {
				_data["clVars"] != null // 这里判断不为null是为了避免 参数为0的情况
					? _data["cancelFun"](_data["clVars"])
					: _data["cancelFun"]();
			}
		}
		
		protected function textLinkHandler(event:TextEvent):void
		{
			if (_textLickClickHandler != null)
				_textLickClickHandler(event.text, this);
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		public function set popInfo(value:Object):void 
		{
			if (!_data || (_data["msg"] != value["msg"])) 
			{
				_data = value;
				_txtInfo.htmlText = UITool.setYaHeiTxt((_data["msg"]));
				if (_data["lbls"])
				{
					if (_data["lbls"]["confirmBtnLbl"]) _btnConfirm.label = _data["lbls"]["confirmBtnLbl"];
					if (_data["lbls"]["cancelBtnLbl"]) _btnConfirm.label = _data["lbls"]["cancelBtnLbl"];
				}
			}
		}
		
		public function get isPopped():Boolean 
		{
			return this.parent != null;
		}
		
		public function setCloseHandler(value:Function):void 
		{
			_closeHandler = value;
		}
		
		public function setTextLinkClickHandler(value:Function):void
		{
			_textLickClickHandler = value;
		}
		
		override public function get width():Number
		{
			return _popUpBaseWidth;
		}
		
		override public function get height():Number
		{
			return _popUpBaseHeight;
		}
		
		public function set confirmBtnLabel(value:String):void
		{

				
		}
		
		public function set cancelBtnLabel(value:String):void
		{
			
		}
	}
}