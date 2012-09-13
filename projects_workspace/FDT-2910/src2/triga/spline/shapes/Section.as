package triga.spline.shapes {
	import away3d.core.base.SubGeometry;
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;

	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	import triga.spline.utils.Triangulator2D;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Section extends Mesh {
		private var original : Vector.<Vector3D>;
		private var vectors : Vector.<Vector3D>;
		private var transforms : Vector.<Vector3D>;
		private var _points : Vector.<Point>;
		private var _vertices : Vector.<Number>;
		private var _indices : Vector.<uint>;
		private var _uvs : Vector.<Number>;
		private var _loop : Boolean = true;

		public function Section(points : Vector.<Point>, material : MaterialBase = null) {
			super(null, material);

			_points = points;

			compute();
		}

		/**
		 * computes the Section's shape
		 */
		protected function compute() : void {
			var subGeometry : SubGeometry = new SubGeometry();

			original = new Vector.<Vector3D>();
			vectors = new Vector.<Vector3D>();
			transforms = new Vector.<Vector3D>();

			vertices = new Vector.<Number>();
			uvs = new Vector.<Number>();

			var min : Point = new Point(Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY);
			var max : Point = new Point(Number.NEGATIVE_INFINITY, Number.NEGATIVE_INFINITY);

			// computes the indices
			indices = Triangulator2D.compute(points);
			// might be null..
			indices ||= Vector.<uint>([]);
			indices = indices.concat(indices.concat().reverse());

			// make vertices loop for uv mapping
			if ( loop && !points[0].equals(points[points.length - 1]) ) points.push(points[0]);

			// store vertices
			for (var i : int = 0; i < points.length; i++) {
				var p : Point = points[ i ];
				var v : Vector3D = new Vector3D(p.x, -p.y, 0);
				original.push(v);
				vectors.push(v.clone());
				transforms.push(v);
				vertices.push(int(p.x + .5), int(-p.y + .5), 0);

				if ( p.x < min.x ) min.x = p.x;
				if ( p.y < min.y ) min.y = p.y;
				if ( p.x > max.x ) max.x = p.x;
				if ( p.y > max.y ) max.y = p.y;
			}

			// uvs
			var dx : Number = 1 / ( max.x - min.x );
			var dy : Number = 1 / ( max.y - min.y );
			for ( i = 0; i < points.length; i++) {
				p = points[ i ];
				uvs.push(( p.x - min.x) * dx, ( p.y - min.y ) * dy);
			}

			// creates geometry if needed
			if ( geometry.subGeometries.length == 0 ) {
				geometry.addSubGeometry(new SubGeometry());
			}

			geometry.subGeometries[ 0 ].updateVertexData(vertices);
			geometry.subGeometries[ 0 ].updateVertexNormalData(vertices.concat());
			geometry.subGeometries[ 0 ].autoDeriveVertexNormals = true;
			geometry.subGeometries[ 0 ].updateUVData(uvs);
			geometry.subGeometries[ 0 ].updateIndexData(indices);
		}

		/**
		 * creates a section of arbitrary shape after the given set of x/y doublets
		 * @param	values a series of X/Y coordinates
		 * @param	material [ optional ] the material to assign to the Section object
		 * @return a Section Object
		 */
		static public function createFromValues(values : Vector.<Number>, material : MaterialBase = null) : Section {
			var points : Vector.<Point> = new Vector.<Point>();
			for ( var i : int = 0; i < values.length;  i += 2 ) {
				points.push(new Point(values[ i ], values[ i + 1 ]));
			}
			return new Section(points, material);
		}

		/**
		 * short hand to create a regular polygon
		 * @param	radius	the radius of the section
		 * @param	sides	the number of sides
		 * @param	material [ optional ] a material to assign to the section
		 * @return a Section object
		 */
		static public function createRegularSection(radius : Number = 100, sides : uint = 12, material : MaterialBase = null) : Section {
			var points : Vector.<Point> = new Vector.<Point>();
			sides = Math.max(3, sides);
			for ( var i : int = 0; i < sides;  i++ ) {
				var a : Number = i * ( Math.PI * 2 ) / sides;
				points.push(new Point(Math.cos(a) * radius, Math.sin(a) * radius));
			}
			return new Section(points, material);
		}

		/**
		 * applies a local 2D transfomration
		 * @param	matrix transfomation matrix to apply to the section
		 */
		public function transform2D(matrix : Matrix) : void {
			for ( var i : int = 0; i < points.length; i++ ) {
				var p : Point = matrix.transformPoint(points[ i ]);
				vectors[ i ].x = p.x;
				vectors[ i ].y = -p.y;
			}
		}

		/******************************************
		
		properties
		
		 ******************************************/
		/**
		 * @return the series of Vector3D transformed by the object's transform matrix
		 */
		public function get vectors3D() : Vector.<Vector3D> {
			transforms.length = 0;
			for ( var i : int = 0; i < vectors.length; i++ ) {
				var v : Vector3D = vectors[ i ];
				transforms[ i ] = transform.transformVector(v);
			}
			return transforms;
		}

		public function get points() : Vector.<Point> {
			return _points;
		}

		public function set points(value : Vector.<Point>) : void {
			_points = value;
		}

		public function get vertices() : Vector.<Number> {
			return _vertices;
		}

		public function set vertices(value : Vector.<Number>) : void {
			_vertices = value;
		}

		public function get indices() : Vector.<uint> {
			return _indices;
		}

		public function set indices(value : Vector.<uint>) : void {
			_indices = value;
		}

		public function get uvs() : Vector.<Number> {
			return _uvs;
		}

		public function set uvs(value : Vector.<Number>) : void {
			_uvs = value;
		}

		public function get loop() : Boolean {
			return _loop;
		}

		public function set loop(value : Boolean) : void {
			_loop = value;
			if ( points[0].equals(points[points.length - 1]) ) points.pop();
			compute();
		}
	}
}