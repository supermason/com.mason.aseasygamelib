package com.company.projectname.game.ui.component
{
	import com.company.projectname.PlatformInfo;
	import com.company.projectname.SystemManager;
	import com.company.projectname.VersionController;
	import com.company.projectname.game.lang.Lang;
	import com.company.projectname.game.tool.UITool;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import easygame.framework.cache.res.ResCacheManager;
	import easygame.framework.filter.FilterManager;
	import easygame.framework.loader.GameLoaderManager;
	import easygame.framework.loader.LoadBehaviour;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 11:28:45 AM
	 * description 游戏内显示对象的基类
	 **/
	public class GameDisObjBase extends DataRenderBase
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		protected const NORMAL_STATE:String = "normal";
		protected const HOVER_STATE:String = "hover";
		
		protected const NULL_ITEM_REPLACEMENT:String = "NULL_ITEM_REPLACEMENT";
		protected const NULL_HEAD_REPLACEMENT:String = "NULL_HEAD_REPLACEMENT";
		
		/**加载时使用动画效果替代*/
		protected const MOVIECLIP_REPLACEMENT:int = 1;
		/**加载时使用图片效果替代*/
		protected const IMG_REPLACEMENT:int = 2;
		/**使用图片效果替代道具类型的加载 - 1*/
		protected const NULL_ITEM:int = 1;
		/**使用图片效果替代头像类型的加载 - 2*/
		protected const NULL_HEAD:int = 2;
		/**替代图片的高宽*/
		protected const REPLACEMENT_IMG_WH:Array = [[], [64, 64], [104, 104]];
		
		// 以下两个常量用于标识内部加载的资源类型
		static public const IMAGE:int = 0;
		static public const SWF:int = 2;
		
		protected var _assetsType:int;
		protected var _rawURL:String;
		protected var _assetsURL:String;
		/**
		 * 显示对象，可以是图片Bitmap，也可以是MovieClip 
		 */		
		protected var _disObj:DisplayObject;
		/**
		 * 如果显示对象包含的是一个SWF，是否在清理资源时将这个swf一并清理
		 */
		protected var _resetSwfRes:Boolean;
		/**
		 * 是否在清理资源时将图片资源释放--默认为true 
		 */		
		protected var _resetImgRes:Boolean = true;
		protected var _resCacheMgr:ResCacheManager;
		protected var _loaderMgr:GameLoaderManager;
		
		protected var _filterMgr:FilterManager;
		
		/**加载时的提示类型  默认使用动画效果替代*/
		protected var _loadingReplacementType:int = 1;
		/**加载器动画*/
		protected var _loadingIcon:MovieClip;
		/**加载时的替换图*/
		protected var _loadingImg:Bitmap;
		/**使用何种替代图片*/
		protected var _replacementImgType:int;
		protected var _replacementImgX:int;
		protected var _replacementImgY:int;
		
		protected var _$width:int;
		protected var _$height:int;
		
		protected var _l:XML;
		
		protected var _platformInfo:PlatformInfo;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 构造方法 
		 * @param assetsType 该显示对象的内部资源类型（图片还是swf）
		 * @param buttonMode 当鼠标移入该显示对象时，是否采用手型图标
		 * 
		 */		
		public function GameDisObjBase(assetsType:int, buttonMode:Boolean=true) 
		{
			this._assetsType = assetsType;
			this.buttonMode = buttonMode;
			
			super();
		}
		
		override protected function init():void
		{
			_resCacheMgr = SystemManager.Instance.resCacheMgr;
			_loaderMgr = SystemManager.Instance.loaderMgr;
			_filterMgr = SystemManager.Instance.fitlerMgr;
			_l = Lang.l;
			_platformInfo = SystemManager.Instance.platformInfo;
			
			super.init();
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		override public function addEvt():void
		{
			super.addEvt();
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		override public function removeEvt():void
		{
			super.removeEvt();
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		override public function reset():void
		{
			super.reset();
			
			if (_disObj)
			{
				if (_disObj is InteractiveObject)
					_disObj.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				
				if (_disObj is Bitmap)
				{
					if (_resetImgRes)
					{
						resetBitmap();
					}
				}
				else
				{
					if (_disObj is MovieClip)
						MovieClip(_disObj).stop();
					
					if (_resetSwfRes)
					{
						if (_disObj.parent)
							_disObj.parent.removeChild(_disObj);
						
						_disObj = null;
					}
				}
			}
			
			installLoadingIcon = false;
		}
		
		protected function resetBitmap():void
		{
			if (Bitmap(_disObj).bitmapData)
			{
				Bitmap(_disObj).bitmapData.dispose();
				Bitmap(_disObj).bitmapData = null;
			}
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		/**
		 * 根据资源类型，动态创建资源地址进行加载
		 * @param	resRootURL
		 * @param	rawURL
		 * @param	extesion 资源后缀名，如果为空字符串，则自动从.png和.swf中选择一个
		 */
		protected function loadRes(resRootURL:String, rawURL:String, extesion:String=""):void
		{
			_rawURL = rawURL;
			_assetsURL = resRootURL +  _rawURL.toLowerCase() + (extesion == "" ? $extesion : extesion);
			checkToLoad();
		}
		/**
		 * 使用传入的全资源地址进行加载
		 * @param	resURL
		 */
		protected function loadResByFullURL(resURL:String):void
		{
			_assetsURL = resURL;
//			trace("in GameDisObjBase::loadResByFullURL==>[" + _assetsURL + "]");
			_assetsURL += ("?v=" + VersionController.fileVersion[_assetsURL]);
			checkToLoad();
		}
		/**
		 * 检查资源是否已存在，否则进行加载
		 */
		protected function checkToLoad():void
		{
			if (hasRes)
				assetsLoadCallBack();
			else
				load();
		}
		
		/**
		 * 资源加载的回调方法 
		 * @return 
		 * 
		 */		
		protected function assetsLoadCallBack():Boolean
		{
			installLoadingIcon = false;
			
			try
			{
				if (_assetsType == IMAGE)
				{
//					trace("in GameDisObjBase::assetsLoadCallBack==>[" + _assetsURL + "]");
					Bitmap(_disObj).bitmapData = _resCacheMgr.findImage(_assetsURL).clone();
				}
				else
				{
					_disObj = new (_resCacheMgr.getResourceFromMV(_rawURL))();
					addChildAt(_disObj, 0);
				}
				
				if (_disObj is InteractiveObject)
					_disObj.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			catch (e:Error)
			{
				trace("NO RESOURCES::[In GameDisObjBase.assetsLoadCallBack >>>URL=" + _assetsURL + "]\n" + "ERROR INFO::" + e.getStackTrace());
				return false;
			}
			
			return true;
		}
		
		/**
		 * 开始加载资源 
		 * 
		 */		
		protected function load():void
		{
			installLoadingIcon = true;
			
			_loaderMgr.queenLoaderMgr.addRawLoadContent(_assetsURL, 
					_assetsType == IMAGE ? ResCacheManager.IMAGE : ResCacheManager.SWF,
					"",
					assetsLoadCallBack).startLoad(LoadBehaviour.NO_LOADING_INFO);
		}
		
		/**
		 * 如果需要自身的无进度提示加载动画，则调用该方法
		 * @param contentWidth
		 * @param contentHeight
		 * @param contentX
		 * @param contentY
		 * @return 
		 * 
		 */			
		protected function createLoadingIcon(contentWidth:int, contentHeight:int, contentX:int=0, contentY:int=0):void
		{
			_loadingReplacementType = MOVIECLIP_REPLACEMENT;
			
			_loadingIcon = new (_resCacheMgr.getResourceFromMV("com.company.projectname.game.ui.tips.LoadingIcon"))();
			
			_loadingIcon.gotoAndStop(1);
			_loadingIcon.x = contentX + (contentWidth - 36) / 2;
			_loadingIcon.y = contentY + (contentHeight - 36) / 2;
		}
		
		/**
		 * 创建图片资源加载完前的替代图片对象 
		 * 
		 */		
		protected function createLoadingImg(replacementImgType:int, 
											contentWidth:int, contentHeight:int, 
											contentX:int=0, contentY:int=0,
											scaleX:Number=1.0, scaleY:Number=1.0,
											alpha:Number=.5):void
		{
			_loadingReplacementType = IMG_REPLACEMENT;
			
			_loadingImg = new Bitmap();
			
			_replacementImgType = replacementImgType;
			_loadingImg.x = contentX + (contentWidth - REPLACEMENT_IMG_WH[_replacementImgType][0] * scaleX) / 2;
			_loadingImg.y = contentY + (contentHeight - REPLACEMENT_IMG_WH[_replacementImgType][1] * scaleY) / 2;
			_loadingImg.scaleX = scaleX;
			_loadingImg.scaleY = scaleY;
			_loadingImg.alpha = alpha;
			
			if (!_resCacheMgr.hasResource(NULL_ITEM_REPLACEMENT, ResCacheManager.PERMANENT_IMAGE))
				_resCacheMgr.cache(NULL_ITEM_REPLACEMENT, 
								   ResCacheManager.PERMANENT_IMAGE, 
								   new (_resCacheMgr.getResourceFromMV("com.company.projectname.game.ui.skin.ItemNullImg"))());
			
			if (!_resCacheMgr.hasResource(NULL_HEAD_REPLACEMENT, ResCacheManager.PERMANENT_IMAGE))
				_resCacheMgr.cache(NULL_HEAD_REPLACEMENT, 
								   ResCacheManager.PERMANENT_IMAGE, 
								   new (_resCacheMgr.getResourceFromMV("com.company.projectname.game.ui.skin.HeadNullImg"))());
		}
		
		/**
		 * 设置字体为微软雅黑 
		 * @param disObjCon
		 * 
		 */		
		protected static function setTxtFontName(disObjCon:DisplayObjectContainer):void
		{
			UITool.setAllTxtInDisObjCon(disObjCon);
		}
		
		/**
		 * 设置htmlText的雅黑显示 
		 * @param txt
		 * @return 
		 * 
		 */		
		protected static function setHtmlTxtFormat(txt:String):String
		{
			return UITool.setYaHeiTxt(txt);
		}
		
		/*=======================================================================*/
		/* EVENT  HANDLER                                                        */
		/*=======================================================================*/
		protected function onMouseDown(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		/*=======================================================================*/
		/* PRIVATE FUNCTIONS                                                     */
		/*=======================================================================*/
		private function get $extesion():String
		{
			return _assetsType == IMAGE ? ".png" : ".swf";
		}
		
		private function get hasRes():Boolean
		{
			return _resCacheMgr.hasResource(_assetsURL, 
				_assetsType == IMAGE ? ResCacheManager.IMAGE : ResCacheManager.SWF);
		}
		
		private function getReplaceMentImg():BitmapData
		{
			if (_replacementImgType == NULL_ITEM)
				return _resCacheMgr.findPermanentImg(NULL_ITEM_REPLACEMENT);
			else if (_replacementImgType == NULL_HEAD)
				return _resCacheMgr.findPermanentImg(NULL_HEAD_REPLACEMENT);
			return null;
			
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		private function set installLoadingIcon(value:Boolean):void
		{
			if (_loadingReplacementType == MOVIECLIP_REPLACEMENT)
			{
				if (_loadingIcon)
				{
					if (value)
					{
						addChild(_loadingIcon);
						_loadingIcon.play();
					}
					else
					{
						_loadingIcon.gotoAndStop(1);
						if (contains(_loadingIcon))
							removeChild(_loadingIcon);
					}
				}
			}
			else if (_loadingReplacementType == IMG_REPLACEMENT)
			{
				if (_loadingImg)
				{
					if (value)
					{
						_loadingImg.bitmapData = getReplaceMentImg();
						addChild(_loadingImg);
					}
					else
					{
						if (contains(_loadingImg))
							removeChild(_loadingImg);
					}
				}
			}
		}
		
		/**
		 * 获取完整资源路径 
		 * @return 
		 * 
		 */		
		public function get fullURL():String
		{
			return _assetsURL;
		}
		
		/**
		 * 对于使用 MovieClip做为皮肤的组件，可以通过该getter获取到皮肤对象 
		 * @return 
		 * 
		 */		
		protected function get skin():MovieClip
		{
			return MovieClip(_disObj);
		}
		
		override public function get width():Number
		{
			return _$width != 0 ? _$width : super.width;
		}
		
		override public function get height():Number
		{
			return _$height != 0 ? _$height : super.height;
		}

		/**
		 * 希望的宽度
		 * @param value
		 * 
		 */		
		public function set $width(value:int):void
		{
			_$width = value;
		}
		
		/**
		 * 希望的高度
		 * @param value
		 * 
		 */
		public function set $height(value:int):void
		{
			_$height = value;
		}

	}
}