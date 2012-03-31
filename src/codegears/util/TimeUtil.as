package codegears.util 
{
	/**
	 * ...
	 * @author Chet Chetchaiyan
	 */
	public class TimeUtil 
	{
		
		public function TimeUtil() 
		{
			
		}
		
		public static function getTimeText(time:Number):String {
			var second:int = time % 60;
			var minute:int = (time / 60) % 60;
			var hour:int = (time / 3600);
			var secondText:String = second.toString();
			if (secondText.length == 1) {
				secondText = "0" + secondText;
			}
			var minuteText:String = minute.toString();
			if (minuteText.length == 1) {
				minuteText = "0" + minuteText;
			}
			var hourText:String = hour.toString();
			if (hourText.length == 1) {
				hourText = "0" + hourText;
			}
			return hourText + " : " + minuteText + " : " + secondText;
		}

	}

}