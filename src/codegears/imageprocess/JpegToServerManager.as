package codegears.imageprocess 
{
	/**
	 * ...
	 * @author Theprit
	 */
	
	import flash.media.Video;
	import flash.display.AVM1Movie;
	import flash.display.MovieClip;
	import flash.net.FileReference;
	import flash.events.MouseEvent;
	import flash.events.WeakFunctionClosure;
	
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import com.adobe.images.JPGEncoder;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	public class JpegToServerManager 
	{
		//--------------------- JPEG Encoder ----------------------------
		private var imgByteArray:ByteArray;
		private var sendHeader:URLRequestHeader;
		private var sendReq:URLRequest;
		private var jpegEncoder:JPGEncoder;
		private var sendLoader:URLLoader;
		
		private var sendImgTimer:Timer;
		import flash.events.TimerEvent;
		
		public function JpegToServerManager() 
		{
			//Init JPEG Encoder ----------------------------------------------
			jpegEncoder = new JPGEncoder(20);
			
			sendHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			sendReq = new URLRequest("http://www.codegears.co.th/TestFlash/bin/toServer.php");
			sendReq.requestHeaders.push(sendHeader);
			sendReq.method = URLRequestMethod.POST;
			
			sendLoader = new URLLoader();
			sendLoader.addEventListener(Event.COMPLETE, imageSentHandler);
			
			sendImgTimer = new Timer(1000);
			sendImgTimer.addEventListener(TimerEvent.TIMER, sendMessage);
		}
		
		//**********************************************************************************************************
		public function sendMessage(_detectCambuff:BitmapData, scale:Number = 0.32, event:Event = null):void {
			var temp:BitmapData = new BitmapData(_detectCambuff.width*scale, _detectCambuff.height*scale);
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			temp.draw(_detectCambuff, matrix);
			
			imgByteArray = jpegEncoder.encode(temp);
			
			sendReq.data = imgByteArray;
			
			sendLoader.load(sendReq);
		}
		
		//**********************************************************************************************************
		protected function imageSentHandler(event:Event):void {
			var dataStr:String = event.currentTarget.data.toString();
			var resultVars:URLVariables = new URLVariables();
			resultVars.decode(dataStr);
			var imagePath:String = "http://" + resultVars.base + "/" + resultVars.filename;
			trace("Uploaded to: " + imagePath);
			
			//_txtSurfResult.text = dataStr;
		}
		
	}

}