package com.company.projectname.game.ui.component
{
	import flash.events.MouseEvent;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Jan 3, 2014 4:07:56 PM
	 * description: 单选按钮容器	
	 **/
	public class RadioButtonGroup
	{
		private var _radioBtnList:Array;
		private var _buziHandler:Function;
		private var _selectedBtn:RadioButton;
		
		public function RadioButtonGroup(radioButtons:Array)
		{
			init(radioButtons);
		}
		
		private function init(args:Array):void
		{
			_radioBtnList = args;
			_selectedBtn = _radioBtnList[0]; // 默认选中第一个button
			
			addEvt();
		}
		
		// public ////
		
		public function addEvt():void
		{
			for each (var radionBtn:RadioButton in _radioBtnList)
			{
				radionBtn.addEvt();
				radionBtn.addEventListener(MouseEvent.MOUSE_UP, radioBtnClickHandler);
				radionBtn.selected = false;
			}
			
			_radioBtnList[0].selected = true;
		}
		
		
		public function reset():void
		{
			for each (var radionBtn:RadioButton in _radioBtnList)
			{
				radionBtn.reset();
				radionBtn.removeEventListener(MouseEvent.MOUSE_UP, radioBtnClickHandler);
			}
		}
		
		public function reInit(btnList:Array):void
		{
			init(btnList);
		}
		
		public function dispose():void
		{
			reset();
			
			_radioBtnList.length = 0;
		}
		
		// event handler ////
		
		protected function radioBtnClickHandler(event:MouseEvent):void
		{
			_selectedBtn = RadioButton(event.target);
			_selectedBtn.selected = true;
			
			for each (var radionBtn:RadioButton in _radioBtnList)
			{
				if (radionBtn != event.target)
				{
					radionBtn.selected = false;
				}
			}
			
			if (_buziHandler != null)
			{
				_buziHandler(event.target);
			}
		}
		
		// private ////
		
		// getter && setter ////
		
		public function set buziHandler(value:Function):void
		{
			_buziHandler = value;
		}

		/**
		 * 当前选择的 单选按钮
		 * @return 
		 * 
		 */		
		public function get selectedBtn():RadioButton
		{
			return _selectedBtn;
		}
		
		/**
		 * 当前选择按钮的数据 
		 * @return 
		 * 
		 */		
		public function get seletedItemData():Object
		{
			return _selectedBtn.data;
		}
		
		/**
		 * 设置索引 
		 * @param index
		 * 
		 */		
		public function set selectedIndex(index:int):void
		{
			if (index >=0 && index < _radioBtnList.length)
			{
				_selectedBtn = _radioBtnList[index];
			}
		}
	}
}