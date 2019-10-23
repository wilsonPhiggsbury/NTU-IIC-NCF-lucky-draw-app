package  {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import fl.transitions.Tween;
	import fl.transitions.easing.None;
	import fl.transitions.TweenEvent;
	import flash.events.Event;
	
	public class FlyingText extends MovieClip{
		private const startLoc:int = 275;
		private const endLoc:int = -275;
		private const alt_endLoc:int = 0;
		public static const DURATION:int = 20; // in frames
		public static const DENSITY:int = 4; // how many movieclips in the container at a time?
		
		private var stopThis:Boolean;
		public var txtbox:TextField;
		public var motionTween:Tween;
		public function FlyingText(txt:String, stopThis:Boolean) {
			txtbox.text = txt;
			this.stopThis = stopThis;
			var real_endLoc,duration:int;
			if(stopThis)
			{
				real_endLoc = alt_endLoc;
				duration = DURATION/2;
			}
			else
			{
				real_endLoc = endLoc;
				duration = DURATION;
			}
			motionTween = new Tween(this,"y",None.easeNone,startLoc,real_endLoc,duration);
			motionTween.addEventListener(TweenEvent.MOTION_FINISH, motionFinish);
			motionTween.start();
		}
		private function motionFinish(e:TweenEvent)
		{
			if(!stopThis)
			{
				//removeChild(txtbox);
				this.dispatchEvent(new Event("flying text end"));
			}
			else
			{
				this.dispatchEvent(new Event("flying text halt"));
			}
		}
		public function flyOut():void
		{
			motionTween = new Tween(this,"y",None.easeNone,alt_endLoc,endLoc,DURATION/2);
			motionTween.addEventListener(TweenEvent.MOTION_FINISH, motionFinish);
			stopThis = false;
			motionTween.start();
		}
	}
	
}
