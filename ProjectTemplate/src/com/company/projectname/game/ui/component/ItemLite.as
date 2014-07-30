package com.company.projectname.game.ui.component
{
	import com.company.projectname.ResourceLocater;
	import com.company.projectname.SystemManager;
	import easygame.framework.text.BorderTextField;
	import com.company.projectname.game.lang.Lang;
	
	import flash.display.Bitmap;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Jan 15, 2014 11:05:05 AM
	 * description: 	
	 **/
	public class ItemLite extends GameDisObjSupportToolTip
	{
		/**
		 * 用于任务界面
		 */		
		public static const FOR_TASK:int = 0;
		
		protected var _needScale:Boolean;
		protected var _scaleX:Number;
		protected var _scaleY:Number;
		protected var _itemId:int;
		
		//=======================================================================================
		
		protected var _curType:int;
		protected var _txtCount:BorderTextField;
		protected var _showCount:Boolean = true;
		protected var _showName:Boolean = false;
		
		protected var _itemName:BorderTextField;
		
		public function ItemLite()
		{
			_$width = 64;
			_$height = 64;
			
			super(GameDisObjBase.IMAGE, false);
		}
		
		override protected function init():void
		{
			super.init();
			
			_disObj = new Bitmap();
			
			_txtCount = new BorderTextField("black",true);
			
			_itemName = new BorderTextField();
			_itemName.y = _$height;
			_itemName.defaultTextFormat = SystemManager.Instance.txtFormatMgr.defaultTextFormat;
			_itemName.textColor = 0x394E75;
			
			addChild(_disObj);
			addChild(_txtCount);
			addChild(_itemName);
			
			createLoadingIcon(_$width, _$height, 0, 0);
			
			this.mouseChildren = false;
		}
		
		override protected function assetsLoadCallBack():Boolean
		{
			if (super.assetsLoadCallBack())
			{
				if (_needScale)
				{
					_disObj.scaleX = _scaleX;
					_disObj.scaleY = _scaleY;
					
					Bitmap(_disObj).smoothing = true;
				}
				
				return true;
			}
			
			return false;
		}
		
		// public ////
		override public function reset():void
		{
			super.reset();
			_curType = -1;
			_txtCount.visible = true;
			_txtCount.text = "";
			_showCount = true;
			_showName = false;
			this.filters = null;
			if (_disObj.scaleX != 1) _disObj.scaleX = 1;
			if (_disObj.scaleY != 1) _disObj.scaleY = 1;
			_$width = 64;
			_$height = 64;
			_needScale = false;
			_scaleX = _scaleY = 1;
			_itemName.text = "";
		}
		
		// getter && setter ////
		override public function set data(value:Object):void
		{
			_curType = value["type"];
			_showCount = value.hasOwnProperty("showCount") ? value["showCount"] : true;
			_showName = value.hasOwnProperty("showName") ? value["showName"] : false;
			
			if (value["type"] == ItemLite.FOR_TASK)
			{
				// 图片名称├4┤道具名称├4┤道具描述├4┤数量
				_data = _dataParser.parseData(value["data"], 4);
			}
			_toolTip = "<font size='16'><b>" + _data[1] + "</b></font>|" + _data[2];
			
			if (_showCount) _txtCount.text = _data[3];
			
			if (_showName)
			{
				_itemName.text = _data[1];
				_itemName.x = (_$width - _itemName.textWidth) / 2;
			}
			
			if (value.hasOwnProperty("scale"))
			{
				_needScale = true;
				_scaleX = _data[4];
				_scaleY = _data[5];
				_$width *= _scaleX;
				_$height *= _scaleY;
			}
			
			
			_txtCount.x = _$width - _txtCount.textWidth - 4;
			_txtCount.y = _$height - _txtCount.textHeight + 2;
			
			loadResByFullURL(ResourceLocater.ITEM_ICON_ROOT + _data[0]);
		}

		public function get itemName():String
		{
			return _data[1];
		}
		
		public function set itemCount(value:int):void
		{
			_data[3] = value;
			_txtCount.text = value.toString();
		}
		
		public function get itemCount():int
		{
			return int(_data[3]);
		}
		public function get itemCode():int
		{
			return _data[4];
		}
		//道具id
		public function get ItemId():int
		{
			return int(_data[8]);
		}
		public function get itemId():int
		{
			return _itemId;
		}

	}
}