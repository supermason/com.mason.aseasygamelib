package easygame.framework.text
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 3:17:50 PM
	 * description 文本样式管理器
	 **/
	public class TxtFormatManager
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		private static var _instance:TxtFormatManager;
		private var _dtf:TextFormat;
		private var _gameTF:TextFormat;
		private var _slideTipTF:TextFormat;
		private var _rightAlignTF:TextFormat;
		private var _globalFont:String = "Microsoft YaHei,微软雅黑";
		private var _underlineDTF:TextFormat;
		
//		private var _dtf_bold_italic_22:TextFormat;
//		private var _dtf_bold_italic_34:TextFormat;
//		private var _dtf_bold_italic_27:TextFormat;
//		private var _dtf_bold_24:TextFormat;
//		private var _dtf_bold_24_ffef01:TextFormat;
//		private var _dtf_bold_14:TextFormat;
//		private var _dtf_bold_14_ffffff:TextFormat;
//		private var _dtf_bold_14_acbdc6:TextFormat;
//		private var _dtf_bold_14_452600:TextFormat;
//		private var _dtf_bold_30:TextFormat;
//		private var _dtf_bold_30_ffef01:TextFormat;
//		private var _dtf_bold_18:TextFormat;
//		private var _dtf_bold_18_dbff8e:TextFormat;
//		private var _dtf_bold_16_3A526E:TextFormat;
//		private var _dtf_bold_18_C95C01:TextFormat;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function TxtFormatManager(se:SingletonEnforcer)
		{
			initTextFormat();
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		private function initTextFormat():void 
		{
			_dtf = createTF(0xffffff, _globalFont, 4, TextFormatAlign.LEFT);
			_slideTipTF = createTF(0xffff00, _globalFont, 4, TextFormatAlign.LEFT, 18, true);
			_rightAlignTF = createTF(0xffffff, _globalFont, 4, TextFormatAlign.RIGHT);
			
			_underlineDTF = createTF(0xffffff, _globalFont, 4, TextFormatAlign.LEFT);
			_underlineDTF.underline = true;
			
//			_dtf_bold_italic_22 = createTF(0xffffff, _globalFont, 4, TextFormatAlign.LEFT, 22, true, true);
//			_dtf_bold_italic_34 = createTF(0xffffff, _globalFont, 4, TextFormatAlign.LEFT, 34, true, true);
//			_dtf_bold_italic_27 = createTF(0xffffff, _globalFont, 4, TextFormatAlign.LEFT, 27, true, true);
//			_dtf_bold_24 = createTF(0xffffff, _globalFont, 4, TextFormatAlign.CENTER, 24, true);
//			_dtf_bold_24_ffef01 = createTF(0xffef01, _globalFont, 4, TextFormatAlign.CENTER, 24, true);
//			_dtf_bold_14 = createTF(0xA1C7DC, _globalFont, 4, TextFormatAlign.LEFT, 14, true);
//			_dtf_bold_14_ffffff = createTF(0xffffff, _globalFont, 4, TextFormatAlign.LEFT, 14, true);
//			_dtf_bold_14_acbdc6 = createTF(0xacbdc6, _globalFont, 4, TextFormatAlign.LEFT, 14, true);
//			_dtf_bold_14_452600 = createTF(0x452600, _globalFont, 4, TextFormatAlign.LEFT, 14, true);
//			_dtf_bold_30 = createTF(0xffffff, _globalFont, 4, TextFormatAlign.CENTER, 30, true);
//			_dtf_bold_30_ffef01 = createTF(0xffef01, _globalFont, 4, TextFormatAlign.CENTER, 30, true);
//			_dtf_bold_18 = createTF(0xffffff, _globalFont, 4, TextFormatAlign.LEFT, 18, true);
//			_dtf_bold_18_dbff8e = createTF(0xdbff8e, _globalFont, 4, TextFormatAlign.LEFT, 18, true);
//			
//			_dtf_bold_16_3A526E = createTF(0x3A526E, _globalFont, 4, TextFormatAlign.LEFT, 16, true);
//			_dtf_bold_18_C95C01 = createTF(0xC95C01, _globalFont, 4, TextFormatAlign.LEFT, 18, true);
		}
		
		private function createTF(color:uint, font:String, leading:uint, align:String, size:Object=null, bold:Object=null, italic:Object=null):TextFormat
		{
			var tf:TextFormat = new TextFormat();
			tf = new TextFormat();
			tf.color = color;
			tf.font = font;
			tf.leading = leading;
			tf.align = align;
			tf.size = size;
			tf.bold = bold;
			tf.italic = italic;
			
			return tf;
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 获取单例对象
		 */
		public static function get instance():TxtFormatManager
		{
			if (!_instance)
				_instance = new TxtFormatManager(new SingletonEnforcer());
			
			return _instance;
		}
		
		/**
		 * 全局字体 
		 * @return 
		 */		
		public function get globalFont():String 
		{
			return _globalFont;
		}

		/**
		 * 获取默认的字体样式对象 
		 * @return 
		 */		
		public function get defaultTextFormat():TextFormat 
		{
			return _dtf;
		}
		
		/**
		 * 获取右对齐的字体样式对象 
		 * @return 
		 */		
		public function get rightAlignTF():TextFormat 
		{
			return _rightAlignTF;
		}

		/**
		 * 滑屏提示字体样式 
		 * @return 
		 * 
		 */		
		public function get slideTipTF():TextFormat
		{
			return _slideTipTF;
		}

		/**
		 * 带下划线的字体格式 
		 * @return 
		 * 
		 */		
		public function get underlineDTF():TextFormat
		{
			return _underlineDTF;
		}

//		/**
//		 * 加粗斜体22号 
//		 * @return 
//		 * 
//		 */		
//		public function get dtf_bold_italic_22():TextFormat
//		{
//			return _dtf_bold_italic_22;
//		}
//		/**
//		 * 加粗斜体34号 
//		 * @return 
//		 * 
//		 */	
//		public function get dtf_bold_italic_34():TextFormat
//		{
//			return _dtf_bold_italic_34;
//		}
//		/**
//		 * 加粗斜体27号 
//		 * @return 
//		 * 
//		 */	
//		public function get dtf_bold_italic_27():TextFormat
//		{
//			return _dtf_bold_italic_27;
//		}
//		/**
//		 * 粗体24号 
//		 * @return 
//		 * 
//		 */
//		public function get dtf_bold_24():TextFormat
//		{
//			return _dtf_bold_24;
//		}
//		/**
//		 * 粗体14号 
//		 * @return 
//		 * 
//		 */
//		public function get dtf_bold_14():TextFormat
//		{
//			return _dtf_bold_14;
//		}
//		/**
//		 * 粗体30号 
//		 * @return 
//		 * 
//		 */
//		public function get dtf_bold_30():TextFormat
//		{
//			return _dtf_bold_30;
//		}
//		/**
//		 * 粗体18号 
//		 * @return 
//		 * 
//		 */
//		public function get dtf_bold_18():TextFormat
//		{
//			return _dtf_bold_18;
//		}
//		/**
//		 * 粗体18号 + 0xdbff8e
//		 * @return 
//		 * 
//		 */
//		public function get dtf_bold_18_dbff8e():TextFormat
//		{
//			return _dtf_bold_18_dbff8e;
//		}
//		/**
//		 * 粗体14号  + 0xacbdc6
//		 * @return 
//		 * 
//		 */
//		public function get dtf_bold_14_acbdc6():TextFormat
//		{
//			return _dtf_bold_14_acbdc6;
//		}
//		/**
//		 * 粗体14号  + ffffff
//		 * @return 
//		 * 
//		 */
//		public function get dtf_bold_14_ffffff():TextFormat
//		{
//			return _dtf_bold_14_ffffff;
//		}
//		/**
//		 * 粗体16号 + #3A526E 
//		 * @return 
//		 * 
//		 */
//		public function get dtf_bold_16_3A526E():TextFormat
//		{
//			return _dtf_bold_16_3A526E;
//		}
//		/**
//		 * 粗体18+ C95C01
//		 * @return 
//		 * 
//		 */
//		public function get dtf_bold_18_C95C01():TextFormat
//		{
//			return _dtf_bold_18_C95C01;
//		}
//		/**
//		 * 粗体24号+ ffef01
//		 * @return 
//		 * 
//		 */		
//		public function get dtf_bold_24_ffef01():TextFormat
//		{
//			return _dtf_bold_24_ffef01;
//		}
//		/**
//		 * 粗体30号+ ffef01
//		 * @return 
//		 * 
//		 */	
//		public function get dtf_bold_30_ffef01():TextFormat
//		{
//			return _dtf_bold_30_ffef01;
//		}
//
//		/**
//		 * 
//		 * @return 
//		 * 
//		 */		
//		public function get dtf_bold_14_452600():TextFormat
//		{
//			return _dtf_bold_14_452600;
//		}


	}
}

class SingletonEnforcer {};