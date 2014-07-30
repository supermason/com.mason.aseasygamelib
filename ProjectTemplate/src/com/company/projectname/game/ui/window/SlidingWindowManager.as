package com.company.projectname.game.ui.window
{
	import com.greensock.TweenLite;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Jan 3, 2014 9:59:22 AM
	 * description: 可滑动窗体管理器	
	 **/
	public class SlidingWindowManager extends DraggableWindowManager
	{
		protected var allW:int, X:int, Y:int;
		/**
		 * 窗体之间的间隔 
		 */		
		protected var _gap:int = 0;
		
		public function SlidingWindowManager(winClz:Class)
		{
			super(winClz);
		}
		
		/**关闭附窗体时重新定位主窗体[主窗体居中]
		 * @param wMgr： 主窗体管理器
		 * */
		protected function resortWindowOnClose(wMgr:DraggableWindowManager):void
		{
			calculateMainWindowPos(wMgr);
			
			moveTo(wMgr.window, {x: X, y: Y});
		}
		
		/**打开付窗体时重新定位主窗体[主+付居中]
		 * @param wMgr： 主窗体管理器
		 * */
		protected function reposMainWindowOnCreation(mwMgr:DraggableWindowManager):void
		{
			calculateWindowToXToY(mwMgr);
			
			sperateTwo(mwMgr.window,
				window, 
				{　x: X, y: Y　}, 
				{　x: X + mwMgr.window.width + _gap, y: Y　}
			);
		}
		
		/**主窗体打开时，随之打开付窗体重新定位2窗体的位置[主+付居中]
		 * <br>【该方法可用于窗体改变大小时重定位主付窗体的位置】
		 * @param wMgr：付窗体管理器
		 * */
		protected function reposAttachedWindowOnCreation(awMgr:DraggableWindowManager):void
		{
			calculateWindowToXToY(awMgr);
			
			sperateTwo(window,
				awMgr.window, 
				{　x: X, y: Y　}, 
				{　x: X + window.width + _gap, y: Y　}
			);
		}
		
		// private ////
		/**
		 * 计算两个窗体移动到的位置 
		 * @param wMgr
		 * 
		 */		
		private function calculateWindowToXToY(wMgr:DraggableWindowManager):void
		{
			allW = wMgr.window.width + window.width + _gap;
			X = (viewPortW - allW) * .5 /*+ x*/;
			Y = (viewPortH - Math.max(wMgr.window.height, window.height)) * .5 /*+　y*/;
		}
		
		/**
		 * 计算主窗体的位置 
		 * @param mwMgr
		 * 
		 */		
		private function calculateMainWindowPos(mwMgr:DraggableWindowManager):void
		{
			X = (viewPortW - mwMgr.window.width) * .5/* + x*/;
			Y = (viewPortH - mwMgr.window.height) * .5/* + y*/;
		}
		
		/**
		 * 缓动分开 
		 * @param target1
		 * @param target2
		 * @param desti1
		 * @param desti2
		 * 
		 */		
		private function sperateTwo(target1:Object, target2:Object, desti1:Object, desti2:Object):void
		{
			TweenLite.killTweensOf([target1, target2]);
			
			TweenLite.to(target1, .3, desti1);
			TweenLite.to(target2, .3, desti2);
		}
	}
}