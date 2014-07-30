package com.company.projectname.game.ui.tips
{
	import com.company.projectname.SystemManager;
	import com.company.projectname.game.ui.component.GameDisObjBase;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	
	import easygame.framework.display.IPopUp;
	import easygame.framework.text.BorderTextField;
	
	/**
	 * ...
	 * @author Mason
	 */
	public class ToolTip extends GameDisObjBase implements IPopUp
	{
		private const DEFAULT_BLOCK_GAP:int = 10; // 内容块之间的间距
		private const TITLE_FIRST_BLOCK_GAP:int = 35; // 标题与第一个内容块之间的间距
		private const DEFAULT_WIDTH:int = 272; // 悬停背景默认的宽
		private const DEFAULT_TEXT_X:int = 20; // 文本显示内容默认的x坐标
		private const DEFAULT_TEXT_WIDTH:int = 240; // 默认的文本宽度
		private const TEXT_COUNT:int = 5; // 默认的文本数量
		
		private var _vars:Object;
		private var background:*;
		private var lines:Vector.<Bitmap>;
		private var info:Vector.<BorderTextField>;
		private var ttH:int = 0; // 用于计算整个toolTip高的临时变量
		private var minXAllowed:int = 100; // 运行的最小x坐标，如果显示的图片的x小于这个值了，则将其向右移动 
		private var count:int;
		private var lineCount:int = TEXT_COUNT - 1; // 横线的数量永远都比文本块的数量少1
		private var pattern:RegExp = /<br>/g;
		private var shown:Boolean;
		private var _lineScale:Number = 1;
		private var _defaultTF:TextFormat;
		private var _maxTxtWidth:int;
		private var _autoSetBgWidth:Boolean = true;
		private var _measureTxt:BorderTextField;
		
		private var loadingIcon:MovieClip;
		private var loadingIconWidth:int = 62;
		private var loadingIconHeight:int = 63;
		
		public function ToolTip() 
		{
			super(GameDisObjBase.IMAGE, false);
			
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		override protected function init():void
		{
			super.init();
			
			background = new (_resCacheMgr.getResourceFromMV("com.xuyou.ogzq2.game.ui.tips.ToolTipSkin"))();
			background.width = 272;
			addChild(background);
			
			loadingIcon = new (_resCacheMgr.getResourceFromMV("com.xuyou.ogzq2.game.ui.tips.LoadingIcon"))();
			loadingIcon.gotoAndStop(1);
			// loadingIcon 是中心点对齐，所以在定位是要加上高宽各一半
			loadingIcon.y = 17 + loadingIconWidth / 2;
			loadingIcon.x = DEFAULT_WIDTH - 17 - loadingIconHeight / 2;
			
			_disObj = new Bitmap();
			//_disObj.x = defaultWidth - 17;
			_disObj.y = 17;
			Bitmap(_disObj).smoothing = true;
			addChild(_disObj);
			
			initTxf();
			initLine();
		}
		
		private function initTxf():void 
		{
			_defaultTF = SystemManager.Instance.txtFormatMgr.defaultTextFormat;
			_defaultTF.leading = 4; // 这值用于调整每个内容块的行间距
			_defaultTF.bold = false;
			
			info = new Vector.<BorderTextField>();
			for (var i:int=0; i < TEXT_COUNT; i++) 
			{
				info.push(new BorderTextField());
				info[i].defaultTextFormat = _defaultTF;
				info[i].x = DEFAULT_TEXT_X;
				info[i].wordWrap = true;
				info[i].width = DEFAULT_TEXT_WIDTH;
				info[i].textColor = 0xFFFFFF;
				addChild(DisplayObject(info[i]));
			}
			
			_measureTxt = new BorderTextField();
		}
		
		private function initLine():void 
		{
			lines = new Vector.<Bitmap>();
			for (var i:int = 0; i < lineCount; i++) 
			{
				lines.push(new Bitmap(new (_resCacheMgr.getResourceFromMV("com.xuyou.ogzq2.game.ui.tips.TipLineSkin"))));
				//lines.push(new Bitmap());
				lines[i].x = 40;
				lines[i].visible = false;
				addChild(lines[i]);
			}
		}
		
		// public ////
		/**
		 * 显示悬停提示
		 * @param	img
		 * @param	tip
		 * @param	vars
		 * @param	stars
		 * @param	showTipImg
		 */
		public function setTips(img:*, tip:Array, vars:Object=null, stars:*=null, showTipImg:Boolean=false):void
		{
			shown = true;
			ttH = 15; // 默认标题距离最上端15个像素
			
			_vars = vars;
			// 暂时忽略外部传入的宽度
			if (_vars)
			{
				if ("bgWidth" in _vars) 
				{
					_autoSetBgWidth = false;
					background.width = _vars["bgWidth"];
					_lineScale = Number(_vars["bgWidth"]) / DEFAULT_WIDTH;
				}
			}
			
			if (!img) // 在没有图片的情况下，根据显示文本内容的最宽来设定背景的宽度
			{
				if (_autoSetBgWidth)
				{
					calculateMaxTxtWidth(tip);
					background.width = DEFAULT_TEXT_X + _maxTxtWidth + 25;
					_lineScale = background.width / DEFAULT_WIDTH;
				}
			}
			
			if (tip && tip.length > 0) 
			{
				count = tip.length;
				for (var i:int = 0; i < count; i++) // 有多少个循环 就有多少个内容块
				{
					if (tip[i].indexOf("<br>") > 0)
						tip[i] = String(tip[i]).replace(pattern, "\n");
					
					info[i].htmlText = setHtmlTxtFormat(tip[i]);
					info[i].y = ttH;
					ttH += info[i].textHeight;
					
					if (i == 0 && img) // 第一行是名称，特殊处理
					{
						ttH += TITLE_FIRST_BLOCK_GAP;
					}
					else
					{
						if (i < count - 1) 
						{
							setLine(i);
						}
						
						// 每个块的内容结束后，加入一个块的间距
						ttH += DEFAULT_BLOCK_GAP;
					}
					
					//trace(info[i].y, ttH);
				}
			}
			
			if (img)
			{
				if (img is BitmapData)
				{
					Bitmap(_disObj).bitmapData = img;
					_disObj.x = DEFAULT_WIDTH - 17 - img.width;
					scaleImg();
				}
				else if (img is String)
				{
					addChild(loadingIcon);
					loadingIcon.play();
					loadResByFullURL(img);
				}
			}
			
			background.height = ttH + 10;
		}
		
		override public function reset():void
		{
			shown = false;
			_autoSetBgWidth = true;
			background.width = DEFAULT_WIDTH;
			_maxTxtWidth = 0;
			_vars = null;
			_lineScale = 1;
			_disObj.y = 17;
			Bitmap(_disObj).bitmapData = null;
			_disObj.scaleX = 1;
			_disObj.scaleY = 1;
			//star.clear();
			for (var i:int = 0; i < TEXT_COUNT; i++) 
			{
				info[i].htmlText = "";
				info[i].width = 240;
				// htmlText设置里面如果有字体样式，会改变textfield的textformat属性
				// 所以这里恢复一下
				if (info[i].defaultTextFormat != _defaultTF)
					info[i].defaultTextFormat = _defaultTF;
				if (i < lineCount)
				{
					lines[i].visible = false;
					lines[i].x = 40;
					if (lines[i].scaleX != 1) lines[i].scaleX = 1;
				}
			}
			removeLoadingIcon();
		}
		
		// protected ////
		override protected function assetsLoadCallBack():Boolean
		{
			removeLoadingIcon();
			
			if (!shown) return true; // 如果加载完毕时已经取消悬停，则不做任何操作
			
			if (super.assetsLoadCallBack())
			{
				scaleImg();
				
				_disObj.x = DEFAULT_WIDTH - 4 - _disObj.width;
				//if (_disObj.x < minXAllowed)
				//_disObj.x += (minXAllowed - _disObj.x);
				if (_disObj.y + _disObj.height > background.height)
					_disObj.y -= (_disObj.y + _disObj.height - ttH - 5);
				return true;
			}
			
			return false;
		}
		
		// private ////
		/**
		 * 计算显示文本中的最宽值 
		 * @param tip
		 * 
		 */		
		private function calculateMaxTxtWidth(tip:Array):void
		{
			for each (var s:String in tip)
			{
				_measureTxt.htmlText = setHtmlTxtFormat(s);
				if (_measureTxt.textWidth > _maxTxtWidth)
					_maxTxtWidth = _measureTxt.textWidth;
			}
		}
		
		/**
		 * 设置线条 
		 * @param i
		 * 
		 */		
		private function setLine(i:int, adjusmetns:int=4):void
		{
			lines[i].y = ttH + adjusmetns;
			lines[i].visible = true;
			if (_lineScale != 1) 
			{
				lines[i].scaleX = _lineScale;
				lines[i].x = (background.width - lines[i].width) / 2;
			}
		}
		
		private function scaleImg():void
		{
			if (_vars)
			{
				if ("scaleX" in _vars)
					_disObj.scaleX = _vars["scaleX"];
				if ("scaleY" in _vars)
					_disObj.scaleY = _vars["scaleY"];
				
				_disObj.transform.matrix = null;
			}
		}
		
		private function removeLoadingIcon():void 
		{
			loadingIcon.gotoAndStop(1);
			if (this.contains(loadingIcon))
				this.removeChild(loadingIcon);
		}
		
		// getter && setter ////
		
		public function get realHeight():int
		{
			return background.height;
		}
		
		override public function get width():Number
		{
			return _maxTxtWidth != 0 ? _maxTxtWidth : DEFAULT_WIDTH;
		}
		
		public function get isPopped():Boolean
		{
			return false;
		}
	}
	
}