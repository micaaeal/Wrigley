package 
{
	/**
	 * @author Theprit
	 */
	import flash.display.Sprite;
	import flash.events.Event;
	
	import codegears.CamProcesser;
	import codegears.BorderMovieClip;
	
	import flash.geom.Rectangle;
	
	[SWF(width = '640', height = '590', frameRate = '25', backgroundColor = '0xFFFFFF')]
	
	public final class Main extends Sprite
	{
		private var camRect:Rectangle;
		private var camprocesser:CamProcesser;
		private var borderMC:BorderMovieClip;
		//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		public function Main()
		{	
			borderMC = new BorderMovieClip();
			addEventListener(Event.ENTER_FRAME, borderMC.onUpdate);
			this.addChild(borderMC);
			
			camRect = new Rectangle(0, 0, 460, 320);
			camprocesser = new CamProcesser(camRect, 25);
			addEventListener(Event.ENTER_FRAME, camprocesser.updateFrame);
			this.addChild(camprocesser);
			camprocesser.setWigleyListener(borderMC);
		}
	}
}
