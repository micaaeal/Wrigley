package codegears.imageprocess 
{
	/**
	 * ...
	 * @author Theprit
	 */
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	import ru.inspirit.image.feature.HaarCascadesDetector;
	import ru.inspirit.image.edges.SobelEdgeDetector;
	import ru.inspirit.image.mem.MemImageInt;
	import ru.inspirit.image.mem.MemImageUChar;
	
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import apparat.math.IntMath;
	
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import flash.utils.ByteArray;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import codegears.imageprocess.SmartRect;
	import ReduceColors;
	
	public class FaceDetecter 
	{
		
		//------------------------ HaarCascade --------------------------------------------------
		//public static const XML_FACE_URL:String = 'haarcascade_frontalface_default.xml';
		public static const ZIP_FACE_URL:String = 'haarcascade_frontalface_alt.zip';
		public static const XML_FACE_URL:String = 'haarcascade_frontalface_alt.xml';
		public static const XML_MOUTH_URL:String = 'mouth.xml';
		public static const XML_NOSE_URL:String = 'nose.xml';
		
		
		//private var faceRectContainer :Sprite;
		
		private var detector:HaarCascadesDetector;
		private var mouthDetector:HaarCascadesDetector;
		private var noseDetector:HaarCascadesDetector;
		
		//------------------- Smart face sprite------------------------- 
		public var sm_faceRect:SmartRect;
		public var sm_mouthRect:SmartRect;
		public var sm_noseRect:SmartRect;
		
		protected var avgHistVec:Vector.<Number> = new Vector.<Number>;
		protected const maxAvgHistCnt:int = 10;
		protected var avgHist:Number = 70;
		
		protected var isFirstTimeFindHist:Boolean = true;
		protected var isReadyToSpeak:Boolean = false;
		
		protected var debugText:String;
		protected var camBuff:BitmapData;
		protected var faceRectContainer :Sprite;
		
		protected var mouthImageBuff:BitmapData;
		protected var mouthBitmap:Bitmap;
		
		protected var mouthImageBuff2:BitmapData;
		protected var mouthBitmap2:Bitmap;
		
		protected var showDebug:Boolean;
		
		public var lastTime:Number;
		
		public function FaceDetecter(myview:Sprite, _camBuff:BitmapData, _showDebug:Boolean = false) 
		{
			showDebug = _showDebug;
			camBuff = _camBuff;
			
			//init smart detect
			sm_faceRect = new SmartRect(myview);
			sm_mouthRect = new SmartRect(myview);
			sm_noseRect = new SmartRect(myview);
			
			sm_faceRect.SetDrawRect(true);
			sm_mouthRect.SetDrawRect(true);
			sm_noseRect.SetDrawRect(false);
			
			//Init mouth bitmap
			mouthImageBuff = new BitmapData(100,40, false, 0x000000);
			mouthBitmap = new Bitmap(mouthImageBuff);
			mouthBitmap.x = 10;
			mouthBitmap.y = 530;
			
			mouthImageBuff2 = new BitmapData(100,40, false, 0x000000);
			mouthBitmap2 = new Bitmap(mouthImageBuff2);
			mouthBitmap2.x = 10;
			mouthBitmap2.y = 575;
			
			faceRectContainer = new Sprite();
			
			
			if (showDebug) 
			{
				myview.addChild( faceRectContainer );
				myview.addChild(mouthBitmap);
				myview.addChild(mouthBitmap2);
			}
			
			//Load zip xml
			var myLoader:URLLoader = new URLLoader();
			myLoader.dataFormat = URLLoaderDataFormat.BINARY;
			myLoader.addEventListener(Event.COMPLETE, onUnZipComplete);
			myLoader.load(new URLRequest(ZIP_FACE_URL));
			
			lastTime = getTimer();
		}
		
		protected function onUnZipComplete(e:Event):void
		{
			var zipFile:ZipFile = new ZipFile( URLLoader( e.currentTarget ).data as ByteArray );
			var entry:ZipEntry = zipFile.getEntry(XML_FACE_URL);
			var data:ByteArray = zipFile.getInput(entry);
			var myXML:XML = XML(data.toString());
			detector = new HaarCascadesDetector(myXML);
			detector.image = camBuff;
			
			entry = zipFile.getEntry(XML_MOUTH_URL);
			data = zipFile.getInput(entry);
			myXML = XML(data.toString());
			mouthDetector = new HaarCascadesDetector(myXML);
			mouthDetector.image = camBuff;
			/*
			entry = zipFile.getEntry(XML_NOSE_URL);
			data = zipFile.getInput(entry);
			myXML = XML(data.toString());
			noseDetector = new HaarCascadesDetector(myXML);
			noseDetector.image = camBuff;
			*/
			
			//addEventListener(Event.ENTER_FRAME, processHaarcascade);
		}
		
		// return 	0 Finding Face: Not found
		// 			1 Found Face, Finding Mouth
		//			2 Found Face, Found Mouth, Stabilize not both
		//			3 Ready to test Speak: Not Speak
		//			4 Ready to test Speak: Found Speak
		public function processHaarcascade(e:Event = null):uint
		{
			var startTime:Number = getTimer();
			var elapedTime:Number = (startTime - lastTime) / 1000;
			lastTime = startTime;
			
			
			var faceRects:Vector.<Rectangle>;
			var mouthRects:Vector.<Rectangle>;
			var noseRects:Vector.<Rectangle>;
			
			var stage:uint = 0;
			
			//search for face
			//Find face only when mouth is lost and begin
			if (sm_mouthRect.GetStage() != sm_mouthRect.SM_STAGE_STATIC) 
			{
				sm_faceRect.SetLock(false);
				faceRects = detector.detect();
			
			// Filter unwant data
				//faceRects = filterRectData(faceRects);
				
			}
			
			sm_faceRect.update(faceRects, elapedTime);
			
			//Find mouth only when face is detect
			if (sm_faceRect.GetStage() == sm_faceRect.SM_STAGE_STATIC) 
			{
				sm_faceRect.SetLock(true);
				stage = 1;
				debugText = 'HaarCascade detect face: FOUND FACE!!';
				
				//Detect mouth
				mouthRects = detectMouth( sm_faceRect.GetRect() );
				//noseRects = detectNose( sm_faceRect.GetRect() );
				//mouthRects = filterRectData(mouthRects);
				
				
				
			}else {
				debugText = 'HaarCascade detect face: Not Found---';
				sm_faceRect.SetLock(false);
				stage = 0;
			}
			
			sm_mouthRect.update(mouthRects, elapedTime);
			//sm_noseRect.update(noseRects, elapedTime);
			
			
			//Debug speak!!
			if ( sm_faceRect.GetStage() == sm_faceRect.SM_STAGE_STATIC &&  sm_mouthRect.GetStage() == sm_mouthRect.SM_STAGE_STATIC) {
				stage = 2;
				
				if (detectMouthSpeak() == true)
					stage = 4;
				else
					stage = 3;
			}
			//draw raw face rect data
			//drawRects(faceRects, scaleFactor, 1);
			//drawRects(noseRects, scaleFactor, 0);
			//drawRects(mouthRects, scaleFactor, 0, false);
			
			return stage;
		}
		
		//**********************************************************************************************************
		
		public function detectMouth(r:Rectangle):Vector.<Rectangle>
		{
			//Screen area
			var mouth_r:Rectangle = r.clone();
			mouth_r.y = mouth_r.bottom - mouth_r.height * 0.35;
			mouth_r.x += mouth_r.width * 0.2;
			mouth_r.width *= 0.6;
			mouth_r.height = r.bottom - mouth_r.y;
			
			var temp:Vector.<Rectangle>;
			
			//detect
			temp = mouthDetector.detect(mouth_r, 1, 1.1, 0.05, null, null);
			
			//filter unwant data
			//temp = filterRectData(temp);
			
			return temp;
		}
		
		//**********************************************************************************************************
		
		public function detectNose(r:Rectangle):Vector.<Rectangle>
		{
			//Screen area
			var nose_r:Rectangle = r.clone();
			nose_r.y += (nose_r.height * 0.25);
			nose_r.x += (nose_r.width * 0.3);
			nose_r.width *= 0.4;
			nose_r.height = r.bottom - nose_r.y - r.height*0.35;
			
			var temp:Vector.<Rectangle>;
			
			//detect
			temp = noseDetector.detect(nose_r, 1, 1.1, 0.05, null, detector);
			
			//filter unwant data
			//temp = filterRectData(temp);
			
			return temp;
		}
		
		//**********************************************************************************************************
		
		public function detectMouthSpeak():Boolean
		{
			//debug
			//generate mouth Image
			//mouthImageBuff.copyPixels(camBuff, sm_mouthRect.GetRect(), new Point(0, 0));
			//mouthImageBuff2.copyPixels(mouthImageBuff, new Rectangle(0, 0, sm_mouthRect.GetRect().width , sm_mouthRect.GetRect().height), new Point(0, 0));
			
			//ReduceColors.toCGA(mouthImageBuff, true, false);
			var colorToReplace:uint = 0xff450000; //0xff750000;
			var newColor:uint = 0xffffffff;
			var maskToUse:uint = 0xffffffff;

			var rect:Rectangle = new Rectangle(0,0,mouthImageBuff.width,mouthImageBuff.height);
			var p:Point = new Point(0, 0);
			//if value in color >= ColorToReplace it will be use old, other is fill with new color
			mouthImageBuff.threshold(camBuff, sm_mouthRect.GetRect(), p, ">=", colorToReplace, newColor, maskToUse, true);
		
			
			//compare algolithum
			//Compare each pixel
			var dd:Number = 0;
			var start:Point = new Point(0, 0);
			var end:Point = new Point(0, 0);
			var stage:Number = 0;
			var n:int = mouthImageBuff.height;
			for (var i:int = 0; i < n; i++) {
				var m:int = mouthImageBuff.width;
				for (var j:int = 0; j < m; j++) {
					var color:int = mouthImageBuff.getPixel(i, j);
					if (color >= 0xff100000) {
						if (stage == 0) {
							stage = 1;
							start.x = j; start.y = i;
							end.x = j; end.y = i;
						}
						else {
							if (start.x > j) start.x = j;
							if (end.x < j) end.x = j;
							end.y = i;
						}
					}
				}
			}
			
			var g:Graphics = faceRectContainer.graphics;
			g.clear();g.lineStyle(2, 0xffff00);
			g.drawRect( mouthImageBuff.rect.left + start.x, mouthImageBuff.rect.top + start.y, 50, 50);
			
			/* //compare each pixel by Vector algolithum is not usable
			var v:Vector.<uint> = bitmapData.getVector(bitmapData.rect);
			var n:int = bitmapData.width * bitmapData.height;
			for (var i:int = 0; i < n; i++) {
				var color:uint = v[i];
				if (color > 0xff300000 ) {
				}
			}
			bitmapData.setVector(bitmapData.rect, v);*/
			
			//Use histogram
			var a:Vector.<Vector.<Number>> = mouthImageBuff.histogram();
			var b:Vector.<Vector.<Number>> = mouthImageBuff2.histogram();
			var dif:Number = IntMath.abs(a[0][0] - b[0][0]);
			
			//save last frame bitmapData
			mouthImageBuff2.copyPixels(mouthImageBuff, mouthImageBuff.rect, new Point(0, 0));
			
			
			
			if ( sm_mouthRect.GetStage() == sm_mouthRect.SM_STAGE_STATIC) {
				//average histogram
				if ( isFirstTimeFindHist == true){
					
					avgHistVec.push(dif);
					
					if ( avgHistVec.length > maxAvgHistCnt) {
						isFirstTimeFindHist = false;
						isReadyToSpeak = true;
						
						var temp:Number = 0;
						var cnt:Number = 0;
						var max:Number = 0;
						for (var l:int = 0; l < avgHistVec.length; l++) {
							if (avgHistVec[l] < 12 || avgHistVec[l]>200) cnt++;
							else {
								temp += avgHistVec[l];
								max = IntMath.max(temp, avgHistVec[l]);
							}
							
						}
						
						var base:Number = avgHistVec.length - cnt;
						if (base < 5) { 
							base = 5;
							avgHist = (temp / base) * 1.5;
							
							if (avgHist <= max) 
							{
								avgHist = (temp / (avgHistVec.length - cnt))*2;
							}
						}
						else {
							avgHist = (temp / (avgHistVec.length - cnt))*2;
						}
						
						if ( isNaN(avgHist)) 
						{
							//Hardcode for an unknown occur
							avgHist = 120;
						}
					}
				}
			}
			
			if ( isReadyToSpeak && dif > avgHist) 
			{
				debugText = 'CHEWING!!!' + dif;
				
				
				return true;
			}
			
			
			debugText = 'detect face: FOUND FACE!!' + dif;
			return false;
		}
		
		//**********************************************************************************************************
		
		public function filterRectData(rects:Vector.<Rectangle>):Vector.<Rectangle>
		{
			//Issue: Very inaccurate, must filter this data
			//> We will find the rect that has same area (inside each other) and keep in new list.
			//Assume that rects that has the most member is the real face. 
				
			//Issue: sometime they has only 1 or 2 data that doesn't contain any other, it still quite inaccurate.
			//> We will discard that data
				
			var intersectRectList:Vector.<Rectangle> = new Vector.<Rectangle>;
			var mostPairRect:int = 0;
			
			//if ( rects.length <= 1) return intersectRectList;
			/*var temp:Number = 0;
			var max:Number = 0;
			var min:Number = 9999;
			for(var i:int = 0; i < rects.length; ++i)
			{
				temp += rects[i].width;
				max = IntMath.max(max, rects[i].width);
				min = IntMath.min(min, rects[i].width);
				
				
			}
			temp = temp / rects.length;
			//difmax = max - temp;
			//difmin = temp - min;
			
			for(var i:int = 0; i < rects.length; ++i)
			{
				if (rects[i].width > temp + 10 && rects[i].width < temp - 10) {
					intersectRectList.push(rects[i]);
				}
			}*/
			
			///*
			for(var i:int = 0; i < rects.length; ++i)
			{
				var tempRectList:Vector.<Rectangle> = new Vector.<Rectangle>;
				
				for (var j:int = 0; j < rects.length; ++j)
				{
					if (i!=j ){//&& rects[i].containsRect(rects[j])) {
						var radiusI:Number = (rects[i].width + rects[i].height) / 2;
						var radiusJ:Number = (rects[j].width + rects[j].height) / 2;
						var redius:Number = IntMath.min(radiusI, radiusJ);
						var centerI:Point = new Point(rects[i].x + rects[i].width / 2, rects[i].y + rects[i].height / 2);
						var centerJ:Point = new Point(rects[j].x + rects[j].width / 2, rects[j].y + rects[j].height / 2); 
						var dist:Number = Point.distance(centerI,centerJ);
						var percent:Number = (dist / radiusI) *100;
						if(percent < 30){
							tempRectList.push(rects[i]);
						}
					}
				}
				if ( tempRectList.length > intersectRectList.length) {
					intersectRectList = tempRectList;
					mostPairRect = i;
				}
			}
			
			trace(intersectRectList.length);
			
			return intersectRectList;
		}
		
		//**********************************************************************************************************
		
	}

}