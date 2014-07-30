package easygame.framework.display
{
	import flash.display.Graphics;
	import flash.display.Stage;
	
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 6:15:16 PM
	 * description 游戏内遮罩组建
	 **/
	public class UICover extends GameSprite
	{
		private var g:Graphics;
		
		public function UICover() 
		{
			super();
		}
		
		
		
//		01.//从beginFill开始填充颜色，封闭路径内 不填充 所以得到一个中间镂空的遮罩层 
//		02.graphics.clear();    
//		03.graphics.lineStyle(0); 
//		04.graphics.beginFill(0x000000,0.4);//背景颜色和透明度 
//		05. 
//		06.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);  //以舞台宽高画背景 
//		07.graphics.lineStyle(3,0xff0000); //画一个镂空的框 
//		08.graphics.drawRect(200,200,50,50);//在200，200处画一个框 
//		09. 
//		10.graphics.endFill(); //结束填充 

		// public ////
		
		public function show(stage:Stage, alpha:Number=.05, color:uint=0x000000, endFill:Boolean=true):void
		{
			g.clear();
			g.beginFill(color, alpha);
			g.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			if (endFill) g.endFill();
		}
		
		public function drawRect(x:int, y:int, w:int, h:int, color:uint=0x000000, alpha:Number=.05):void
		{
			g.lineStyle(1, color, 0);
			g.drawRect(x, y, w, h);
			g.endFill();
		}
		
		public function remove():void
		{
			g.clear();
		}
		
		// protected ////
		override protected function init():void
		{
			g = this.graphics;
		}
	}
}