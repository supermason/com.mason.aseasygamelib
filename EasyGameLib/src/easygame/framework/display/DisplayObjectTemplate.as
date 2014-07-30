package easygame.framework.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	
	/** 
	 * @author: mason
	 * @E-mail: jijiiscoming@hotmail.com
	 * @version 1.0.0 
	 * 创建时间：May 15, 2014 10:42:39 AM 
	 * 描述：显示对象模版类
	 * */
	public class DisplayObjectTemplate implements IDisplay
	{
		public function DisplayObjectTemplate()
		{
		}
		
		public function addChild(child:DisplayObject):DisplayObject
		{
			return displayContent.addChild(child);
		}
		
		public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return displayContent.addChildAt(child, index);
		}
		
		public function removeChild(child:DisplayObject):DisplayObject
		{
			return displayContent.removeChild(child);
		}
		
		public function removeChildAt(index:int):DisplayObject
		{
			return displayContent.removeChildAt(index);
		}
		
		public function removeChildren(beginIndex:int = 0, endIndex:int = 0x7fffffff):void
		{
			displayContent.removeChildren(beginIndex, endIndex);
		}
		
		public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			displayContent.swapChildren(child1, child2);
		}
		
		public function swapChildrenAt(index1:int, index2:int):void
		{
			displayContent.swapChildrenAt(index1, index2);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			displayContent.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			displayContent.removeEventListener(type, listener, useCapture);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return displayContent.hasEventListener(type);
		}
		
		public function contains(child:DisplayObject):Boolean
		{
			return displayContent.contains(child);
		}
		
		public function getChildAt(index:int):DisplayObject
		{
			return displayContent.getChildAt(index);
		}
		
		public function getChildByName(name:String):DisplayObject
		{
			return displayContent.getChildByName(name);
		}
		
		public function getChildIndex(child:DisplayObject):int
		{
			return displayContent.getChildIndex(child);
		}
		
		public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void
		{
			if (displayContent is Sprite)
			{
				return Sprite(displayContent).startDrag(lockCenter, bounds);
			}
		}
		
		public function stopDrag():void
		{
			if (displayContent is Sprite)
			{
				return Sprite(displayContent).stopDrag();
			}
		}
		
		public function reset():void
		{
			
		}
		
		/**
		 * 无需实现该方法 
		 */
		public function destory():void
		{
		}
		
		// getter && setter ///
		
		public function get x():Number
		{
			return displayContent.x;
		}
		
		public function set x(value:Number):void
		{
			displayContent.x = value;
		}
		
		public function get y():Number
		{
			return displayContent.y;
		}
		
		public function set y(value:Number):void
		{
			displayContent.y = y;
		}
		
		public function get visible():Boolean
		{
			return displayContent.visible;
		}
		
		public function set visible(value:Boolean):void
		{
			displayContent.visible = value;
		}
		
		public function get alpha():Number
		{
			return displayContent.alpha;
		}
		
		public function set alpha(value:Number):void
		{
			displayContent.alpha = value;
		}
		
		public function get width():Number
		{
			return displayContent.width;
		}
		
		public function set width(value:Number):void
		{
			displayContent.width = value;
		}
		
		public function get height():Number
		{
			return displayContent.height;
		}
		
		public function set height(value:Number):void
		{
			displayContent.height = value;
		}
		
		public function get scaleX():Number
		{
			return displayContent.scaleX;
		}
		
		public function set scaleX(value:Number):void
		{
			displayContent.scaleX = value;
		}
		
		public function get scaleY():Number
		{
			return displayContent.scaleY;
		}
		
		public function set scaleY(value:Number):void
		{
			displayContent.scaleY = value;
		}
		
		public function get mouseEnabled():Boolean
		{
			return displayContent.mouseEnabled;
		}
		
		public function set mouseEnabled(value:Boolean):void
		{
			displayContent.mouseEnabled = value;
		}
		
		public function get mouseChildren():Boolean
		{
			return displayContent.mouseChildren;
		}
		
		public function set mouseChildren(value:Boolean):void
		{
			displayContent.mouseChildren = value;
		}
		
		public function get scrollRect():Rectangle
		{
			return displayContent.scrollRect;
		}
		
		public function set scrollRect(value:Rectangle):void
		{
			displayContent.scrollRect = value;
		}
		
		public function get parent():DisplayObjectContainer
		{
			return displayContent.parent;
		}
		
		public function get buttonMode():Boolean
		{
			if (displayContent is Sprite)
			{
				return Sprite(displayContent).buttonMode;
			}
			else
			{
				return false;
			}
		}
		
		public function set buttonMode(value:Boolean):void
		{
			if (displayContent is Sprite)
			{
				Sprite(displayContent).buttonMode = value;
			}
		}
		
		public function get graphics():Graphics
		{
			if (displayContent is Sprite)
			{
				return Sprite(displayContent).graphics;
			}
			else
			{
				return null;
			}
		}
		
		public function get numChildren():int
		{
			return displayContent.numChildren;
		}
		
		public function get filters():Array
		{
			return displayContent.filters;
		}
		
		public function set filters(value:Array):void
		{
			displayContent.filters = value;
		}
		
		public function get stage():Stage
		{
			return displayContent.stage;
		}
		
		/**
		 * 显示对象（子类必须重写该方法）
		 * 
		 * <p><code>easygame.framework.display.DisplayObjectTemplate::displayContent()</code>方法默认返回null</p>
		 * @return 
		 * 
		 */		
		public function get displayContent():DisplayObjectContainer
		{
			return null;
		}
	}
}