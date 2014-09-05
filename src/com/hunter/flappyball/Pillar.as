package com.hunter.flappyball 
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Hunter Lightman
	 */
	public class Pillar extends Sprite
	{
		private var _gap:Number;
		private var _w:Number;
		private var _h:Number = 10000;
		private var _y:Number;
		
		public var p1:Sprite = new Sprite();
		public var p2:Sprite = new Sprite();
		
		public function Pillar(gap:Number, w:Number, stageheight:Number) 
		{
			_gap = gap;
			_w = w;
			
			_y = Math.random() * (stageheight - gap - 50) + 25;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void {
			addChild(p1);
			addChild(p2);
			
			p1.graphics.beginFill(0x00FF00, 1);
			p1.graphics.lineStyle(4, 0x000000);
			p1.graphics.drawRect(0, 0, _w, _h);
			p1.graphics.endFill();
			p2.graphics.beginFill(0x00FF00, 1);
			p2.graphics.lineStyle(4, 0x000000);
			p2.graphics.drawRect(0, 0, _w, _h);
			p2.graphics.endFill();
			p2.y = p1.height + _gap;
			
			this.y = _y - _h;
		}
		
	}

}