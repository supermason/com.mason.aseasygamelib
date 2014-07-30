package  com.company.projectname.game.ui.notice
{
	import easygame.framework.display.IPopUp;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Jun 11, 2014 3:00:14 PM
	 * description: 	
	 **/
	public interface IUINotice extends IPopUp
	{
		function start(notices:String):void;
		
		function loopNotice(msg:String):void;
		
		function clearPermanent():void;
		
		function set endCallBack(value:Function):void;
		
		function get noticeWidth():int;
		
		function set noticeBgURL(value:String):void;
	}
}