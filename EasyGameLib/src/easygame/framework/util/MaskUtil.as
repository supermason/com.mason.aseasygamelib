package easygame.framework.util
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * ...
	 * @author Mason
	 */
	public class MaskUtil 
	{
		/**
		 * 为一个显示对象绘制遮罩层 
		 * @param disObj
		 * @return 
		 * 
		 */		
		public static function drawMask(disObj:DisplayObject):Sprite
		{
			var bmd:BitmapData = new BitmapData(disObj.width, disObj.height, true, 0);
			
			if (disObj is MovieClip)
				MovieClip(disObj).gotoAndStop(1);
			
			bmd.draw(disObj);
			
			return createMask(bmd);
		}
		
		/**
		 * 根据一张图片的有效像素点创建一个遮罩对象
		 * @param	bmd
		 * @return
		 */
		public static function createMask(bmd:BitmapData):Sprite
		{
			var ha:Sprite = new Sprite();
			ha.mouseChildren = false;
			ha.mouseEnabled = false;
			ha.visible = false;
			
			var g:Graphics = ha.graphics;
			g.beginFill(0x000000);
			
			bmd.lock();
			for (var i:int = 0, bmdW:int = bmd.width; i < bmdW; i++) 
			{
				for (var j:int = 0, bmdH:int = bmd.height; j < bmdH; j++) 
				{
					if (bmd.getPixel32(i, j))
						g.drawRect(i, j, 1, 1);
				}
			}
			bmd.unlock();
			
			g.endFill();
			
			bmd = null;
			
			return ha;
		}
		
	}

}