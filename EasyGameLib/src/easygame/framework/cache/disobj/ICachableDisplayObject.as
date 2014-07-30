package easygame.framework.cache.disobj
{
	import easygame.framework.display.IDisplay;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 2:10:01 PM
	 * description 可缓存显示对象接口 
	 **/
	public interface ICachableDisplayObject extends IDisplay
	{		
		/**
		 * 为显示对象初始化事件监听器
		 */
		function addEvt():void;
		/**
		 * 移除给显示对象添加的事件监听器 
		 */		
		function removeEvt():void;
		/**
		 * 显示对象销毁 
		 */		
		function dispose():void;
		/**
		 * 初始化显示对象 
		 * @param d
		 */		
		function set data(d:Object):void;
		/**
		 * 设置显示对象业务逻辑处理方法 
		 * @param value
		 */		
		function set buziHandler(value:Function):void;
		/**
		 * 获取显示对象是否被选中
		 * @return 
		 */		
		function get selected():Boolean;
		/**
		 * 设置显示对象为选中状态 
		 * @param value
		 */		
		function set selected(value:Boolean):void;
		/**
		 * 元素在容器中的索引
		 * @return 
		 * 
		 */		
		function get index():int;
		/**
		 * @private
		 */		
		function set index(value:int):void;
	}
}