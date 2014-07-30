package com.company.projectname.game.ui.popup
{
	import com.company.projectname.game.lang.Lang;
	import com.company.projectname.game.ui.component.RadioButton;
	import com.company.projectname.game.ui.component.RadioButtonGroup;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Mar 3, 2014 1:24:27 PM
	 * description: 	
	 **/
	public class RadioButtonPopUp extends PopUpBase
	{
		private const DEFAULT_RADION_BUTTON_COUNT:int = 3;
		/**
		 * 默认创建的单选按钮的数量 - 3 (这值会始终保持一个曾经出现过的最大值)
		 */		
		private var _curRadioButtonCount:int = DEFAULT_RADION_BUTTON_COUNT;
		/**
		 * 本次显示时使用的按钮数量 
		 */		
		private var _useRadioButtonCount:int = DEFAULT_RADION_BUTTON_COUNT;
		private var _radioButtons:Array;
		private var _raidoButtonGroup:RadioButtonGroup;
		private var _radioButton:RadioButton;
		private var _yPosChanged:Boolean;
		private const DEFAULT_RADIO_BUTTON_Y:int = 100;
		
		public function RadioButtonPopUp()
		{
			super(PopUpType.RADIO_BUTTON);
		}
		
		// protected /////
		override protected function init():void
		{
			super.init();
			
			_radioButtons = [];
			
			createButtons(0, _curRadioButtonCount);
			
			_raidoButtonGroup = new RadioButtonGroup(_radioButtons);
			_raidoButtonGroup.buziHandler = radioButtonClickHandler;
			
			updateBtnXPos();
		}
		
		protected function createButtons(startIndex:int, endIndex:int):void
		{
			for (var i:int = startIndex; i < endIndex; i++)
			{
				_radioButton = new RadioButton();
				_radioButton.y = DEFAULT_RADIO_BUTTON_Y;
				_radioButtons[i] = _radioButton;
			}
		}
		
		override protected function doBusiness():void
		{
			if (_data["cbFun"]) 
			{
				if (_data["data"]["value"])
				{
					_data["vars"] != null // 这里判断不为null是为了避免 参数为0的情况
						? _data["cbFun"](_data["vars"], int(_data["data"]["value"][0]), _radioButton.data) 
						: _data["cbFun"](int(_data["data"]["value"][0]), _radioButton.data);
				}
				else
				{
					_data["vars"] != null // 这里判断不为null是为了避免 参数为0的情况
						? _data["cbFun"](_data["vars"], _radioButton.data) 
						: _data["cbFun"](_radioButton.data);
				}
			}
		}
		
		// public ////
		override public function initEvt():void
		{
			super.initEvt();
			
			_raidoButtonGroup.addEvt();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			_btnConfirm.x = 105;
			_btnCancel.x = 227;
			
			for (var i:int = 0; i < _useRadioButtonCount; i++)
			{
				if (contains(_radioButtons[i]))
					removeChild(_radioButtons[i]);
				
				if (_yPosChanged)
					_radioButtons[i].y = DEFAULT_RADIO_BUTTON_Y;
			}
			_useRadioButtonCount = 0;
			_yPosChanged = false;
			_raidoButtonGroup.reset();
			_skin.txtTip2.text = "";

		}
		
		// event handler ////
		private function radioButtonClickHandler(button:RadioButton):void
		{
			_radioButton = button;
			if (_data["data"]["value"])
				_skin.txtTip2.text = String(Lang.l.totalCost).replace("@", Math.ceil(int(_data["data"]["value"][0]) * (100 + int(button.data)) / 100));
		}
		
		// private ////
		private function render():void
		{
			_useRadioButtonCount = _data["data"]["radioButtonLbl"].length;
			if (_useRadioButtonCount > _curRadioButtonCount)
			{
				addNewButton();
				_curRadioButtonCount = _useRadioButtonCount;
			}
			
			var temp:int = 0;
			for (var i:int = 0; i < _useRadioButtonCount; i++)
			{
				_radioButtons[i].label = _data["data"]["radioButtonLbl"][i];
				_radioButtons[i].data = _data["data"]["radioButtonData"][i];
				if (_yPosChanged) _radioButtons[i] += 20;
				
				temp += _radioButtons[i].width;
				
				addChild(_radioButtons[i]);
			}
			
			temp = (PopUpBase.POP_UP_WIDTH - temp) / 2;
			
			_radioButtons[0].x = temp;
			for (i = 1; i < _useRadioButtonCount; i++)
			{
				_radioButtons[i].x = _radioButtons[i-1].x + _radioButtons[i].width;
				if (_yPosChanged) _radioButtons[i] += 20;
			}
			
		}
		
		private function addNewButton():void
		{
			createButtons(_curRadioButtonCount, _useRadioButtonCount);
			
			_raidoButtonGroup.dispose();
			_raidoButtonGroup.reInit(_radioButtons);
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		override public function set popInfo(value:Object):void 
		{
			super.popInfo = value;
			
//			_popData = value["data"]["value"];
//			_maxCount = _popData[0];
//			_skin.txtCountTitle.text += String(Lang.l.maxCount).replace("@", _maxCount);
//			_count = 1;
//			_txtInput.text = "1"; // 默认至少一个
//			
//			_needUpdateInfo = value["data"]["updateInfo"];
//			_tip = value["data"]["tip"];
//			_tipType = value["data"]["tipType"];
//			_autoMax = value["data"]["autoMax"];
//			
//			if (_autoMax) 
//			{
//				_count = _maxCount;
//				_txtInput.text = _maxCount.toString();
//			}
//			if (_needUpdateInfo) updateInfo();
			
			render();
			
			radioButtonClickHandler(_radioButtons[0]);
			
			_yPosChanged = !value["data"].hasOwnProperty("value");
			
			if (value["data"] && value["data"].hasOwnProperty("hideCloseBtn"))
				_closeBtn.visible = !value["data"]["hideCloseBtn"];
			
			if (value["data"] && value["data"].hasOwnProperty("hideCancelBtn"))
			{
				if (value["data"]["hideCancelBtn"])
				{
					_btnCancel.visible = false;
					_btnConfirm.x = 162;
				}
			}
		}
	}
}