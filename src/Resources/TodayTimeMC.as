package Resources {
	
	import codegears.util.TimeUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	
	public class TodayTimeMC extends MovieClip {
		
		public var timeText:TextField;
		private var time:Number;
		public function TodayTimeMC() {
			time = 0;
		}
		
		public function addTime(elapse:Number):void{
			time += elapse;
			timeText.text = TimeUtil.getTimeText(time);
		}
		
				
	}
	
}
