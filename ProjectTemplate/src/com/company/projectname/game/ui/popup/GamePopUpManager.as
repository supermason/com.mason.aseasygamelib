package com.company.projectname.game.ui.popup
{
	import com.company.projectname.game.tool.WebTool;
	import com.company.projectname.game.ui.window.PopUpManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 1:57:11 PM
	 * description 弹出提示框管理器 
	 **/
	public class GamePopUpManager extends PopUpManager
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		static private const MESSAGE_POP:int = 0;
		static private const CONFIRM_POP:int = 1;
		static private const COUNT_CHOSE_POP:int = 2;
		static private const RADIO_BUTTON_POP:int = 3;
		static private const INPUT:int = 4;
		static private const ITEM_OPR_POP:int = 5;
		
		private var messagePopUp:MessagePopUp;
		private var confirmPopUp:ConfirmPopUp;
		private var countChosePopUp:CountChosePopUp;
		private var radioButtonPopUp:RadioButtonPopUp;
		private var inputPopUp:InputPopUp;
		private var itemOprPopUp:ItemOprPopUp;
		private var dicPopUp:Dictionary;
		private var curPopType:int; // -1标识没有弹出任何层
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		public function GamePopUpManager()
		{
			super();
			
			_coverAlpha = .5;
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		override public function init(parent:DisplayObjectContainer):void
		{
			super.init(parent);
			
			messagePopUp = new MessagePopUp();
			messagePopUp.setCloseHandler(onOKClick);
			messagePopUp.setTextLinkClickHandler(textLickClickHandler);
			confirmPopUp = new ConfirmPopUp();
			confirmPopUp.setCloseHandler(onOKClick);
			countChosePopUp = new CountChosePopUp();
			countChosePopUp.setCloseHandler(onOKClick);
			radioButtonPopUp = new RadioButtonPopUp();
			radioButtonPopUp.setCloseHandler(onOKClick);
			inputPopUp = new InputPopUp();
			inputPopUp.setCloseHandler(onOKClick);
			itemOprPopUp = new ItemOprPopUp();
			itemOprPopUp.setCloseHandler(onOKClick);
			
			dicPopUp = new Dictionary();
			dicPopUp[GamePopUpManager.MESSAGE_POP] = messagePopUp;
			dicPopUp[GamePopUpManager.CONFIRM_POP] = confirmPopUp;
			dicPopUp[GamePopUpManager.COUNT_CHOSE_POP] = countChosePopUp;
			dicPopUp[GamePopUpManager.RADIO_BUTTON_POP] = radioButtonPopUp;
			dicPopUp[GamePopUpManager.INPUT] = inputPopUp;
			dicPopUp[GamePopUpManager.ITEM_OPR_POP] = itemOprPopUp;
			
			curPopType = -1;
		}
		
		/**创建一个对话框
		 * <br>popType决定了对话框的类型，详细请参考<code>GamePopManager</code>类中的常量定义
		 * <br>popData必须包含<code>msg</code>键值，否则本次创建被忽略
		 * <br>popData还可包含:
		 * <br><code>lbls</code>键值：对话框中按钮的显示文本（{ confirmBtnLbl: "", cancelBtnLbl: ""}）
		 * <br><code>cbFun</code>键值: 点击确定按钮时的处理方法
		 * <br><code>vars</code>键值: 确定按钮回调方法所需的参数
		 * <br><code>cancelFun</code>键值: 点击取消按钮时的处理方法
		 * <br><code>clVars</code>键值：取消按钮回调方法锁舞的参数
		 * <br><code>data</code>键值：对话框里需要使用的数据（{updateInfo: 是否更新提示, value:[], radioButtonLbl:[], radioButtonData: []}）
		 * <br>其他键值将被忽略
		 * @param popData
		 * @param popType
		 * */
		public function createGamePopUp(popData:Object, popType:int=0, useCover:Boolean=true):void
		{
			if (!popData || !popData.hasOwnProperty("msg") || popData["msg"] == "")
				return;
			
			if (dicPopUp[popType]) 
			{
//				removeGamePopUp();
				
				if (this.curPopType == popType)
				{
					IPopUpWin(dicPopUp[curPopType]).dispose();
				}
				else
				{
					removeGamePopUp();
					
					addPop(dicPopUp[popType], true, useCover);
				}
				
				this.curPopType = popType;
				IPopUpWin(dicPopUp[popType]).initEvt();
				
				IPopUpWin(dicPopUp[popType]).popInfo = popData;
			} 
			else 
			{
				throw new Error("No such PopType>>>[" + popType + "]!");
			}
		}
		
		/**移除对话框*/
		public function removeGamePopUp():void
		{
			if (curPopType == -1) 
				return;
			
			if (dicPopUp[curPopType]) 
			{
				IPopUpWin(dicPopUp[curPopType]).dispose();
				removePop(dicPopUp[curPopType]);
				curPopType = -1;
			} 
			else 
			{
				throw new Error("No such PopType>>>[" + curPopType + "]!");
			}
		}
		
		override public function onResize(x:int=-1, y:int=-1):void
		{
			if (dicPopUp[curPopType] && dicPopUp[curPopType].isPopped)
				super.center(dicPopUp[curPopType]);
		}
		
		/**
		 * 更新弹出框中的数据 
		 * @param data
		 * 
		 */		
		public function updatePopData(data:Object):void
		{
			if (curPopType == -1) 
				return;
			
			if (dicPopUp[curPopType]) 
			{
				dicPopUp[curPopType].updatePopData(data);
			}
		}
		
		/*=======================================================================*/
		/* EVENT  HANDLER                                                        */
		/*=======================================================================*/
		private function onOKClick(popup:IPopUpWin):void
		{
//			popup.dispose();
//			removePop(popup);
			removeGamePopUp();
		}
		
		private function textLickClickHandler(data:String, popup:IPopUpWin):void
		{
			switch (data)
			{
				case PopUpTxtLinkEventType.CHARGE:
					
					WebTool.gotoChargePage();
					break;
				case PopUpTxtLinkEventType.FIRE:
					break;
			}
			
			onOKClick(popup);
		}
	}
}