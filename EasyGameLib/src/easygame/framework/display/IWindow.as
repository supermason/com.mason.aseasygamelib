package easygame.framework.display
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 5:49:03 PM
	 * description 抽象的窗体接口 
	 **/
	public interface IWindow extends IDisplay
	{
		/**
		 * 设置可视区域对象，方便窗体的定位
		 * @param value
		 * 
		 */		
		function set viewPort(value:IViewport):void;
		/**
		 * 窗体内业务逻辑统一出口 
		 * @param handler
		 * 
		 */		
		function set winEvtBuziHandler(handler:Function):void;
		/**
		 * 窗体皮肤创建完毕的回调方法 
		 * @param handler
		 * 
		 */		
		function set skinCreated(handler:Function):void;
		/**
		 * 窗体创建完毕的回调方法 
		 * @param handler
		 * 
		 */		
		function set winCreated(handler:Function):void;
		/**
		 * 窗体关闭的回调方法 
		 * @param handler
		 * 
		 */		
		function set winClosed(handler:Function):void;
		/**
		 * 窗体开始关闭的回调方法 
		 * @param handler
		 * 
		 */		
		function set winClosing(handler:Function):void;
		/**
		 * 设置窗体使用的数据 
		 * @param value
		 * 
		 */		
		function set contentData(value:Object):void;
		/**
		 * 设置窗体要用到的皮肤(URL路径) 
		 * @param url
		 * 
		 */		
		function set skinURL(url:String):void;
		/**
		 * 关闭窗体（调用该方法会触发winClosing和winClosed这两个回调方法） 
		 * 
		 */		
		function closeWindow():void;
		/**
		 * 内部调用方法，关闭窗体，调用该方法不会触发 winClosing和winClosed这两个回调方法
		 * @param remove
		 * 
		 */		
		function close(remove:Boolean):void;
		/**
		 * 重新打开一个窗体（窗体在关闭后不会被销毁，而是从显示列表移除，但保持一个对窗体的引用） 
		 * @param value
		 * 
		 */		
		function reOpen(value:Object):void;
		/**
		 * 刷新窗体数据 
		 * @param value
		 * 
		 */		
		function refresh(value:*=null):void;		
		/**
		 * 拖拽时屏蔽一些事件 
		 * @param block
		 * 
		 */		
		function blockEvt(block:Boolean):void;
		/**
		 * 是否支持鼠标按下时将当前窗体设置为最上层
		 */
		function get setTopWhenMouseDown():Boolean;
		/**
		 * @private
		 */
		function set setTopWhenMouseDown(value:Boolean):void;
	}
}