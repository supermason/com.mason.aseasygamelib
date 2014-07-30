package easygame.framework.display
{
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * @author Mason
	 * @version 1.0.0
	 * create-time Nov 13, 2013 5:18:54 PM
	 * description 窗体基类 
	 **/
	public class Window extends DraggableSprite implements IWindow
	{
		/*=======================================================================*/
		/* VARIABLES                                                             */
		/*=======================================================================*/
		/**窗体是否已经完成初始化*/
		protected var _isInit:Boolean;
		protected var _content:Object;
		/** 窗体业务事件处理方法<br>该方法接受2个参数：事件名称+所需数据[默认值为null]*/
		protected var _winBuziEvtHandler:Function;
		/**窗体皮肤创建完毕时的回调方法*/
		protected var _skinCreated:Function;
		/**窗体创建后会调用该方法*/
		protected var _winCreated:Function;
		/**窗体完全关闭后调用该方法*/
		protected var _winClosed:Function;
		/**窗体开始关闭时调用该方法*/
		protected var _winClosing:Function;
		/**关闭窗体时是否使用缓动效果*/
		protected var _useTweenWhenOpen:Boolean;
		
		/**是否在创建窗体后显示，默认值为true*/
		protected var _showWhenCreated:Boolean = true;
		
		/*=======================================================================*/
		/* CONSTRUCTOR                                                           */
		/*=======================================================================*/
		/**
		 * 构造方法 
		 * @param contentData 初始化窗体所需的数据
		 */		
		public function Window(contentData:Object) 
		{
			super();
			
			_content = contentData;
			_useTweenWhenOpen = true;
			visible = false;
			alpha = 0;
		}
		
		/*=======================================================================*/
		/* PUBLIC  FUNCTIONS                                                     */
		/*=======================================================================*/
		public function closeWindow():void
		{
			_winClosing();
		}
		
		public function close(remove:Boolean):void
		{
			TweenMax.killTweensOf(this);
			TweenMax.to(this, .1, {autoAlpha: 0, onComplete:checkRemove, onCompleteParams:[remove]});
			//checkRmove(remove);
			//visible = false;
			//alpha = 0;
		}
		
		/**每次窗体关闭时都会调用该方法，该方法会调用<code>removeEvt</code>方法
		 * <br>继承该类的所有子窗体最好都重写该方法，在窗体关闭时清理事件监听*/
		override public function reset():void
		{
			super.reset();
			
			removeEvt();
			
			contentData = {};
		}
		
		override public function destory():void
		{
			super.destory();
			
			removeEvt();
			
			removeComps();
		}
		
		/**
		 * 重新打开窗体
		 * */
		public function reOpen(value:Object):void
		{
			_content = value;
			
			if (!visible)
				$show();
			
			addEvt();
		}
		
		/**需要刷新而不是重新打开界面时，用该方法*/
		public function refresh(value:*=null):void
		{
			
		}
		
		/**
		 * 调用<code>show()</code>方法并完成后，会派发窗体创建完毕事件
		 * <br>如果要重写<code>show()</code>方法，务必要派发<code>WindowEvent.CREATION_COMPLETE</code>事件
		 * */
		public function windowCreated(dispatchCreatedEvt:Boolean=true):void
		{
			_isInit = true;
			alpha = 1;
			if (!visible) visible = true;
			if (dispatchCreatedEvt)
				_winCreated();
		}
		
		/**
		 * 拖拽时屏蔽一些事件 
		 * @param block
		 * 
		 */		
		public function blockEvt(block:Boolean):void
		{
			
		}
		
		/*=======================================================================*/
		/* PROTECTED FUNCTIONS                                                   */
		/*=======================================================================*/
		/**
		 * 窗体皮肤加载后调用初始方法
		 */
		protected function initSkin():void
		{
			initComponent();
			addEvt();
			if (!visible) $show();
		}
		
		/**
		 * 初始化各种组件
		 */
		protected function initComponent():void
		{
			
		}
		
		/**
		 * 窗体打开时，初始化窗体内的所有的事件监听器
		 */
		protected function addEvt():void
		{
			displayContent.addEventListener(MouseEvent.MOUSE_DOWN, win_mouseDownHandler);
		}
		
		/**
		 * 窗体关闭时，移除所有的事件监听器
		 */
		protected function removeEvt():void
		{
			displayContent.removeEventListener(MouseEvent.MOUSE_DOWN, win_mouseDownHandler);
		}
		
		/**
		 * 窗体销毁时，移除所有的组件
		 */
		protected function removeComps():void
		{
			
		}
		
		protected function checkRemove(remove:Boolean):void
		{
			reset();
			
			if (!parent) return;
			
			if (remove) $remove(parent);
			
			_winClosed();
		}
		
		protected function $remove(p:*):void
		{
			if (p.contains(this)) p.removeChild(this);
		}
		
		protected function $show(dispatchCreatedEvt:Boolean=true):void
		{
			setCenter();
			
			if (_useTweenWhenOpen)
			{
				TweenMax.killTweensOf(this);
				TweenMax.to(this, .3, { autoAlpha: 1, onComplete:windowCreated, onCompleteParams:[dispatchCreatedEvt] } );
			}
			else 
			{
				windowCreated(dispatchCreatedEvt);
			}
		}
		
		/**
		 * 在显示之前，调用定位的方法
		 */
		protected function setCenter():void
		{
			// 
			if (_skinCreated != null)
				_skinCreated();
		}
		
		/*=======================================================================*/
		/* EVENT HANDLER                                                         */
		/*=======================================================================*/
		protected function win_mouseDownHandler(event:MouseEvent):void
		{
			if (_setTopWhenMouseDown)
				setTop();
		}
		
		/*=======================================================================*/
		/* GETTER && SETTER                                                      */
		/*=======================================================================*/
		public function set autoVisible(value:Boolean):void
		{
			if (value) $show();
		}
		
		public function set contentData(value:Object):void
		{
			_content = value;
		}
		
		public function set winEvtBuziHandler(value:Function):void
		{
			_winBuziEvtHandler = value;
		}
		
		public function set skinCreated(value:Function):void
		{
			_skinCreated = value;
		}
		
		public function set winCreated(value:Function):void
		{
			_winCreated = value;
		}
		
		public function set winClosed(value:Function):void
		{
			_winClosed = value;
		}
		
		public function set winClosing(value:Function):void
		{
			_winClosing = value;
		}
		
		/**
		 * 子类重写给方法，实现具体的皮肤加载 
		 * @param url
		 * 
		 */		
		public function set skinURL(url:String):void
		{
			
		}
	}
}