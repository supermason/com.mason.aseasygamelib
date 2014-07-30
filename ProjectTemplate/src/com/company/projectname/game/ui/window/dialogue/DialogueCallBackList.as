package com.company.projectname.game.ui.window.dialogue
{
	import com.company.projectname.game.ui.window.WinManagerBase;
	
	import flash.utils.Dictionary;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Mar 21, 2014 3:03:53 PM
	 * description: 	
	 **/
	public class DialogueCallBackList extends WinManagerBase
	{
		/////////////////////////////////////////////////////////////////////////
		// 常量定义
		/////////////////////////////////////////////////////////////////////////
		
		// 属性///////////////////////////////////////////////////////////////////
		private static var _instance:DialogueCallBackList;
		/**
		 * 回调方法列表
		 */
		private var _dialogueOverCallBackList:Dictionary;
		/**
		 * 回调方法可能用到的参数列表
		 */
		private var _callBackVars:Dictionary;
		
		public function DialogueCallBackList(se:SingletonEnforcer)
		{
			super();
			
			if (!se) throw new ArgumentError("not null!");
			if (_instance) throw new Error("Only One!");
			
			init();
		}
		
		// private ////
		private function init():void
		{
		}		
		
		// public ////
		/**
		 * 对话结束后，更加funcID执行对应的方法
		 * @param	funcID
		 */
		public function call(funcID:String):void
		{
			if (_dialogueOverCallBackList[funcID])
			{
				if (_callBackVars && _callBackVars[funcID])
					_dialogueOverCallBackList[funcID].call(null, _callBackVars[funcID]);
				else
					_dialogueOverCallBackList[funcID].call();
			}
		}
		
		
		// getter && setter ////
		/**
		 * 对话结束后回调类实例 
		 * @return 
		 * 
		 */		
		public static function get instance():DialogueCallBackList
		{
			if (!_instance)
				_instance = new DialogueCallBackList(new SingletonEnforcer());
			
			return _instance;
		}
	}
}

// 单例强制类
class SingletonEnforcer {}