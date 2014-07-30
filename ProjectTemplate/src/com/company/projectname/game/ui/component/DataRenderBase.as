package com.company.projectname.game.ui.component
{
	import com.company.projectname.SystemManager;
	import easygame.framework.cache.disobj.CachableDisplayObject;
	import com.company.projectname.game.lang.Lang;
	import com.company.projectname.game.vo.User;
	import com.company.projectname.network.DataParser;
	
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 23, 2013 11:19:51 AM
	 * description: 渲染器基类，提供一个DataParser对象， 可用于解析来自服务端的数据
	 **/
	public class DataRenderBase extends CachableDisplayObject
	{
		protected var _dataParser:DataParser;
		protected var _user:User;
		protected var _lang:XML;
		
		public function DataRenderBase()
		{
			_dataParser = SystemManager.Instance.dataParser;
			_user = SystemManager.Instance.userMgr.user;
			_lang = Lang.l;
			
			super();
		}
	}
}