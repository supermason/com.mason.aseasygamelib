package easygame.framework.text
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Jan 17, 2014 10:37:15 AM
	 * description: 	
	 **/
	public class GameText extends TextField
	{
		public function GameText(useDefaultTXF:Boolean=true)
		{
			super();
			
			// 设置该值，使textWidth|textHeight生效
			this.autoSize = TextFieldAutoSize.LEFT;
			// 默认不可选中
			this.selectable = false;
			//
			this.mouseWheelEnabled = false;
			//
			this.mouseEnabled = false;
			//
			this.wordWrap = false;
			//
			this.multiline = false;
			//
			this.textColor = 0xFFFFFF;
			
			if (useDefaultTXF) this.defaultTextFormat = TxtFormatManager.instance.defaultTextFormat;
		}
		
		override public function set text(value:String):void
		{
			if (value != null)
				super.text = value;
		}
	}
}