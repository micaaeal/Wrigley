package ru.inspirit.surf.arsupport 
{
	import away3dlite.arcane;
	import away3dlite.cameras.Camera3D;

	import ru.inspirit.surf.ar.ARCamera3D;

	import flash.geom.Matrix3D;
	
	use namespace arcane;

	/**
	 * @author Eugene Zatepyakin
	 */
	public final class ARAway3DLiteCamera3D extends Camera3D 
	{
		public var arCamera:ARCamera3D;
		public const arProjectionMatrix:Matrix3D = new Matrix3D();
		
		public function ARAway3DLiteCamera3D(arCamera:ARCamera3D, viewportToSourceWidthRatio:Number = 1.0)
		{
			super();
			
			this.arCamera = arCamera;
			
			this.x = 0;
			this.y = 0;
			this.z = 0;
			
			arProjectionMatrix.rawData = constructAway3DLiteProjectionMatrix(viewportToSourceWidthRatio);
			
			lens = new ARLens(arProjectionMatrix);
		}
		
		public function changeScreenSize(w:int, h:int, viewportToSourceWidthRatio:Number = 1.0):void
		{
			arCamera.changeScreenSize(w, h);
			arProjectionMatrix.rawData = constructAway3DLiteProjectionMatrix(viewportToSourceWidthRatio);
		}
		
		protected function constructAway3DLiteProjectionMatrix(viewportToSourceWidthRatio:Number = 1.0):Vector.<Number>
		{
			return Vector.<Number>([
					arCamera.m00*viewportToSourceWidthRatio,	arCamera.m01,	0,	arCamera.m03,
					arCamera.m10,	arCamera.m11*viewportToSourceWidthRatio,	0,	arCamera.m13,
					arCamera.m20,	arCamera.m21,	arCamera.m22,	1,
					0,		0,		0,		0
				]);
		}

		/*public override function get projectionMatrix3D():Matrix3D 
		{
			return this.arProjectionMatrix;
		}*/
	}
}

import away3dlite.arcane;
import away3dlite.cameras.lenses.AbstractLens;

import flash.geom.Matrix3D;

use namespace arcane;

internal final class ARLens extends AbstractLens
{
	protected var arProjectionMatrix:Matrix3D;
				
	public function ARLens (arProjectionMatrix:Matrix3D)
	{
		this.arProjectionMatrix = arProjectionMatrix;
		super();
	}
	
	arcane override function _update () :void 
	{
		_projectionMatrix3D = arProjectionMatrix;
	}
}
