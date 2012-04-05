package Resources {
	
	import flash.display.*;
	import codegears.util.TimeUtil;
	import flash.text.TextField;
	import flash.events.*;
	import flash.net.URLRequest;
	
	public class AllTimeMC extends MovieClip {
		public var timeText:TextField;
		public var nameText:TextField;
		public var dateText:TextField;
		public var box:MovieClip;
		public var date:Date = new Date();
		
		public function AllTimeMC() {
			// test set value
			setDate();
			setTime("00:00:23");
			setName("aey");
			setFace("../assets/test01.png"); //set picture url
			
			
			// constructor code
		}
		public function initImg(e:Event):void
		{
			var pic:Loader =e.target.loader as Loader;
			pic.width = 60;
			pic.height=50;
			}
		
		
		public function setTime(time:String):void {
			timeText.text = "" + time;
		}
		public function setDate():void {
			dateText.text = ""+date.getDate()+"/"+date.getMonth()+"/"+date.getFullYear();
		}
		
		public function setName(name:String):void  {
			nameText.text = "" +name;
		}
		
		public function setFace(pic:String):void  {
			var urlRequest:URLRequest = new URLRequest(pic);
			var loader:Loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,initImg);
			loader.load(urlRequest)
			box.addChild(loader);
			
		}
		
	}
	
}
