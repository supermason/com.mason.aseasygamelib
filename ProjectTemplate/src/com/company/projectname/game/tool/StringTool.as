package com.company.projectname.game.tool
{
	
	/** 
	 * @author: mason
	 * @E-mail: jijiiscoming@hotmail.com
	 * @version 1.0.0 
	 * 创建时间：May 13, 2014 4:46:28 PM 
	 * 描述：
	 * */
	public class StringTool
	{
		public static var shieldStrs:String;
		private static var shieldArr:Array;
		private static var shieldKeyWordsArr:Array = ["union", "select", "update", "delete", "truncate", "call", "exec", "and", "or", "not", "rollback", "commit", 
			"&", "=", ">", "<", "├", "┤", "(", ")", "/*", "*/", "//", "@", "\\", "/", " ", "\t", "\n", "\r", "'", "--"];
		private static var curStr:String;
		
		//////////////////////////////////////////////////////////////////////// 
		/**
		 * 获取费用字符串
		 * @param cost: 费用数值
		 * @return 格式化后的字符串(XX金XX银XX铜)
		 * */
		public static function getCostStr(cost:int):String
		{
			/*return int(cost / 10000) + "金" 
			+ int((cost % 10000) / 100) + "银" 
			+ int(cost % 100) + "铜";*/
			return cost + ""/*Lang.l.UI_1.tong*/;
		}
		
		/**
		 * 获取时间字符串
		 * @param l 指定的语言包
		 * @param seconds: 时间秒数
		 * @param format: 显示格式
		 * @return 格式化后的字符串(XX小时XX分XX秒)
		 * */
		public static function getTimeStr(l:XML, seconds:int, format:String=""):String
		{
			var h:int = int(seconds / 3600);
			var m:int = int((seconds % 3600) / 60);
			var s:int = int(seconds % 60); 
			
			with (l)
			{
				return (h > 9 ? h : "0" + h) + (format == "" ? hour :  format)
					+ (m > 9 ? m : "0" + m) + (format == "" ? minute :  format) 
					+ (s > 9 ? s : "0" + s) + (format == "" ? second :  "");
			}
		}
		
		/**
		 * 获取时间字符串(不超过一小时的时间)
		 * @param l 指定的语言包
		 * @param seconds: 时间秒数
		 * @param format: 显示格式
		 * @return 格式化后的字符串(XX分XX秒)
		 * */
		public static function getSecondStr(l:XML, seconds:int, format:String=""):String
		{
			if (seconds < 0) seconds = 0;
			var m:int = int((seconds % 3600) / 60);
			var s:int = int(seconds % 60); 
			
			with (l)
			{
				return (m > 9 ? m : "0" + m) + (format == "" ? COMM.minute :  format) 
					+ (s > 9 ? s : "0" + s) + (format == "" ? COMM.second :  "");
			}
		}
		
		/**
		 * 将秒数格式化为对应的时间
		 * @param seconds: 秒数
		 * @param l 指定的语言包
		 * @return 大于一天的返回 XX天XX小时 / 一天之内的返回XX:XX:XX
		 * */
		public static function getComplicatedTimeStr(seconds:int, l:XML=null):String
		{
			if (seconds < 0) seconds = 0;
			var h:int = int(seconds / 3600);
			var m:int = int((seconds % 3600) / 60);
			var s:int = int(seconds % 60); 
			
			var d:int = int(h / 24);
			// 大于一天
			if (d > 0)
			{
				h = h % 24;
				if (l)
				{
					with (l)
					{
						return (d > 9 ? d : "0" + d) + day
							+ (h > 9 ? h : "0" + h) + hour;
					}
				}
				else
				{
					return (d > 9 ? d : "0" + d) + "D"
						+ (h > 9 ? h : "0" + h) + "H";
				}
			} // 一天之内
			else
			{
				return (h > 9 ? h : "0" + h) + ":" 
					+ (m > 9 ? m : "0" + m) + ":" 
					+ (s > 9 ? s : "0" + s);
			}
		}
		
		/**
		 * 将秒数格式化为对应的时间
		 *  @param l 指定的语言包
		 * @param seconds: 秒数
		 * @return 大于一天的返回 XX天 / 一天之内的返回XX小时 / 一小时之内的返回XX:XX
		 * */
		public static function getComplicatedTimeStr2(l:XML,seconds:int):String
		{
			if (seconds < 0) seconds = 0;
			var h:int = int(seconds / 3600);
			var m:int = int((seconds % 3600) / 60);
			var s:int = int(seconds % 60); 
			var d:int = int(h / 24);
			
			if (d > 0) // 大于一天
			{
				return d + l.day;
			} 
			else // 一天之内
			{
				if (h > 0) // 大于一小时
				{
					return h + l.hour;
				}
				else // 以小时以内 
				{
					return (m > 9 ? m : "0" + m) + ":" + (s > 9 ? s : "0" + s);
				}
			}
		}
		
		/**
		 * 返回一个巨大秒数对应的天，小时，分
		 * @param
		 * @param holder: 0-day|1-hour|2-minute
		 * */
		public static function getDayHourMinute(seconds:int, holder:Array, makeUpToTwo:Boolean=true):void
		{
			if (seconds < 0) return;
			
			var h:int = int(seconds / 3600);
			var m:int = int((seconds % 3600) / 60);
			var s:int = int(seconds % 60); 
			var d:int = int(h / 24);
			
			h -= d * 24; 
			
			if (makeUpToTwo && d < 10)
				holder[0] = "0" + d;
			else
				holder[0] = d;
			
			if (makeUpToTwo && h < 10)
				holder[1] = "0" + h;
			else
				holder[1] = h;
			
			if (makeUpToTwo && m < 10)
				holder[2] = "0" + m;
			else
				holder[2] = m;
		}
		
		/**
		 * 执行屏蔽字
		 * @param str：待检测的字符串
		 * */
		public static function shieldStr(str:String):String{
			for each(curStr in shieldArr){
				while(str.indexOf(curStr)>-1){
					str=str.replace(curStr,"**");
				}
			}
			return str;
		}
		
		/**
		 * 是否有屏蔽字 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function hasForbiddenWords(str:String):Boolean
		{
			for each (curStr in shieldArr)
			{
				while (str.indexOf(curStr)>-1){
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 屏蔽数据库关键字 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function shieldKeyWords(str:String):String
		{
			str = str.toLowerCase();
			for each (curStr in shieldKeyWordsArr)
			{
				while(str.indexOf(curStr) > -1)
				{
					str = str.replace(curStr, "**");
				}
			}
			return str;
		}
		
		/**将大串数字(100W开始的)格式化为中文表达法*/
		public static function formatNumber(NUM:Number):String
		{
			if (NUM >= 1000000 && NUM < 100000000)
			{
				return int(Math.floor(NUM / 10000.0 * 10) / 10) + "万";
			}
			else if (NUM >= 100000000)
			{
				return int(Math.floor(NUM / 100000000.0 * 10) / 10) + "亿";
			}
			else
				return NUM + "";
		}
		
		/**将大于w的数值转换为X万的格式*/
		public static function formatNumber2(NUM:Number):String
		{
			if (NUM < 10000) 
				return NUM + "";
			
			if (NUM % 10000 == 0)
				return (NUM / 10000).toFixed() + "w";
			
			return (NUM / 10000).toFixed(1) + "w";
		}
		
		/**
		 * 获取一个时间描述字符串(xxxx/xx/xx  xx:xx:xx) 
		 * @return 
		 * 
		 */		
		public static function getCurrentDate():String
		{
			var date:Date = new Date();
			return date.fullYear + "/" 
				+ getTwoCharNum(date.month + 1) + "/" 
				+ getTwoCharNum(date.date + 1) + "  "
				+ getTwoCharNum(date.hours) + ":"
				+ getTwoCharNum(date.minutes) + ":"
				+ getTwoCharNum(date.seconds);
		}
		
		/**
		 * 比较一个数字，如果小于10则返回0X，否则就是数字对应的字符串 
		 * @param num
		 * @return 
		 * 
		 */		
		public static function getTwoCharNum(num:int):String
		{
			return num < 10 ? "0" + num : num.toString();
		}
		
		/**
		 * 取出xxxx-xx-xx xx:xx:xx时间格式中的  小时:分 
		 * @param date
		 * @return 
		 * 
		 */		
		public static function getHourMinute(date:String):String
		{
			var temp:Array = (date.split(" ")[1]).split(":");
			
			return temp[0] + ":" + temp[1];
		}
	}
}