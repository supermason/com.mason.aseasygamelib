package com.xuyou.ogzq2.game.ui.window.dialogue
{
	import com.greensock.TweenLite;
	import com.xuyou.ogzq2.ResourceLocater;
	import com.xuyou.ogzq2.SystemManager;
	import com.xuyou.ogzq2.game.ui.component.PrettySimpleButton;
	import com.xuyou.ogzq2.game.ui.tool.UITool;
	import com.xuyou.ogzq2.game.ui.window.FixedWindow;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Mar 21, 2014 9:43:23 AM
	 * description: 	
	 **/
	public class UIDialogue extends FixedWindow implements IUIDialgoue
	{
		private const TIP_BTN_COUNT:int = 4;
		private var _saying:Boolean;
		private var _imgSildedIn:Boolean;
		private var _charIndex:int;
		private var _curDialogue:Object;
		private var _curDialogueStr:String;
		private var _curHtmlDialogueStr:String;
		private var _curTipStr:String;
		private var _intervalId:int;
		private var _dialogueOverCallBackId:String;
		private var HTML_MARKER:RegExp = /[u4e00-u9fa5]/g;
		private var _btnClose:PrettySimpleButton;
		
		private var _txfFormatHolder:TextField;
		private var _defaultTXF:TextFormat;
		
		public function UIDialogue(contentData:Object)
		{
			_$width = 967;
			_$height = 397;
			
			super("com.xuyou.ogzq2.game.ui.window.dialogue.UIDialgoueSkin", contentData);
			skinURL = ResourceLocater.UI_ROOT + "dialogue/dialogue.swf";
		}
		
		// public ////
		override public function reOpen(value:Object):void
		{
			super.reOpen(value);
			
			fillData();
		}
		
		override public function clear():void
		{
			super.clear();
			_saying = false;
			_imgSildedIn = false;
			_charIndex = 0;
			_dialogueOverCallBackId = null;
			removeCloseBtn();
			_skin.mvCoach.gotoAndStop(1);
			_curDialogueStr = "";
			_curHtmlDialogueStr = "";
			initMVTip(false);
			clearInterval(_intervalId);
		}
		
		// protected ////
		override protected function init():void
		{
			super.init();
			
			_skin.mvCoach.mouseEnabled = false;
			
			_btnClose = new PrettySimpleButton(PrettySimpleButton.CLOSE_BUTTON);
			_btnClose.x = 875;
			_btnClose.y = 50;
			
			_skin.nextArr.mouseChildren = false;
			_skin.nextArr.buttonMode = true;
			
			initMVTip();
			
			_skin.mvCoach.gotoAndStop(1);
			UITool.disableMouseEvt(_skin.mvCoach);
			
			_defaultTXF = _skin.txtContent.defaultTextFormat;
			_defaultTXF.font = SystemManager.Instance.txtFormatMgr.globalFont;
			_txfFormatHolder = new TextField();
			_txfFormatHolder.defaultTextFormat = _defaultTXF;
			
			fillData();
		}
		
		override protected function addEvt():void
		{
			super.addEvt();
			
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
		}
		
		override protected function removeEvt():void
		{
			super.removeEvt();
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
			if (_btnClose) _btnClose.removeEventListener(MouseEvent.MOUSE_UP, closeMe);
		}
		
		// event handler ////
		
		private function mouseEvtHandler(event:MouseEvent):void
		{
			if (_saying)
				finishOneDialogue();
			else
				nextDialogue();
		}
		
		private function closeMe(event:MouseEvent):void
		{
			this.closeWindow();
		}
		
		private function doSomethingAccorToTip(event:MouseEvent):void
		{
			_winBuziEvtHandler(DialogueEvent.GOTO_DO_SOMETHING, event.target.oprData);
		}
		
		// private ////
		
		private function removeCloseBtn():void
		{
			if (_skin.contains(_btnClose))
				_skin.removeChild(_btnClose);
		}
		
		private function addCloseBtn():void
		{
			_skin.addChild(_btnClose);
			_btnClose.addEventListener(MouseEvent.MOUSE_UP, closeMe);
		}
		
		private function initMVTip(init:Boolean=true):void
		{
			for (var i:int = 1; i <= TIP_BTN_COUNT; i++)
			{
				if (init)
				{
					_skin["mvTip" + i].mouseChildren = false;
				}
				_skin["mvTip" + i].buttonMode = false;
				_skin["mvTip" + i].txtTip.htmlText = "";
				_skin["mvTip" + i].removeEventListener(MouseEvent.MOUSE_UP, doSomethingAccorToTip);
			}
		}
		
		private function fillData():void
		{
			_skin.mvCoach.gotoAndPlay(1);
			nextDialogue();
		}
		
		private function nextDialogue():void 
		{
			//stage.removeEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
			
			_saying = true;
			
			if (noDialogue)
			{
//				if (_content["oprChoose"])
//				{
//					stage.removeEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
//					
//					initOprChose(_content["oprChoose"]);
//				}
//				else
//				{
					closeWindow();
//				}
			}
			else
			{
				_curDialogue = _content["dialogue"].shift();
				_curDialogueStr = _curDialogue["content"];
				_curHtmlDialogueStr = _curDialogueStr;
				// 赋值保存html的样式
				_txfFormatHolder.htmlText = "<i><b>" + _curDialogueStr + "</b></i>";
				// 获得去掉样式的文本
				_curDialogueStr = _txfFormatHolder.text;
				_curTipStr = _content["oprTip"] != null ? _content["oprTip"].shift() : "";
				if (_curDialogueStr.indexOf("@") != -1)
					_curDialogueStr = _curDialogueStr.replace("@", _userMgr.user.nickname);
				_dialogueOverCallBackId = _curDialogue["funcID"];
				// 如果是同一方向的，则无需滑入
				if (!_imgSildedIn)
				{
					_imgSildedIn = true;
					resetImg();
					imgSlideIn(-100);
				}
				_skin.txtContent.htmlText = "";
				_skin.txtContent.text = "";
//				_intervalId = setInterval(printTxt, 10);
				resetNextTip();
				finishOneDialogue();
//				_skin.txtContent.htmlText = "<i><b>" + _curDialogueStr + "</b></i>";
			}
		}
		
		private function resetImg():void
		{
			_skin.mvCoach.x = -200;
			_skin.mvCoach.alpha = 0;
		}
		
		private function imgSlideIn(tx:int):void
		{
			TweenLite.killTweensOf(_skin.mvCoach);
			TweenLite.to(_skin.mvCoach, .25, { autoAlpha: 1, x: tx } );
		}
		
		private function resetNextTip():void 
		{
			_skin.nextArr.txtTip.htmlText = "";
			_skin.nextArr.gotoAndStop(1);
			_skin.nextArr.visible = false;
		}
		
		private function showNextTip():void
		{
			_skin.nextArr.txtTip.htmlText = setTxtFormat("<b><i>" + _curTipStr + "</i></b>");
			_skin.nextArr.gotoAndPlay(1);
			_skin.nextArr.visible = true;
		}
		
		private function printTxt():void 
		{
			if (_charIndex == _curDialogueStr.length)
			{
				finishOneDialogue();
			}
			else
			{
				try 
				{
					_skin.txtContent.appendText(_curDialogueStr.substr(_charIndex, 1));
					_skin.txtContent.setTextFormat(_txfFormatHolder.getTextFormat(_charIndex), _charIndex);
					_charIndex++;
				}
				catch (err:Error)
				{
					finishOneDialogue();
				}
			}
		}
		
		private function finishOneDialogue():void
		{
			_charIndex = 0;
//			_skin.txtContent.htmlText = "<i><b>" + _curHtmlDialogueStr + "</b></i>";
			_skin.txtContent.text = "";
		
			for (var i:int = 0, len:int = _curDialogueStr.length; i < len; ++i)
			{
				_skin.txtContent.appendText(_curDialogueStr.substr(i, 1));
				_skin.txtContent.setTextFormat(_txfFormatHolder.getTextFormat(i), i);
			}
			
			clearInterval(_intervalId);
			
			if (noDialogue)
			{
				if (_content["oprChoose"])
				{
					stage.removeEventListener(MouseEvent.MOUSE_UP, mouseEvtHandler);
					
					initOprChose(_content["oprChoose"]);
				}
				else
				{
					showNextTip();
				}
			}
			else
			{
				showNextTip();
			}
			_saying = false;
			if (_dialogueOverCallBackId && _dialogueOverCallBackId != "")
				_winBuziEvtHandler(DialogueEvent.SAVE_DIALOGUE_OVER_CALLBACK_ID, _dialogueOverCallBackId);
		}
		
		private function initOprChose(data:Array):void
		{
			resetNextTip();
			
			for (var i:int = 0, len:int = data.length; i < len; i++)
			{
				_skin["mvTip" + (i+1)].buttonMode = true;
				_skin["mvTip" + (i+1)].txtTip.htmlText =  setTxtFormat("<i><b><u>" + data[i]["txt"] + "</u></b></i>");
				_skin["mvTip" + (i+1)].oprData = data[i]["oprType"];
				_skin["mvTip" + (i+1)].addEventListener(MouseEvent.MOUSE_UP, this.doSomethingAccorToTip);
			}
			
			addCloseBtn();
		}
		
		private function get noDialogue():Boolean
		{
			try
			{
				return _content["dialogue"].length == 0;
			}
			catch (err:Error)
			{
				
			}
			
			return true;
		}
	}
}