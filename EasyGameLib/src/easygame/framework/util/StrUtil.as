package easygame.framework.util
{
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 3:29:15 PM
	 * description 字符串操作帮助类
	 * 注意：\unnnn,表示十六进制的unicode编码； 
	 *      \xnn ,表示十六进制的ascii编码； 
	 **/

	public class StrUtil 
	{ 
		//////////////////////////////////////////////////////////////////////// 
		public static var C_EMPTY:String = "";//空 
		public static var C_BLANK:String = " ";//空格 
		public static var C_NEW_LINE:String = "\n";//新行 
		public static var C_TAB:String = "\t";//Tab符 
		public static var C_BACKSAPCE:String = "\b";//回退符 
		public static var C_NEXTPAGE:String = "\f";//制表符（换页格式符） 
		public static var C_RETURN:String = "\r";//回车符 
		
		/** 用在 encodeXML(String) 和 decodeXML(String) */ 
		private static var translateArray:Array = [ 
			[ "&", "&amp;" ],//这个要放在第一位
			[ " ", "&nbsp;"],
			[ "<", "&lt;" ],
			[ ">", "&gt;" ],
			[ "\"", "&quot;" ],
			[ "'", "&apos;" ],
			[ "", "&szlig;" ],
			[ "\"", "&quot;" ] 
		]; 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 把xml里面的特殊字符转换成替代字符 
		 */  
		public static function encodeXML(text:String):String{ 
			var s:String = text; 
			for (var i:int = 0; i < translateArray.length; i++) { 
				s = replaceAll(s, translateArray[i][0], translateArray[i][1]); 
			} 
			return s; 
		} 
		/** 
		 * 把替代字符还原成xml字符 
		 */ 
		public static function decodeXML(text:String):String{ 
			var s:String = text; 
			for (var i:int = 0; i < translateArray.length; i++) { 
				s = replaceAll(s, translateArray[i][1], translateArray[i][0]); 
			} 
			return s; 
		} 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 判断空 
		 */  
		public static function isEmpty(str:String):Boolean{ 
			if(str == null)return true; 
			str = trim(str); 
			if(str == null || str.length<=0)return true; 
			return false; 
		} 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 去除两头的空格 
		 */  
		public static function trim(str:String):String{ 
			//return StringUtil.trim(str);
			return str.replace(/^\s*/g,"").replace(/\s*$/g,"");
		} 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 取得字符串位置 
		 * @param String src 操作的字符串 
		 * @param String str 匹配的串 
		 * @param int index 开始的位置[默认值：0] 
		 *  
		 * @return int 返回匹配的位置，－1表示没有匹配的 
		 */  
		public static function indexOf(src:String, str:String, index:int=0):int{ 
			//if(isEmpty(src)||isEmpty(str))return -1; 
			return src.indexOf(str,index); 
		} 
		/** 
		 * 取得字符串位置 
		 * @param String src 操作的字符串 
		 * @param String str 匹配的串 
		 * @param int index 开始的位置[默认值：字符串长度-1] 
		 *  
		 * @return int 返回匹配的位置，－1表示没有匹配的 
		 */  
		public static function lastIndexOf(src:String, str:String, index:int=-1):int{ 
			//if(isEmpty(src)||isEmpty(str))return -1; 
			//if(index==-1)index=src.length-1;//默认值：字符串长度-1 
			//return src.lastIndexOf(str,index); 
			
			if(index == -1) 
				return src.lastIndexOf(str); 
			else 
				return src.lastIndexOf(str, index); 
		} 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 截取字符串 
		 * [注] 1,substring方法中，如果参数为负数，会自动转化为0； 
		 *      2,substring方法中，如果结束下标小于开始下标，表示反向截取； 
		 * @param String src 源串 
		 * @param int start 起始位置 
		 * @param int end 结束位置 
		 *  
		 * @return String 截取的串 
		 */  
		public static function subString(src:String, index_start:int=0,  
										 index_end:int=-1):String{ 
			if(index_end ==-1){ 
				return src.substring(index_start); 
			}else{ 
				return src.substring(index_start, index_end); 
			} 
		} 
		
		/** 
		 * 从开始下标截取一定长度的字符串 
		 * [注]start:-1表示倒数第一个字符；－2表示倒数第二个字符，依次类推; 
		 *     若指定的长度超过了剩余的长度，则取剩余的全部长度; 
		 * @param String src 源串 
		 * @param int start 开始位置 
		 * @param int length 截取长度 
		 *  
		 * @return String 截取的串 
		 */  
		public static function substr(src:String, start:int, length:int=-1):String{ 
			if(length ==-1){ 
				return src.substr(start); 
			}else{ 
				return src.substr(start, length); 
			} 
		} 
		
		// search(正则表达式) match()?????/ 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 将字符串转换为数组 
		 * @param String src 源串 
		 * @param String ch 标识串 
		 *  
		 * @return Array 以标识分割的字符串数组 
		 */  
		public static function toArray(src:String, ch:String):Array{ 
			return src.split(ch); 
		} 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 替换字符串 
		 * @param String src 源串 
		 * @param String from_ch 被替换的字符 
		 * @param String to_ch 替换的字符 
		 * @param Boolean rp_all 是否替换掉全部匹配字符,true:是|false：否 
		 *  
		 * @return String 结果字符串 
		 */  
		public static function replace(src:String, from_ch:String,  
									   to_ch:String, rp_all:Boolean=false):String{ 
			while(src.indexOf(from_ch)!=-1){ 
				src = src.replace(from_ch, to_ch); 
				if(!rp_all)return src; 
			} 
			return src; 
		} 
		/** 
		 * 替换全部字符串 
		 * @param String src 源串 
		 * @param String from_ch 被替换的字符 
		 * @param String to_ch 替换的字符 
		 *  
		 * @return String 结果字符串 
		 */  
		public static function replaceAll(src:String, from_ch:String, 
										  to_ch:String):String{ 
			return src.split(from_ch).join(to_ch); 
		} 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 反转字符: abc==>cba 
		 * @param String src 源串 
		 *  
		 * @return String 反转之后的串 
		 */  
		public static function reverse(src:String):String{ 
			var arr:Array = src.split(""); 
			arr = arr.reverse(); 
			return arr.join(""); 
		} 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 取得某个字符的ASCII码 
		 */  
		public static function charCodeAt(src:String, index:int):int{ 
			return src.charCodeAt(index); 
		} 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 取得某个位置的字符 
		 */  
		public static function charAt(src:String, index:int):String{ 
			return src.charAt(index); 
		} 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 大小写转换 
		 */  
		public static function toUpperCase(src:String):String{ 
			return src.toUpperCase(); 
		} 
		public static function toLowerCase(src:String):String{ 
			return src.toLowerCase(); 
		} 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 将字符转换成boolean值 
		 */  
		public static function booleanValue(src:String):Boolean{ 
			var trimmed:String = trim(src).toLowerCase(); 
			return trimmed == "true" 
				|| trimmed == "t" 
				|| trimmed == "yes" 
				|| trimmed == "1"; 
		} 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 去除头部的空格 
		 */  
		public static function trimLeadingWhitespace(src:String):String{ 
			var ch:String; 
			var index:int = 0; 
			while((ch = src.charAt(index)) == C_BLANK){ 
				index++; 
			} 
			return subString(src, index); 
		} 
		/** 
		 * 去除尾部的空格 
		 */  
		public static function trimTrailingWhitespace(src:String):String{ 
			var ch:String; 
			var index:int = src.length-1; 
			while((ch = src.charAt(index)) == C_BLANK){ 
				index--; 
			} 
			return subString(src, 0, index+1);//注意这里要＋1 
		} 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 是否以某个字符串开头 
		 */  
		public static function startsWith(src:String, prefix:String):Boolean{ 
			if(isEmpty(src) || isEmpty(prefix)) return false; 
			if(src.length < prefix.length) return false; 
			return src.indexOf(prefix) == 0; 
		} 
		
		/** 
		 * 是否以某个字符串开头[忽略大小写] 
		 */ 
		public static function startsWithIgnoreCase(src:String, prefix:String):Boolean{ 
			if(isEmpty(src) || isEmpty(prefix)) return false; 
			if(src.length < prefix.length) return false; 
			var tmp:String = src.toLowerCase(); 
			var s:String = prefix.toLowerCase(); 
			return tmp.indexOf(s) == 0; 
		} 
		/** 
		 * 是否以某个字符串结尾 
		 */ 
		public static function endsWith(src:String, suffix:String):Boolean{ 
			if(isEmpty(src) || isEmpty(suffix)) return false; 
			if(src.length < suffix.length) return false; 
			return src.lastIndexOf(suffix) == src.length - suffix.length; 
		} 
		/** 
		 * 是否以某个字符串结尾[忽略大小写] 
		 */ 
		public static function endsWithIgnoreCase(src:String, suffix:String):Boolean{ 
			if(isEmpty(src) || isEmpty(suffix)) return false; 
			if(src.length < suffix.length) return false; 
			var tmp:String = src.toLowerCase(); 
			var s:String = suffix.toLowerCase(); 
			return tmp.lastIndexOf(s) == tmp.length - s.length; 
		} 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 是否是数字 
		 */  
		public static function isNumeric(src:String):Boolean{ 
			if (isEmpty(src)) return false; 
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/; 
			return regx.test(src); 
		} 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 是否相同 
		 */  
		public static function equals(src:String, dest:String):Boolean{ 
			return src == dest;//????? 
		} 
		public static function equalsIgnoreCase(src:String, dest:String):Boolean{ 
			var t:String = src.toLowerCase(); 
			var s:String = dest.toLowerCase(); 
			return s == t;//????? 
		} 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 按照某个标识分割成数组 
		 */  
		public static function split(src:String, flg:String):Array{ 
			return src.split(flg); 
		} 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 包含 
		 */  
		public static function contains(src:String, flg:String):Boolean{ 
			return src.indexOf(flg) !=- 1; 
		} 
		//////////////////////////////////////////////////////////////////////// 
		/** 
		 * 把字符串转换成UTF-8的编码 
		 */  
		public static function encodeUTF(src:String):String{ 
			return encodeURIComponent(src); 
		} 
		/** 
		 * 从UTF-8转换成原来的编码 
		 */  
		public static function decodeUTF(src:String):String{ 
			return decodeURIComponent(src); 
		} 
		
		/**
		 * 是否为空白;
		 */		
		public static function isWhitespace(char:String):Boolean
		{
			switch (char) {
				case "":
				case " ":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;	
				default:
					return false;
			}
		}
		
		/**
		 * 将一个大数字转化为千分制表现形式
		 * @param value：待转化的数字
		 * @return 格式化后的字符串
		 * */
		public static function getPrettyValue(value:Number):String
		{
			var s:String = StrUtil.trim(value.toString());
			if(s.length < 4)
			{
				return s; 
			}
			else
			{
				var arrStr:Array = s.split("");
				arrStr = arrStr.reverse();
				s = "";
				var __i:int = arrStr.length;
				for(var i:int = 0; i < __i; i++)
				{
					if((i != 0) && ((i % 3) == 0))
						s += ",";
					s += arrStr[i];
				}
				return s.split("").reverse().join("");
			}
		}
	}
}