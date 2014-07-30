package com.company.projectname
{
	import flash.utils.Dictionary;
	
	public class VersionController
	{
		/**
		 * 资源文件对应的版本号 
		 */		
		public static var fileVersion:Dictionary = new Dictionary();
		
		public function VersionController()
		{
			
		}
		
		/**
		 * 
		 * @param verSource
		 * 
		 */		
		public static function init(verSource:String):void
		{
			var source:Array = verSource.split("|");
			var v:Array;
			for each (var s:String in source)
			{
				if (s != "")
				{
					v = s.split("=");
					fileVersion[v[0]] = v[1];
				}
			}
			
		}
	}
	
	
}


