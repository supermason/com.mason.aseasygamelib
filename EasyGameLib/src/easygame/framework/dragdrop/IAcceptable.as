package easygame.framework.dragdrop
{
	import flash.display.DisplayObject;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 2:39:47 PM
	 * description 支持接收容器接口
	 **/
	public interface IAcceptable
	{
		/**可以接受的拖拽对象类型*/
		function get accetpType():Class;
		/**是否被占用*/
		function get isOcuppied():Boolean;
		/**内部包含的可拖拽对象*/
		function get content():DisplayObject;
		/**是否可以接收放置*/
		function canAccept(itemDragged:DisplayObject):Boolean;
		/**
		 * 接受一次放置
		 * 
		 * <p> 该方法内部建议调用<code>isOcuppied</code>进行检测
		 *  
		 * @param itemDragged
		 * 
		 */		
		function accept(itemDragged:DisplayObject):void;
		/**
		 * 添加一个拖拽对象
		 * 
		 * <p>与<code>accept</code>的区别在于该方法内部不会判断当前接收的格子是否被占用
		 *  
		 * @param itemDragged
		 * 
		 */		
		function addItem(itemDragged:DisplayObject):void;
		
		function removeItem():void;
	}
}