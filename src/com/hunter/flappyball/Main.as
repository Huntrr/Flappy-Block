package com.hunter.flappyball
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.TouchEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	/**
	 * ...
	 * @author Hunter Lightman
	 */
	public class Main extends Sprite 
	{
		public const BALL_RADIUS:Number = 20;
		public const PILLAR_WIDTH:Number = 30;
		public const PILLAR_GAP:Number = 200;
		public const BASE_SPEED:Number = 5;
		public var score:int = 0;
		
		private var player:Player;
		private var pillars:Vector.<Pillar> = new Vector.<Pillar>();
		private var loseMessage:TextField = new TextField();
		
		private var lost:Boolean = false;
		
		private var shared:SharedObject;
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			// entry point
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			// new to AIR? please read *carefully* the readme.txt files!

		}
		
		private function start():void {
			player = new Player(BALL_RADIUS);
			player.x = 80;
			player.y = stage.fullScreenHeight / 2 + BALL_RADIUS;
			addChild(player);
			player.start();
			
			pillars = new Vector.<Pillar>();
			score = 0;
			
			lost = false;
		}
		
		private function init(e:Event):void {
			shared = SharedObject.getLocal("FlappyBall");
			
			if (!shared.data.high) {
				shared.data.high = 0;
			}
			lost = true;
			
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, tap);
			addEventListener(Event.ENTER_FRAME, loop);
			
						
			var txtFormat:TextFormat = new TextFormat();
							txtFormat.align = "center";
							txtFormat.color = 0xFF0000;
							txtFormat.size = 32;
							loseMessage.text = "Welcome. This is FlappySquare. This is hard. You will fail. Current high score is " + shared.data.high + ". Good luck.";
							loseMessage.width = stage.fullScreenWidth - 40;
							loseMessage.x = 20;
							loseMessage.height = stage.fullScreenHeight;
							loseMessage.multiline = true;
							loseMessage.wordWrap = true;
							
							loseMessage.setTextFormat(txtFormat);
							loseMessage.y = stage.fullScreenHeight / 2 - (loseMessage.textHeight/2);
							addChild(loseMessage);
		}
		
		private function loop(e:Event):void {
			if (!lost) {
				if (pillars.length == 0) {
					pillars.push(new Pillar(PILLAR_GAP, PILLAR_WIDTH, stage.fullScreenHeight));
					pillars[pillars.length - 1].x = stage.fullScreenWidth;
					addChild(pillars[pillars.length - 1]);
				}
				
				if (pillars[pillars.length - 1].x < stage.fullScreenWidth - 400) {
					pillars.push(new Pillar(PILLAR_GAP, PILLAR_WIDTH, stage.fullScreenHeight));
					pillars[pillars.length - 1].x = stage.fullScreenWidth;
					addChild(pillars[pillars.length - 1]);
				}
				
				for (var i:int = 0; i < pillars.length; i++) {
					if(!lost) {
					
						pillars[i].x -= BASE_SPEED + (score / 2);
						
						if (player.hitTestObject(pillars[i].p1) || player.hitTestObject(pillars[i].p2) || player.y > stage.fullScreenHeight) {
							player.visible = false;
							var txtFormat:TextFormat = new TextFormat();
							txtFormat.align = "center";
							txtFormat.color = 0xFF0000;
							txtFormat.size = 32;
							
							var newHigh:Boolean = score > shared.data.high;
							
							loseMessage.text = "SORRY YOU HAVE LOST. YOU SUCK. FINAL SCORE: " + score + "\n(You " + (newHigh ? " actually are kind of cool because you beat your old high score of " : " are so terribly bad that you couldn't even beat your old high score of ") + shared.data.high + ")";
							loseMessage.width = stage.fullScreenWidth - 40;
							loseMessage.height = stage.fullScreenHeight;
							loseMessage.x = 20;
							loseMessage.multiline = true;
							loseMessage.wordWrap = true;
							
							if (newHigh) {
								shared.data.high = score;
							}
							
							loseMessage.setTextFormat(txtFormat);
							loseMessage.y = stage.fullScreenHeight / 2 - (loseMessage.textHeight/2);
							addChild(loseMessage);
							
							if(player) {
								removeChild(player);
							}
							
							lost = true;
						}
					}
				}
				
				if (lost) {
					for (var j:int = 0; j < pillars.length; j++) {
						removeChild(pillars[j]);
					}
				}
				
				if (pillars[0].x < 0 - pillars[0].width) {
					score = score + 1;
					//player.adder = score/4;
					pillars.reverse();
					pillars.pop();
					pillars.reverse();
				}
			}
		}
		
		private function tap(e:TouchEvent):void {
			if (lost) {
				if(getChildIndex(loseMessage) >= 0) {
					removeChild(loseMessage);
				}
				start();
			} else {
				player.flap();
			}
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}