package easygame.framework.text
{
	import easygame.framework.filter.FilterManager;
	
	/** 
	 * @author: mason
	 * @E-mail: jijiiscoming@hotmail.com
	 * @version 1.0.0 
	 * 创建时间：Jul 2, 2014 10:51:34 AM 
	 * 描述：
	 * */
	public class BorderTextField extends GameText
	{
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 默认创建一个黑色描边的文本 
		 * @param borderColor
		 * 
		 */	
		public function BorderTextField(borderColor:String="black", useBorder:Boolean=false, useDefaultTxf:Boolean=true)
		{
			super(useDefaultTxf);
			
			if (useBorder) addBorder(borderColor);
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		private function addBorder(borderColor:String):void 
		{
			if (borderColor == TxfBorderColor.BLACK)
				this.filters = [FilterManager.Instance.black];
			else if (borderColor == TxfBorderColor.RED)
				this.filters = [FilterManager.Instance.red];
			else if (borderColor == TxfBorderColor.YELLOW)
				this.filters = [FilterManager.Instance.yellow];
		}
	}
}