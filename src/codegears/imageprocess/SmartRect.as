package codegears.imageprocess 
{
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.Graphics;
	
	/**
	 * ...
	 * @author Theprit
	 */
	public class SmartRect 
	{
		
		protected var smartRectSprite: Sprite;
		
		//Storage data buffer
		protected var sm_PrevData:Vector.<Rectangle>;
		protected var sm_PrevDataLV2:Vector.<Rectangle>;
		
		//position data
		protected var sm_curRect:Rectangle = new Rectangle;
		protected var sm_tarRect:Rectangle = new Rectangle;		
		protected var sm_oldRect:Rectangle = new Rectangle;
		
		// config value Rate
		protected var sm_moveRate:Number = 2;
		protected var sm_scaleRate:Number = 2;
		protected var sm_rangeResist:Number = 14;
		protected var sm_sizeResist:Number = 14;
		protected var sm_s_rangeResist:Number = 17;
		protected var sm_s_sizeResist:Number = 19;
		
		protected var sm_timeDetectLoss:Number = 1.4;
		protected var sm_timeDetectStatic:Number = 1.4;
		
		// variable
		public const SM_STAGE_LOST:int = 0;
		public const SM_STAGE_MOVING:int = 1;
		public const SM_STAGE_STATIC:int = 2;
		
		protected var sm_curStage:int = 0; //0:lost 1:moving 2:static
		protected var sm_curTimeOut:Number = 0;
		protected var sm_curTimeStill:Number = 0;
		
		protected var _enableUseDataLV1:Boolean;
		protected var _enableUseDataLV2:Boolean;
		
		protected var _drawRect:Boolean;
		protected var _isLock:Boolean;
		
		public function SmartRect(parentView:Sprite, enableUseDataLV1:Boolean = true, enableUseDataLV2:Boolean = false) :void
		{
			smartRectSprite = new Sprite();
			parentView.addChild(smartRectSprite);
			
			_enableUseDataLV1 = enableUseDataLV1;
			_enableUseDataLV2 = enableUseDataLV2;
		}
		
		public function SetLock(islock:Boolean = false):void {
			_isLock = islock;
		}
		
		public function update(rect:Vector.<Rectangle>, elapedTime:Number) : void
		{
			//filter data
			var resRect:Rectangle = filterRectData(rect);
			
			if (!_isLock) {
				//resRect = sm_oldRect;
			
			
			// Loss stage
			if (sm_curStage == SM_STAGE_LOST) 
			{
				if ( resRect == null) {
					sm_curTimeOut = 0;
					sm_curTimeStill = 0;
					sm_tarRect.width = 0;
					sm_tarRect.height = 0;
				}
				else {
					sm_curStage = SM_STAGE_MOVING;
					sm_tarRect = resRect;
				}
			}
			// Moving stage
			else if ( sm_curStage == SM_STAGE_MOVING) {
				if ( resRect == null) {
					sm_curTimeOut += elapedTime;
					if (sm_curTimeOut > sm_timeDetectLoss) {
						//Lost
						sm_curStage = SM_STAGE_LOST;
						sm_tarRect.width = 0;
						sm_tarRect.height = 0;
						sm_curTimeOut = 0;
					}
				}
				else 
				{
					sm_curTimeOut = 0;
					sm_tarRect = resRect;
					
					//Check freeze 
					var center_a:Point = sm_curRect.topLeft; 
					center_a.x += sm_curRect.width / 2;
					center_a.y += sm_curRect.height / 2 ;
					var center_b:Point = sm_tarRect.topLeft; 
					center_b.x += sm_tarRect.width / 2;
					center_b.y += sm_tarRect.height / 2 ;
					
					if ( IsCenterRectNearRect(sm_curRect, sm_tarRect, sm_rangeResist) ){
						sm_curTimeStill += elapedTime;
						if (sm_curTimeStill > sm_timeDetectStatic) {
							sm_curStage = SM_STAGE_STATIC;
							sm_curTimeStill = 0;
						}
					}else {
						sm_curTimeStill = 0;
					}
				}
				
			}
			// Static stage
			else if (sm_curStage == SM_STAGE_STATIC) {
				
				//Check if lost 
				if ( resRect == null ) {
					sm_curTimeOut += elapedTime;
					if (sm_curTimeOut > sm_timeDetectLoss){
						sm_curStage = SM_STAGE_LOST;
						sm_curTimeOut = 0;
						sm_tarRect.width = 0;
						sm_tarRect.height = 0;
					}
				}
				else {
					if ( IsCenterRectNearRect(resRect, sm_tarRect, sm_s_rangeResist) == false){
						sm_curTimeOut += elapedTime;
						if (sm_curTimeOut > sm_timeDetectLoss){
							sm_curStage = SM_STAGE_MOVING;
							sm_curTimeOut = 0;
							sm_tarRect = resRect;
						}
					}
					else {
						sm_curTimeOut = 0;
					}
				}
				
			}
			
			
			var speedX:Number = (sm_tarRect.x - sm_curRect.x) * sm_moveRate;
			var speedY:Number = (sm_tarRect.y - sm_curRect.y) * sm_moveRate;
			var expandX:Number = (sm_tarRect.width - sm_curRect.width) * sm_scaleRate;
			var expandY:Number = (sm_tarRect.height - sm_curRect.height) * sm_scaleRate;
			
			
			sm_curRect.x += (speedX * elapedTime);
			sm_curRect.y += (speedY * elapedTime);
			sm_curRect.width += (expandX * elapedTime);
			sm_curRect.height += (expandY * elapedTime);
			
			}
			
			//Draw
			if( _drawRect){
				var graphic:Graphics = smartRectSprite.graphics;
				graphic.clear();
				
				if (sm_curStage == SM_STAGE_LOST) graphic.lineStyle(1, 0xff0000);
				else if (sm_curStage == SM_STAGE_MOVING) graphic.lineStyle(2, 0x0000ff);
				else graphic.lineStyle(2, 0x00ff00);
				
				graphic.drawRect(sm_curRect.x, sm_curRect.y, sm_curRect.width, sm_curRect.height);
			}
		}
		
		public function SetDrawRect(draw:Boolean = true):void {
			_drawRect = draw;
		}
		
		public function filterRectData(rects:Vector.<Rectangle>):Rectangle
		{
			//Issue: Very inaccurate, must filter this data
			//> We will find the rect that has same area (inside each other) and keep in new list.
			//Assume that rects that has the most member is the real face. 
				
			//Issue: sometime they has only 1 or 2 data that doesn't contain any other, it still quite inaccurate.
			//> We will calculate with old frames and do like above.
			//> We will calculate with the data of smartRect too.
				
			//var intersectRectList:Vector.<Rectangle> = new Vector.<Rectangle>;
			//var mostPairRect:int = 0;
			
			if ( rects == null ) return null;
			
			var cnt:int;
			var highestCnt:int = 0;
			var highestRect:Rectangle;
			
			//if ( rects.length <= 1) return intersectRectList;
			
			//Todo: Expensive algolithum! must change later
			for(var i:int = 0; i < rects.length; ++i)
			{
				//var tempRectList:Vector.<Rectangle> = new Vector.<Rectangle>;
				//var tempRect:Rectangle;
				cnt = 0;
				
				//Check with other rect
				for (var j:int = 0; j < rects.length; ++j)
				{
					if (i!=j && rects[i].containsRect(rects[j])) {
					//if ( i!=j && IsCenterRectNearRect(rects[i], rects[j]) ){
						////tempRectList.push(rects[i]);
						cnt++;
					}
				}
				
				//Check with prevData Lv1
				if ( _enableUseDataLV1 && sm_PrevData != null){
					for (var k:int = 0; k < sm_PrevData.length; ++k ) {
						if ( rects[i].containsRect(sm_PrevData[k])) {
						//if ( IsCenterRectNearRect(rects[i], sm_PrevData[k]) ){
							////tempRectList.push(rects[i]);
							cnt++;
						}
					}
				}
				//Check with prevData Lv2
				if ( _enableUseDataLV2 && sm_PrevDataLV2 != null){
					for (var l:int = 0; l < sm_PrevDataLV2.length; ++l ) {
						if ( rects[i].containsRect(sm_PrevDataLV2[l])) {
						//if ( IsCenterRectNearRect(rects[i], sm_PrevDataLV2[l]) ){
							////tempRectList.push(rects[i]);
							cnt++;
						}
					}
				}
				
				////if ( tempRectList.length > intersectRectList.length) {
				if ( cnt > highestCnt ){
					//intersectRectList = tempRectList;
					//mostPairRect = i;
					highestCnt = cnt;
					highestRect = rects[i];
				}
			}
			
			
			//Check compared with data of smartRect
			/*cnt = 0;
			for(var p:int = 0; p < rects.length; ++p)
			{
				if ( sm_tarRect.containsRect(rects[p])) {
					cnt++;
				}
			}
			//Check with prevData Lv1
			if ( _enableUseDataLV1 && sm_PrevData != null){
				for (var m:int = 0; m < sm_PrevData.length; ++m ) {
					if ( sm_tarRect.containsRect(sm_PrevData[m])) {
						cnt++;
					}
				}
			}
			//Check with prevData Lv2
			if ( _enableUseDataLV2 && sm_PrevDataLV2 != null){
				for (var n:int = 0; n < sm_PrevDataLV2.length; ++n ) {
					if ( sm_tarRect.containsRect(sm_PrevDataLV2[n])) {
						cnt++;
					}
				}
			}
				
			if ( cnt > highestCnt) {
				highestRect = sm_tarRect;
			}
			*/
			
			//Keep old data
			sm_PrevDataLV2 = sm_PrevData;
			sm_PrevData = rects;
			
			//trace(intersectRectList.length);
			
			////return intersectRectList;
			return highestRect;
		}
		
		
		public function IsCenterRectNearRect(r1:Rectangle, r2:Rectangle, range_modifier:uint = 5):Boolean
		{
			var center_a:Point = r1.topLeft; 
			center_a.x += r1.width / 2;
			center_a.y += r1.height / 2 ;
			var center_b:Point = r2.topLeft; 
			center_b.x += r2.width / 2;
			center_b.y += r2.height / 2 ;
					
			if (Point.distance(center_a, center_b) < range_modifier ) {
				return true;
			}
			
			return false;
		}
		
		public function GetStage():int {
			return sm_curStage;
		}
		
		public function GetRect():Rectangle {
			return sm_tarRect;
		}
	}

}