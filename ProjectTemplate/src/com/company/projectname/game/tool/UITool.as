package com.company.projectname.game.tool
{
	import com.company.projectname.SystemManager;
	import com.company.projectname.game.ui.component.PrettySimpleButton;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Mason
	 */
	public class UITool 
	{
		/**
		 * 文本悬停时的颜色 ：0xc5ddff
		 */		
		public static const TXT_HOVER_COLOR:uint = 0xc5ddff;
		/**
		 * 文本正常时的颜色： 0x006eff
		 */		
		public static const TXT_NORMAL_COLOR:uint = 0x006eff;
		/**
		 * 排行榜里整成状态的字体颜色： 
		 */		
		public static const TXT_NORMAL_COLOR_IN_RANK:uint = 0x2F4785;
		
		// 卡牌反转时的3D透视角度调整
		private static var _perspectiveProjection:PerspectiveProjection = new PerspectiveProjection();
		private static var _projectionCenter:Point = new Point();
		
		/**
		 * 设置按钮是否可用状态
		 * @param	btn
		 * @param	enabled
		 * @param	applyFilter
		 */
		public static function setButtonState(btn:PrettySimpleButton, enabled:Boolean, applyFilter:Boolean=true):void
		{
			if (!btn) return;
			if (applyFilter)
				btn.filters = enabled ? [] : [SystemManager.Instance.fitlerMgr.grayEffect];
			btn.enabled = enabled;
			btn.mouseEnabled = enabled;
		}
		
		/**
		 * 显示对象上下移动 
		 * @param target
		 * @param direction 0-向下|1-向上
		 * @param range 移动的距离
		 * @param duration
		 * 
		 */		
		public static function moveUpAndDown(target:*, direction:int, range:int=20, duration:Number=.3):void
		{
			kill(target);
			TweenLite.to(target, duration, {y: (direction == 1 ? range * -1 : 0)});
		}
		
		/**
		 * 上下跳动 循环效果
		 * @param target
		 * @param range
		 * @param duration
		 * 
		 */		
		public static function moveUpDownLoop(target:*, range:int=20, duration:Number=.3):void
		{
			TweenLite.to(target, duration, {
				y: range * -1, 
				onComplete: moveUpDownLoopAgain,
				onCompleteParams: [target, range, duration]
			});
		}
		
		private static function moveUpDownLoopAgain(target:*, range:int=20, duration:Number=.3):void
		{
			TweenLite.to(target, duration, {
				y: 0, 
				onComplete:moveUpDownLoop,
				onCompleteParams:[target, range, duration]
			});
		}
		
		/**
		 * 闪烁一个对象 
		 * @param target
		 * 
		 */		
		public static function shining(target:*):void
		{
			TweenMax.to(target, .4, {
				y: "-10",
				glowFilter: { color:0x91e600, alpha:1, blurX:30, blurY:30 },
				onComplete: goBackToNoShining,
				onCompleteParams: [target, true]
			});
		}
		/**
		 * 配合实现闪烁效果 
		 * @param target
		 * @param repeat
		 * 
		 */		
		public static function goBackToNoShining(target:*, repeat:Boolean=true):void
		{
			var vars:Object = {
				y: 5,
				glowFilter: { color:0x91e600, alpha:0, blurX:0, blurY:0, remove:true }
			};
			
			if (repeat)
			{
				vars["onComplete"] = shining;
				vars["onCompleteParams"] = [target];
			}
			
			TweenMax.to(target, .4, vars);
		}
		
		/**
		 * 是否有Tween动画 
		 * @return
		 */		
		public static function hasTweens(target:*, lite:Boolean=true):Boolean
		{
			if (lite) return TweenLite.getTweensOf(target).length > 0;
			else 	  return TweenMax.getTweensOf(target).length > 0; 
		}
		
		/**
		 * 移除一个对象的缓动效果 
		 * @param target
		 * @param lite
		 * 
		 */		
		public static function kill(target:*, lite:Boolean=true):void
		{
			if (lite) TweenLite.killTweensOf(target);
			else 	  TweenMax.killTweensOf(target);
		}
			
		/**
		 * 将显示对象的注册点移到中心位置
		 * @param disObj
		 * @param w
		 * @param h
		 * 
		 */		
		public static function transformRegPointToCenter(disObj:DisplayObject, w:int=0, h:int=0):void
		{
			var matrix:Matrix = disObj.transform.matrix;
			if (matrix)
			{
				if (w == 0) w = disObj.width;
				if (h == 0) h = disObj.height;
				matrix.tx = 0;
				matrix.ty = 0;
				matrix.translate(-w/2, -h/2);
				disObj.transform.matrix = matrix;
			}
		}
		
		/**
		 * 调整3D透视角度 
		 * @param fieldOfView - 0--180之间的数
		 * @param projectionCenterX
		 * @param projectionCenterY
		 * @return 
		 * 
		 */		
		public static function adjustProjection(fieldOfView:Number, projectionCenterX:Number, projectionCenterY:Number):PerspectiveProjection
		{
			if (fieldOfView < 0) fieldOfView = 0;
			if (fieldOfView > 180) fieldOfView = 180;
			
			_projectionCenter.x = projectionCenterX;
			_projectionCenter.y = projectionCenterY;
			
			_perspectiveProjection.fieldOfView = fieldOfView;
			_perspectiveProjection.projectionCenter = _projectionCenter;
			
			return _perspectiveProjection;
		}
		
		/**
		 * 禁用tab键 
		 * @param disObj
		 * 
		 */		
		public static function disableTab(disObj:DisplayObjectContainer):void
		{
			disObj.tabChildren = false;
			disObj.tabEnabled = false;
		}
		
		/**
		 * 禁用鼠标事件 
		 * @param disObj
		 * 
		 */		
		public static function disableMouseEvt(disObj:DisplayObjectContainer):void
		{
			disObj.mouseEnabled = false;
			disObj.mouseChildren = false;
		}
		
		/**
		 * 
		 * @param target
		 * @param add
		 * @param duration
		 * @param color
		 * @param alpha
		 * @param blurX
		 * @param blurY
		 * @param strength
		 * 
		 */		
		public static function glow(target:*, add:Boolean=true, duration:Number=.3, color:uint=0xffffff, alpha:Number=1, blurX:int=5, blurY:int=5, strength:int=2):void
		{
			TweenMax.killTweensOf(target, true, {glowFilter: true});
			if (add)
				TweenMax.to(target, duration, {glowFilter:{color:color, alpha:alpha, blurX:blurX, blurY:blurY, strength:strength}});
			else
				TweenMax.to(target, duration, {glowFilter:{alpha:0, blurX:0, blurY:0, remove:true}});
		}
		
		/**
		 * 
		 * @param target
		 * @param ty
		 * 
		 */		
		public static function moveYTo(target:*, ty:int):void
		{
			TweenLite.killTweensOf(target, true, {y: true});
			TweenLite.to(target, .3, { y: ty });
		}
		
		/**
		 * 将一个mv中所有的textfield的字体设置为游戏内的通用字体
		 * @param mv
		 * 
		 */		
		public static function setAllTxtInDisObjCon(disObjCon:DisplayObjectContainer):void
		{
			if (!disObjCon) return;
			
			var count:int = disObjCon.numChildren;
			var $txt:TextField;
			var $txf:TextFormat;
			var child:DisplayObject;
			
			while (count--)
			{
				child = disObjCon.getChildAt(count);
				
				if (child is TextField)
				{
					$txt = TextField(child);
					$txf = $txt.defaultTextFormat;
					$txf.font = SystemManager.Instance.txtFormatMgr.globalFont;
					$txt.defaultTextFormat = $txf;
				}
				else if (child is DisplayObjectContainer)
				{
					setAllTxtInDisObjCon(DisplayObjectContainer(child));
				}
			}
		}
		
		/**
		 * 设置为游戏内的通用字体
		 * @param txt
		 * @return 
		 * 
		 */		
		public static function setYaHeiTxt(txt:String):String
		{
			return "<font face='" + SystemManager.Instance.txtFormatMgr.globalFont + "'>" + txt + "</font>";
		}
	}

}