package com.hunter.flappyball 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Hunter Lightman
	 */
	public class Player extends Sprite
	{
		private var _radius:Number;
		private const GRAVITY:Number = 1;
		private const MAX_V:Number = 30;
		private const JUMP:Number = -15;
		public var adder:int = 0;
		
		private var vy:Number = 0;
		
		public function Player(radius:Number) 
		{
			_radius = radius;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function loop(e:Event):void {
			vy += GRAVITY + adder;
			
			if (vy > MAX_V + adder) {
				vy = MAX_V;
			} else if (vy < -MAX_V - adder) {
				vy = -MAX_V;
			}
			this.y = y + vy;
		}
		
		public function init(e:Event):void {
			this.graphics.beginFill(0xFF0000, 1);
			this.graphics.lineStyle(4, 0x000000);
			this.graphics.drawRect(_radius, _radius, _radius * 2, _radius * 2);
			this.graphics.endFill();
		}
		
		public function start():void {
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		public function flap():void {
			vy = JUMP - adder*2;
		}
	}

}