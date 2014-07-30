package easygame.framework.util
{
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Mason
	 */
	public class EventUtil 
	{
		/**
		 * 为一个容器内的某一类型的显示对象添加或者移除某个鼠标事件
		 * @param	container
		 * @param	eventType
		 * @param	compClz
		 * @param	add
		 * @param	eventHandler
		 */
		public static function forbidMouseEvent(container:DisplayObjectContainer, eventType:String, compClz:Class, add:Boolean, eventHandler:Function):void
		{
			var len:int = container.numChildren;
			
			while (--len >= 0)
			{
				if (container.getChildAt(len) is compClz)
				{
					if (add)
						container.getChildAt(len).addEventListener(eventType, eventHandler);
					else
						container.getChildAt(len).removeEventListener(eventType, eventHandler);
				}
			}
		}
		
		/**
		 * 取消一个容器内所有子组件的鼠标事件响应功能 
		 * @param container
		 * 
		 */		
		public static function forbidChildrenEvt(container:DisplayObjectContainer):void
		{
			container.mouseChildren = false
		}
	}
}