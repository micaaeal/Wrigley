package codegears 
{
	import codegears.ui.ProgressBar;
	import codegears.util.CodeGearsTimer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import Resources.AllTimeMC;
	import Resources.TimeProgress;
	import Resources.*;
	
	/**
	 * ...
	 * @author Chet Chetchaiyan
	 */
	public class BorderMovieClip extends MovieClip implements WigleyCameraListener
	{
		private var timer:CodeGearsTimer;
		private var movie:MovieClip;
		private var todayTime:TodayTimeMC;
		private var allTime:AllTimeMC;
		private var timeProgress:TimeProgress;
		private var progressBar:ProgressBar;
		private var backG:BackGroundMC;
		private var head:hearBarMc;
		private var body:bodyBarMc;
		private var tail:tailBarMc;
		private var bg:bgBarMc;
		
		public function BorderMovieClip() {
			timer = new CodeGearsTimer();
			timer.start();
			
			/*backG = new BackGroundMC();
			backG.x = -20;
			backG.y = 0;
			this.addChild(backG);*/
			
			movie = new MovieClip();
			movie.graphics.beginFill(0x7190b3);
			movie.graphics.drawRect(0, 0, 240, 180);
			movie.graphics.endFill();
			movie.x = 390;
			this.addChild(movie);
			todayTime = new TodayTimeMC();
			todayTime.x = 390;
			todayTime.y = 290;
			this.addChild(todayTime);
			allTime = new AllTimeMC();
			allTime.x = 390;
			allTime.y = 400;
			this.addChild(allTime);
			timeProgress = new TimeProgress();
			timeProgress.y = 380;
			this.addChild(timeProgress);
			head = new hearBarMc() ;
			body = new bodyBarMc();
			tail = new tailBarMc();
			bg = new bgBarMc();
			/*var bg:MovieClip = new MovieClip();
			//bg.graphics.beginBitmapFill(bitmapdata, null, true, false);
			bg.graphics.beginFill(0xFFFF00);
			bg.graphics.drawRect(0, 0, 380, 10);
			bg.graphics.endFill();			
			
			
			head.graphics.beginFill(0xFF00FF);
			head.graphics.drawRect(0, 0, 10, 10);
			head.graphics.endFill();		
			var body:MovieClip = new MovieClip();
			
			body.graphics.beginFill(0xFF0000);
			body.graphics.drawRect(0, 0, 10, 10);
			body.graphics.endFill();			
			var tail:MovieClip = new MovieClip();
			
			tail.graphics.beginFill(0x00FF00);
			tail.graphics.drawRect(0, 0, 10, 10);
			tail.graphics.endFill();		*/	
			
			progressBar = new ProgressBar(bg, head, body, tail);
			progressBar.y = 445;
			progressBar.setProgress(0.5);
			this.addChild(progressBar);
		}
		
		public function onStart():void {
			
		}
		
		public function onBoxDetect():void {
			
		}
		
		public function onMouthMove():void {
			
		}
		
		public function onMouthStop():void {
		}
		
		public function onUpdate(event:Event):void {
			timer.update();
			todayTime.addTime(timer.getEleapse());
		}
	}

}