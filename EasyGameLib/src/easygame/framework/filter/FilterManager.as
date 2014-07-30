package easygame.framework.filter
{
	import easygame.framework.util.ColorMatrix;
	
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 2:53:09 PM
	 * description 滤镜管理器
	 **/
	public class FilterManager
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		
		/**单例对象*/
		private static var _instance:FilterManager;
		
		/**黑色描边*/
		private var _black:GlowFilter;
		/**黄色描边*/
		private var _yellow:GlowFilter;
		private var _orange:GlowFilter;
		/**红色描边*/
		private var _red:GlowFilter;
		/** 绿色描边*/
		private var _green:GlowFilter;
		private var _green2:GlowFilter;
		/**灰色效果*/
		private var _grayEffect:ColorMatrixFilter;
		/**红色效果*/
		private var _redEffect:ColorMatrixFilter;
		/**阴影效果*/
		private var _dropDown:DropShadowFilter;
		private var _purpleEffect:ColorMatrixFilter;
		private var _goldenEffect:ColorMatrixFilter;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function FilterManager(se:SingletonEnforcer)
		{
			_black = new GlowFilter(0x000000,.8,2,2,1000);
			_yellow = new GlowFilter(0xffff6b,0.4,20,20);
			_orange = new GlowFilter(0xfe4200,1,15,15);
			_red = new GlowFilter(0xec1100, 0.4, 3, 3);
			_green = new GlowFilter(0x00ff00);
			_green2 = new GlowFilter(0x00ff00, .8, 15, 15, 2);
			_grayEffect = new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0]);
			_redEffect = new ColorMatrixFilter([0.9086, 0.9094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0]);
			_dropDown = new DropShadowFilter(2, 60, 0, .7);
			
			var colorMatrix:ColorMatrix = new ColorMatrix();
			colorMatrix.adjustBrightness(-10);
			colorMatrix.adjustContrast(10);
			colorMatrix.adjustSaturation(15);
			colorMatrix.adjustHue(65);
			_purpleEffect = new ColorMatrixFilter(colorMatrix);
			
			colorMatrix = new ColorMatrix();
			colorMatrix.adjustBrightness(87);
			colorMatrix.adjustContrast(57);
			colorMatrix.adjustSaturation(-5);
			colorMatrix.adjustHue(180);
			_goldenEffect = new ColorMatrixFilter(colorMatrix);
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		public static function get Instance():FilterManager
		{
			if (!_instance)
			{
				_instance = new FilterManager(new SingletonEnforcer());
			}
			
			return _instance;
		}
		
		/**黑色描边*/
		public function get black():GlowFilter
		{
			return _black;
		}
		/**黄色描边*/
		public function get yellow():GlowFilter
		{
			if (_yellow.inner)
				_yellow.inner = false;
			return _yellow;
		}
		/**黄色内描边*/
		public function getInnerYellow():GlowFilter
		{
			_yellow.inner = true;
			return _yellow;
		}
		/**红色描边*/
		public function get red():GlowFilter
		{
			if (_red.inner)
				_red.inner = false;
			return _red;
		}
		/**红色内描边*/
		public function get innerRed():GlowFilter
		{
			_red.inner = true;
			return _red;
		}
		/**绿色描边*/
		public function get green():GlowFilter
		{
			if (_green.inner)
				_green.inner = false;
			return _green;
		}
		/**绿色内描边*/
		public function get innerGreen():GlowFilter
		{
			_green.inner = true;
			return _green;
		}
		/**绿色描边2*/
		public function get green2():GlowFilter
		{
			return _green2;
		}
		/**灰色效果*/
		public function get grayEffect():ColorMatrixFilter
		{
			return _grayEffect;
		}
		
		/**红色效果*/
		public function get redEffect():ColorMatrixFilter
		{
			return _redEffect;
		}
		
		/**阴影效果*/
		public function get dropDown():DropShadowFilter 
		{
			return _dropDown;
		}

		/**紫色滤镜*/
		public function get purpleEffect():ColorMatrixFilter
		{
			return _purpleEffect;
		}

		/**橘黄色*/
		public function get orange():GlowFilter
		{
			return _orange;
		}

		public function get goldenEffect():ColorMatrixFilter
		{
			return _goldenEffect;
		}

	}
}

class SingletonEnforcer {}