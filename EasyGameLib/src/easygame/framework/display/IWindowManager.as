package easygame.framework.display
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 5:49:30 PM
	 * description 抽象窗体管理器接口
	 **/
	public interface IWindowManager
	{
		/**
		 * 窗体数据刷新 
		 * @param v
		 * 
		 */		
		function refresh(v:*= null):void;
		
		/**
		 * 打开一个窗体 
		 * @param o
		 * @param parent
		 * @param modal
		 * @param x
		 * @param y
		 * 
		 */		
		function open(o:Object=null, 
					  parent:DisplayObjectContainer=null, 
					  modal:Boolean=false, 
					  x:int=-1, 
					  y:int = -1):void;
		
		/**
		 * 舞台大小改变事件处理方法 
		 * @param x
		 * @param y
		 * 
		 */		
		function onResize(x:int = -1, y:int = -1):void;
		
		/**
		 * 关闭窗体 
		 * 
		 */		
		function close():void;
		
		
		/**
		 * 是否屏蔽组件的事件响应 
		 * @param block
		 * 
		 */		
		function blockEvt(block:Boolean):void;
		
		/**
		 * 窗体是否处于激活状态（即是否打开） 
		 * @return 
		 * 
		 */		
		function get active():Boolean;
	}
}