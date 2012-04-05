package Resources {
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	
	
	public class TimeProgress extends MovieClip {
		
		
		private var image1:MovieClip;
		private var image2:MovieClip;
		private var imageBorder1:MovieClip;
		private var imageBorder2:MovieClip;
		private var temp:int = 0;
		private var setRandom:int = Math.floor(Math.random() * 5) + 1;
		public function TimeProgress() {
			// constructor code
			//random set from set1 to set5
			//seatimage according to the set
			//setborderimage accourding to the set
			//temp= 0;
			
			
			
			for (var i:int = 1; i < 6; i++)
			{
			var myPic:String = "../assets/PNG/Wrigley_00"+setRandom+"_0"+i+".png";
			var urlRequest:URLRequest = new URLRequest(myPic);
			var loader:Loader = new Loader;
			loader.x = i * 60;
			loader.y = 0;
			loader.load(urlRequest);
			addChild(loader);
			}
			
			setBorder(2);
		}
		
		
		
		/*
		public function setFiveDisplay(display1:DisplayObject, display2:DisplayObject, 
						display3:DisplayObject, display4:DisplayObject, display5:DisplayObject):void{
			
		}
		*/
		
		/*
		 * function using for set border to the image
		 * count : input number which set border from the start to the count number
		 */
		public function setBorder(count:int):void {
			while(numChildren>0)
			{removeChildAt(0); }
			
			for (var i:int = 1; i < 6; i++)
			{
			var myPic:String = "../assets/PNG/Wrigley_00"+setRandom+"_0"+i+".png";
			var urlRequest:URLRequest = new URLRequest(myPic);
			var loader:Loader = new Loader;
			loader.x = i * 60;
			loader.y = 0;
			if (i <= count)
			{loader.filters = [new GlowFilter(0x000000,1,20,20,1, 1,false,false)]; }
			
			loader.load(urlRequest);
			addChild(loader);
			}
			
		}
	}
	
}
