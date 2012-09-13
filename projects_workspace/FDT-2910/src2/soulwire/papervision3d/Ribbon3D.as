// SOULWIRE LTD
// © JUSTIN CLARKE WINDLE
// blog.soulwire.co.uk
// Ribbon3d v1.00
// 11/08/2008 20:35
package soulwire.papervision3d {
	import org.papervision3d.core.geom.renderables.Triangle3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.math.NumberUV;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.objects.DisplayObject3D;

	public class Ribbon3D extends DisplayObject3D {
		// ————————————————————————————————————————————————————————————	————
		// MEMBER										CLASS / DATATYPE	INIT
		// ————————————————————————————————————————————————————————————
		private var length : Number;
		private var planes : Array;
		private var v1 : Vertex3D;
		private var v2 : Vertex3D;
		private var v3 : Vertex3D;
		private var v4 : Vertex3D;
		// ————————————————————————————————————————————————————————————
		public var tx : Number;
		public var ty : Number;
		public var tz : Number;
		public var width : Number;

		// ————————————————————————————————————————————————————————————
		// CONSTRUCTOR
		// ————————————————————————————————————————————————————————————
		public function Ribbon3D(materialObj : MaterialObject3D = null, thickness : Number = 20, maxSegments : int = 100) {
			super();
			planes = new Array();

			tx = ty = tz = 0;
			v1 = new Vertex3D(tx + width, ty, tz);
			v2 = new Vertex3D(tx - width, ty, tz);

			material = materialObj;
			length = maxSegments;
			width = thickness;
		}

		// ————————————————————————————————————————————————————————————
		// METHODS
		// ————————————————————————————————————————————————————————————
		private function newPlane() : TriangleMesh3D {
			var plane : TriangleMesh3D = new TriangleMesh3D(material, [], []);

			plane.geometry.vertices.push(v1, v2, v3, v4);
			plane.geometry.faces.push(newTriangle(plane, 0));
			plane.geometry.faces.push(newTriangle(plane, 1));
			plane.geometry.ready = true;

			return plane;
		}

		private function newTriangle(plane : TriangleMesh3D, type : int) : Triangle3D {
			var b : Boolean = Boolean(type);

			var vA : Vertex3D = plane.geometry.vertices[ b ? 3 : 0 ];
			var vB : Vertex3D = plane.geometry.vertices[ b ? 1 : 2 ];
			var vC : Vertex3D = plane.geometry.vertices[ b ? 2 : 1 ];

			var nA : NumberUV = new NumberUV(int(b), 1);
			var nB : NumberUV = new NumberUV(int(b), int(!b));
			var nC : NumberUV = new NumberUV(int(!b), int(b));

			return( new Triangle3D(plane, [vA, vB, vC], null, [nA, nB, nC]) );
		}

		// ————————————————————————————————————————————————————————————
		public function draw() : void {
			v3 = new Vertex3D(tx + width, ty, tz);
			v4 = new Vertex3D(tx - width, ty, tz);

			var plane : TriangleMesh3D;

			if ( numChildren >= length ) {
				plane = planes.shift();
				plane.geometry.vertices = [v1, v2, v3, v4];
				plane.geometry.faces = [newTriangle(plane, 0), newTriangle(plane, 1)];
				planes.push(plane);
			} else {
				plane = newPlane();
				planes.push(plane);
				addChild(plane);
			}

			v1 = v3;
			v2 = v4;
		}

		public function moveTo(xp : Number = 0, yp : Number = 0, zp : Number = 0) : void {
			super.x = xp;
			super.y = yp;
			super.z = zp;
		}

		// ————————————————————————————————————————————————————————————
		// GET / SET
		// ————————————————————————————————————————————————————————————
		override public function get x() : Number {
			return tx;
		}

		override public function get y() : Number {
			return ty;
		}

		override public function get z() : Number {
			return tz;
		}

		override public function set x(n : Number) : void {
			tx = n;
		}

		override public function set y(n : Number) : void {
			ty = n;
		}

		override public function set z(n : Number) : void {
			tz = n;
		}
	}
}
