package codegears.imageprocess 
{
	/**
	 * ...
	 * @author Theprit
	 */
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import ru.inspirit.image.ASLSD;
	import ru.inspirit.surf.ASSURF;
	import ru.inspirit.surf.ReferenceInfo;
	import ru.inspirit.surf.image.AutoImageProcessor;
	import ru.inspirit.surf.image.QuasimondoImageProcessor;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ReduceColors;
	
	public class ObjectDetecter 
	{
		[Embed(source = '../../../assets/TestElectro.jpg')] private static const ref_a:Class;
		
		protected var imageRect:Rectangle;
		
		protected const iref : BitmapData = Bitmap(new ref_a()).bitmapData;
		
		protected const surf:ASSURF = new ASSURF();
		protected const imgQProc:QuasimondoImageProcessor = new QuasimondoImageProcessor(new Rectangle(), false);
		protected const imgAProc:AutoImageProcessor = new AutoImageProcessor(new Rectangle());
		protected const surfTimer:Timer = new Timer(1000/20);
		
		protected var refID_0:int;
		protected var debugText:String;
		public var cambuff:BitmapData;
		public var imgBuff:BitmapData;
		
		public var objectDetectRect:Rectangle = new Rectangle(84, 280, 186, 144);
		
		public function ObjectDetecter(_cambuff:BitmapData, _objectDetectRect:Rectangle) 
		{
			cambuff = _cambuff;
			objectDetectRect = _objectDetectRect;
			
			imgBuff = new BitmapData(objectDetectRect.width, objectDetectRect.height, false, 0x000000);
			
			// ASSURF setup
			// first method you should call
			surf.init(ASSURF.DETECT_PRECISION_HIGH, 600, 5000, 3);
			
			// make ASSURF detect region of interest automatically
			surf.autoDetectROI = true;
			
			// add bitmapData object as reference
			refID_0 = surf.addRefObject(iref, 6, 2000, false);
			
			// finalize setup by analyzing all references
			// you cant add anything after it
			surf.buildRefIndex();
			
			// here is 2 different image pre-processors you can use to refine camera image
			imgAProc.imageRect = imgQProc.imageRect = cambuff.rect;
			surf.imageProcessor = imgAProc;
			//surf.imageProcessor = imgQProc;
			
			// setup input image dimensions
			surf.setup(640, 480);
			
			//surfTimer.addEventListener(TimerEvent.TIMER, processSurf);
			//surfTimer.start();
		}
		
		public function processSurf( ):Boolean
		{
			var t:int = getTimer();
			var ref:ReferenceInfo;
			
			ref = surf.detectSingleObject(cambuff, refID_0, ASSURF.GET_HOMOGRAPHY);
			//ref = surf.detectSingleObject(_cambuff, refID_0, ASSURF.GET_MATCHES);
			
			
			if(ref.matchedPointsCount >= 2) 
			{
				imgBuff.copyPixels(cambuff, objectDetectRect, new Point(0, 0));
				ReduceColors.toCGA(imgBuff, true);
				
				//black point
				var p1:uint = imgBuff.getPixel(objectDetectRect.width * 0.20, objectDetectRect.height * 0.20);
				var p2:uint = imgBuff.getPixel( objectDetectRect.width * 0.75, objectDetectRect.height * 0.50); 
				var p3:uint = imgBuff.getPixel(objectDetectRect.width * 0.54, objectDetectRect.height * 0.84);
				
				//Check Black region
				var bb:Number = percentBlackColorInRect(imgBuff, new Rectangle(objectDetectRect.width*0.1,objectDetectRect.height*0.1,objectDetectRect.width*0.5, objectDetectRect.height*0.5));
				var aa:Number = percentBlackColorInRect(imgBuff, new Rectangle(objectDetectRect.width*0.55,0,objectDetectRect.width - objectDetectRect.width*0.55, objectDetectRect.height));
				
				
				if (bb > 95 && aa < 90)
				{
					debugText = 'SURF Detect Object: Found Object!' + ref.matchedPointsCount ;
					
					return true;
				}
				else {
					debugText= 'SURF Detect Object: Found But' + ref.matchedPointsCount ;
					
					return false;
				}
				
			}else {
				debugText = 'SURF Detect Object: Not found' + ref.matchedPointsCount;
				return false;
			}
		}
		
		public function GetDebugText():String {
			return debugText;
		}
		
		private function percentBlackColorInRect(image:BitmapData, rect:Rectangle):Number {
			var cnt:Number = 0;
			for ( var x:Number = rect.x; x < (rect.x + rect.width); x++ ) {
				for ( var y:Number = rect.y; y < (rect.y + rect.height); y++ ) {
					var color:uint = image.getPixel(x, y);
					if (color == 0 ) 
						cnt++;
				}
			}
			return (cnt/(rect.width * rect.height))*100;
		}
	}

}