package codegears.ui 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Chet Chetchaiyan
	 */
	public class ProgressBar extends MovieClip 
	{
		
		private var backgroundMC:MovieClip;
		private var headMC:MovieClip;
		private var bodyMC:MovieClip;
		private var tailMC:MovieClip;
		private var totalWidth:int;
		
		public function ProgressBar(background:MovieClip, head:MovieClip, body:MovieClip, tail:MovieClip) 
		{
			backgroundMC = background;
			headMC = head;
			bodyMC = body;
			tailMC = tail;
			totalWidth = backgroundMC.width;
			this.addChild(backgroundMC);
			this.addChild(headMC);
			this.addChild(bodyMC);
			this.addChild(tailMC);
		}
		
		public function setProgress(progress:Number):void {
			progress = Math.min(1, progress);
			progress = Math.max(0, progress);
			var bodyWidth:int = progress * (totalWidth - headMC.width - tailMC.width);
			bodyMC.width = bodyWidth;
			bodyMC.x = headMC.width;
			tailMC.x = headMC.width + bodyMC.width;
		}
	}

}