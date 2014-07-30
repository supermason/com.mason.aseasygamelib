package com.company.projectname.game.ui.component
{
	import com.company.projectname.ResourceLocater;
	import easygame.framework.dragdrop.DragManager;
	import easygame.framework.dragdrop.IDraggable;
	import easygame.framework.text.BorderTextField;
	import com.company.projectname.game.ui.component.GameDisObjBase;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Mason
	 */
	public class Item extends DoubleClickItem implements IDraggable 
	{
		public static const CAN_NOT_USE:int = 0;
		public static const ONCE_EACH_TIME:int = 1;
		public static const MORE_EACH_TIME:int = 2;
		public static const EQUIP_FRAGMENTS:int = 3;
		public static const PLAYER_CARD:int = 4;
		
		private var WIDTH:int = 42;
		private var HEIGHT:int = 42;
		
		private var _txtCount:BorderTextField;
		private var _packIndex:int;
		private var _count:int;
		
		private var _smallSize:Boolean = true;
		private var _realWidth:int;
		private var _realHeight:int;
		
		private var _removedHandler:Function;
		
		private var _canSynthesis:Boolean;
		private var _canUpgrade:Boolean;
		
		private var _simpleData:String;
		
		/**
		 * 特殊的标识
		 * 
		 * <p> 为了物品在合成|升级 与 背包间移动时触发某些特殊功能而在销毁时不被触发而特设
		 *  
		 */		
		private var _disposed:Boolean;
		
		/**
		 * 游戏内的物品显示对象，支持拖拽功能
		 * 
		 * <p>游戏内没有双击操作
		 * 
		 */
		public function Item() 
		{
			super(GameDisObjBase.IMAGE);
			
		}
		
		override protected function init():void
		{
			super.init();
			
			_txtCount = new BorderTextField("black", true);
//			_txtCount.y = HEIGHT - 16;
			_disObj = new Bitmap();
			
			addChild(_disObj);
			addChild(_txtCount);
			
			createLoadingIcon(WIDTH, HEIGHT, 0, 0);
			
//			this.doubleClickEnabled = true;
		}
		
		override protected function assetsLoadCallBack():Boolean
		{
			if (super.assetsLoadCallBack())
			{
				_realWidth = _disObj.width;
				_realHeight = _disObj.height;
				
				_disObj.scaleX = WIDTH / _disObj.width;
				_disObj.scaleY = HEIGHT / _disObj.height;
				
				Bitmap(_disObj).smoothing = true;
				
				return true;
			}
			
			return false;
		}
		
		// public ////
		override public function addEvt():void
		{
			super.addEvt();
			
			itemEvt(true);
		}
		
		override public function removeEvt():void
		{
			super.removeEvt();
			
			itemEvt(false);
		}
		
		override public function reset():void
		{
			_disposed = true;
			_removedHandler = null;
			
			if (parent)
				parent.removeChild(DisplayObject(this));
			
			_packIndex = 0;
			if (_data) _data.length = 0;
			
			_disObj.scaleX = 1;
			_disObj.scaleY = 1;
			
			_canSynthesis = false;
			_canUpgrade = false;
			
			_realWidth = 0;
			_realHeight = 0;
			_smallSize = true;
			count = 0;
			_simpleData = "";
			
			super.reset();
		}
		
		/**
		 * 更新大小 
		 * @param toBig
		 * 
		 */		
		public function updateSize(toSmall:Boolean):void
		{
			if (_smallSize == toSmall) return;
			
			_smallSize = toSmall;
			
			_disObj.scaleX = !toSmall ? 1 : (WIDTH / _disObj.width);
			_disObj.scaleY = !toSmall ? 1 : (HEIGHT / _disObj.height);
			
			updateCountTxtPos(!toSmall ? _realWidth : WIDTH, !toSmall ? _realHeight : HEIGHT);
		}
		
		public function tryToUse():void
		{
			if (this.hasEventListener(MouseEvent.MOUSE_UP))
			{
				if (_buziHandler != null)
					_buziHandler(this);
			}
		}
		
		public function clear():void
		{
			super.reset();
		}
		
		// event handler ////
		private function mouseEvtHandler(event:Event):void
		{
			if (event.type == MouseEvent.MOUSE_UP)
			{
				hideToolTip();
//				deferClickEvent(MouseEvent(event));
				if (_buziHandler != null)
					_buziHandler(this);
					
			}
//			else if (event.type == MouseEvent.DOUBLE_CLICK)
//			{
//				hideToolTip();
//				//doubleClickHandler(MouseEvent(event));
//			}
			else if (event.type == Event.REMOVED)
			{
				if (!_disposed)
				{
					if (_removedHandler != null)
						_removedHandler();
				}
			}
		}
		
		override protected function onMouseDown(event:MouseEvent):void
		{
			if (event.type == MouseEvent.MOUSE_DOWN)
			{
				super.onMouseDown(event);
				
				// 未加载完毕的，不允许拖拽
				if (Bitmap(_disObj).bitmapData)
					DragManager.doDrag(DisplayObject(this), Bitmap(_disObj).bitmapData.clone(), event, .7);
			}
		}
		
		// private ////
		
		private function itemEvt(add:Boolean):void
		{
			if (add)
			{
				addEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
//				addEventListener(MouseEvent.DOUBLE_CLICK, mouseEvtHandler);
				addEventListener(Event.REMOVED, mouseEvtHandler);
			}
			else
			{
				removeEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
//				removeEventListener(MouseEvent.DOUBLE_CLICK, mouseEvtHandler);
				removeEventListener(Event.REMOVED, mouseEvtHandler);
			}
		}
		
		private function updateCountTxtPos(w:int, h:int):void
		{
			_txtCount.x = w - _txtCount.textWidth - 4;
			_txtCount.y = h - _txtCount.textHeight - 4;
		}
		
		/**
		 * 创建简单道具数据 
		 * 
		 */		
		private function createSimpleItemData():void
		{
			// 图片名称├4┤道具名称├4┤道具描述├4┤数量 (道具使用对话框需要的数据)
			_simpleData = _data[0] + _dataParser.getSeparater(2) + _data[1] + _dataParser.getSeparater(2) + _data[7] + _dataParser.getSeparater(2) + _count;
		}
		
		// getter && setter ////
		override public function set data(o:Object):void
		{
			// 除了升级卡既能合成又能升品外，其余卡最多只能合成，或者干脆不能合成
			// 物品图片名称├2┤物品名称├2┤物品编号├2┤背包中的位置索引├2┤物品品质├2┤物品数量├2┤物品类型（材料、装备...等在数据库中定义的类别）├2┤物品描述├2┤物品出售价格├2┤合成的欧元手续费├2┤合成的金币手续费├2┤升品的欧元手续费├2┤升品的金币手续费├2┤能升级的（不能的该值为空字符串）├2┤能合成的（不能的该值为空字符串）
			_data = _dataParser.parseData(String(o), 2);
			
			_packIndex = int(_data[3]);
			count = int(_data[5]);
			
			_canSynthesis = (int(_data[9]) > 0) && (int(_data[10]) > 0);
			_canUpgrade = (int(_data[11]) > 0) && (int(_data[12]) > 0);
			
			_toolTip = "<font size='16'><b>" + _data[1] + "<b></font>\n|" + _data[7] + getLvlVsUpgradeInfo()/* + "|" + _lang.count + _data[5] + "\n" + _lang.price2 + _data[8]*/;
			
			loadResByFullURL(ResourceLocater.ITEM_ICON_ROOT + _data[0]);
			
			// 对于物品编号小于60001的道具，不支持使用
			// 所以没有up事件的监听
			if (modelId < 60001 || modelId == 301701)
				removeEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
			
			_disposed = false;
			
			createSimpleItemData();
		}
		
		/**
		 * 添加是否能够升级或升品的提示 
		 * @return 
		 * 
		 */		
		private function getLvlVsUpgradeInfo():String
		{
			var r:String = "";
			
			// 只有签约卡和升级卡才需要判断该值
			if (modelId < 50001)
			{
				if (!_canSynthesis)
				{
					r += "|" + _lang.topLvl;
				}
				
				if (modelId > 40010 && !_canUpgrade)
				{
					if (r == "")
						r += "|";
					else
						r += "\n";
					
					r += _lang.topQuality;
				}
			}
			
			return r;
		}
		
		/**
		 * 物品名称
		 * @return 
		 * 
		 */		
		public function get itemName():String
		{
			return _data[1];
		}
//		/**
//		 * 物品属于玩家后的编号
//		 * @return 
//		 * 
//		 */	
//		public function get id():int
//		{
//			return _data[9];
//		}
		/**
		 * 物品的模型编号 
		 * @return 
		 * 
		 */				
		public function get modelId():int
		{
			return _data[2];
		}
		/**
		 * 物品品质
		 * @return 
		 * 
		 */	
		public function get quality():int
		{
			return _data[4];
		}
		/**
		 * 物品数量
		 * @return 
		 * 
		 */	
		public function get count():int
		{
			return _count;
		}
		/**
		 *  
		 * @private
		 * 
		 */		
		public function set count(value:int):void
		{
			_count = value;
			
			if (_count > 0)
			{
				_txtCount.text = _count.toString();
				
				updateCountTxtPos(WIDTH, HEIGHT);
			}
			else
			{
				_txtCount.text = "";
			}
			
			this.visible = _count > 0;
			
			createSimpleItemData();
		}
				
		/**
		 * 物品类型
		 * @return 
		 * 
		 */	
		public function get type():int
		{
			return _data[6];
		}
		/**
		 * 物品售价
		 * @return 
		 * 
		 */	
		public function get money():int
		{
			return _data[8];
		}
		/**
		 * 物品在包裹中的索引
		 * @return 
		 * 
		 */
		public function get packIndex():int
		{
			return _packIndex;
		}
		/**
		 * 
		 * @private
		 * 
		 */
		public function set packIndex(value:int):void
		{
			_packIndex = value;
		}

		/**
		 * 道具是否支持合成
		 * @return 
		 * 
		 */		
		public function get canSynthesis():Boolean
		{
			return _canSynthesis;
		}
		
		/**
		 * 道具是否支持升级
		 * @return 
		 * 
		 */		
		public function get canUpgrade():Boolean
		{
			return _canUpgrade;
		}
		
		/**
		 * 合成的欧元手续费
		 * @return 
		 * 
		 */		
		public function get synthesisCost1():int
		{
			return _data[9];
		}
		
		/**
		 * 合成的金币手续费
		 * @return 
		 * 
		 */		
		public function get synthesisCost2():int
		{
			return _data[10];
		}
		
		/**
		 * 升级的欧元手续费
		 * @return 
		 * 
		 */		
		public function get upgradeCost1():int
		{
			return _data[11];
		}
		
		/**
		 * 升级的金币手续费
		 * @return 
		 * 
		 */		
		public function get upgradeCost2():int
		{
			return _data[12];
		}
		
		/**
		 * 是否只用于展示 
		 * @param value
		 * 
		 */		
		public function set forDisplayOnly(value:Boolean):void
		{
			itemEvt(!value);
		}

		/**
		 * 当物品被移除时的回调方法
		 * 
		 * <p>如果无需回调，则将该方法置为null
		 * 
		 * @return 
		 * 
		 */		
		public function get removedHandler():Function
		{
			return _removedHandler;
		}
		/**
		 * 
		 * @private
		 * 
		 */
		public function set removedHandler(value:Function):void
		{
			_removedHandler = value;
		}

		/**
		 * 道具使用框中需要的数据 
		 * @return 
		 * 
		 */		
		public function get simpleData():String
		{
			return _simpleData;
		}

		/**
		 * 下一个可以合成的道具数据
		 * 图片名称├3┤道具名称├3┤道具描述
		 * @return 
		 * 
		 */		
		public function get nextSynItemData():String
		{
			return _data[13];
		}
		
		/**
		 * 下一个可以升级的道具数据
		 * 图片名称├3┤道具名称├3┤道具描述
		 * @return 
		 * 
		 */		
		public function get nextUpgItemData():String
		{
			return _data[14];
		}
		
		/**
		 * （装备、碎片特有）能兑换的积分 [占用了出售价格那个位置的数据]
		 * @return 
		 * 
		 */		
		public function get score():int
		{
			return _data[8];
		}
	}

}