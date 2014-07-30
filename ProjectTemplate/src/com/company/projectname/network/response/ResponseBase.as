package com.company.projectname.network.response
{
	import com.company.projectname.SystemManager;
	import com.company.projectname.game.lang.Lang;
	import com.company.projectname.game.ui.UIManager;
	import com.company.projectname.network.DataParser;
	import com.company.projectname.network.NetWorkManager;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 5:26:45 PM
	 * description 服务器响应处理基类
	 **/
	public class ResponseBase
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		protected var _funDic:Dictionary;
		/**
		 * 系统管理器
		 */
		protected var _sysMgr:SystemManager;
		/**
		 * UI管理器
		 */
		protected var _uiMgr:UIManager;
		/**
		 * 网络请求管理器
		 */
		protected var _nwMgr:NetWorkManager;
		/**
		 * 服务器回传数据检测类 及解析类 
		 */		
		protected var _dParser:DataParser;
		/**
		 * 一次请求是否成功的标识 
		 */		
		protected var _flag:int;
		/**
		 * Response类的类名 
		 */		
		protected var _clzName:String;
		
		protected var _lang:XML;
		
		private var _coverRemoved:Boolean;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function ResponseBase()
		{
			init();
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		/**
		 * 根据不同类型处理不同的响应
		 * @param	t
		 * @param	o
		 */
		public function handleResponse(funcId:int, o:Object):void
		{
			if (_funDic.hasOwnProperty(funcId))
				_funDic[funcId](o);
		}
		
		/*=======================================================================*/
		/* PROTECTED  FUNCTIONS                                                  */
		/*=======================================================================*/
		protected function init():void
		{
			_sysMgr = SystemManager.Instance;
			_uiMgr = _sysMgr.uiMgr;
			_nwMgr = _sysMgr.nwMgr;
			_dParser = _sysMgr.dataParser;
			_lang = Lang.l;
			_clzName = flash.utils.getQualifiedClassName(this).split("::").pop()
			createHandler();
		}	
		/**
		 * 子类重写该方法，绑定对应操作类型
		 */
		protected function createHandler():void
		{
			_funDic = new Dictionary();
		}
		
		/**
		 * 弹出错误提示
		 * @param	errMsg
		 * @param	cb
		 */
		protected function popMsg(errMsg:String, cb:Function = null):void
		{
			trace(errMsg, _flag);
			
			_uiMgr.gamePopUpMgr.createGamePopUp( {
				msg: errMsg,
				cbFun: cb
			} );
		}
		
		/**
		 * 滑屏提示
		 * @param	msg
		 * @param	cb
		 * @param	cbParams
		 */
		protected function slideMsg(msg:String, needImg:Boolean=true, cb:Function = null, cbParams:Object = null):void
		{
			_uiMgr.slideTipMgr.slideTip(msg, needImg, null, cb, cbParams);
		}
		
		/**
		 * 获取一次操作的数据 
		 * @param o
		 * @return 
		 * 
		 */		
		protected function getOprData(o:Object):String
		{
			return o[ResponseManager.DATA];
		}
		
		/**
		 * 获取一次操作的状态( 0-成功|<0失败)，同时移除操作屏蔽 
		 * @param s
		 * @param removeCover -- 一次操作后是否移除操作屏蔽遮罩
		 * @param checkState -- 是否根据操作状态判断是否移除遮罩 (根据<code>checkState</code>判断的情况会忽略<code>removeCover</code>的值)
		 * @return
		 * 
		 */		
		protected function getOprState(o:Object, removeCover:Boolean=true, checkState:Boolean=false):int
		{
			_flag = _dParser.getOprState(getOprData(o));
			
			// 根据交互状态判断是否需要移除遮罩
			if (checkState)
			{
				_coverRemoved = _flag == 0;
				if (_coverRemoved) 
				{
					$removeCover();
				}
			}
			else
			{
				// 对于那种需要连续自动与后台交互的方法，如果报错，则不会在这里移除遮罩
				// 所以这里保存一下遮罩是否移除的状态
				// 在弹出错误提示的时候移除遮罩
				_coverRemoved = removeCover;
				if (removeCover) 
				{
					$removeCover();
				}
			}
			return _flag;
		}
		
		/**
		 * 获取一次操作的错误提示 
		 * @param methodName
		 * @param errCode
		 * @return 
		 * 
		 */		
		protected function getErrMsg(methodName:String, errCode:int=0):String
		{
			if (!_coverRemoved) 
			{
				_coverRemoved = true;
				
				$removeCover();
			}
			
			if (errCode == DataParser.OPERATION_TOO_FREQUENT_FLAG)
				return _lang.tooFrequent;
			else if (errCode == DataParser.RELEASING_NEW_VERSION)
				return _lang.releasingNewVersion;
			else if (errCode == DataParser.SERVER_IS_FULL)
				return _lang.serverIsFull;
			
			return Lang.err[_clzName][methodName]["e" + ((errCode == 0 ? _flag : errCode) * -1)];
		}
		
		/**
		 * 移除交互屏蔽遮罩 
		 * 
		 */		
		protected function $removeCover():void
		{
			_sysMgr.sendingStateMonitor.cancel();
		}
	}
}