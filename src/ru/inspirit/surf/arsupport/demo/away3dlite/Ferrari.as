package ru.inspirit.surf.arsupport.demo.away3dlite 
{
	import away3dlite.containers.ObjectContainer3D;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Loader3D;
	import away3dlite.loaders.Max3DS;
	import away3dlite.materials.BitmapMaterial;

	import ru.inspirit.surf.arsupport.ARAway3DLiteDisplayObject;

	import flash.display.Bitmap;

	/**
	 * @author Eugene Zatepyakin
	 */
	public final class Ferrari extends ARAway3DLiteDisplayObject 
	{
		[Embed(source="../../../../../../../assets/fskiny.jpg")] private static var tex_ass:Class;
		
		private var max3ds:Max3DS;
		private var loader:Loader3D;
		private var loaded:Boolean = false;
		private var model:ObjectContainer3D;
		private var mat:BitmapMaterial;
		
		public var world3d:World3D;
		
		public function Ferrari(world3d:World3D)
		{
			super();
			
			this.world3d = world3d;
			
			mat = new BitmapMaterial(Bitmap(new tex_ass()).bitmapData);
			
			max3ds = new Max3DS();
			max3ds.scaling = 100;
			max3ds.material = mat;
			
			loader = new Loader3D();
			loader.loadGeometry("f360.3ds", max3ds);
			loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			
			this.addChild(loader);
		}
		
		private function onSuccess(event:Loader3DEvent):void
		{
			model = loader.handle as ObjectContainer3D;
			//model.rotationX = 90;
			loaded = true;
			
			model.materialLibrary.getMaterial("fskin").material = mat;
		}
	}
}
