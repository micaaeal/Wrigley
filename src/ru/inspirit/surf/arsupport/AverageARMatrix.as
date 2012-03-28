package ru.inspirit.surf.arsupport
{
	import ru.inspirit.surf.ar.ARTransformMatrix;

	import flash.utils.getTimer;

	/**
	 * @author Eugene Zatepyakin
	 */
	public final class AverageARMatrix extends ARTransformMatrix
	{
		public static var maxLength:int = 3;
		public static var maxMatrixLife:int = 150;
		// time in ms

		public var entries:AverageEntry = new AverageEntry();
		public var count:uint = 0;

		public function AverageARMatrix()
		{
			reset();
		}

		public function addMatrix( matrix:ARTransformMatrix, error:Number ):void
		{
			var entr:AverageEntry = new AverageEntry();
			entr.next = entries;
			entries = entr;
			count++;
			entr.transform = matrix;
			entr.life = getTimer();
			entr.error = error;
			var n:int = count;
			// var n2:int = n >> 1;

			var m:ARTransformMatrix;
			m00 = 0;
			m01 = 0;
			m02 = 0;
			m03 = 0;
			m10 = 0;
			m11 = 0;
			m12 = 0;
			m13 = 0;
			m20 = 0;
			m21 = 0;
			m22 = 0;
			m23 = 0;
			entr = entries;
			while(entr.next)
			{
				m = entr.transform;
				m00 += m.m00;
				m01 += m.m01;
				m02 += m.m02;
				m03 += m.m03;
				m10 += m.m10;
				m11 += m.m11;
				m12 += m.m12;
				m13 += m.m13;
				m20 += m.m20;
				m21 += m.m21;
				m22 += m.m22;
				m23 += m.m23;
				/*if(i >= 2)
				{
					m03 += m.m03;
					m13 += m.m13;
					m23 += m.m23;
				}*/
				entr = entr.next;
			}
			var invDel:Number = 1 / n;
			m00 *= invDel;
			m01 *= invDel;
			m02 *= invDel;
			m03 *= invDel;
			m10 *= invDel;
			m11 *= invDel;
			m12 *= invDel;
			m13 *= invDel;
			m20 *= invDel;
			m21 *= invDel;
			m22 *= invDel;
			m23 *= invDel;
			if(count > maxLength)
			{
				removeWorstOne();
				--count;
			}
		}

		public function reset():void
		{
			if(count)
			{
				count = 0;
				entries = new AverageEntry();
			}
		}

		private function removeWorstOne():void
		{
			var t:uint = getTimer();
			var err:Number;
			var maxErr:Number = 0;
			var old:uint = 0;
			var td:uint;
			var remErr:AverageEntry;
			var remTime:AverageEntry;
			var entr:AverageEntry = entries;
			while(entr.next)
			{
				err = entr.error;
				if(err > maxErr)
				{
					maxErr = err;
					remErr = entr;
				}
				td = t - entr.life;
				if(td > old)
				{
					old = td;
					remTime = entr;
				}
				entr = entr.next;
			}
			if(old > maxMatrixLife)
			{
				removeEntry( remTime );
			}
			else
			{
				removeEntry( remErr );
			}
		}

		public function getAway3DLiteMatrix():Vector.<Number>
		{
			return Vector.<Number>( [ m00, m10, m20, 0, m01, m11, m21, 0, m02, m12, m22, 0, m03, m13, m23, 1 ] );
			/*
			// may be useful
			return Vector.<Number>([
					 m00,	 m10,	 m20, 0,
					-m02,	-m12,	-m22, 0,
					 m01,	 m11,	 m21, 0,
					 m03,	 m13,	 m23, 1
					]);*/
		}

		private function removeEntry( entr:AverageEntry ):void
		{
			var tmp:AverageEntry;
			if(entr == entries)
			{
				tmp = entries;
				if(count > 1)
				{
					entries = entries.next;
				}
				else
				{
					entries = null;
				}
			}
			else
			{
				tmp = entries;
				while (tmp.next != entr)
					tmp = tmp.next;
				tmp.next = entr.next;
			}
		}
	}
}
import ru.inspirit.surf.ar.ARTransformMatrix;

internal final class AverageEntry
{
	public var life:uint = 0;
	public var error:Number = 0;
	public var transform:ARTransformMatrix;
	public var next:AverageEntry;
}
