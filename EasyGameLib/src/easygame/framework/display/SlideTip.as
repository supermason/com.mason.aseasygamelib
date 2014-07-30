package easygame.framework.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import easygame.framework.text.GameText;
	
	/**
	 * ...
	 * @author Mason
	 */
	public class SlideTip extends NoEventSprite implements ISlideTip 
	{
		private var _tipX:int = 0;
		private var _tipY:int = 0;
		private var _tipBgImg:Bitmap;
		private var _tipImage:Bitmap;
		private var _tipInfo:GameText;
		private var _defaultBgWidth:int;
		
		public function SlideTip() 
		{
			super();
		}
		
		override protected function init():void
		{
			super.init();
			
			_tipImage = new Bitmap();
			_tipInfo = new GameText();
			_tipInfo.y = 8;
			_tipInfo.textColor = 0xa1c7dc;
//			_tipInfo.defaultTextFormat = TxtFormatManager.instance.slideTipTF;
			
			addChild(_tipImage);
			addChild(_tipInfo);
		}
		
		// public ////
		public function setMessage(msg:String, image:BitmapData = null):void 
		{
			this.alpha = 0;
			_tipInfo.htmlText = msg;
//			if (image)
//			{
//				_tipImage.bitmapData = image;
//				_tipImage.x = 10;
//				_tipImage.y = (_tipBgImg.height - _tipImage.height) / 2;
//				_tipInfo.width = _tipBgImg.width - 20 - _tipImage.width - _tipImage.x;
//				_tipInfo.height = _tipBgImg.height - 20;
//				_tipInfo.x = (_tipBgImg.width - (_tipImage.width + _tipImage.x) - _tipInfo.textWidth) / 2 + (_tipImage.width + _tipImage.x) - 5;
//				_tipInfo.y = (_tipBgImg.height - _tipInfo.textHeight) / 2;
//			}
//			else
//			{
//				_tipInfo.width = _tipBgImg.width - 20;
//				_tipInfo.height = _tipBgImg.height - 20;
//				_tipInfo.x = (_tipBgImg.width - _tipInfo.textWidth) / 2;
//				_tipInfo.y = (_tipBgImg.height - _tipInfo.textHeight) / 2;
//			}
			
			var finalWidth:int = _tipInfo.textWidth + 20;
			
			if (image)
			{
				_tipImage.bitmapData = image;
				_tipImage.x = 24;
				_tipImage.y = (_tipBgImg.height - _tipImage.height) / 2;
				finalWidth += (24 + _tipImage.width + 7);
				_tipInfo.x = _tipImage.x + _tipImage.width + 7;
			}
			else
			{
//				_tipInfo.x = 7;
				
				_tipInfo.x = (_defaultBgWidth - _tipInfo.textWidth) / 2;
			}
			
			if (finalWidth < _defaultBgWidth)
				finalWidth = _defaultBgWidth;
			
			_tipBgImg.scaleX = finalWidth / _defaultBgWidth;
			_tipBgImg.smoothing = true;
		}
		
		override public function reset():void
		{
			super.reset();
			
			_tipInfo.htmlText = "";
			_tipInfo.x = _tipX;
			_tipInfo.y = _tipY;
			
			if (_tipImage.bitmapData)
			{
				_tipImage.bitmapData.dispose();
				_tipImage.bitmapData = null;
			}
		}
		
		// private  ////
		private function relocateUI():void
		{
//			_tipX = 10;
//			_tipY = 10;
//			_tipInfo.x = _tipX;
//			_tipInfo.y = _tipY;
//			_tipInfo.wordWrap = true;
//			_tipInfo.multiline = true;
		}
		
		// getter && setter ////
		
		public function set bgImage(value:BitmapData):void
		{
			if (!_tipBgImg)
			{
				_tipBgImg = new Bitmap();
				addChildAt(_tipBgImg, 0);
				
				_tipBgImg.bitmapData = value;
				_defaultBgWidth = _tipBgImg.width;
				relocateUI();
			}
		}
		
		public function set txtColor(value:uint):void
		{
			_tipInfo.textColor = value;
		}
		
		public function get isPopped():Boolean
		{
			return this.parent != null;
		}
	}

}