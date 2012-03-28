package ru.inspirit.surf
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	/**
	 * @author Eugene Zatepyakin
	 */
	public class Utils 
	{
		public static const SURF_POINTS_FILTER:FileFilter = new FileFilter ("ASSURF Data file","*.ass");
		public static const IMAGES_FILTER:FileFilter = new FileFilter("Image File", "*.jpeg;*.jpg;*.gif;*.png");
		
		private static var fileReference:FileReference = new FileReference();
		private static var onOpenFile:Function;
		
		private static var imageLoader:Loader = new Loader();
		
		public static function openImageFile(onLoaded:Function):void
		{
			onOpenFile = loadLocalImage;
			
			fileReference.addEventListener(Event.SELECT, onFileSelect);
			fileReference.addEventListener(Event.COMPLETE, onFileLoadComplete);
			
			
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			
			fileReference.browse([IMAGES_FILTER]);
		}
		
		public static function loadLocalImage(data:ByteArray):void
		{
			imageLoader.loadBytes(data);
		}

		public static function savePointsData(pointsData:ByteArray):void
		{
			fileReference.save(pointsData, 'points.ass');
		}
		
		public static function openPointsDataFile(onOpen:Function):void
		{
			onOpenFile = onOpen;
			
			fileReference.addEventListener(Event.SELECT, onFileSelect);
			fileReference.addEventListener(Event.COMPLETE, onFileLoadComplete);
			
			fileReference.browse( [ SURF_POINTS_FILTER ] );
		}
		
		protected static function onFileSelect(e:Event):void
		{
			fileReference.load();
		}
		
		protected static function onFileLoadComplete(e:Event):void
		{
			fileReference.removeEventListener(Event.SELECT, onFileSelect);
			fileReference.removeEventListener(Event.COMPLETE, onFileLoadComplete);
			
			onOpenFile(fileReference.data);
		}
	}
}
