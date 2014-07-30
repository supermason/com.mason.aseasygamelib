package com.company.projectname.network
{
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Nov 15, 2013 4:54:43 PM
	 * description: 后台数据解析工具类[静态类]
	 **/
	public class DataParser
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		/**
		 * 前缀 ├
		 */		
		public const PREFIX:String = "├";
		/**
		 * 后缀 ┤
		 */		
		public const SUFFIX:String = "┤";
		/**
		 * 服务端返回的错误头 
		 */		
		public const SERVER_ERROR_HEADER:String = "-100";
		/**
		 * 请求过快的屏蔽标识 - -1006 
		 */		
		public static const OPERATION_TOO_FREQUENT_FLAG:int = -1006;
		/**
		 * 新版发布中 - -2000
		 */		
		public static const RELEASING_NEW_VERSION:int = -2000;
		/**
		 * 服务器人数已满 - -1007
		 * */
		public static const SERVER_IS_FULL:int = -1007;
		/**
		 * 账户被封 - -1008 
		 */		
		public static const ACCOUNT_FORBIDDEN:int = -1008;
		
		private static const PLUS_DATA_SEPERATOR:String = "|";
		
		private var _plusInfo:String = "";
		
		/*=======================================================================*/
		/* PUBLIC FUNCTIONS                                                      */
		/*=======================================================================*/
		/**
		 * 获取一次操作的状态
		 * @param data 服务器返回的数据
		 * @return >=0说明成功|<0说明失败（不同负值代表不同失败的含义）
		 * 
		 */		
		public function getOprState(data:String):int
		{			
			if (data.indexOf(getSeparater(0)) == -1) // 不包含任何终极分隔符，说明只包含一个值
			{
				if (data.indexOf(SERVER_ERROR_HEADER) > -1) // 说明是服务端返回的错误提示 -- 通常是存储过程出错了
				{
					if (data.indexOf(PLUS_DATA_SEPERATOR) > -1) // 如果包含其他信息
					{
						_plusInfo = data.split(PLUS_DATA_SEPERATOR)[1];
					}
					
					return int(data.substr(0, 5));
				}
				else // 逻辑错误
				{
					if (int(data) >= 0) // 大于0的情况，说明成功
						return 0;
					else // 小于0的情况说明失败
						return int(data);
				}
			}
			else // 包含，说明成功了
			{
				return 0;
			}
		}
		
		/**
		 * 解析数据 
		 * @param data -- 要被split的数据
		 * @param index -- 在数据中的层级：0为最上层、1为第二层....以此类推
		 * @return 
		 * 
		 */		
		public function parseData(data:String, index:int):Array
		{
			if (!data || data == "" || data == "null") return  null;
			
			return data.split(getSeparater(index));
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		/**
		 * 获取分隔符 
		 * @param index
		 * @return 
		 * 
		 */		
		public function getSeparater(index:int):String
		{
			return PREFIX + index + SUFFIX;
		}

		/**
		 * 特殊数据 
		 * @return 
		 * 
		 */		
		public function get plusInfo():String
		{
			return _plusInfo;
		}

		public function set plusInfo(value:String):void
		{
			_plusInfo = value;
		}


	}
}