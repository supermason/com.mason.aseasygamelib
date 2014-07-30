package com.company.projectname.game.ui.component
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 26, 2013 3:59:38 PM
	 * description: 	
	 **/
	public class TabButtonBar extends Sprite
	{
		private var _btnSkin:String;
		private var _tabBtnTxf:TextFormat;
		private var _tabBtnLblX:int = -999;
		private var _tabBtnLblY:int = -999;
		private var _gap:int = 2; // 页签之间的间距，默认2像素
		private var _tabNames:Array;
		private var _tabBtns:Vector.<PrettySimpleButton>;
		private var _curSelectedBtn:PrettySimpleButton;
		private var _selectedIndex:int;
		private var _tabButtonClickHandler:Function;
		
		public function TabButtonBar(btnSkin:String="")
		{
			super();
			
			this.mouseEnabled = false;
			_btnSkin = btnSkin;
		}
		
		// public ////
		/**
		 * 为tabBar添加事件 
		 * 
		 */		
		public function addEvt():void
		{
			for each (var pBtn:PrettySimpleButton in _tabBtns)
			{
				pBtn.initBasicEvt();
				
				pBtn.addEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
			}
		}
		
		/**
		 * 根据索引替换索引对应出Tab按钮的lbl文字显示 
		 * @param newLbl
		 * @param index 传入默认的-1则表示替换当前选中状态按钮的lbl文字
		 * 
		 */		
		public function changeTabBtnLblByIndex(newLbl:String, index:int=-1):void
		{
			var fIndex:int = index == -1 ? _selectedIndex : index;
			
			if (fIndex < 0 || fIndex > _tabBtns.length - 1)
				return;
			
			_tabBtns[fIndex].label = newLbl;
		}
		
		/**
		 * 根据索引替换索引对应出Tab按钮的lbl文字颜色
		 * @param color
		 * @param index
		 * 
		 */		
		public function changeTabBtnLblColorByIndex(color:uint, index:int=-1):void
		{
			var fIndex:int = index == -1 ? _selectedIndex : index;
			
			if (fIndex < 0 || fIndex > _tabBtns.length - 1)
				return;
			
			_tabBtns[fIndex].labelColor = color;
		}
		
		/**
		 * 更新页签显示 
		 * @param value
		 * 
		 */		
		public function updateTab(value:Array):void
		{
			_tabNames = value;
			
			if (!_tabBtns)
				_tabBtns = new Vector.<PrettySimpleButton>();
			else
				reset();
			
			for (var i:int = 0, len:int = _tabNames.length; i < len; ++i)
			{
				if (i < _tabBtns.length)
				{
					_tabBtns[i].label = _tabNames[i];
				}
				else
				{
					createTabButton(_tabNames[i]);
				}
			}
		}
		
		public function disableBtnAt(index:int):void
		{
			if (index >= 0 && index < _tabBtns.length)
			{
				_tabBtns[index].enabled = false;
				_tabBtns[index].removeEvt();
				_tabBtns[index].removeEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
			}
		}
		
		public function enableBtnAt(index:int):void
		{
			if (index >= 0 && index < _tabBtns.length)
			{
				_tabBtns[index].enabled = true;
				_tabBtns[index].initBasicEvt();
				if (!_tabBtns[index].hasEventListener(MouseEvent.MOUSE_UP))
					_tabBtns[index].addEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
			}
		}
		
		/**
		 * 资源回收 
		 * 
		 */		
		public function reset():void
		{
			if (_tabBtns && _tabBtns.length > 0)
			{
				for each (var pBtn:PrettySimpleButton in _tabBtns)
				{
					pBtn.toggle = false;
					pBtn.removeEvt();
					pBtn.removeEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
				}
				
				_tabBtns[0].toggle = true;
			}
			
			tabBtnBarEnabled = true;
			
			_selectedIndex = 0;
		}
		
		// protected ////
		/**
		 * 创建按钮列表，并组织成tab样式 
		 * 
		 */		
		protected function render():void
		{
			if (_tabNames && _tabNames.length > 0)
			{
				if (!_tabBtns)
					_tabBtns = new Vector.<PrettySimpleButton>();
				
				for each (var tabName:String in _tabNames)
				{
					createTabButton(tabName);
				}
				
				_tabBtns[0].toggle = true; // 默认选中第一个页签
			}
		}
		
		
		// event handler ////
		private function mouseEvtHandler(event:MouseEvent):void
		{
			if (event.type == MouseEvent.MOUSE_UP)
			{
				unSelectedAll();
				
				_curSelectedBtn = PrettySimpleButton(event.target);
				_selectedIndex = _tabBtns.indexOf(_curSelectedBtn);
				
				doBuzi();
			}
		}
		
		// private ////
		/**
		 * 创建Tab按钮 
		 * @param tabName
		 * 
		 */		
		private function createTabButton(tabName:String):void
		{
			if (_btnSkin && _btnSkin != "")
			{
				_curSelectedBtn = new PrettySimpleButton(_btnSkin);
				_curSelectedBtn.labelY = _tabBtnLblY != -999 ? _tabBtnLblY : 3;
				if (_tabBtnLblX != -999) _curSelectedBtn.labelX = _tabBtnLblX;
				if (_tabBtnTxf)
					_curSelectedBtn.textFormat = _tabBtnTxf;
				_curSelectedBtn.label = tabName;
				_curSelectedBtn.x = _tabBtns.length * (_curSelectedBtn.width + _gap);
				addChild(_curSelectedBtn);
				_tabBtns.push(_curSelectedBtn);
			}
		}
		
		/**
		 * 取消所有按钮的选中状态 
		 * 
		 */		
		public function unSelectedAll():void
		{
			for each (var pBtn:PrettySimpleButton in _tabBtns)
			{
				pBtn.toggle = false;
			}
		}
		
		/**
		 * 点击页签后执行业务方法 
		 * 
		 */		
		private function doBuzi():void
		{
			_curSelectedBtn.toggle = true;
			
			if (_tabButtonClickHandler != null)
				_tabButtonClickHandler(_selectedIndex);
		}
		
		private function updateTabBtnTxf():void
		{
			for each (var psb:PrettySimpleButton in _tabBtns)
			{
				psb.textFormat = _tabBtnTxf;
			}
		}
		
		private function updateTabBtnLblX():void
		{
			for each (var psb:PrettySimpleButton in _tabBtns)
			{
				psb.labelX = _tabBtnLblX;
			}
		}
		
		private function updateTabBtnLblY():void
		{
			for each (var psb:PrettySimpleButton in _tabBtns)
			{
				psb.labelY = _tabBtnLblY;
			}
		}
		
		// getter && setter ////
		/**
		 * 包含页签名称的数组
		 * 
		 * <p>调用该方法将创建页签按钮列表 
		 * @param value
		 * 
		 */
		public function set tabNames(value:Array):void
		{
			_tabNames = value;
			render();
		}
		
		/**
		 * 直接从外部传入按钮对象，制作Tab页签 
		 * @param value
		 * 
		 */		
		public function set tabBtns(value:Array):void
		{
			if (value && value.length > 0)
			{
				if (!_tabBtns)
					_tabBtns = new Vector.<PrettySimpleButton>();
				else
				{
					reset();
					
					while (this.numChildren > 0)
						this.removeChildAt(0);
					
					_tabBtns.length = 0;
				}
				
				for each (var pBtn:PrettySimpleButton in value)
				{
					_curSelectedBtn = pBtn;
					
					_curSelectedBtn.x = _tabBtns.length * (_curSelectedBtn.width + _gap);
					
					_tabBtns[_tabBtns.length] = _curSelectedBtn;
					
					addChild(pBtn);
				}
				
				_tabBtns[0].toggle = true;
			}
		}
		
		/**
		 * 页签按钮点击时的 
		 * @param value
		 * 
		 */
		public function set tabButtonClickHandler(value:Function):void
		{
			_tabButtonClickHandler = value;
		}
		
		/**
		 * 页签按钮之间的间距
		 * 
		 * <p> 默认2个像素 -- 在调用<code>tabNames</code>前调用，否则改变无效
		 * 
		 * @return 
		 * 
		 */
		public function get gap():int
		{
			return _gap;
		}
		/**
		 * 
		 * @param private
		 * 
		 */
		public function set gap(value:int):void
		{
			_gap = value;
		}
		
		/**
		 * 当前选中的页签索引 -- 从0开始
		 * 
		 * <p>调用该<code>setter</code>会触发点击事件
		 * 
		 * @return 
		 * 
		 */
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		/**
		 * 
		 * @private
		 * 
		 * @param value
		 * 
		 */
		public function set selectedIndex(value:int):void
		{
			setSelectedIndex(value);
			
			doBuzi();
			
		}

		/**
		 * 设置选中的页签，该方法不会触发事件 
		 * @param value
		 * 
		 */		
		public function setSelectedIndex(value:int):void
		{
			_selectedIndex = value;
			
			if (_selectedIndex < 0) _selectedIndex = 0;
			if (_selectedIndex > _tabBtns.length - 1) _selectedIndex = _tabBtns.length - 1;
			
			unSelectedAll();
			
			_curSelectedBtn = _tabBtns[_selectedIndex];
			
			_curSelectedBtn.toggle = true;
		}
		
		/**
		 * 设置tabbar是否可用 
		 * @param value
		 * 
		 */		
		public function set tabBtnBarEnabled(value:Boolean):void
		{
			this.mouseChildren = value;
			this.mouseEnabled = value;
		}
		
		public function get tabBtnBarEnabled():Boolean
		{
			return this.mouseEnabled;
		}
		
		/**
		 * 设置字体样式 
		 * @param txf
		 * 
		 */		
		public function set textFormat(txf:TextFormat):void
		{
			_tabBtnTxf = txf;
			if (_tabBtns && _tabBtns.length > 0)
				updateTabBtnTxf();
		}
		
		public function set tabLabelX(value:int):void
		{
			_tabBtnLblX = value;
			if (_tabBtns && _tabBtns.length > 0)
				updateTabBtnLblX();
		}
		
		public function set tabLabelY(value:int):void
		{
			_tabBtnLblY = value;
			if (_tabBtns && _tabBtns.length > 0)
				updateTabBtnLblY();
		}
		
		public function get buttons():Vector.<PrettySimpleButton>
		{
			return this._tabBtns;
		}
	}
}