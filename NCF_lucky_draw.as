package  {
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.SimpleButton;
	import flash.errors.*;
	import flash.utils.setTimeout;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public class NCF_lucky_draw extends MovieClip{
		var columns:Array = new Array();
		var initializing:Boolean;
		// all movieclips and interactables
		public var left_container:Container;
		public var mid_container:Container;
		public var right_container:Container;
		public var start_btn:SimpleButton;
		public var stop_btn:SimpleButton;
		public var grey_btn:SimpleButton;
		public var errorMSG:ErrorMessage;
		// all sounds
		private var FX_running,FX_tick,FX_stop:Sound;
		private var FX_running_channel:SoundChannel;
		private var FX_tick_channel,FX_stop_channel:SoundChannel;
		var currentContainer:int = 0;
		public function NCF_lucky_draw() {
			stage.displayState = StageDisplayState.FULL_SCREEN; 
			//stage.scaleMode = StageScaleMode.NO_BORDER;
			FX_running = new Sound();
			FX_tick = new Sound();
			FX_stop = new Sound();
			FX_running.load(new URLRequest("slotmachine_running.mpeg"));
			FX_tick.load(new URLRequest("slotmachine_tick.mpeg"));
			FX_stop.load(new URLRequest("slotmachine_stop.mpeg"));
			
			errorMSG.visible = false;
			stop_btn.visible = stop_btn.mouseEnabled = false;
			grey_btn.visible = grey_btn.mouseEnabled = false;
			start_btn.addEventListener(MouseEvent.CLICK,startRoll);
			stop_btn.addEventListener(MouseEvent.CLICK,stopRoll);
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,loadComplete);
			loader.load(new URLRequest("tables.txt"));
			
			this.addEventListener("flying text halt", nextContainer, true);
		}
		private function loadComplete(e:Event)
		{
			var allData:Array; 
			try
			{
				allData = e.currentTarget.data.split('\n');
				left_container.setPool(allData[0]);
				mid_container.setPool(allData[1]);
				right_container.setPool(allData[2]);
			}
			catch (e:Error)
			{
				trace(e.message);
				errorMSG.visible = true;
			}

			left_container.init("N",0);
			mid_container.init("C",1);
			right_container.init("F",2);
			initializing = true;
			//left_container.start();
		}
		private function nextContainer(e:Event)
		{
			var stoppedContainer:Container = e.target.parent.parent as Container;
			var stopDelayTicks:int = getStopDelay(0);
			trace("Stopped container",stoppedContainer.id);
			trace("Delay",stoppedContainer.id,"=",stopDelayTicks);
			trace("____________");
			if(initializing)
			{
				FX_tick.play();
			}
			else
			{
				FX_tick.play();
				if(stoppedContainer == left_container)
				{
					setTimeout(mid_container.stopRoll,stopDelayTicks);
				}
				else if(stoppedContainer == mid_container)
				{
					setTimeout(right_container.stopRoll,stopDelayTicks);
				}
				else if(stoppedContainer == right_container)
				{
					FX_running_channel.stop();
					FX_stop.play();					
					stopRoll(null);//setTimeout(stopRoll,FlyingText.DURATION*2,null);
				}
			}
		}
		private function startRoll(e:MouseEvent)
		{
			initializing = false;
			var leftStopTime:Number = getStopDelay(0);
			left_container.start();
			mid_container.start();
			right_container.start();
			setTimeout(left_container.stopRoll,leftStopTime);
			FX_running_channel = FX_running.play(0,3);
			
			start_btn.visible = start_btn.mouseEnabled = false;
			grey_btn.visible = grey_btn.mouseEnabled = true;
			
		}
		private function stopRoll(e:MouseEvent)
		{
			start_btn.visible = start_btn.mouseEnabled = true;
			grey_btn.visible = grey_btn.mouseEnabled = false;
		}
		private function getStopDelay(shorten:int):int
		{
			return Math.floor(Math.random()*2000)+2000-shorten;
		}
	}
	
}
