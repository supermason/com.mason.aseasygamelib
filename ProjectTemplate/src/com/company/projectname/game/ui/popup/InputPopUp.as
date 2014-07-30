package com.company.projectname.game.ui.popup
{
	import com.company.projectname.game.lang.Lang;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Mar 5, 2014 9:26:36 AM
	 * description: 	
	 **/
	public class InputPopUp extends PopUpBase
	{
		private var _basePrice:int;
		private var _inputPrice:int;
		
		public function InputPopUp()
		{
			super(PopUpType.INPUT);
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		override public function initEvt():void 
		{
			super.initEvt();
			
//			_txtInput.addEventListener(KeyboardEvent.KEY_UP, checkPrice);
		}
		
		override public function dispose():void 
		{
//			_txtInput.removeEventListener(KeyboardEvent.KEY_UP, checkPrice);
			
			_txtCostInfo.text = "";
			
			super.dispose();
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		
		override protected function init():void
		{
			super.init();
			
			initInput(9);
			initInputTip(Lang.l.sellMoney);
			_skin.txtCountTitle.x += 30;
			initCostTip();
			
			updateBtnXPos();
		}
		
		override protected function doBusiness():void
		{			
//			validateInput();
			
			if (_data["cbFun"]) {
				_data["vars"] != null // 这里判断不为null是为了避免 参数为0的情况
					? _data["cbFun"](_data["vars"], _inputPrice) 
					: _data["cbFun"](_inputPrice);
			}
		}
		
		/*=======================================================================*/
		/* EVENT  HANDLER                                                        */
		/*=======================================================================*/
		
		protected function checkPrice(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.BACKSPACE) return;
			
			_inputPrice = int(_txtInput.text);
			
			if (_inputPrice < _basePrice)
			{
				_inputPrice = _basePrice;
			}
			_txtInput.text = _inputPrice.toString();
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTION
		/*=======================================================================*/
		private function validateInput():void
		{
			_inputPrice = int(_txtInput.text);
			
			if (_inputPrice < _basePrice)
			{
				_inputPrice = _basePrice;
			}
			_txtInput.text = _inputPrice.toString();
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		override public function set popInfo(value:Object):void 
		{
			super.popInfo = value;
			
			_basePrice = _data["data"]["value"][0];
			_inputPrice = _basePrice;
			_txtInput.text = _basePrice.toString();
			_txtCostInfo.text = String(Lang.l.basePrice).replace("@", _basePrice);
		}
	}
}