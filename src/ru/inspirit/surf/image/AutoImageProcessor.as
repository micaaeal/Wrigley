package ru.inspirit.surf.image 
{
	import ru.inspirit.surf.ImageProcessor;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/**
	 * @author Eugene Zatepyakin
	 */
	public final class AutoImageProcessor extends ImageProcessor 
	{
		public const LUTr:Array = new Array(256);
		public const LUTg:Array = new Array(256);
		public const LUTb:Array = new Array(256);
			
		public function AutoImageProcessor(rect:Rectangle) 
		{
			imageRect = rect;
		}
		
		override public function preProcess(input:BitmapData, output:BitmapData):void
		{			
			var histogram:Vector.<Vector.<Number>> = input.histogram(imageRect);
			
            var binSum:Number;
            var percentage:Number;
            var nextPercentage:Number;
            var j:int, k:int;
            var channel:Vector.<Number>;
            var channelr:Vector.<Number> = histogram[0];
            var channelg:Vector.<Number> = histogram[1];
            var channelb:Vector.<Number> = histogram[2];
            var min:int = 0;
            var max:int = 256;
			var count:Number = 0.0;
            
            k = min - 1;
            while (++k < max)
            {
                count += channelr[k] + channelg[k] + channelb[k];
            }
            
            if (count == 0.0)
            {
                min = 0;
                max = 0;
            }
            else
            {
            	channel = channelb;
            	count = 1.0 / count;
            	
				binSum = 0.0;
                j = -1;
                k = 0;
                while (++j < 255)
                {
                    
                    binSum += channel[j];
                    percentage = binSum * count - 0.006;
                    nextPercentage = (binSum + channel[++k]) * count - 0.006;
                    if ((percentage * (1.0 - (int(percentage < 0.0) << 1))) < (nextPercentage * (1.0 - (int(nextPercentage < 0.0) << 1))))
                    {
                        min = k;
                        break;
                    }
                }
                
                binSum = 0.0;
                j = 256;
                k = 255;
                while (--j > 0)
                {
                    
                    binSum += channel[j];
                    percentage = binSum * count - 0.006;
                    nextPercentage = (binSum + channel[--k]) * count - 0.006;
                    if ((percentage * (1.0 - (int(percentage < 0.0) << 1))) < (nextPercentage * (1.0 - (int(nextPercentage < 0.0) << 1))))
                    {
                        max = k;
                        break;
                    }
                }
            }
                
            var i:int = 256;
            var val:int;
            
            var lr:Array = LUTr;
			var lg:Array = LUTg;
			var lb:Array = LUTb;
            
            if (min != max)
			{
				var scale:Number = 1.0 / (max - min) * 255;
				while(--i > -1)
				{
	                val = ((i - min) * scale) + 0.5;
	                if (val > 255) val = 255;
	                if (val < 0) val = 0;
	                
					lr[i] = val << 16;
					lg[i] = val << 8;
					lb[i] = val;
				}
            }
            else
			{
                while(--i > -1)
				{
	                val = (i - min) * 255 + 0.5;
	                if (val > 255) val = 255;
	                if (val < 0) val = 0;
	                
					lr[i] = val << 16;
					lg[i] = val << 8;
					lb[i] = val;
				}
            }
            
			output.paletteMap(input, imageRect, ORIGIN, lr, lg, lb);
			//output.paletteMap(input, imageRect, ORIGIN, null, null, lb);
			//output.copyChannel(output, imageRect, ORIGIN, 4, 3);
			
			output.applyFilter( output, imageRect, ORIGIN, GRAYSCALE_MATRIX );
		}
	}
}
