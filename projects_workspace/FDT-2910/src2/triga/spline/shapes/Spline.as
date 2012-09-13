package triga.spline.shapes {
	import away3d.core.base.SubGeometry;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;

	import flash.geom.Vector3D;

	import triga.utils.VectorUtils;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Spline extends SubGeometry {
		private var _path : Vector.<Vector3D>;
		private var _radius : Number;
		private var _sides : uint;
		private var _capHoles : Boolean;
		private var _section : Section;
		// reference axis to calc orientation aka magic constant, tweak at your own risk
		private var FIXED_UP_AXIS : Vector3D = Vector3D.Z_AXIS;
		private var material : MaterialBase;
		private var _mesh : Mesh;
		private var PI_div_2 : Number = Math.PI * .5;
		static public const RADIANS_TO_DEGREES : Number = 180 / Math.PI;

		/**
		 * creates a 3D Spline object.
		 * @param	path a series of Vector3D objects describing the path
		 * @param	radius specifies the radius of the spline mesh
		 * @param	sides specifies the number of sides of the spline mesh
		 * @param	capHoles specifies if faces should be created at the ends of the spline mesh
		 * @param	material [optional]	specifies a material to assign to the renderable spline mesh 
		 */
		public function Spline(path : Vector.<Vector3D>, radius : Number = 2, sides : uint = 3, capHoles : Boolean = true, material : MaterialBase = null) {
			this.material = material;

			_path = path;

			_radius = radius;
			_sides = sides;
			_capHoles = capHoles;

			_section = Section.createRegularSection(_radius, _sides);
			_section.loop = false;

			compute();
		}

		/**
		 * magic
		 */
		protected function compute() : void {
			var vs : Vector.<Number> = new Vector.<Number>();
			var uvs : Vector.<Number> = new Vector.<Number>();
			var indices : Vector.<uint> = new Vector.<uint>();

			// orientation
			var v : Vector3D, n : Vector3D, dir : Vector3D, angle : Number = 0;
			var sectionVectors : Vector.<Vector3D>;

			// indices
			var step : uint = 0, back : uint, i : int, i0 : uint, i1 : uint, i2 : uint, i3 : uint;

			for ( i = 0; i < path.length; i++ ) {
				v = path[ i ];
				n = path[ ( i + 1 ) >= path.length ? i : ( i + 1 ) ];

				// find the orientation of the section at this location

				// http://www.experts-exchange.com/Programming/Game/3D_Prog./Q_24783637.html

				if ( !v.equals(n) ) {
					dir = v.subtract(n);
					dir.normalize();
					angle = Math.acos(FIXED_UP_AXIS.dotProduct(dir)) * 180 / Math.PI;
					if ( angle > -PI_div_2 || angle < PI_div_2 ) {
						dir = n.subtract(v);
						dir.normalize();
						angle = Math.acos(FIXED_UP_AXIS.dotProduct(dir));
					}
					dir = FIXED_UP_AXIS.crossProduct(dir);
					dir.normalize();
					_section.transform.identity();
					_section.rotate(dir, angle * RADIANS_TO_DEGREES);
				}

				// positions the section at the current location
				_section.position = v;

				// pushing vertices
				sectionVectors = _section.vectors3D;
				for each ( v in sectionVectors ) {
					vs.push(v.x, v.y, v.z);
				}

				// creating indices
				if ( step > 0 ) {
					back = step - sides;
					for ( var j : int = 0; j < sides; j++ ) {
						i0 = back + j;
						i1 = back + ( j + 1 ) % sides;
						i2 = step + j;
						i3 = step + ( j + 1 ) % sides;

						indices.push(i1, i0, i2);
						indices.push(i1, i2, i3);
					}
				}
				step += sides;
			}

			uvs = VectorUtils.expand2D(Vector.<Number>([0, 1]), Vector.<Number>([0, 1]), path.length, sides);

			// closing the ends if needed
			if ( capHoles ) {
				var len : uint = vs.length / 3 - sides;
				for ( i = 0; i < _section.indices.length / 2; i += 3 ) {
					indices.push(_section.indices[ i + 1 ], _section.indices[ i ], _section.indices[ i + 2 ]);
					indices.push(len + _section.indices[ i ], len + _section.indices[ i + 1 ], len + _section.indices[ i + 2 ]);
				}
			}
			indices = indices.concat(indices.concat().reverse());
			// updates geometry
			updateVertexData(vs);
			autoDeriveVertexNormals = true;
			updateIndexData(indices);
			updateUVData(uvs);
		}

		/**
		 * recomputes the vertices positions only
		 */
		public function update() : void {
			var vs : Vector.<Number> = new Vector.<Number>();
			var v : Vector3D, n : Vector3D, dir : Vector3D, angle : Number = 0;
			var sectionVectors : Vector.<Vector3D>;
			for ( var i : uint = 0; i < path.length; i++ ) {
				v = path[ i ];
				n = path[ ( i + 1 ) >= path.length ? i : ( i + 1 ) ];
				if ( !v.equals(n) ) {
					dir = v.subtract(n);
					dir.normalize();
					angle = Math.acos(FIXED_UP_AXIS.dotProduct(dir)) * 180 / Math.PI;
					dir = FIXED_UP_AXIS.crossProduct(dir);
					dir.normalize();
					_section.transform.identity();
					_section.rotate(dir, angle);
				}
				_section.position = v;
				sectionVectors = _section.vectors3D;
				for each ( v in sectionVectors ) vs.push(v.x, v.y, v.z);
			}
			updateVertexData(vs);
		}

		/*******************************************
		
		properties
		
		 *******************************************/
		public function get path() : Vector.<Vector3D> {
			return _path;
		}

		public function set path(value : Vector.<Vector3D>) : void {
			_path = value;
			compute();
		}

		public function get radius() : Number {
			return _radius;
		}

		public function set radius(value : Number) : void {
			_radius = value;
			_section = Section.createRegularSection(radius, sides);
			compute();
		}

		public function get sides() : uint {
			return _sides;
		}

		public function set sides(value : uint) : void {
			_sides = Math.max(3, value);
			_section = Section.createRegularSection(radius, sides);
			compute();
		}

		public function get capHoles() : Boolean {
			return _capHoles;
		}

		public function set capHoles(value : Boolean) : void {
			_capHoles = value;
			compute();
		}

		/*************************************************
		
		utils
		
		 *************************************************/
		public function get mesh() : Mesh {
			if ( _mesh == null ) {
				_mesh = new Mesh();
				return addToMesh(_mesh);
			}
			return _mesh;
		}

		public function addToMesh(mesh : Mesh) : Mesh {
			mesh.geometry.addSubGeometry(this);
			var subMesh : SubMesh = mesh.getSubMeshForSubGeometry(this);
			subMesh.material = material;
			return mesh;
		}
	}
}