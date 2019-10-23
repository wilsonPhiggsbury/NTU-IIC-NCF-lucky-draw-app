package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.setTimeout;
	import flash.display.Shape;
	import flash.display.Sprite;
	import fl.transitions.TweenEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.None;

	
	public class Container extends MovieClip{
		
		private var maskRect:Shape = new Shape();
		private var colorRect:Shape = new Shape();
		private var flyingTextContainer:Sprite = new Sprite();
		// logic keeptracking utilities
		private var flyingTexts:Array = new Array();
		public var id:int;
		public var textPool:Array;
		private var timer:Timer;
		private var stopping:Boolean = false;
		// fun stuff: tweens with colors!
		/*public var r:uint;
		public var g:uint;
		public var b:uint;
		private var rTween:Tween;
		private var gTween:Tween;
		private var bTween:Tween;
		private const colorPeriod:int = 10;*/
		
		public function Container() {
			
			this.addEventListener("flying text end",removeFlyingText,true);
			maskRect.graphics.beginFill(0);
			maskRect.graphics.drawRect(-this.width/2, -this.height/2, this.width, this.height);
			maskRect.graphics.endFill();
			/*colorRect.graphics.lineStyle(5);
			flyingTextContainer.addChild(colorRect);
			*/addChild(maskRect);
			addChild(flyingTextContainer);
			flyingTextContainer.mask = maskRect;
			//maskRect;
		}
		public function init(startingText:String, id:int)
		{
			/*r = randColor();
			g = randColor();
			b = randColor();
			rTween = new Tween(this,'r',None.easeNone,r,r,colorPeriod);
			gTween = new Tween(this,'g',None.easeNone,g,g,colorPeriod);
			bTween = new Tween(this,'b',None.easeNone,b,b,colorPeriod);
			rTween.addEventListener(TweenEvent.MOTION_FINISH,chooseNextColor);
			gTween.addEventListener(TweenEvent.MOTION_FINISH,chooseNextColor);
			bTween.addEventListener(TweenEvent.MOTION_CHANGE,transitionColor);
			bTween.addEventListener(TweenEvent.MOTION_FINISH,chooseNextColor);*/
			
			/*colorRect.graphics.beginFill(randColor()<<16 | randColor()<<8 | randColor());
			colorRect.graphics.lineStyle(2);
			colorRect.graphics.drawRoundRect(-100, -150, 200, 300,40,40);
			colorRect.graphics.endFill();*/
			
			this.id = id;
			//initialize timer
			timer = new Timer(FlyingText.DURATION/stage.frameRate/FlyingText.DENSITY*1000);
			timer.addEventListener(TimerEvent.TIMER,spawn);
			//clear movieclip array, initialize with last number
			for each(var k in flyingTexts)
			{
				removeChild(k);
			}
			flyingTexts = new Array();
			var flyingText:FlyingText = new FlyingText(startingText, true);
			flyingTextContainer.addChild(flyingText);
			flyingTexts.push(flyingText);
			
		}
		public function start():void
		{
			var lastText:FlyingText = flyingTexts[0];
			lastText.flyOut();
			/*rTween.start();
			gTween.start();
			bTween.start();*/
			timer.start();
		}
		private function spawn(e:TimerEvent)
		{
			var randElement:String = textPool[Math.floor(Math.random()*textPool.length)];
			var flyingText:FlyingText = new FlyingText(randElement, stopping);
			flyingTextContainer.addChild(flyingText);
			flyingTexts.push(flyingText);
			if(stopping)
			{
				timer.reset();
				stopping = false;
			}
			
			/*colorRect.graphics.clear();
			colorRect.graphics.beginFill(randColor()<<16 | randColor()<<8 | randColor());
			colorRect.graphics.drawRoundRect(-100, -150, 200, 300,40,40);
			colorRect.graphics.endFill();*/
			
		}
		/*private function spawnLast(e:TimerEvent)
		{
			setTimeout(
			   function():void{
			   	var randElement:String = textPool[Math.floor(Math.random()*textPool.length)];
				var flyingText:FlyingText = new FlyingText(randElement, true);
				flyingTextContainer.addChild(flyingText);
				flyingTexts.push(flyingText);
			   }
			,timer.delay);
			
		}*/
		private function removeFlyingText(e:Event)
		{
			flyingTextContainer.removeChild(flyingTexts.shift());
		}
		public function setPool(input:String)
		{
			textPool = input.split(',');
		}
		public function stopRoll():void
		{
			stopping = true;
		}
		// utility
		private function randColor():uint
		{
			var tmpRand:Number = Math.random()*0.5;
			
			var randColor:uint = Math.floor((1-tmpRand*tmpRand)*256);
			return randColor;
		}
		/*private function transitionColor(e:TweenEvent)
		{
			colorRect.graphics.beginFill(r<<16 | g<<8 | b);
			colorRect.graphics.drawRoundRect(-100, -150, 200, 300,40,40);
			colorRect.graphics.endFill();
		}
		private function chooseNextColor(e:TweenEvent)
		{
			if(e.target == rTween)
			{
				rTween.stop();
			}
			else if(e.target == gTween)
			{
				gTween.stop();
			}
			r = randColor();
			g = randColor();
			b = randColor();
			bTween.continueTo(b,colorPeriod);
			gTween.continueTo(g,colorPeriod);
			rTween.continueTo(r,colorPeriod);
			if(stopping)
			{
				rTween.stop();
				gTween.stop();
				bTween.stop();
			}
		}*/
	}
	
}
