package triga.spline.shapes {
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.SubGeometry;
	import away3d.core.base.SubMesh;
	import away3d.core.math.Quaternion;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;

	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	import triga.shapes.Axis;
	import triga.shapes.Label;
	import triga.utils.VectorUtils;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Loft extends SubGeometry {
		private var _path : Vector.<Vector3D>;
		private var _capHoles : Boolean;
		private var _section : Section;
		private var matrix : Matrix = new Matrix();
		private var _translationsX : Vector.<Number>;
		private var _translationsY : Vector.<Number>;
		private var _scalesX : Vector.<Number>;
		private var _scalesY : Vector.<Number>;
		private var _rotations : Vector.<Number>;
		// reference axis to calc orientation aka magic constant, tweak at your own risk
		private var FIXED_UP_AXIS : Vector3D = Vector3D.Z_AXIS;
		private var material : MaterialBase;
		private var _mesh : Mesh;
		private var PI_div_2 : Number = Math.PI * .5;
		static public const RADIANS_TO_DEGREES : Number = 180 / Math.PI;

		/**
		 * creates a 3D Loft object.
		 * @param	path		a series of Vector3D objects describing the path
		 * @param 	section		specifies a Section object to Extrude along the path
		 * @param	capHoles	specifies if faces should be created at the ends of the spline mesh
		 * @param	material [optional]		specifies a material to assign to the renderable spline mesh 
		 */
		public function Loft(path : Vector.<Vector3D>, section : Section, capHoles : Boolean = true, material : MaterialBase = null) {
			this.material = material;

			_section = section;
			_capHoles = capHoles;

			this.path = path;
			// will call: compute()
		}

		public function resetTransform() : void {
			_translationsX = VectorUtils.expand(Vector.<Number>([0]), path.length);
			_translationsY = VectorUtils.expand(Vector.<Number>([0]), path.length);
			_scalesX = VectorUtils.expand(Vector.<Number>([1]), path.length);
			_scalesY = VectorUtils.expand(Vector.<Number>([1]), path.length);
			_rotations = VectorUtils.expand(Vector.<Number>([0]), path.length);
		}

		/**
		 * extrusion of the shape along the path
		 */
		protected function compute() : void {
			var vs : Vector.<Number> = new Vector.<Number>();
			var uvs : Vector.<Number> = new Vector.<Number>();
			var normals : Vector.<Number> = new Vector.<Number>();
			var indices : Vector.<uint> = new Vector.<uint>();

			// orientation
			var v : Vector3D, n : Vector3D, dir : Vector3D, axis : Vector3D, angle : Number = 0, lastAngle : Number = 0;
			var sectionVectors : Vector.<Vector3D>;

			// indices
			var step : uint = 0, back : uint, i : int, j : int, i0 : uint, i1 : uint, i2 : uint, i3 : uint;

			for ( i = 0; i < path.length; i++ ) {
				v = path[ i ];
				n = path[ ( i + 1 ) >= path.length ? i : ( i + 1 ) ];

				// find the orientation of the section at this location

				// http://www.experts-exchange.com/Programming/Game/3D_Prog./Q_24783637.html

				if ( !v.equals(n) ) {
					dir = n.subtract(v);
					dir.normalize();

					angle = Math.acos(FIXED_UP_AXIS.dotProduct(dir));

					axis = FIXED_UP_AXIS.crossProduct(dir);
					axis.normalize();

					_section.transform.identity();
					_section.rotate(axis, angle * RADIANS_TO_DEGREES);
				}

				// positions the section at the current location
				_section.position = v;

				// push transformed vertices
				sectionVectors = _section.vectors3D;

				for each ( v in sectionVectors ) {
					vs.push(v.x, v.y, v.z);
				}

				// create indices
				if ( step > 0 ) {
					back = step - sides;
					for ( j = 0; j < sides; j++ ) {
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

			// close the ends if needed
			if ( capHoles ) {
				var len : uint;
				// front faces
				len = vs.length / 3 - sides;
				for ( i = 0; i < sides; i++ ) {
					vs.push(vs[ i * 3], vs[ i * 3 + 1], vs[ i * 3 + 2]);
					uvs.push(section.uvs[i * 2], section.uvs[i * 2 + 1]);
				}
				len = vs.length / 3 - sides;
				for ( i = 0; i < _section.indices.length / 2; i += 3 ) {
					indices.push(len + _section.indices[ i + 1 ], len + _section.indices[ i ], len + _section.indices[ i + 2 ]);
				}

				// back faces
				len = vs.length / 3 - sides * 2;
				for ( i = 0; i < sides; i++ ) {
					vs.push(vs[ ( i + len ) * 3], vs[ ( i + len ) * 3 + 1], vs[ ( i + len ) * 3 + 2]);
					uvs.push(section.uvs[i * 2], section.uvs[i * 2 + 1]);
				}
				len = vs.length / 3 - sides;
				for ( i = 0; i < _section.indices.length / 2; i += 3 ) {
					indices.push(len + _section.indices[ i ], len + _section.indices[ i + 1 ], len + _section.indices[ i + 2 ]);
				}
			}

			// updates geometry
			updateVertexData(vs);
			autoDeriveVertexNormals = true;
			updateIndexData(indices);
			updateUVData(uvs);
		}

		/**
		 * recomputes the vertices positions and transforms only
		 */
		public function update() : void {
			var vs : Vector.<Number> = new Vector.<Number>();
			var v : Vector3D, n : Vector3D, dir : Vector3D, axis : Vector3D, angle : Number = 0;
			var sectionVectors : Vector.<Vector3D>;
			var len : uint = path.length;
			for ( var i : uint = 0; i < len; i++ ) {
				v = path[ i ];
				n = path[ ( i + 1 ) >= path.length ? i : ( i + 1 ) ];
				if ( !v.equals(n) ) {
					dir = n.subtract(v);
					dir.normalize();

					angle = Math.acos(FIXED_UP_AXIS.dotProduct(dir));
					axis = FIXED_UP_AXIS.crossProduct(dir);
					axis.normalize();

					_section.transform.identity();
					_section.rotate(axis, angle * RADIANS_TO_DEGREES);
				}
				_section.position = v;
				section.transform2D(getTransformMatrix(i));
				sectionVectors = _section.vectors3D;
				for each ( v in sectionVectors ) vs.push(v.x, v.y, v.z);
			}
			if ( capHoles ) {
				for ( i = 0; i < sides; i++ ) {
					vs.push(vs[ i * 3], vs[ i * 3 + 1], vs[ i * 3 + 2]);
				}
				len = vs.length / 3 - sides * 2;
				for ( i = 0; i < sides; i++ ) {
					vs.push(vs[ ( i + len ) * 3], vs[ ( i + len ) * 3 + 1], vs[ ( i + len ) * 3 + 2]);
				}
			}

			updateVertexData(vs);
		}

		/*******************************************
		
		transforms
		
		 *******************************************/
		/**
		 * sets the local (2D) translations to assign to the section along the path.
		 * the vector of values can be of arbitrary size, it will be remapped to fit the path's length.
		 * @param	tx	a Vector.<Number> specifying the X translation
		 * @param	ty	a Vector.<Number> specifying the Y translation
		 */
		public function setTranslations(tx : Vector.<Number> = null, ty : Vector.<Number> = null) : void {
			var length : uint = path.length;
			if ( tx != null ) _translationsX = ( tx.length < length ) ? VectorUtils.expand(tx, length) : VectorUtils.compress(tx, length);
			if ( ty != null ) _translationsY = ( ty.length < length ) ? VectorUtils.expand(ty, length) : VectorUtils.compress(ty, length);
		}

		/**
		 * sets the local (2D) translation to assign to a given location along the path.
		 * @param 	id 	the id of the point along the path
		 * @param	tx	value of the X translation
		 * @param	ty	value of the Y translation
		 */
		public function setTranslationAt(id : uint, tx : Number, ty : Number) : void {
			id = Math.max(0, Math.min(path.length, id));
			_translationsX[ id ] = tx;
			_translationsY[ id ] = ty;
		}

		/**
		 * retrieves the translation at a given point along the path
		 * @param	id	the id of the point along the path
		 * @return	a Point containing the X & Y components of the translation
		 */
		public function getTranslationAt(id : uint) : Point {
			id = Math.max(0, Math.min(path.length, id));
			return new Point(_translationsX[ id ], _translationsY[ id ]);
		}

		/**
		 * sets the local (2D) scales to assign to the section along the path.
		 * the vector of values can be of arbitrary size, it will be remapped to fit the path's length.
		 * @param	sx	a Vector.<Number> specifying the X scale
		 * @param	sy	a Vector.<Number> specifying the Y scale
		 */
		public function setScales(sx : Vector.<Number> = null, sy : Vector.<Number> = null) : void {
			var length : uint = path.length;
			if ( sx != null ) _scalesX = ( sx.length < length ) ? VectorUtils.expand(sx, length) : VectorUtils.compress(sx, length);
			if ( sy != null ) _scalesY = ( sy.length < length ) ? VectorUtils.expand(sy, length) : VectorUtils.compress(sy, length);
		}

		/**
		 * sets the local (2D) scale to assign to a given location along the path.
		 * @param 	id 	the id of the point along the path
		 * @param	sx	value of the X scale
		 * @param	sy	value of the Y scale
		 */
		public function setScaleAt(id : uint, sx : Number, sy : Number) : void {
			id = Math.max(0, Math.min(path.length, id));
			_scalesX[ id ] = sx;
			_scalesY[ id ] = sy;
		}

		/**
		 * retrieves the scale at a given point along the path
		 * @param	id	the id of the point along the path
		 * @return	a Point containing the X & Y components of the scale
		 */
		public function getScaleAt(id : uint) : Point {
			id = Math.max(0, Math.min(path.length, id));
			return new Point(_scalesX[ id ], _scalesY[ id ]);
		}

		/**
		 * sets the local (2D) rotations to assign to the section along the path.
		 * the vector of values can be of arbitrary size, it will be remapped to fit the path's length.
		 * @param	angles	a Vector.<Number> specifying the rotation in radians around the section's center
		 */
		public function setRotations(angles : Vector.<Number> = null) : void {
			var length : uint = path.length;
			if ( angles != null ) _rotations = ( angles.length < length ) ? VectorUtils.expand(angles, length) : VectorUtils.compress(angles, length);
		}

		/**
		 * sets the local (2D) rotation to assign to a given location along the path.
		 * @param 	id 	the id of the point along the path
		 * @param	angle	value of the rotation in radians
		 */
		public function setRotationAt(id : uint, angle : Number) : void {
			id = Math.max(0, Math.min(path.length, id));
			_rotations[ id ] = angle;
		}

		/**
		 * retrieves the rotation at a given point along the path
		 * @param	id	the id of the point along the path
		 * @return	the rotation at this location in radians
		 */
		public function getRotationAt(id : uint) : Number {
			id = Math.max(0, Math.min(path.length, id));
			return _rotations[ id ];
		}

		private function getTransformMatrix(i : int) : Matrix {
			matrix.identity();

			matrix.rotate(_rotations[ i ]);
			matrix.scale(_scalesX[ i ], _scalesY[ i ]);
			matrix.translate(_translationsX[ i ], _translationsY[ i ]);

			return matrix;
		}

		/*******************************************
		
		properties
		
		 *******************************************/
		public function get path() : Vector.<Vector3D> {
			return _path;
		}

		public function set path(value : Vector.<Vector3D>) : void {
			_path = value;

			// remove duplicate locations along the path
			var i : int = _path.length - 1;
			while ( i-- > 1 ) {
				if ( _path[ i - 1 ].nearEquals(_path[i], 1) ) {
					_path.splice(i, 1);
				}
			}

			resetTransform();

			compute();
		}

		public function get section() : Section {
			return _section;
		}

		public function set section(value : Section) : void {
			_section = value;
			compute();
		}

		public function get sides() : uint {
			return _section.points.length;
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