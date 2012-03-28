package ru.inspirit.surf.arsupport
{
	import away3dlite.containers.ObjectContainer3D;

	import ru.inspirit.surf.ar.ARTransformMatrix;

	/**
	 * @author Eugene Zatepyakin
	 */
	public class ARAway3DLiteDisplayObject extends ObjectContainer3D
	{
		public var averageMatrix:AverageARMatrix = new AverageARMatrix();
		public var maxLostCount:uint = 7;
		public var lostCount:uint = 0;
		public var detected:Boolean = false;

		public function ARAway3DLiteDisplayObject()
		{
			super();
		}

		public function setTransform( tm:ARTransformMatrix, matrixError:Number ):void
		{
			averageMatrix.addMatrix( tm, matrixError );

			this.transform.matrix3D.rawData = averageMatrix.getAway3DLiteMatrix();

			visible = true;
			detected = true;
			lostCount = 0;
		}

		public function lost():void
		{
			if(++lostCount == maxLostCount)
			{
				hideObject();
			}
		}

		protected function hideObject():void
		{
			visible = false;
			detected = false;
			averageMatrix.reset();
		}
	}
}
