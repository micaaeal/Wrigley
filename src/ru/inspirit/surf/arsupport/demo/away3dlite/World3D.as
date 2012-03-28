package ru.inspirit.surf.arsupport.demo.away3dlite 
{
	import away3dlite.containers.Scene3D;
	import away3dlite.containers.View3D;

	import ru.inspirit.surf.ASSURF;
	import ru.inspirit.surf.ar.ARCamera3D;
	import ru.inspirit.surf.arsupport.ARAway3DLiteCamera3D;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Eugene Zatepyakin
	 */
	public final class World3D extends Sprite 
	{
		public var view3d:View3D;
		public var camera3d:ARAway3DLiteCamera3D;
		public var scene3d:Scene3D;
		
		public var airplane:Messerschmitt;
		public var ferrari:Ferrari;
        
		public function World3D(surf:ASSURF, arCamera:ARCamera3D)
		{
			scene3d = new Scene3D();
			camera3d = new ARAway3DLiteCamera3D(arCamera, 1/*stage.stageWidth / 640*/);
			view3d = new View3D(scene3d, camera3d);
			
			surf.setupARCamera(arCamera);
			
			view3d.x = 640 * 0.5;
			view3d.y = 480 * 0.5;
			view3d.z = 0;
            
            this.addChild(view3d);
		}
		
		public function initPlane():void
		{
			airplane = new Messerschmitt(this);
            scene3d.addChild(airplane);
		}
		
		public function initFerrari():void
		{
			ferrari = new Ferrari(this);
            scene3d.addChild(ferrari);
		}
		
		public function render(e:Event = null):void
		{			
			view3d.render();
		}
	}
}
