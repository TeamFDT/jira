package triga.shapes {
	import away3d.core.base.data.Vertex;

	import flash.geom.Vector3D;

	import triga.utils.ConvexHull;
	import triga.utils.PlaneUtils;
	import triga.utils.TrigaSphereUtils;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public final class Tetrahedron {
		public var i0 : uint;
		public var i1 : uint;
		public var i2 : uint;
		public var i3 : uint;
		public var centroid : Vector3D;
		public var sphere : TrigaSphere;
		public var inSphere : TrigaSphere;
		public var faces : Vector.<TrigaFace>;
		private var _uvData : Vector.<Number> = Vector.<Number>([0, 0, 0, 1, 1, 1, 1, 0]);
		private var _vertexData : Vector.<Number>;
		public var _dihedralAngles : Vector.<Number> = Vector.<Number>([0, 0, 0, 0]);

		public function Tetrahedron(vertices : Vector.<Number>, i0 : uint, i1 : uint, i2 : uint, i3 : uint) {
			this.i0 = i0;
			this.i1 = i1;
			this.i2 = i2;
			this.i3 = i3;

			var v0 : Vector3D = new Vector3D(vertices[ i0 * 3 ], vertices[ i0 * 3 + 1 ], vertices[ i0 * 3 + 2 ]);
			var v1 : Vector3D = new Vector3D(vertices[ i1 * 3 ], vertices[ i1 * 3 + 1 ], vertices[ i1 * 3 + 2 ]);
			var v2 : Vector3D = new Vector3D(vertices[ i2 * 3 ], vertices[ i2 * 3 + 1 ], vertices[ i2 * 3 + 2 ]);
			var v3 : Vector3D = new Vector3D(vertices[ i3 * 3 ], vertices[ i3 * 3 + 1 ], vertices[ i3 * 3 + 2 ]);

			faces = Vector.<TrigaFace>([new TrigaFace(vertices, i0, i1, i2), new TrigaFace(vertices, i0, i2, i3), new TrigaFace(vertices, i0, i3, i1), new TrigaFace(vertices, i1, i2, i3)]);

			centroid = new Vector3D(( vertices[ i0 * 3 ] + vertices[ i1 * 3 ] + vertices[ i2 * 3 ] + vertices[ i3 * 3 ] ) * .25, ( vertices[ i0 * 3 + 1 ] + vertices[ i1 * 3 + 1 ] + vertices[ i2 * 3 + 1 ] + vertices[ i3 * 3 + 1 ] ) * .25, ( vertices[ i0 * 3 + 2 ] + vertices[ i1 * 3 + 2 ] + vertices[ i2 * 3 + 2 ] + vertices[ i3 * 3 + 2 ] ) * .25);

			_vertexData = Vector.<Number>([vertices[ i0 * 3 ] - centroid.x, vertices[ i0 * 3 + 1 ] - centroid.y, vertices[ i0 * 3 + 2 ] - centroid.z, vertices[ i1 * 3 ] - centroid.x, vertices[ i1 * 3 + 1 ] - centroid.y, vertices[ i1 * 3 + 2 ] - centroid.z, vertices[ i2 * 3 ] - centroid.x, vertices[ i2 * 3 + 1 ] - centroid.y, vertices[ i2 * 3 + 2 ] - centroid.z, vertices[ i3 * 3 ] - centroid.x, vertices[ i3 * 3 + 1 ] - centroid.y, vertices[ i3 * 3 + 2 ] - centroid.z]);

			sphere = TrigaSphereUtils.circumSphere(vertices[ i0 * 3 ], vertices[ i0 * 3 + 1 ], vertices[ i0 * 3 + 2 ], vertices[ i1 * 3 ], vertices[ i1 * 3 + 1 ], vertices[ i1 * 3 + 2 ], vertices[ i2 * 3 ], vertices[ i2 * 3 + 1 ], vertices[ i2 * 3 + 2 ], vertices[ i3 * 3 ], vertices[ i3 * 3 + 1 ], vertices[ i3 * 3 + 2 ]);

			inSphere = TrigaSphereUtils.inSphere(v0, v1, v2, v3);

			var normals : Vector.<Vector3D> = new Vector.<Vector3D>();
			for each ( var f:TrigaFace in faces ) {
				if ( f.isFacing(centroid) ) {
					f.flip(_uvData);
				}
				f.buildVector3D();
				var n : Vector3D = f._v1.subtract(f._v0).crossProduct(f._v2.subtract(f._v0));
				n.normalize();
				normals.push(n);
			}

			_dihedralAngles = Vector.<Number>([Math.acos(normals[ 0 ].dotProduct(normals[ 1 ])), Math.acos(normals[ 1 ].dotProduct(normals[ 2 ])), Math.acos(normals[ 2 ].dotProduct(normals[ 3 ])), Math.acos(normals[ 3 ].dotProduct(normals[ 0 ]))]);
		}

		public function get uvData() : Vector.<Number> {
			return _uvData;
		}

		public function get vertexData() : Vector.<Number> {
			return _vertexData;
		}

		public function get vertexNormalData() : Vector.<Number> {
			return Vector.<Number>([0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1]);
		}

		public function makeUnique() : void {
			faces = Vector.<TrigaFace>([new TrigaFace(_vertexData, 0, 1, 2), new TrigaFace(_vertexData, 0, 2, 3), new TrigaFace(_vertexData, 0, 3, 1), new TrigaFace(_vertexData, 1, 2, 3)]);

			for each ( var f:TrigaFace in faces ) {
				if ( f.isFacing(centroid) ) {
					f.flip();
				}
			}
		}

		public function get indexData() : Vector.<uint> {
			return Vector.<uint>([faces[ 0 ].i0, faces[ 0 ].i1, faces[ 0 ].i2, faces[ 1 ].i0, faces[ 1 ].i1, faces[ 1 ].i2, faces[ 2 ].i0, faces[ 2 ].i1, faces[ 2 ].i2, faces[ 3 ].i0, faces[ 3 ].i1, faces[ 3 ].i2]);
		}

		/*
		public function get centroid():Vertex 
		{
		if ( _centroid == null )
		{
		_centroid = new Vertex( ( vertices[ i0 * 3 ] 	+ vertices[ i1 * 3 ] + vertices[ i2 * 3 ]+ vertices[ i3 * 3 ] ) * .25,
		( vertices[ i0 * 3 + 1 ]+ vertices[ i1 * 3 + 1 ]+ vertices[ i2 * 3 + 1 ]+ vertices[ i3 * 3 + 1 ] ) * .25,
		( vertices[ i0 * 3 + 2 ]+ vertices[ i1 * 3 + 2 ]+ vertices[ i2 * 3 + 2 ]+ vertices[ i3 * 3 + 2 ] ) * .25	);
		}
		return _centroid;
		}
		 */
		public function shareFace(t : Tetrahedron) : TrigaFace {
			for each ( var f:TrigaFace in faces ) for each ( var _f:TrigaFace in t.faces ) if ( f.isPairOrEqual(_f) ) return f;
			return null;
		}

		public function hasCommonFace(face : TrigaFace) : TrigaFace {
			for each ( var f:TrigaFace in faces ) if ( f.isPairOrEqual(face) ) return f;
			return null;
		}

		public function hasEqualFace(face : TrigaFace) : TrigaFace {
			for each ( var f:TrigaFace in faces ) if ( f.equals(face) ) return f;
			return null;
		}

		public function shareVertex(index : uint) : Boolean {
			if ( i0 == index || i1 == index || i2 == index || i3 == index ) return true;
			return false;
		}
	}
}