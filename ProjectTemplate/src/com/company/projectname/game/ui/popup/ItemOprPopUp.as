package com.company.projectname.game.ui.popup
{
	import com.company.projectname.SystemManager;
	import easygame.framework.display.DraggableSprite;
	import com.company.projectname.game.lang.Lang;
	import com.company.projectname.game.ui.component.HorizentalList;
	import com.company.projectname.game.ui.component.ItemLite;
	import com.company.projectname.game.ui.component.PrettySimpleButton;
	import com.company.projectname.game.tool.UITool;
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Mar 17, 2014 1:05:52 PM
	 * description: 	
	 **/
	public class ItemOprPopUp extends DraggableSprite implements IPopUpWin
	{
		public static const USE_ITEM:int = 1;
		public static const SYN_CARD:int = 2;
		public static const BUY_FROM_MALL:int = 3;
		public static const EXCHANGE_SCORE:int = 4;
		
		// 以下都是skin皮肤内的组件引用
		protected var _skin:MovieClip;
		protected var _btnDoIt:PrettySimpleButton;
		protected var _btnClose:PrettySimpleButton;
		protected var _itemList:HorizentalList;
		
		protected var _data:Object;
		protected var _popType:int;
		private var _count:int;
		private var _maxCount:int;
		private var _needUpdateInfo:Boolean;
		/**数量选择时，是否默认最大值*/
		private var _autoMax:Boolean;
		private var _tip:String;
//		/**1-购买精力|2-购买道具|3-批量合成*/
//		private var _tipType:int;
		/**货币名称*/
		private const PRICE_NAME:Array = [ Lang.l.gold, Lang.l.euro, Lang.l.scoreStr,"积分" ];
		private const TIP_TITLE:Array = ["", Lang.l.useLbl, Lang.l.synthesis, Lang.l.buyLbl, Lang.l.exchangeLbl];
		/**操作类型（1-使用|2-合成|3-购买）*/
		private var _oprType:int = 1;
		private var _autoClose:Boolean = true;
		
		private var _closeHandler:Function;
		
		public function ItemOprPopUp()
		{
			super();
			
			_popType = PopUpType.ITEM_OPR;
			
			init();
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		protected function init():void
		{
			_skin = new (SystemManager.Instance.resCacheMgr.getResourceFromMV("com.xuyou.ogzq2.game.ui.popup.ItemOprPopUpSkin"))();
			UITool.setAllTxtInDisObjCon(_skin);
			_btnDoIt = new PrettySimpleButton(PrettySimpleButton.SMALL_BUTTON);
			_btnDoIt.x = 163;
			_btnDoIt.y = 174;
//			_btnDoIt.labelColor = 0x1f2234;
			_btnClose = new PrettySimpleButton(PrettySimpleButton.CLOSE_BUTTON);
			_btnClose.x = _skin.width - 43;
			_btnClose.y = 6;
			_itemList = new HorizentalList(ItemLite);
			_itemList.x = 59;
			_itemList.y = 80;
			
			_skin.txiCount.restrict = "0-9";
//			_skin.txiCount.maxChars = 7;
//			_skin.txiCount.background = true;
//			_skin.txiCount.backgroundColor = 0xcccccc;
			
			addChild(_skin);
			addChild(_itemList);
			addChild(_btnDoIt);
			addChild(_btnClose);
			
			super.viewPort = SystemManager.Instance.uiMgr.viewPort;
		}
		
		public function updatePopData(data:Object):void
		{
			if (data["maxCount"])
			{
				_maxCount = data["maxCount"];
				
				_itemList.contentList[0].itemCount = _maxCount;
			}
		}
		
		protected function doBusiness():void
		{
//			if (_skin.txiCount.text != "")
//				_count = int(_skin.txiCount.text);
//			else
//				_skin.txiCount.text = _count.toString();
			
			if (_data["cbFun"]) {
				_data["vars"] != null // 这里判断不为null是为了避免 参数为0的情况
					? _data["cbFun"](_data["vars"], _count) 
					: _data["cbFun"](_count);
			}
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		public function initEvt():void
		{
			_btnDoIt.addEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
			_btnClose.addEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
			_skin.txiCount.addEventListener(KeyboardEvent.KEY_UP, checkCount);
			_skin.txiCount.addEventListener(MouseEvent.MOUSE_DOWN, stopDownEvt);
			
			addDragEvtHandler();
		}
		
		public function dispose():void
		{
			removeDragEvtHandler();
			
			_btnDoIt.removeEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
			_btnClose.removeEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
			_skin.txiCount.removeEventListener(KeyboardEvent.KEY_UP, checkCount);
			_skin.txiCount.removeEventListener(MouseEvent.MOUSE_DOWN, stopDownEvt);
			
			_skin.txiCount.text = "1";
			_skin.txtInfo.htmlText = "";
			_skin.txtCountTitle.text = Lang.l.useLbl;
			_skin.txtTip.text = "";
			_oprType = 1;
			_autoClose = true;
			_itemList.reset();
			
			_data = { };
		}
		
		public function setTextLinkClickHandler(value:Function):void
		{
		}
		
		// event handler ////
		protected function stopDownEvt(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		protected function mouseEvtHandler(event:MouseEvent):void
		{
			if (event.currentTarget == _btnDoIt)
			{
				doBusiness();
			}
			else if (event.target == _btnClose)
			{
				_autoClose = true;
			}
			
			if (_autoClose)
				_closeHandler(this);
		}
		
		protected function checkCount(event:KeyboardEvent):void
		{
			if (_skin.txiCount.text == "") return;
			
			_count = int(_skin.txiCount.text);
//			if (_count == 0)
//			{
//				_count = 1;
//			}
//			else if (_count > _maxCount)
//			{
//				_count = _maxCount;
//			}
			
			_skin.txiCount.text = _count.toString();
			
			if (_needUpdateInfo) updateInfo();
		}
		
		// privaate ////
		private function updateInfo():void
		{
			_skin.txtCountTitle.text = TIP_TITLE[_oprType];
			// 1-使用|2-合成|3-购买
			if (_oprType == 1) // 道具使用
			{
				//_skin.txtTip.text = _tip.replace("@", (_data["data"]["value"][1] + 1 + _data["data"]["value"][1] + _count) * _count);
				_skin.txtTip.text = Lang.l.piece;
			}
			else if (_oprType == 2) // 合成
			{
				// 最大数量|tab索引用于区分货币名称|道具名称|价格
				// 购买@个#需要花费
//				_skin.txtTip.text = _tip.replace("@", _count).replace("#", _data["data"]["value"][2]) + (_count * int(_data["data"]["value"][3])) + PRICE_NAME[_data["data"]["value"][1]];
				_skin.txtTip.text = Lang.l.piece + ", " + Lang.l.costTip + (_count * int(_data["data"]["value"][2])) + PRICE_NAME[_data["data"]["value"][1]];
			}
			else if (_oprType == 3) // 商城购买
			{
				// 最大数量|tab索引用于区分货币名称|手续费
				//_skin.txtTip.text =  _tip.replace("@", _count) + (_count * int(_data["data"]["value"][2])) + PRICE_NAME[_data["data"]["value"][1]];
				_skin.txtTip.text = Lang.l.piece + ", " + Lang.l.costTip + (_count * int(_data["data"]["value"][3])) + PRICE_NAME[_data["data"]["value"][1]];
			}
		}
		
		// getter && setter ////
		public function set popInfo(popData:Object):void
		{
			if (!_data || (_data["msg"] != popData["msg"])) 
			{
				_data = popData;
				_skin.txtInfo.htmlText = UITool.setYaHeiTxt("<font size='18'><b>" + _data["msg"] + "</b></font>");
//				if (_data["lbls"])
//				{
//					if (_data["lbls"]["confirmBtnLbl"]) _btnDoIt.label = String(_data["lbls"]["confirmBtnLbl"]);
//				}
			}
			
			_maxCount = _data["data"]["value"][0];
			_skin.txtCountTitle.text += String(Lang.l.maxCount).replace("@", _maxCount);
			_count = 1;
			_skin.txiCount.text = "1"; // 默认至少一个
			
			_needUpdateInfo = _data["data"]["updateInfo"];
			_tip = _data["data"]["tip"];
			_oprType = _data["data"]["tipType"];
			_autoMax = _data["data"]["autoMax"];
			_itemList.contents = _data["data"]["items"];
			_btnDoIt.label = TIP_TITLE[_oprType];
			_skin.mvTitle.gotoAndStop(_oprType);
			if (_data["data"].hasOwnProperty("autoClose"))
				_autoClose = _data["data"]["autoClose"];
			
			if (_autoMax) 
			{
				_count = _maxCount;
				_skin.txiCount.text = _maxCount.toString();
			}
			if (_needUpdateInfo) updateInfo();
		}
		
		public function get isPopped():Boolean
		{
			return this.parent != null;
		}
		
		public function setCloseHandler(value:Function):void
		{
			_closeHandler = value;
		}
		
		override public function get width():Number
		{
			return _skin.width;
		}
		
		override public function get height():Number
		{
			return _skin.height;
		}
	}
}