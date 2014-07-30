package easygame.framework.animation
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 3:03:28 PM
	 * description 时间驱动器
	 **/
	public class Juggler 
	{
		
		private var mObjects:Vector.<IAnimatable>;
		private var mElapsedTime:Number;
		
		/** Create an empty juggler. */
		public function Juggler()
		{
			mElapsedTime = 0;
			mObjects = new <IAnimatable>[];
		}
		
		/** Adds an object to the juggler. */
		public function add(object:IAnimatable):void
		{
			if (object && mObjects.indexOf(object) == -1) 
			{
				mObjects.push(object);
			}
		}
		
		/** Determines if an object has been added to the juggler. */
		public function contains(object:IAnimatable):Boolean
		{
			return mObjects.indexOf(object) != -1;
		}
		
		/** Removes an object from the juggler. */
		public function remove(object:IAnimatable):void
		{
			if (object == null) return;
			
			var index:int = mObjects.indexOf(object);
			if (index != -1) mObjects[index] = null;
		}
		
		/** Removes all objects at once. */
		public function purge():void
		{
			// the object vector is not purged right away, because if this method is called 
			// from an 'advanceTime' call, this would make the loop crash. Instead, the
			// vector is filled with 'null' values. They will be cleaned up on the next call
			// to 'advanceTime'.
			
			for (var i:int=mObjects.length-1; i>=0; --i)
			{
				mObjects[i] = null;
			}
		}
		
		/** Advances all objects by a certain time (in seconds). */
		public function advanceTime(passedTime:Number):void
		{   
			var numObjects:int = mObjects.length;
			var currentIndex:int = 0;
			var i:int;
			
			mElapsedTime += passedTime;
			if (numObjects == 0) return;
			
			// there is a high probability that the "advanceTime" function modifies the list 
			// of animatables. we must not process new objects right now (they will be processed
			// in the next frame), and we need to clean up any empty slots in the list.
			
			for (i=0; i<numObjects; ++i)
			{
				var object:IAnimatable = mObjects[i];
				if (object)
				{
					// shift objects into empty slots along the way
					if (currentIndex != i) 
					{
						mObjects[currentIndex] = object;
						mObjects[i] = null;
					}
					
					object.advanceTime(passedTime);
					++currentIndex;
				}
			}
			
			if (currentIndex != i)
			{
				numObjects = mObjects.length; // count might have changed!
				
				while (i < numObjects)
					mObjects[int(currentIndex++)] = mObjects[int(i++)];
				
				mObjects.length = currentIndex;
			}
		}
		
		/** The total life time of the juggler. */
		public function get elapsedTime():Number { return mElapsedTime; }    
	}
}