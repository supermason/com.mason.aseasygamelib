package easygame.framework.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	import easygame.framework.cache.ICachable;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 2:09:11 PM
	 * description 显示对象基础属性接口
	 **/
	public interface IDisplay extends ICachable
	{
		// public ////
		/**
		 *  Registers an event listener object with an EventDispatcher object so that the listener receives notification of an event.
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 
		 */		
		
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
		/**
		 * Removes a listener from the EventDispatcher object. 
		 * @param type
		 * @param listener
		 * @param useCapture
		 * 
		 */		
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void;
		
		/**
		 * Checks whether the EventDispatcher object has any listeners registered for a specific type of event.
		 * @param type
		 * @return 
		 * 
		 */		
		function hasEventListener(type:String):Boolean;
		
		/**
		 * Determines whether the specified display object is a child of the DisplayObjectContainer instance or the instance itself. 
		 * @param child
		 * @return 
		 * 
		 */		
		function contains(child:DisplayObject):Boolean;
		
		/**
		 * Adds a child DisplayObject instance to this DisplayObjectContainer instance. 
		 * @param child
		 * @return 
		 * 
		 */		
		function addChild(child:DisplayObject):DisplayObject;
		/**
		 * Adds a child DisplayObject instance to this DisplayObjectContainer instance. 
		 * @param child
		 * @param index
		 * @return 
		 * 
		 */		
		function addChildAt(child:DisplayObject, index:int):DisplayObject;
		/**
		 *  Removes the specified child DisplayObject instance from the child list of the DisplayObjectContainer instance.
		 * @param child
		 * @return 
		 * 
		 */		
		function removeChild(child:DisplayObject):DisplayObject;
		/**
		 * Removes a child DisplayObject from the specified index position in the child list of the DisplayObjectContainer.
		 * @param index
		 * @return 
		 * 
		 */		
		function removeChildAt(index:int):DisplayObject;
		/**
		 * Removes all child DisplayObject instances from the child list of the DisplayObjectContainer instance.
		 * @param beginIndex
		 * @param endIndex
		 * 
		 */		
		function removeChildren(beginIndex:int = 0, endIndex:int = 0x7fffffff):void;
		/**
		 * Swaps the z-order (front-to-back order) of the two specified child objects. 
		 * @param child1
		 * @param child2
		 * 
		 */		
		function swapChildren(child1:DisplayObject, child2:DisplayObject):void;
		/**
		 * Swaps the z-order (front-to-back order) of the child objects at the two specified index positions in the child list. 
		 * @param index1
		 * @param index2
		 * 
		 */		
		function swapChildrenAt(index1:int, index2:int):void;
		/**
		 * Returns the child display object instance that exists at the specified index.
		 * @param index
		 * @return 
		 * 
		 */		
		function getChildAt(index:int):DisplayObject;
		/**
		 * Returns the child display object that exists with the specified name.
		 * @param name
		 * @return 
		 * 
		 */		
		function getChildByName(name:String):DisplayObject;
		/**
		 * Returns the index position of a child DisplayObject instance. 
		 * @param child
		 * @return 
		 * 
		 */		
		function getChildIndex(child:DisplayObject):int;
		/**
		 * Lets the user drag the specified sprite. 
		 * @param lockCenter
		 * @param bounds
		 * 
		 */		
		function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void;
		/**
		 * Ends the startDrag() method. 
		 * 
		 */		
		function stopDrag():void; 
		
		// getter && setter ///////////////////////////////////////////////////////
		/**
		 * Indicates the x coordinate of the DisplayObject instance relative to the local coordinates of the parent DisplayObjectContainer. 
		 * @return 
		 * 
		 */		
		function get x():Number;
		function set x(value:Number):void;
		/**
		 * Indicates the y coordinate of the DisplayObject instance relative to the local coordinates of the parent DisplayObjectContainer. 
		 * @return 
		 * 
		 */		
		function get y():Number;
		function set y(value:Number):void;
		/**
		 *  Whether or not the display object is visible.
		 * @return 
		 * 
		 */		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		/**
		 * Indicates the alpha transparency value of the object specified.
		 * @return 
		 * 
		 */		
		function get alpha():Number;
		function set alpha(value:Number):void;
		/**
		 *  Indicates the width of the display object, in pixels.
		 * @return 
		 * 
		 */		
		function get width():Number;
		function set width(value:Number):void;
		/**
		 * Indicates the height of the display object, in pixels.
		 * @return 
		 * 
		 */		
		function get height():Number;
		function set height(value:Number):void;
		/**
		 * Indicates the horizontal scale (percentage) of the object as applied from the registration point.
		 * @return 
		 * 
		 */		
		function get scaleX():Number;
		function set scaleX(value:Number):void;
		/**
		 * Indicates the vertical scale (percentage) of an object as applied from the registration point of the object.
		 * @return 
		 * 
		 */		
		function get scaleY():Number;
		function set scaleY(value:Number):void;
		/**
		 * Specifies whether this object receives mouse, or other user input, messages.
		 * @return 
		 * 
		 */		
		function get mouseEnabled():Boolean;
		function set mouseEnabled(value:Boolean):void;
		/**
		 * Determines whether or not the children of the object are mouse, or user input device, enabled. 
		 * @return 
		 * 
		 */		
		function get mouseChildren():Boolean;
		function set mouseChildren(value:Boolean):void;
		/**
		 * The scroll rectangle bounds of the display object. 
		 * @return 
		 * 
		 */		
		function get scrollRect():Rectangle;
		function set scrollRect(value:Rectangle):void;
		/**
		 * [read-only] Indicates the DisplayObjectContainer object that contains this display object. 
		 * @return 
		 * 
		 */		
		function get parent():DisplayObjectContainer;
		/**
		 * Specifies the button mode of this sprite. 
		 * @return 
		 * 
		 */		
		function get buttonMode():Boolean;
		function set buttonMode(value:Boolean):void;
		/**
		 * [read-only] Returns the number of children of this object. 
		 * @return 
		 * 
		 */		
		function get numChildren():int;
		/**
		 * An indexed array that contains each filter object currently associated with the display object. 
		 * @return 
		 * 
		 */		
		function get filters():Array;
		function set filters(value:Array):void;
		/**
		 * [read-only] The Stage of the display object. 
		 * @return 
		 * 
		 */		
		function get stage():Stage;
		/**
		 * [read-only] Specifies the Graphics object that belongs to this sprite where vector drawing commands can occur.
		 * @return 
		 * 
		 */		
		function get graphics():Graphics;
		
		/**
		 * 获取显示对象 
		 * @return 
		 * 
		 */		
		function get displayContent():DisplayObjectContainer;
	}
}