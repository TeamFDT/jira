package triga.utils {
	import away3d.core.base.Geometry;
	import away3d.core.base.SubGeometry;
	import away3d.entities.Mesh;
	import away3d.tools.utils.Ray;

	import flash.geom.Vector3D;

	import triga.shapes.TrigaFace;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class MeshUtils {
		static private var AXES : Vector.<Vector3D> = Vector.<Vector3D>([new Vector3D(10000000000, 0, 0), new Vector3D(0, 10000000000, 0), new Vector3D(0, 0, 10000000000), new Vector3D(-10000000000, 0, 0), new Vector3D(0, -10000000000, 0), new Vector3D(0, 0, -10000000000)]);
		private var indices : Vector.<uint>;
		private var vertices : Vector.<Number>;
		private var mesh : Vector.<TrigaFace>;
		public var hitFace : Vector.<TrigaFace>;
		private var face : TrigaFace;

		public function MeshUtils(vertices : Vector.<Number>, indices : Vector.<uint>) {
			this.vertices = vertices;
			this.indices = indices;

			mesh = new Vector.<TrigaFace>();

			for ( var i : int = 0; i < indices.length; i += 3 ) {
				face = new TrigaFace(vertices, indices[ i ], indices[ i + 1 ], indices[ i + 2 ]);
				face.buildVector3D();
				mesh.push(face);
			}
		}

		public function pointInPolyhedron(p : Vector3D, testNegativeAxes : Boolean = true) : Boolean {
			var count : int = 0;
			var axis : Vector3D;
			var ray : Ray = new Ray();

			for each ( face in mesh ) {
				axis = AXES[0];
				axis.y = p.y;
				axis.z = p.z;
				if ( ray.getRayToTriangleIntersection(p, axis, face._v0, face._v1, face._v2) ) {
					count++;
				}
				axis = AXES[1];
				axis.x = p.x;
				axis.z = p.z;
				if ( ray.getRayToTriangleIntersection(p, axis, face._v0, face._v1, face._v2) ) {
					count++;
				}
				axis = AXES[2];
				axis.x = p.x;
				axis.y = p.y;
				if ( ray.getRayToTriangleIntersection(p, axis, face._v0, face._v1, face._v2) ) {
					count++;
				}

				if ( testNegativeAxes ) {
					axis = AXES[3];
					axis.y = p.y;
					axis.z = p.z;
					if ( ray.getRayToTriangleIntersection(p, axis, face._v0, face._v1, face._v2) ) {
						hitFace.push(face);
						count++;
					}
					axis = AXES[4];
					axis.x = p.x;
					axis.z = p.z;
					if ( ray.getRayToTriangleIntersection(p, axis, face._v0, face._v1, face._v2) ) {
						hitFace.push(face);
						count++;
					}
					axis = AXES[5];
					axis.x = p.x;
					axis.y = p.y;
					if ( ray.getRayToTriangleIntersection(p, axis, face._v0, face._v1, face._v2) ) {
						hitFace.push(face);
						count++;
					}
				}
			}
			return ( count % 2 == 1 );
		}

		static public function buildSubGeometry(vertices : Vector.<Number>, indices : Vector.<uint>) : SubGeometry {
			var subgeom : SubGeometry = new SubGeometry();

			subgeom.updateVertexData(vertices);
			subgeom.updateIndexData(indices);

			return subgeom;
		}

		static public function buildMesh(vertices : Vector.<Number>, indices : Vector.<uint>, uvs : Vector.<Number> = null, normals : Vector.<Number> = null) : Mesh {
			var geom : Geometry = new Geometry();
			var subgeom : SubGeometry = new SubGeometry();

			subgeom.updateVertexData(vertices);
			subgeom.updateIndexData(indices);

			var i : int;
			if ( uvs == null ) {
				uvs = new Vector.<Number>();
				for ( i = 0; i < vertices.length; i += 3 ) uvs.push(0, 0);
			}
			subgeom.updateUVData(uvs);

			if ( normals == null ) {
				normals = vertices.concat();
				subgeom.autoDeriveVertexNormals = true;
			}
			subgeom.updateVertexNormalData(normals);

			geom.addSubGeometry(subgeom);
			return new Mesh(null, geom);
		}

		static public function gravityCenter(...args) : Vector3D {
			var v : Vector3D = new Vector3D();

			for each ( var a:* in args ) {
				v.x += ( a as Vector3D ).x;
				v.y += ( a as Vector3D ).y;
				v.z += ( a as Vector3D ).z;
			}
			v.scaleBy(1 / args.length);
			return v;
		}

		static public function wireframe(mesh : Mesh, thickness : Number, doubleSided : Boolean = false) : Mesh {
			var vertices : Vector.<Number> = mesh.geometry.subGeometries[ 0 ].vertexData;
			var indices : Vector.<uint> = mesh.geometry.subGeometries[ 0 ].indexData;

			var i : int;
			var i0 : uint, i1 : uint, i2 : uint;
			var n0 : uint, n1 : uint, n2 : uint;

			var third : Number = 1 / 3;
			var c : Vector3D = new Vector3D();
			var vn0 : Vector3D, vn1 : Vector3D, vn2 : Vector3D;

			var vs : Vector.<Number> = vertices.concat();
			var ind : Vector.<uint> = new Vector.<uint>();

			for ( i = 0; i < indices.length; i += 3) {
				// current indices
				i0 = indices[ i ];
				i1 = indices[ i + 1 ];
				i2 = indices[ i + 2 ];

				// new indices
				n0 = vs.length / 3;
				n1 = n0 + 1;
				n2 = n0 + 2;

				ind.push(i0, i1, n0, i1, n1, n0, i1, i2, n1, i2, n2, n1, i2, i0, n2, i0, n0, n2);

				if ( doubleSided ) {
					ind.push(i1, i0, n0, n1, i1, n0, i2, i1, n1, n2, i2, n1, i0, i2, n2, n0, i0, n2);
				}

				// vertices
				i0 *= 3;
				i1 *= 3;
				i2 *= 3;

				// face center
				c.x = ( vertices[ i0 ] + vertices[ i1 ] + vertices[ i2 ] ) * third;
				c.y = ( vertices[ i0 + 1 ] + vertices[ i1 + 1 ] + vertices[ i2 + 1 ] ) * third;
				c.z = ( vertices[ i0 + 2 ] + vertices[ i1 + 2 ] + vertices[ i2 + 2 ] ) * third;

				// new Vertices
				vs.push(vertices[ i0 ] + ( c.x - vertices[ i0 ] ) * thickness, vertices[ i0 + 1 ] + ( c.y - vertices[ i0 + 1 ] ) * thickness, vertices[ i0 + 2 ] + ( c.z - vertices[ i0 + 2 ] ) * thickness, vertices[ i1 ] + ( c.x - vertices[ i1 ] ) * thickness, vertices[ i1 + 1 ] + ( c.y - vertices[ i1 + 1 ] ) * thickness, vertices[ i1 + 2 ] + ( c.z - vertices[ i1 + 2 ] ) * thickness, vertices[ i2 ] + ( c.x - vertices[ i2 ] ) * thickness, vertices[ i2 + 1 ] + ( c.y - vertices[ i2 + 1 ] ) * thickness, vertices[ i2 + 2 ] + ( c.z - vertices[ i2 + 2 ] ) * thickness);
			}

			mesh.geometry.subGeometries[ 0 ].updateVertexData(vs);
			mesh.geometry.subGeometries[ 0 ].updateIndexData(ind);
			return mesh;
		}
	}
}