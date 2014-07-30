package com.company.projectname.game.ui.notice
{
	import com.company.projectname.ResourceLocater;
	import com.company.projectname.SystemManager;
	import com.company.projectname.game.tool.UITool;
	import com.company.projectname.game.ui.component.Image;
	import com.company.projectname.network.DataParser;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	
	import easygame.framework.text.GameText;
	import easygame.framework.util.WebUtils;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Jun 11, 2014 3:10:56 PM
	 * description: 	
	 **/
	public class UINotice extends Sprite implements IUINotice
	{		
		public static const PERMANENT:int = 1;
		public static const TEMPORARY:int = 2;
		
		private var _$width:int = 527;
		private var _$height:int = 30;
		
		private var _bgImg:Image;
		private var _notice:Vector.<GameText>;
		private var _index:int;
		private var _loopping:Boolean;
		private var _dataParser:DataParser;
		
		/**触发时推过来的公告*/
		private var _noticeList:Vector.<NoticeVO>;
		/**常态公告*/
		private var _constantNoticeList:Vector.<NoticeVO>;
		private var _endCallBack:Function;
		private var _renewPermanent:Boolean;
		
		public function UINotice()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
			_dataParser = SystemManager.Instance.dataParser;
			
			this.scrollRect = new Rectangle(0, 0, _$width, _$height);
			
			_bgImg = new Image();
			addChild(_bgImg);
			
			_notice = new <GameText>[];
			for (var i:int = 0; i < 2; ++i)
			{
				_notice[i] = new GameText();
				_notice[i].x = 100;
				_notice[i].y = 30;
				_notice[i].selectable = true;
				_notice[i].mouseEnabled = true;
				_notice[i].addEventListener(TextEvent.LINK, onHyperLink);
				addChild(_notice[i]);
			}
			
			_noticeList = new <NoticeVO>[];
			_constantNoticeList = new <NoticeVO>[];
			
//			mouseChildren = false;
			mouseEnabled = false;
		}
		
		// public ////
		
		public function start(notices:String):void
		{
			var nList:Array = _dataParser.parseData(notices, 1);
			var n:Array;
			var nVO:NoticeVO;
			for each (var s:String in nList)
			{
				n = _dataParser.parseData(s, 2);
				nVO = NoticeVO.fromPool(int(n[2]), n[0], int(n[1]));
				if (nVO.type == UINotice.PERMANENT)
				{
					if (_renewPermanent && _constantNoticeList.length > 0)
					{
						_renewPermanent = false;
						_constantNoticeList.length = 0;
					}
					
					_constantNoticeList[_constantNoticeList.length] = nVO;
				}
				else
				{
					_noticeList[_noticeList.length] = nVO;
				}
			}
			
			if (_noticeList.length > 0)
				startLoop(_noticeList.shift());
			else
				loopPermanentNotice();
			
			_renewPermanent = false;
		}
		
		public function loopNotice(msg:String):void
		{
			_renewPermanent = true;
			
			start(msg);
		}
		
		public function clearPermanent():void
		{
			for each (var nVO:NoticeVO in _constantNoticeList)
			{
				NoticeVO.toPool(nVO);
			}
			
			_constantNoticeList.length = 0;
			
			// 如果没有临时公告，则移除公告
			if (_noticeList.length == 0)
				loopPermanentNotice();
		}
		
		public function destory():void
		{
			
		}
		
		public function reset():void
		{
			
		}
		
		// event handler ////
		
		protected function onHyperLink(event:TextEvent):void
		{
			if (event.text != "")
				WebUtils.NavigateToURL(event.text, "_blank");
		}
		
		// private ////
		private function loopPermanentNotice():void
		{
			if (_constantNoticeList.length > 0)
			{
				var noticeVo:NoticeVO = _constantNoticeList.shift();
				startLoop(noticeVo);
				_constantNoticeList[_constantNoticeList.length] = noticeVo;				
			}
			else
			{
				_loopping = false;
				visible = false;
				
				if (_endCallBack != null)
				{
					_endCallBack.call();
				}
			}
		}
		
		private function startLoop(noticeVO:NoticeVO):void
		{
			_loopping = true;
			
			if (_index >= _notice.length - 1)
				_index = 0;
			
			var content:String = noticeVO.content;
			var delay:int = noticeVO.staySec;
			
			_notice[_index].htmlText = "<font color='#eaff00' size='14'>" + UITool.setYaHeiTxt(content) + "</font>";
			_notice[_index].y = 30; 
			
			TweenLite.to(_notice[_index], .3, { 
				y: -2, 
				onComplete: noticeDisappear,
				onCompleteParams: [delay]
			});
			
			// 对于临时公告，则回收
			if (noticeVO.type == UINotice.TEMPORARY) NoticeVO.toPool(noticeVO);
			
			show();
		}
		
		private function noticeDisappear(delay:int):void
		{
			TweenLite.to(_notice[_index], .2, { 
				y: -_notice[_index].textHeight - 5, 
				onComplete: loopNext,
				delay: delay
			});
		}
		
		private function loopNext():void
		{
			if (_noticeList.length > 0)
			{
				_index++;
				startLoop(_noticeList.shift());
			}
			else
			{
				loopPermanentNotice();
			}
		}
		
		private function show():void
		{
			if (!visible) visible = true;
		}
		
		// getter && setter ////
		public function set endCallBack(value:Function):void
		{
			_endCallBack = value;
		}
		
		public function get noticeWidth():int
		{
			return _$width;
		}
		
		public function set noticeBgURL(value:String):void
		{
			_bgImg.source = ResourceLocater.NOTICE_RES_ROOT + value;
		}
		
		public function get displayContent():DisplayObjectContainer
		{
			return this;
		}
		
		public function get isPopped():Boolean
		{
			return false;
		}
		
	}
}