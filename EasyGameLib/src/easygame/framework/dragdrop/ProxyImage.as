package easygame.framework.dragdrop
{
	import easygame.framework.display.NoEventSprite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 2:41:35 PM
	 * description 拖拽代理对象
	 **/
	public class ProxyImage extends NoEventSprite
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private var _image:Bitmap;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function ProxyImage()
		{
			super();
		}
		
		override protected function init():void
		{
			super.init();
			
			_image = new Bitmap();
			addChild(_image);
		}
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		/**
		 * 一次拖拽结束，重置资源 
		 */		
		override public function reset():void
		{
			super.reset();
			
			if (_image.bitmapData)
			{
				_image.bitmapData.dispose();
				_image.bitmapData = null;
			}
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 设置拖拽代理图片
		 * @param bmd
		 * 
		 */		
		public function set imageData(bmd:BitmapData):void
		{
			_image.bitmapData = bmd;
		}
	}
}