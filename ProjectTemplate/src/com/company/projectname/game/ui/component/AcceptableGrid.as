package com.company.projectname.game.ui.component
{
	import easygame.framework.dragdrop.IAcceptable;
	import easygame.framework.dragdrop.IDraggable;
	
	import flash.display.DisplayObject;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 26, 2013 10:06:38 AM
	 * description: 支持接收拖拽对象的格子容器基类
	 **/
	public class AcceptableGrid extends GameDisObjBase implements IAcceptable
	{
		/**
		 * 可拖拽对象在IAcceptable内部显示列表中的索引
		 * 在执行了isOcuppied方法后会将索引值赋给该值
		 * 方便方法content内部的使用
		 */
		protected var _contentIndex:int = -1;
		protected var _acceptType:Class;
		
		public function AcceptableGrid(assetsType:int, buttonMode:Boolean=false)
		{
			super(assetsType, buttonMode);
		}
		
		// public ////
		override public function reset():void
		{
			if (isOcuppied)
				IDraggable(content).reset();
			
			super.reset();
		}
		
		public function canAccept(itemDragged:DisplayObject):Boolean 
		{
			return itemDragged is accetpType;
		}
		
		/**
		 * 接收一个拖拽物体
		 * 
		 * <p> 内部会调用<code>isOcuppied</code>方法判断当前的格子是否被占用，并在内部调用了方法<code>addItem</code>
		 * 
		 * @param	itemDragged
		 */
		public function accept(itemDragged:DisplayObject):void 
		{
			// 如果当前被占用，则互换content
			if (isOcuppied)
			{
				if (itemDragged.parent)
					IAcceptable(itemDragged.parent).addItem(content);
				else
					removeItem();
			}
			
			addItem(itemDragged);
		}
		
		/**
		 * 添加一个拖拽物体
		 * 
		 * <p>不会检测当前格子是否被占用 ，内部调用<code>addChild</code>方法将拖拽物体加入显示列表
		 * 
		 * <p> 子类可以重写该方法，实现定位等操作
		 * 
		 * @param itemDragged
		 * 
		 */		
		public function addItem(itemDragged:DisplayObject):void
		{
			addChild(itemDragged);
		}
		
		public function removeItem():void
		{
			
		}
		
		// getter && setter ////
		
		public function get accetpType():Class 
		{
			return _acceptType;
		}
		
		public function get isOcuppied():Boolean 
		{
			_contentIndex = -1;
			// 遍历，看看是否孩子中有可拖拽对象
			// 倒着遍历速度快，因为可拖拽对象应该是最后addChild的元素
			for (var i:int = this.numChildren - 1; i >= 0; i--)
			{
				if (this.getChildAt(i) is IDraggable)
				{
					_contentIndex = i;
					return true;
				}
			}
			
			return false;
		}
		
		public function get content():DisplayObject 
		{
			// 如果是在检查是否占用状态后获取孩子对象
			// 则直接返回保存的显示位置对应的子对象
			if (_contentIndex != -1)
			{
				return this.getChildAt(_contentIndex);
			}
			else
			{
				// 这里改为查找IDraggable对象
				var disObj:DisplayObject = null;
				for (var i:int = this.numChildren - 1; i >= 0; i--)
				{
					disObj = this.getChildAt(i);
					if (disObj is IDraggable)
						break;
					
					disObj = null; // 这里必须设置为null，因为它已经被赋值
				}
				
				return disObj;
			}
		}
	}
}