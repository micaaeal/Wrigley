package ru.inspirit.surf.image
{
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import ru.inspirit.surf.ImageProcessor;

	import com.quasimondo.geom.ColorMatrix;

	import flash.display.BitmapData;

	/**
	 * @author Eugene Zatepyakin
	 */
	public final class QuasimondoImageProcessor extends ImageProcessor
	{
		public const cm:ColorMatrix = new ColorMatrix();
		public const cmf:ColorMatrixFilter = new ColorMatrixFilter();
		public var stretchLevels:Boolean = false;

		public function QuasimondoImageProcessor(rect:Rectangle, stretchLevels:Boolean = false)
		{
			imageRect = rect;
			this.stretchLevels = stretchLevels;
		}

		override public function preProcess(input:BitmapData, output:BitmapData):void
		{
			cm.reset();
			cm.autoDesaturate(input, imageRect, stretchLevels, false);

			cmf.matrix = cm.matrix;
			output.applyFilter( input, imageRect, ORIGIN, cmf );
		}
	}
}
