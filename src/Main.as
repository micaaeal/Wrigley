package 
{
	/**
	 * @author Theprit
	 */
	import flash.display.Sprite;
	import flash.net.URLRequest;	
	import flash.display.Loader;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
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
			//---- Load External SWF ----//
			var path:URLRequest = new URLRequest("Resources.swf");
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onSWFLoadComplete);
			loader.load(path,context);
		}
		
		public function onSWFLoadComplete(event:Event):void 
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
