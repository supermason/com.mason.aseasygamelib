package easygame.framework.loader
{
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 12, 2013 4:00:31 PM
	 * description 与LoaderManager配合使用的待加载资源列表
	 **/
	public dynamic class LoadContentList extends Array
	{
		/**
		 * 保存一次加载中的资源URL路径列表，用于去重复判断 
		 */		
		protected var curContents:String;
		
		public function LoadContentList(...parameters)
		{
			curContents = "";
			
			var n:uint = parameters.length;
			if (n == 1 && (parameters[0] is Number)) 
			{ 
				var dlen:Number = parameters[0]; 
				var ulen:uint = dlen; 
				if (ulen != dlen) 
				{ 
					throw new RangeError("Array index is not a 32-bit unsigned integer ("+dlen+")"); 
				} 
				length = ulen; 
			} 
			else 
			{ 
				length = n; 
				for (var i:int=0; i < n; i++) 
				{ 
					this[i] = parameters[i]  
				} 
			} 
		}
		
		// override ////
		AS3 override function push(...parameters):uint
		{
			if (parameters.length == 0 
				|| (parameters.length == 1 && !"url" in parameters[0]))
			{
				return this.length;
			}
			
			for (var key:* in parameters) 
			{
				("url" in parameters[key] 
					&& curContents.indexOf(parameters[key]["url"]) == -1)
						? (curContents += parameters[key]["url"])
							: parameters.splice(key, 1);
			}
			
			return super.push.apply(this, parameters);
		}
		
		// public ////
		/**
		 * 一次加载后，清除资源列表 
		 * 
		 */		
		public function clear():void
		{
			curContents = "";
		}
	}
}