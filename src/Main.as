package 
{
	/**
	 * @author Theprit
	 */
	
	import codegears.CamProcesser;
	import flash.geom.Rectangle;
	
	[SWF(width = '640', height = '590', frameRate = '25', backgroundColor = '0xFFFFFF')]
	
	
	public final class Main extends Sprite
	{
		private var camRect:Rectangle;
		private var camprocesser:CamProcesser;
		//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		public function Main()
		{	
			camRect = new Rectangle(0, 0, 420, 360);
			camprocesser = new CamProcesser(camRect);
			
		}
		
	//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		protected function init():void
		{
			
		}
		
		
		
		
	}
}
