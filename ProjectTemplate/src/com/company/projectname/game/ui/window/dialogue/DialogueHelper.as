package com.company.projectname.game.ui.window.dialogue
{
	import com.company.projectname.game.lang.Lang;
	import com.company.projectname.game.ui.window.WinManagerBase;
	
	import flash.utils.Dictionary;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Mar 21, 2014 11:21:58 AM
	 * description: 	
	 **/
	public class DialogueHelper extends WinManagerBase
	{
		private static var _instance:DialogueHelper;
		private var _dialogueData:Dictionary;
		
		public function DialogueHelper(se:SingletonEnforcer)
		{
			super();
			
			if (!se) throw new ArgumentError("not null!");
			if (_instance) throw new Error("Only One!");
			
			createDialgoueData();
		}
		
		// public ////
		
		/**
		 * 开始对话
		 * @param	dialoguId -- 对话的字典编号
		 */
		public function startGameDialogue(dialoguId:int):void
		{
			_uiMgr.dialogueMgr.open( { 
				"dialogue": _dialogueData[dialoguId].concat(),
				"oprTip": getDialogueOprTip(dialoguId),
				"oprChoose": getOprChooseTip(dialoguId)
			}, null, true);
		}
		
		// private ////
		private function createDialgoueData():void
		{
			_dialogueData = new Dictionary();
			// 以下为代码参照
//			_dialogueData[DialgoueContentID.YOUTH_PLAYER_AS_GIFT_FOR_ALL_NEW_USER] = [/*{
//				content: Lang.l.d0 },*/{
//					content: Lang.l.d1,
//					funcID: DialogueCallBackList.GUIDE_TO_OPEN_FORMATION
//			}];
		}
		
		private function getDialogueOprTip(dialoguId:int):Array
		{
			switch (dialoguId)
			{
				// 以下为代码参照
//				case DialgoueContentID.YOUTH_PLAYER_AS_GIFT_FOR_ALL_NEW_USER:
//					return [/*Lang.l.d0T, */Lang.l.d1T];
				default:
					return null;
			}
		}
		
		private function getOprChooseTip(dialoguId:int):Array
		{
			// 以下为代码参照
			if (dialoguId == DialgoueContentID.GUIDE_TO_IMPROVE_YOURSELF_1)
			{
				return makeOprData(String(Lang.l.oprChooseName1).split(","));
			}
			else
			{
				return null;
			}
		}
		
		private function makeOprData(data:Array):Array
		{
			var t:Array
			for (var i:int = 0, len:int = data.length; i < len; i++)
			{
				t = data[i].split("|");
				data[i] = {
					"txt": t[0],
					"oprType": t[1]
				};
			}
			
			return data;
		}
		
		// getter && stter ////
		/**
		 * 获取对话辅助类实例 
		 * @return 
		 * 
		 */		
		public static function get instance():DialogueHelper
		{
			if (!_instance)
				_instance = new DialogueHelper(new SingletonEnforcer());
			
			return _instance;
		}
	}
}

// 单例强制类
class SingletonEnforcer {}

// 对话编号常量类
class DialgoueContentID 
{
	
}