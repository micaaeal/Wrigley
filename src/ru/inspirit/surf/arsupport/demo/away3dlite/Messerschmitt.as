package ru.inspirit.surf.arsupport.demo.away3dlite 
{
	import away3dlite.core.base.Object3D;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Loader3D;
	import away3dlite.loaders.MQO;

	import ru.inspirit.surf.arsupport.ARAway3DLiteDisplayObject;

	/**
	 * @author Eugene Zatepyakin
	 */
	public final class Messerschmitt extends ARAway3DLiteDisplayObject 
	{
		private var mqo:MQO;
		private var loader:Loader3D;
		private var loaded:Boolean = false;
		private var model:Object3D;
		
		public var world3d:World3D;
		
		public function Messerschmitt(world3d:World3D)
		{
			super();
			
			this.world3d = world3d;
			
			mqo = new MQO();
			mqo.scaling = 3;
			
			loader = new Loader3D();
			loader.loadGeometry("Messerschmitt_Bf_109.mqo", mqo);
			loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			
			this.addChild(loader);
		}
		
		private function onSuccess(event:Loader3DEvent):void
		{
			model = loader.handle;
			model.rotationX = 90;
			loaded = true;
		}
	}
}
