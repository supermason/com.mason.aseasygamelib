package com.company.projectname.game.ui.popup
{
	import com.company.projectname.game.lang.Lang;
	import com.company.projectname.game.ui.component.PrettySimpleButton;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Jan 7, 2014 4:52:22 PM
	 * description: 	
	 **/
	public class CountChosePopUp extends PopUpBase
	{
		private var _btnAdd:PrettySimpleButton;
		private var _btnSub:PrettySimpleButton;
		private var _popData:Array;
		private var _maxCount:int;
		private var _count:int;
		private var _needUpdateInfo:Boolean;
		/**数量选择时，是否默认最大值*/
		private var _autoMax:Boolean;
		private var _tip:String;
		/**1-购买精力|2-购买道具|3-批量合成*/
		private var _tipType:int;
		/**货币名称*/
		private const PRICE_NAME:Array = [ Lang.l.gold, Lang.l.euro, Lang.l.scoreStr ];
		
		public function CountChosePopUp()
		{
			super(PopUpType.COUNT_CHOSE);
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		override public function initEvt():void 
		{
			super.initEvt();
			
			_btnAdd.addEventListener(MouseEvent.MOUSE_UP, updateCount);
			_btnSub.addEventListener(MouseEvent.MOUSE_UP, updateCount);
			_txtInput.addEventListener(KeyboardEvent.KEY_UP, checkCount);
		}
		
		override public function dispose():void 
		{
			_txtCostInfo.text = "";
			_skin.txtCountTitle.text = Lang.l.inputCount;
			_txtCostInfo.text = "";
			_tip = "";
			_tipType = -1;
			
			_btnAdd.removeEventListener(MouseEvent.MOUSE_UP, updateCount);
			_btnSub.removeEventListener(MouseEvent.MOUSE_UP, updateCount);
			_txtInput.removeEventListener(KeyboardEvent.KEY_UP, checkCount);
			
			super.dispose();
		}
		
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		
		override protected function init():void
		{
			super.init();
			
			_btnAdd = new PrettySimpleButton(PrettySimpleButton.PLUS_BUTTON);
			_btnAdd.x = 324;
			_btnAdd.y = 100;
			_btnSub = new PrettySimpleButton(PrettySimpleButton.PLUS_BUTTON);
			_btnSub.x = 190;
			_btnSub.y = 100;
			
			addChild(_btnAdd);
			addChild(_btnSub);
			
			initInput();
			initInputTip(Lang.l.inputCount);
			initCostTip();
			
			updateBtnXPos();
		}
		
		override protected function doBusiness():void
		{
			if (_data["cbFun"]) {
				_data["vars"] != null // 这里判断不为null是为了避免 参数为0的情况
					? _data["cbFun"](_data["vars"], _count) 
					: _data["cbFun"](_count);
			}
		}
		
		/*=======================================================================*/
		/* EVENT  HANDLER                                                        */
		/*=======================================================================*/
		
		protected function updateCount(event:MouseEvent):void
		{
			if (event.target == _btnAdd)
			{
				if (_count < _maxCount)
				{
					_count++;
				}
			}
			else if (event.target == _btnSub)
			{
				if (_count > 1)
				{
					_count--;
				}
			}
			
			_txtInput.text = _count.toString();
			
			if (_needUpdateInfo) updateInfo();
		}
		
		
		protected function checkCount(event:KeyboardEvent):void
		{
			if (_txtInput.text == "") return;
			
			try { _count = int(_txtInput.text); }
			catch (err:Error) { _count = 0; }
			
			if (_count == 0)
			{
				_count = 1;
			}
			else if (_count > _maxCount)
			{
				_count = _maxCount;
			}
			
			_txtInput.text = _count.toString();
			
			if (_needUpdateInfo) updateInfo();
		}
		
		// privaate ////
		private function updateInfo():void
		{
			// (iTodayAddTimes + 1 + iTodayAddTimes + in_intTimes)*in_intTimes;
//			_txtCostInfo.text = String(Lang.l.costInfo).replace("@", (_popData[1] + 1 + _popData[1] + _count) * _count);
			if (_tipType == 1) // 其他类购买提示
			{
				_txtCostInfo.text = _tip.replace("@", (_popData[1] + 1 + _popData[1] + _count) * _count);
			}
			else if (_tipType == 2) // 商城购买提示
			{
				// 最大数量|tab索引用于区分货币名称|道具名称|价格
				// 购买@个#需要花费
				_txtCostInfo.text = _tip.replace("@", _count).replace("#", _popData[2]) + (_count * int(_popData[3])) + PRICE_NAME[_popData[1]];
			}
			else if (_tipType == 3) // 批量合成
			{
				// 最大数量|tab索引用于区分货币名称|手续费
				_txtCostInfo.text =  _tip.replace("@", _count) + (_count * int(_popData[2])) + PRICE_NAME[_popData[1]];
			}
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		override public function set popInfo(value:Object):void 
		{
			super.popInfo = value;
			
			_popData = value["data"]["value"];
			_maxCount = _popData[0];
			_skin.txtCountTitle.text += String(Lang.l.maxCount).replace("@", _maxCount);
			_count = 1;
			_txtInput.text = "1"; // 默认至少一个
			
			_needUpdateInfo = value["data"]["updateInfo"];
			_tip = value["data"]["tip"];
			_tipType = value["data"]["tipType"];
			_autoMax = value["data"]["autoMax"];
			
			if (_autoMax) 
			{
				_count = _maxCount;
				_txtInput.text = _maxCount.toString();
			}
			if (_needUpdateInfo) updateInfo();
		}

	}
}