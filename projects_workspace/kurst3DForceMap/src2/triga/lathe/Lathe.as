package triga.lathe {
	import away3d.core.base.SubGeometry;
	import away3d.entities.Mesh;

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import triga.utils.VectorUtils;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Lathe extends SubGeometry {
		private var _axis : Vector3D;
		private var _profile : Profile;
		private var _sides : uint;
		private var _offset : Vector3D;
		private var _turns : Number;

		public function Lathe(axis : Vector3D, profile : Profile, sides : uint = 12, turns : Number = 1, offset : Vector3D = null) {
			_axis = axis;
			_axis.normalize();

			_profile = profile;
			_sides = sides;
			_turns = turns;
			_offset = offset || new Vector3D();

			compute();
		}

		private function compute() : void {
			var vertices : Vector.<Number> = new Vector.<Number>();
			var indices : Vector.<uint> = new Vector.<uint>();
			var uvs : Vector.<Number> = new Vector.<Number>();

			var step : uint = 0, back : uint = 0, profilePointCount : uint = profile.path.length;
			var i0 : uint, i1 : uint, i2 : uint, i3 : uint, currentIndex : uint = 0;

			var m : Matrix3D = new Matrix3D();
			var v : Vector3D, t : Vector3D;
			var angleStep : Number = 360 / ( sides / turns );
			var total : Number = ( 360 * turns ) + angleStep;
			// 0 > i > 360° * turns
			for ( var i : Number = 0; i < total; i += angleStep ) {
				m.identity();
				m.appendRotation(i, axis, axis);

				for each ( v in profile.path ) {
					t = m.transformVector(v);

					vertices.push(t.x, t.y, t.z);
				}

				if ( step > 0 ) {
					back = step - profilePointCount;
					for ( var j : int = 0; j < profilePointCount - 1; j++ ) {
						i0 = back + j;
						i1 = back + ( j + 1 ) % profilePointCount;
						i2 = step + j;
						i3 = step + ( j + 1 ) % profilePointCount;

						indices.push(i1, i0, i2);
						indices.push(i1, i2, i3);
					}
				}
				step += profilePointCount;
			}

			updateVertexData(vertices);

			indices = indices.concat(indices.concat().reverse());
			updateIndexData(indices);

			updateVertexNormalData(vertices.concat());

			updateUVData(VectorUtils.expand2D(Vector.<Number>([0, 1]), Vector.<Number>([0, 1]), profilePointCount, ( sides * turns ) + 1));
		}

		public function update() : void {
			var vertices : Vector.<Number> = new Vector.<Number>();
			var m : Matrix3D = new Matrix3D();
			var v : Vector3D, t : Vector3D;
			var angleStep : Number = 360 / ( sides / turns );
			var total : Number = ( 360 * turns ) + angleStep;
			for ( var i : Number = 0; i < total; i += angleStep ) {
				m.identity();
				m.appendRotation(i, axis, axis);
				for each ( v in profile.path ) {
					t = m.transformVector(v);
					vertices.push(t.x, t.y, t.z);
				}
			}
			updateVertexData(vertices);
		}

		public function get axis() : Vector3D {
			return _axis;
		}

		public function set axis(value : Vector3D) : void {
			_axis = value;
			update();
		}

		public function get profile() : Profile {
			return _profile;
		}

		public function set profile(value : Profile) : void {
			_profile = value;
			compute();
		}

		public function get sides() : uint {
			return _sides;
		}

		public function set sides(value : uint) : void {
			_sides = value;
			compute();
		}

		public function get offset() : Vector3D {
			return _offset;
		}

		public function set offset(value : Vector3D) : void {
			_offset = value;
			compute();
		}

		public function get turns() : Number {
			return _turns;
		}

		public function set turns(value : Number) : void {
			_turns = value;
			compute();
		}

		public function get mesh() : Mesh {
			var mesh : Mesh = new Mesh();
			mesh.geometry.addSubGeometry(this);
			return mesh;
		}
	}
}