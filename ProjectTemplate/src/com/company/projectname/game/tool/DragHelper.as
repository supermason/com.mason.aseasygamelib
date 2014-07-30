package com.company.projectname.game.tool
{
	import com.company.projectname.SystemManager;
	import easygame.framework.dragdrop.IAcceptable;
	import com.company.projectname.game.ui.component.Item;
	import com.company.projectname.network.DataParser;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	/**
	 * @author: Mason
	 * @version: 1.0.0
	 * create_time: Dec 27, 2013 2:03:55 PM
	 * description: 静态类，配合DragManager使用，完成服务端校验后的放置
	 **/
	public class DragHelper
	{
		/**拖拽触发者*/
		private static var _initiator:DisplayObject;
		/**拖拽接收者*/
		private static var _accepter:IAcceptable;
		/**数据解析器*/
		private static var _dataParser:DataParser;
		
		/**
		 * 初始化 
		 * 
		 */		
		public static function init():void
		{
			_dataParser = SystemManager.Instance.dataParser;
		}
		
		/**
		 * 处理拖拽中需要屏蔽的一些地方 
		 * @param dragging
		 * 
		 */		
		public static function smoothDragHandler(dragging:Boolean):void
		{
			
		}
		
		/**
		 * 各种拖拽的服务端校验 
		 * @param initiator
		 * @param accepter
		 * 
		 */		
		public static function serverAuthentication(initiator:DisplayObject, accepter:IAcceptable):void
		{
			_initiator = initiator;
			_accepter = accepter;
			
//			if (_initiator is Item) // 物品拖拽
//			{
//				if (_accepter is PackGrid) // 目标是背包
//				{
//					if (_initiator.parent is PackGrid) // 背包内的移动
//					{
//						// 只有目标位置改变，才会触发移动校验
//						if (Item(_initiator).packIndex != PackGrid(_accepter).index)
//						{
//							SystemManager.Instance.nwMgr.packReq.moveItem(
//											SystemManager.Instance.uiMgr.packMgr.curTab,
//											SystemManager.Instance.uiMgr.packMgr.curPage,
//											Item(_initiator).modelId, 
//											PackGrid(_accepter).index
//							);
//						}
//						else // 如果是原位置的移动，则判断是否要使用 
//						{
//							Item(_initiator).tryToUse();
//						}
//					}
//					else if (_initiator.parent is MaterialCardGrid) // 从合成或升级界面向背包内拖动
//					{
//						// 暂时模拟验证成功
//						validated();
//					}
//				}
//				else if (_accepter is MaterialCardGrid) // 目标是合成或者升级界面
//				{
//					PackTool.draggedMaterial = Item(_initiator);
//					// 暂时模拟验证成功
//					validated();
//				}
//			}
		}
		
		/**
		 * 验证通过，则完成拖拽 
		 * 
		 * @param	s
		 */		
		public static function validated(s:String=""):void
		{
			// 先执行数据操作，再结束拖拽 （下面的方法中需要通过_accepter取得替换之前的对象）
			if (s != "") dragEndHandler(s);
			
			_accepter.accept(_initiator);
			
			reset();
		}
		
		/**
		 * 当将物体拖拽到非接收格子上时，弹出对应的操作界面(丢弃、选择数量等)
		 * @param initiator
		 * @param event
		 */		
		public static function popupOperationUI(initiator:DisplayObject, event:MouseEvent):void
		{
			
		}
		
		/**
		 * 服务端验证丢弃ok，前台丢弃物品 
		 * 
		 */		
		public static function dumpItem():void
		{
			if (_initiator)
				Item(_initiator).reset();
			
			reset();
		}
		
		/**
		 * 拖拽结束，清理资源  -- 也用于拖拽失败时，清空本次拖拽的数据
		 * 
		 */		
		public static function reset():void
		{
			_accepter = null;
			_initiator = null;
		}
		
		// privatae ////
		/**
		 * 推拽后带来的数据变化 
		 * @param s
		 * 
		 */		
		private static function dragEndHandler(s:String):void
		{
			var temp:Array = null;
			// 如果是球员，则需要改变球队阵容实力|2个球员的实力
		}
		
		private static function getPowerTip(powerGap:int):String
		{
			if (powerGap > 0)
				return "-" + powerGap;
			else
				return "+" + Math.abs(powerGap);
		}
		
		/**
		 * 丢弃物品 
		 * @param itemId
		 * 
		 */		
		private static function doDump(itemId:int):void
		{
//			SystemManager.Instance.nwMgr.packReq.dumpItem(itemId);
		}
	}
}