package codegears 
{
	import codegears.ui.ProgressBar;
	import codegears.util.CodeGearsTimer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import Resources.AllTimeMC;
	import Resources.TimeProgress;
	import Resources.TodayTimeMC;
	
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
		
		
		public function BorderMovieClip() {
			timer = new CodeGearsTimer();
			timer.start();
			movie = new MovieClip();
			movie.graphics.beginFill(0xFFFF00);
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
			timeProgress.y = 400;
			this.addChild(timeProgress);
			var bg:MovieClip = new MovieClip();
			bg.graphics.beginFill(0xFFFF00);
			bg.graphics.drawRect(0, 0, 400, 10);
			bg.graphics.endFill();			
			var head:MovieClip = new MovieClip();
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
			tail.graphics.endFill();			
			progressBar = new ProgressBar(bg, head, body, tail);
			progressBar.y = 450;
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