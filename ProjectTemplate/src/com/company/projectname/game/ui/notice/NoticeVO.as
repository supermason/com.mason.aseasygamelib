package com.company.projectname.game.ui.notice
{
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Jun 26, 2014 1:49:43 PM
	 * description: 	
	 **/
	public class NoticeVO
	{
		public var type:int;
		public var content:String;
		public var staySec:int;
		
		private static var _noticePool:Vector.<NoticeVO> = new <NoticeVO>[];
		
		public function NoticeVO(type:int, content:String, staySec:int)
		{
			reset(type, content, staySec);
		}
		
		public function reset(type:int, content:String, staySec:int):NoticeVO
		{
			this.type = type;
			this.content = content;
			this.staySec = staySec;
			
			return this;
		}
		
		// 对象缓存 //////////////////////////////////////////////////////////////////
		public static function fromPool(type:int, content:String, staySec:int):NoticeVO
		{
			if (_noticePool.length) return _noticePool.pop().reset(type, content, staySec);
			else return new NoticeVO(type, content, staySec);
		}
		
		public static function toPool(noticeVO:NoticeVO):void
		{
			noticeVO.type = -1;
			noticeVO.content = "";
			noticeVO.staySec = 3;
			_noticePool[_noticePool.length] = noticeVO;
		}
	}
}