package 
{
	/**
	 * @author Theprit
	 */
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.media.Camera;
	import flash.media.Video;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import ReduceColors;
	
	import codegears.imageprocess.ObjectDetecter;
	import codegears.imageprocess.FaceDetecter;
	import codegears.imageprocess.FLVToServerSteaming;
	import codegears.imageprocess.JpegToServerManager;
	
	[SWF(width = '640', height = '590', frameRate = '25', backgroundColor = '0xFFFFFF')]
	
	public final class Main extends Sprite
	{
		//Camera
		protected var _detectCambuff:BitmapData;
		
		protected var camBmp:Bitmap;
		protected var _cam:Camera;
		protected var _video:Video;
		protected var _cambuff:BitmapData;
		private var w:int = 640;
		private var h:int = 480;
		
		//graphic
		protected var myview:Sprite;
		protected var outline:Shape;
		
		//Demo varliable
		public var objectDetectRect:Rectangle = new Rectangle(84, 280, 186, 144);
		private var demoStage:Number = 0; //0:Begin 1:PlaceFinish 2:DetectFace 3:DetectSpeak
		
		public var detectObject:ObjectDetecter;
		public var detectFace:FaceDetecter;
		
		public var recoder:FLVToServerSteaming;
		public var jpegSender:JpegToServerManager;
		
		public var lastTime:Number;
		
		//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		public function Main()
		{			
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
	//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		protected function init():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initCamera(640, 480, 25);
			
			outline = new Shape();
			myview.addChild(outline);
			
			detectObject = new ObjectDetecter(_cambuff, objectDetectRect);
			detectFace = new FaceDetecter(myview, _cambuff);
			
			recoder = new FLVToServerSteaming(_cam);
			
			jpegSender = new JpegToServerManager();
			
			lastTime = getTimer();
			addEventListener(Event.ENTER_FRAME, updateFrame);
		}
		
		//**********************************************************************************************************
		
		protected function initCamera(w:int = 640, h:int = 480, fps:int = 20):void
		{
			_cambuff = new BitmapData( w, h, false, 0x0 );
            _cam = Camera.getCamera();
            _cam.setMode( w, h, fps, true );

			//_cambuff_rect = _cambuff.rect;
			//_cam_mtx = new Matrix(-1, 0, 0, 1, w);
            
            _video = new Video( _cam.width, _cam.height );
            _video.attachCamera( _cam );
			
			camBmp = new Bitmap(_cambuff); 
			myview = new Sprite();
			addChild(myview);
			myview.addChild( camBmp );
		}
		
		//**********************************************************************************************************
		
		protected function updateFrame(e:Event):void
		{
			var startTime:Number = getTimer();
			var elapedTime:Number = (startTime - lastTime) / 1000;
			lastTime = startTime;
			
			_cambuff.draw(_video);
			
			var g:Graphics = outline.graphics;
			g.clear();
				
			if ( demoStage == 0) {
				//Stage with to detect object
				
				g.clear();
				g.lineStyle(1, 0xff0000);
				g.drawRect(objectDetectRect.x, objectDetectRect.y, objectDetectRect.width, objectDetectRect.height);
				
				//Detecting object
				if (detectObject.processSurf() == true) {
					demoStage = 1;
					
				}
			}
			else if(demoStage == 1){
				//This stage is between stage: object is founded and is init net connection in this stage.
				
				g.clear();
				g.lineStyle(4, 0x00ffff);
				g.drawRect(objectDetectRect.x, objectDetectRect.y, objectDetectRect.width, objectDetectRect.height);
				
				//connect and start send stream video
				recoder.Connect();
				
				demoStage = 2;
			}
			else if (demoStage == 2) {
				//This stage do detect face, month , game logic and connecting to server
				
				//Detecting face
				var stage:uint = detectFace.processHaarcascade();
				
				//Send an image to server
				jpegSender.sendMessage(_cambuff);
				
				//Cut server connection
				if (stage == 0) {
					recoder.Disconnect();
				}
			}
		}
	}
}
