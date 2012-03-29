package codegears 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Chet Chetchaiyan
	 */
	public class BorderMovieClip extends MovieClip implements WigleyCameraListener
	{
		private var movie:MovieClip;
		private var todayTime:MovieClip;
		private var allTime:MovieClip;
		private var timeProgress:MovieClip;
		
		
		public function BorderMovieClip() {
			movie = new MovieClip();
			movie.graphics.beginFill(0xFFFF00);
			movie.graphics.drawRect(0, 0, 240, 180);
			movie.graphics.endFill();
			movie.x = 390;
			this.addChild(movie);
			todayTime = new MovieClip();
			todayTime.graphics.beginFill(0xFF0000);
			todayTime.graphics.drawRect(0, 0, 200, 100);
			todayTime.graphics.endFill();
			todayTime.x = 390;
			todayTime.y = 290;
			this.addChild(todayTime);
			allTime = new MovieClip();
			allTime.graphics.beginFill(0xFF0000);
			allTime.graphics.drawRect(0, 0, 200, 100);
			allTime.graphics.endFill();
			allTime.x = 390;
			allTime.y = 400;
			this.addChild(allTime);
			timeProgress = new MovieClip();
			timeProgress.graphics.beginFill(0xFF00FF);
			timeProgress.graphics.drawRect(0, 0, 320, 100);
			timeProgress.graphics.endFill();
			timeProgress.y = 400;
			this.addChild(timeProgress);			
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
		}
	}

}