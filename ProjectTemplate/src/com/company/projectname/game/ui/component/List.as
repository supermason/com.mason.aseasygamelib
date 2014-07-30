package com.company.projectname.game.ui.component
{
	import easygame.framework.cache.disobj.ICachableDisplayObject;
	import easygame.framework.cache.disobj.DisObjCacheManager;
	
	import flash.display.Sprite;
	
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 11:11:06 AM
	 * description 列表基类
	 **/
	public class List extends Sprite
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _renderData:*;
		private var _contentList:Array;
		protected var _render:ICachableDisplayObject;
		protected var _index:int;
		private var _buziHandler:Function;
		private var _cacheClz:Class;
		private var _disObjCacheMgr:DisObjCacheManager;
		private var _preventRepetitiveClick:Boolean;
		private var _needIterate:Boolean;
		/**重置时是否移除所有组件的逻辑方法，即点击后无效*/
		private var _removeBuziHandlerWhenReset:Boolean;
		/**渲染结束后的回调方法*/
		private var _renderFinishCallBack:Function;
		/**移除一个对象后的回调方法*/
		private var _removeItemCallBack:Function;
		private var _resetWhenRender:Boolean;
		private var _autoScrollCallBack:Function;
		
		/**
		 * 元素垂直|水平方向上的间距[默认值0]
		 */
		private var _gap:Number = 0;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 构造方法 
		 * @param cacheClz 内部放置的可缓存显示对象的类型
		 * 
		 */		
		public function List(cacheClz:Class) 
		{
			super();
			
			_cacheClz = cacheClz;
			
			_contentList = [];
			
			_disObjCacheMgr = DisObjCacheManager.instance;
			_disObjCacheMgr.checkCache(cacheClz);
			
			_resetWhenRender = true;
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		
		/**
		 * 通过添加一个用于初始化元素的数据对象向列表中添加一个组件
		 * @param	o
		 */
		public function addRawItem(d:Object):void
		{
			_render = _disObjCacheMgr.getDisObj(_cacheClz);
			_render.index = _index;
			_render.buziHandler = renderClickHandler;
			_render.data = d;
			_contentList.push(_render);
			adjustRender();
			addChild(_render.displayContent);
			_index++;
		}
		
		/**
		 *  获取指定位置的显示对象
		 * @param	index
		 * @return
		 */
		public function getRenderAt(index:int):ICachableDisplayObject
		{
			if (index < 0) return null;
			if (index > _contentList.length - 1) return null;
			
			return _contentList[index];
		}
		
		/**
		 * 选中最后一个元素
		 */
		public function selectedLastItem():void
		{
			if (_contentList && _contentList.length > 0)
			{
				selectedIndex = _contentList.length - 1;
			}
		}
		
		/**
		 * 从列表中移除一个元素，该方法会自动调用被移除项的<code>reset()</code>方法
		 * @param item
		 * */
		public function remove(item:ICachableDisplayObject):void
		{
			if (contains(item.displayContent)) 
				removeChild(item.displayContent);
			
			var index:int = _contentList.indexOf(item);
			if (index >= 0)
			{
				_contentList.splice(index, 1);
				updateDisplayList(index, item);
			}
			
			item.reset();
			
			if (_renderFinishCallBack != null)
				_renderFinishCallBack();
		}
		/**
		 * 获取指定render在渲染列表中的索引位置
		 * */
		public function getRenderIndex(render:ICachableDisplayObject):int
		{
			return _contentList.indexOf(render);
		}
		/**
		 * 取消所有的元素的选中状态
		 */
		public function unselectAll():void
		{
			for each (var ici:ICachableDisplayObject in _contentList) 
			{
				ici.selected = false;
			}
		}
		/**
		 * 清理资源
		 */
		public function reset():void
		{
			for each (var ici:ICachableDisplayObject in _contentList) 
			{
				ici.selected = false;
				if (_removeBuziHandlerWhenReset)
					ici.buziHandler = null;
				ici.reset();
				ici.x = 0;
				ici.y = 0;
			}
			
			_contentList = [];
			
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			
			_render = null;
			_renderData = [];
			
			if (_removeBuziHandlerWhenReset)
				_buziHandler = null;
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		
		/**
		 * 渲染列表
		 */
		protected function render():void
		{
			_index = 0;
			
			for each (var d:Object in _renderData) 
			{
				addRawItem(d);
			}
			
			if (_renderFinishCallBack != null)
				_renderFinishCallBack();
			
			_render = null;
		}
		
		// 
		protected function adjustRender():void
		{
			
		}
		
		/**
		 * 移除一个元算后，更新显示列表
		 * 
		 * @param	removedIndex
		 * @param	removedItem
		 */
		protected function updateDisplayList(removedIndex:int, removedItem:ICachableDisplayObject):void 
		{
			if (removedIndex > _contentList.length - 1) return;
			
			var newX:int = removedItem.x, newY:int = removedItem.y;
			var oldX:int, oldY:int;
			
			for (var i:int = removedIndex, len:int = _contentList.length; i < len; ++i)
			{
				oldX = _contentList[i].x;
				oldY = _contentList[i].y;
				
				_contentList[i].x = newX;
				_contentList[i].y = newY;
				_contentList[i].index--;
				
				newX = oldX;
				newY = oldY;
			}
		}
		
		/*=======================================================================*/
		/* EVENT HANDLERS                                                        */
		/*=======================================================================*/
		/**
		 * 列表中对象点击事件处理方法 
		 * @param renderClicked
		 * 
		 */		
		protected function renderClickHandler(renderClicked:ICachableDisplayObject):void
		{
			if (_preventRepetitiveClick && _render == renderClicked)
				return;
			
			_render = renderClicked;
			subClassBuziHandler();
			if (_buziHandler != null)
				_buziHandler(_render);
		}
		
		/**子类中如果需要修改<code>contenClickHandler</code>方法，通常只用重写<code>subClassBuziHandler</code>即可*/
		protected function subClassBuziHandler():void
		{
			if (_needIterate) 
			{
				for each (var ici:ICachableDisplayObject in _contentList) 
				{
					if (ici != _render)
						ici.selected = false;
				}
				_render.selected = true;
			}
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 设置列表内容数据
		 */
		public function set contents(value:*):void
		{
			if (_resetWhenRender) reset();
			
			if (value && value.length > 0) 
			{
				_renderData = value;
				render();
			}
		}
		
		public function set businessHandler(value:Function):void
		{
			_buziHandler = value;
		}
		
		public function get needIterate():Boolean
		{
			return _needIterate;
		}
		
		/**
		 * 设置在内容被点击时是否允许迭代所有内容对象对于需要高亮显示选中项的列表来说，要设置为true默认为true
		 */
		public function set needIterate(value:Boolean):void
		{
			_needIterate = value;
		}
		/**获取渲染器对象列表*/
		public function get contentList():Array
		{
			return _contentList;
		}
		
		public function get preventRepetitiveClick():Boolean
		{
			return _preventRepetitiveClick;
		}
		
		/**设置是否防止渲染器被反复点击，默认为true不允许 */
		public function set preventRepetitiveClick(value:Boolean):void
		{
			_preventRepetitiveClick = value;
		}
		
		/**
		 * 设置选中项的索引，赋值会触发点击事件
		 * 
		 * <p>如果value小于0，则修正为0，如果value大于列表长度，则修正为length-1
		 * 
		 * <p>如果该列表放置于ScrollBar容器中， 且方法<code>_autoScrollCallBack</code>被赋值，则会触发该方法自动滚动滚动条
		 * */
		public function set selectedIndex(value:int):void
		{
			if (_contentList && _contentList.length > 0) // 列表内有数据
			{
				if (value > _contentList.length - 1) value = _contentList.length - 1;
				if (value < 0) value = 0;
				
				renderClickHandler(_contentList[value]); // 触发被点击事件
				
				if (_autoScrollCallBack != null && _render)
					_autoScrollCallBack(_render.y);
			}
		}
		
		public function get selectedIndex():int
		{
			if (_contentList && _contentList.length > 0 && _render)
			{
				return _contentList.indexOf(_render);
			}
			else
			{
				return -1;
			}
		}
		
		public function get gap():Number 
		{
			return _gap;
		}
		
		public function set gap(value:Number):void 
		{
			_gap = value;
		}
		
		/**
		 * 获取渲染结束的回调方法
		 */
		public function get renderFinishCallBack():Function 
		{
			return _renderFinishCallBack;
		}
		/**
		 * 设置渲染结束的回调方法[必须在给contents赋值前调用，否则只有在下次赋值时才有效]
		 */
		public function set renderFinishCallBack(value:Function):void 
		{
			_renderFinishCallBack = value;
		}
		
		/**
		 * 在清理资源时，是否清除内部的事件监听处理方法
		 * 一般情况无需将该值设置为true
		 */
		public function get removeBuziHandlerWhenReset():Boolean 
		{
			return _removeBuziHandlerWhenReset;
		}
		
		public function set removeBuziHandlerWhenReset(value:Boolean):void 
		{
			_removeBuziHandlerWhenReset = value;
		}

		/**在每次填充数据绘制列表时，都先reset一次，默认行为*/
		public function get resetWhenRender():Boolean
		{
			return _resetWhenRender;
		}

		/**
		 * @private
		 */
		public function set resetWhenRender(value:Boolean):void
		{
			_resetWhenRender = value;
		}

		/**当列表中的元素改变时，是否自动更加滚动条组建*/
		public function get autoScrollCallBack():Function
		{
			return _autoScrollCallBack;
		}

		/**
		 * @private
		 */
		public function set autoScrollCallBack(value:Function):void
		{
			_autoScrollCallBack = value;
		}


	}
}