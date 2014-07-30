package easygame.framework.text
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Dec 2, 2013 3:26:48 PM
	 * description 
	 **/
	public class ScrollRTA extends Sprite
	{
		public static const MESSAGE_BOARD_WIDTH:int = 310;
		public static const MESSAGE_BOARD_HEIGHT:int = 176;
		private var MAX_BAR_HEIGHT:int;
		private var MIN_BAR_HEIGHT:int;
		private var FIXED_X:int;
		private var FIXED_Y:int;
		
		private var _txa:RichTextArea;
		private var _scrollBar:MovieClip;
		private var _scrollBtn:MovieClip;
		private var _stage:Stage;
		private var _rectangle:Rectangle;
		private var _doweTime:int;
		
		private var _txtLinkHandler:Function;
		private var _mouseUpHandler:Function;
		
		private var _allMsg:String = ""; // 另存一份信息
		private var _curTxtCount:int;
		private var _msgMaxCount:int = 200; //当前文本框中的最大信息数量（一次调用appendRichText该值+1）
		private var _deleteCount:int = 100; // 每次删除的数量
		private var DELETE_FLAG:String = "├DEL┤"; // 删除标识位
		
		/**
		 * 所属的频道编号 
		 */		
		public var channelID:int;
		
		public function ScrollRTA()
		{
			super();
			
			//this.mouseEnabled = false;
		}
		
		// public ////
		/**
		 * 初始化支持滚动条的富文本框 
		 * @param scrollBar
		 * @param stage
		 * 
		 */		
		public function init(scrollBar:MovieClip, stage:Stage):void
		{
			_stage = stage;
			_scrollBar = scrollBar;
			_scrollBtn = _scrollBar._ScrollBtn;
			_scrollBar._UpBtn.visible = false;
			_scrollBar._DownBtn.visible = false;
			FIXED_X = 0;
			FIXED_Y = 0; // Math.ceil(_scrollBar._UpBtn.height);
			MAX_BAR_HEIGHT = Math.ceil(/*MESSAGE_BOARD_HEIGHT*/_scrollBtn.height);
			MIN_BAR_HEIGHT = Math.ceil(_scrollBar._ScrollIcon.height * 2);
			_rectangle = new Rectangle(FIXED_X, FIXED_Y);
			
			_scrollBtn.gotoAndStop(1);
			_scrollBtn.buttonMode = true;
			_scrollBar._ScrollIcon.mouseEnabled = false;
			_scrollBar._ScrollIcon.mouseChildren = false;
			
			_txa = new RichTextArea(MESSAGE_BOARD_WIDTH, MESSAGE_BOARD_HEIGHT);
			_txa.x = _scrollBar.width + 3;
			//_txa.textField.addEventListener(MouseEvent.MOUSE_WHEEL , txtScrollHandler);
			
			addChild(_scrollBar);
			addChild(_txa);
			
			addEvt();
		}
		
		/**
		 * 添加信息 
		 * @param msg
		 * 
		 */		
		public function appendRichText(msg:String):void
		{
			if (_curTxtCount == _deleteCount)
				_allMsg += DELETE_FLAG;
			
			_allMsg += msg;
			_curTxtCount++;
			_txa.appendRichText(msg);
			
			if (_curTxtCount >= _msgMaxCount)
				trancatMsg();
			
			scrollToBottom();
		}
		
		public function clearAllText():void
		{
			_allMsg = "";
			_curTxtCount = 0;
			_txa.clear();
		}
		
		// protected ////
		protected function addEvt():void
		{
			_txa.addEventListener(MouseEvent.MOUSE_UP, txtLinkChecker);
			_txa.addEventListener(MouseEvent.MOUSE_MOVE, txaOnMouseMove);
			_txa.addEventListener(MouseEvent.MOUSE_WHEEL , txtScrollHandler);
			
			//_scrollBar._UpBtn.addEventListener(flash.events.MouseEvent.MOUSE_UP, mouseEvtHandler);
			//_scrollBar._DownBtn.addEventListener(flash.events.MouseEvent.MOUSE_UP, mouseEvtHandler);
			//_scrollBar._UpBtn.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, upBtnContinueDownHandler);
			//_scrollBar._DownBtn.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, downBtnContiueDownHandler);
			_scrollBar._ListBack.addEventListener(flash.events.MouseEvent.MOUSE_UP, mouseEvtHandler);
			
			_scrollBtn.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, scrollBtnDownHandler);
			_scrollBtn.addEventListener(flash.events.MouseEvent.MOUSE_OVER, scrollBtnStateHandler);
			_scrollBtn.addEventListener(flash.events.MouseEvent.MOUSE_OUT, scrollBtnStateHandler);
		}
		
		// event handler ////
		private function txtScrollHandler(e:MouseEvent):void 
		{
			if (e.delta > 0) 
			{
				if (canScrollUp(3)) scrollTxa();
			}
			else
			{
				if (canScrollDown(3)) scrollTxa();
			}
		}
		
		protected function mouseEvtHandler(event:MouseEvent):void
		{
			/*if (event.currentTarget == _scrollBar._UpBtn)
			{
				_stage.removeEventListener(Event.ENTER_FRAME, continuousUp);
				//if (!canScrollUp(3)) return;
			}
			else if (event.currentTarget == _scrollBar._DownBtn)
			{
				_stage.removeEventListener(Event.ENTER_FRAME, continuousDown);
				//if (!canScrollDown(3)) return;
			}
			else */if (event.currentTarget == _scrollBar._ListBack)
			{
				//_scrollBtn.y = event.localY + FIXED_Y;
				//if (_scrollBtn.y >= MAX_BAR_HEIGHT - _scrollBtn.height + FIXED_Y)
					//_scrollBtn.y = MAX_BAR_HEIGHT - _scrollBtn.height + FIXED_Y;
				canScrollDown(event.localY + FIXED_Y);
				
				scrollTxa();
			}
			
			//scrollTxa();
		}
		
		private function canScrollUp(delta:int):Boolean
		{
			if (_scrollBtn.y == FIXED_Y) 
				return false;
			
			_scrollBtn.y -= delta;
			
			if (_scrollBtn.y < FIXED_Y) 
				_scrollBtn.y = FIXED_Y;
			
			return true;
		}
		
		private function canScrollDown(delta:int):Boolean
		{
			if (_scrollBtn.y == MAX_BAR_HEIGHT - _scrollBtn.height + FIXED_Y)
					return false;
			
			_scrollBtn.y += delta;
			
			if (_scrollBtn.y >= MAX_BAR_HEIGHT - _scrollBtn.height + FIXED_Y)
				_scrollBtn.y = MAX_BAR_HEIGHT - _scrollBtn.height + FIXED_Y;
			
			return true;
		}
		
		protected function scrollBtnDownHandler(event:MouseEvent):void
		{
			_scrollBtn.gotoAndStop(3);
			_scrollBtn.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, scrollBtnDownHandler);
			
			_scrollBtn.addEventListener(MouseEvent.MOUSE_UP, scrollBtnUpHandler);
			
			// 大于显示区域时才开始滚动
			if (needScroll)
			{
				_rectangle.height = MAX_BAR_HEIGHT - _scrollBtn.height;
				_scrollBtn.startDrag(false, _rectangle);
				
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, scrollTxa);
				_stage.addEventListener(MouseEvent.MOUSE_UP, scrollBtnUpHandler);
			}
		}
		
		protected function scrollBtnUpHandler(event:MouseEvent):void
		{
			_scrollBtn.removeEventListener(MouseEvent.MOUSE_UP, scrollBtnUpHandler);
			_scrollBtn.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, scrollBtnDownHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrollTxa);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, scrollBtnUpHandler);
			_scrollBtn.stopDrag();
			
			//if (_mouseUpHandler != null)
				//_mouseUpHandler(event);
		}
		
		protected function scrollBtnStateHandler(event:MouseEvent):void
		{
			if (event.type == MouseEvent.MOUSE_OVER)
				_scrollBtn.gotoAndStop(2);
			else if (event.type == MouseEvent.MOUSE_OUT)
				_scrollBtn.gotoAndStop(1);
		}
		
		protected function scrollTxa(event:MouseEvent=null):void
		{
			_txa.textField.scrollV = Math.round((_scrollBtn.y - FIXED_Y )/((MAX_BAR_HEIGHT - _scrollBtn.height)) *(_txa.textField.maxScrollV - 1)) + 1;
			updateBarPos();
		}
		
		private function txtLinkChecker(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			
			scrollBtnUpHandler(e);
			
			var link:String = _txa.textField.getTextFormat(_txa.textField.getCharIndexAtPoint(_txa.textField.mouseX, _txa.textField.mouseY)).url;
			
			if (link && _txtLinkHandler != null)
				_txtLinkHandler(link, e);
			else if (_mouseUpHandler != null)
				_mouseUpHandler(e);
		}
		
		private function txaOnMouseMove(e:MouseEvent):void 
		{
			//trace(e.target, e.currentTarget);
			
			if (_txa.textField.text == "" || _txa.textField.text == null) return;
			
			var beginIndex:int = _txa.textField.getCharIndexAtPoint(_txa.textField.mouseX, _txa.textField.mouseY);
			if (_txa.textField.getTextFormat(beginIndex).url)
				this.buttonMode = true;
			else
				this.buttonMode = false;
		}
		
		private function upBtnContinueDownHandler(event:MouseEvent):void
		{
			if (!canScrollUp(3)) return;
				
			scrollTxa();
			// 当鼠标在按钮上按下的时间大于设定时间时，连续滚动
			_doweTime = getTimer();
			_stage.addEventListener(Event.ENTER_FRAME, continuousUp);
		}
		
		private function continuousUp(event:Event):void
		{
			if (getTimer() - _doweTime > 500) 
			{
				if (!canScrollUp(3)) 
					_stage.removeEventListener(Event.ENTER_FRAME, continuousUp);
				else
					scrollTxa();
			}
		}
		
		private function downBtnContiueDownHandler(event:MouseEvent):void
		{
			if (!canScrollDown(3)) return;
				
			scrollTxa();
			// 当鼠标在按钮上按下的时间大于设定时间时，连续滚动
			_doweTime = getTimer();
			_stage.addEventListener(Event.ENTER_FRAME, continuousDown);
		}
		
		private function continuousDown(event:Event):void
		{
			if (getTimer() - _doweTime > 500) 
			{
				if (!canScrollDown(3)) 
					_stage.removeEventListener(Event.ENTER_FRAME, continuousDown);
				else
					scrollTxa();
			}
		}
		
		// private ////
		/**
		 * 更新滑动块 的位置 
		 * 
		 */		
		private function updateBarPos():void
		{
			_scrollBar._ScrollIcon.y = Math.round(_scrollBtn.y + (_scrollBtn.height - _scrollBar._ScrollIcon.height) / 2);
		}
		
		/**
		 *  每次有文本输入，则自动滚动到最底部
		 * 
		 */		
		private function scrollToBottom():void
		{
			if (needScroll)
			{
				_scrollBtn.height = Math.floor(MESSAGE_BOARD_HEIGHT * MAX_BAR_HEIGHT / _txa.textField.textHeight);
				if (_scrollBtn.height < MIN_BAR_HEIGHT)
					_scrollBtn.height = MIN_BAR_HEIGHT;
				_scrollBtn.y = FIXED_Y + MAX_BAR_HEIGHT - _scrollBtn.height;
				updateBarPos();
			}
			
			// 自动跟随到最底部
			_txa.textField.scrollV = _txa.textField.maxScrollV;
		}
		
		/**
		 * 大于最大信息上限，剪裁文本 
		 * 
		 */		
		private function trancatMsg():void
		{
			_curTxtCount -= _deleteCount;
			if (_curTxtCount < 0) _curTxtCount = 0;
			_allMsg = _allMsg.split(DELETE_FLAG)[1];
			
			_txa.clear();
			_txa.appendRichText(_allMsg);
			
//			trace("==========================删除多余文本信息=============================");
		}
		
		// getter && setter ////
		
		public function get txa():RichTextArea
		{
			return _txa;
		}
		
		private function get needScroll():Boolean
		{
			return _txa.textField.textHeight > MESSAGE_BOARD_HEIGHT;
		}
		
		public function get txtLinkHandler():Function 
		{
			return _txtLinkHandler;
		}
		
		public function set txtLinkHandler(value:Function):void 
		{
			_txtLinkHandler = value;
		}
		
		/**
		 * 文本框内部会截获stage的mouseUp事件，所以为了避免其他需求，需要一个回调方法通知外部
		 */
		public function set mouseUpHandler(value:Function):void 
		{
			_mouseUpHandler = value;
		}

		/**
		 * 最大文本数量（调用一次<code>appendRichText</code>该值递增1） 默认200
		 * @return 
		 * 
		 */		
		public function get msgMaxCount():int
		{
			return _msgMaxCount;
		}

		public function set msgMaxCount(value:int):void
		{
			_msgMaxCount = value;
		}
		
		/**
		 * 一次删除多少行 ，默认100
		 * @return 
		 * 
		 */
		public function get deleteCount():int
		{
			return _deleteCount;
		}

		public function set deleteCount(value:int):void
		{
			_deleteCount = value;
			
			if (_deleteCount > _msgMaxCount)
				_deleteCount = _msgMaxCount;
		}


	}
}