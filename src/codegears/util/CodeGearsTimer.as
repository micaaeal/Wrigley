package codegears.util 
{
	/**
	 * ...
	 * @author Chet Chetchaiyan
	 */
	import flash.utils.getTimer;
	
	public class CodeGearsTimer 
	{
		private var elapedTime:Number;
		private var startTime:Number;
		private var lastTime:Number;
			
		public function CodeGearsTimer() 
		{
			
		}
		
		public function start():void {
			lastTime = getTimer();
		}
		
		public function update():void {
			startTime = getTimer();
			elapedTime = (startTime - lastTime) / 1000;
			lastTime = startTime;
		}
		
		public function getEleapse():Number {
			return elapedTime;
		}
		
	}

}