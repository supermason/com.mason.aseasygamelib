package com.company.projectname.game.ui.component
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Feb 28, 2014 4:22:57 PM
	 * description: 	
	 **/
	public class ProgressButton extends PrettySimpleButton
	{
		private var _matrix:Matrix;
		private var _cover:Shape;
		private var _g:Graphics;
		
		public function ProgressButton(btnType:String="SmallButton", needTxt:Boolean=true, useFilter:Boolean=true, initEvtWhenCreate:Boolean=true)
		{
			super(btnType, needTxt, useFilter, initEvtWhenCreate);
			
			createProgressBar();
		}
		
		// protected ////
		
		protected function createProgressBar():void
		{
			_cover = new Shape();
			_g = _cover.graphics;
			
			addCover();
			
//			_colorTransform = new ColorTransform(143, 143, 143, .8, 143, 143, 143);
			// tx和ty就等价于xy
			// a和d就等价于scaleX、scaleY
			// b和c是用来倾斜的(bY轴倾斜，cX轴倾斜)
			// 360°=2π弧度
			// 角度 * Math.PI / 180 = 弧度
			_matrix = new Matrix(1, 0, -Math.tan(11 * Math.PI / 180), 1, 7);
			_cover.transform.matrix = _matrix;
			
		}
		
		protected function addCover():void
		{
			if (_btnTxt)
			{
				// 这个层要在文字的下面
				addChildAt(_cover, getChildIndex(_btnTxt));
			}
			else
			{
				addChild(_cover);
			}
		}
		
		// public ////
		/**
		 * 设置按钮可用进度，并自动 
		 * @param value
		 * 
		 */		
		public function set progress(value:Number):void
		{
			_enabled = value >= 0;
			
			if (_enabled)
			{
				_g.clear();
			}
			else
			{
				drawCover(Math.abs(value));
			}
		}
		
		// private ////
		private function drawCover(value:Number):void
		{
			_g.clear();
			_g.beginFill(0x000000, .7);
			_g.drawRoundRect(0, 0, Math.ceil(_buttonSkin.width * value - 7), _buttonSkin.height - 2, 8, 8);
			_g.endFill();
			
		}
	}
}