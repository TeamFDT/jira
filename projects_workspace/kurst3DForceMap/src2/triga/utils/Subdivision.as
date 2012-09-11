package triga.utils {
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;

	import flash.geom.Vector3D;

	import triga.spline.curves.Cubic;
	import triga.spline.curves.ICurve3D;
	import triga.utils.MeshUtils;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Subdivision {
		static private var subdivisions : Vector.<Vector3D> = new Vector.<Vector3D>();

		static public function compute(mesh : Mesh, method : ICurve3D = null, offset : Number = .5, doubleSided : Boolean = false, inner : Boolean = false) : Mesh {
			if ( method == null ) method = new Cubic(.5, true);

			var vertices : Vector.<Number> = mesh.geometry.subGeometries[ 0 ].vertexData;
			var indices : Vector.<uint> = mesh.geometry.subGeometries[ 0 ].indexData;

			var vs : Vector.<Number> = new Vector.<Number>();
			var ind : Vector.<uint> = new Vector.<uint>();

			var tv0 : Vector3D = new Vector3D(), tv1 : Vector3D = new Vector3D(), tv2 : Vector3D = new Vector3D();
			var triangleVectors : Vector.<Vector3D> = Vector.<Vector3D>([tv0, tv1, tv2]);

			var edgeVectors : Vector.<Vector3D> = new Vector.<Vector3D>();
			var ev : Vector3D = new Vector3D();

			var splineVectors : Vector.<Vector3D> = new Vector.<Vector3D>();
			var sv : Vector3D = new Vector3D();
			var c : Vector3D = new Vector3D();

			var i : int, j : int;

			var third : Number = 1 / 3;
			var segments : uint = 1 / method.precision;
			var innerOffset : Number = offset;
			var i0 : uint, i1 : uint, i2 : uint, ic : uint;
			var n0 : uint, n1 : uint, n2 : uint;
			for ( i = 0; i < indices.length; i += 3 ) {
				// current indices
				i0 = indices[ i ];
				i1 = indices[ i + 1 ];
				i2 = indices[ i + 2 ];

				// vertices
				i0 *= 3;
				i1 *= 3;
				i2 *= 3;

				// face center
				c.x = ( vertices[ i0 ] + vertices[ i1 ] + vertices[ i2 ] ) * third;
				c.y = ( vertices[ i0 + 1 ] + vertices[ i1 + 1 ] + vertices[ i2 + 1 ] ) * third;
				c.z = ( vertices[ i0 + 2 ] + vertices[ i1 + 2 ] + vertices[ i2 + 2 ] ) * third;

				//
				// if ( offset == -1 ) innerOffset = Math.random() < .25 ? 1 : ( .1 + Math.random() * .8 );

				tv0.x = vertices[ i0 ] + ( c.x - vertices[ i0 ] ) * innerOffset;
				tv0.y = vertices[ i0 + 1 ] + ( c.y - vertices[ i0 + 1 ] ) * innerOffset;
				tv0.z = vertices[ i0 + 2 ] + ( c.z - vertices[ i0 + 2 ] ) * innerOffset;

				tv1.x = vertices[ i1 ] + ( c.x - vertices[ i1 ] ) * innerOffset;
				tv1.y = vertices[ i1 + 1 ] + ( c.y - vertices[ i1 + 1 ] ) * innerOffset;
				tv1.z = vertices[ i1 + 2 ] + ( c.z - vertices[ i1 + 2 ] ) * innerOffset;

				tv2.x = vertices[ i2 ] + ( c.x - vertices[ i2 ] ) * innerOffset;
				tv2.y = vertices[ i2 + 1 ] + ( c.y - vertices[ i2 + 1 ] ) * innerOffset;
				tv2.z = vertices[ i2 + 2 ] + ( c.z - vertices[ i2 + 2 ] ) * innerOffset;

				splineVectors = method.compute(triangleVectors);

				if ( inner ) {
					n0 = vs.length / 3;
					ic = n0 + splineVectors.length;

					for ( j = 0; j < splineVectors.length; j++ ) {
						ind.push(ic, n0 + j, n0 + ( j + 1 ) % splineVectors.length);
						vs.push(splineVectors[ j ].x, splineVectors[ j ].y, splineVectors[ j ].z);
					}

					vs.push(c.x, c.y, c.z);
				} else {
					tv0.x = vertices[ i0 ];
					tv1.x = vertices[ i1 ];
					tv2.x = vertices[ i2 ];

					tv0.y = vertices[ i0 + 1 ];
					tv1.y = vertices[ i1 + 1 ];
					tv2.y = vertices[ i2 + 1 ];

					tv0.z = vertices[ i0 + 2 ];
					tv1.z = vertices[ i1 + 2 ];
					tv2.z = vertices[ i2 + 2 ];

					edgeVectors = subdiv(triangleVectors, segments);

					j = 0;
					while ( splineVectors.length > edgeVectors.length ) splineVectors.splice(j++ * segments, 1);

					n0 = vs.length / 3;
					n1 = n0 + 1;
					n2 = n0 + 2;

					vs.push(vertices[ i0 ], vertices[ i0 + 1 ], vertices[ i0 + 2 ], vertices[ i1 ], vertices[ i1 + 1 ], vertices[ i1 + 2 ], vertices[ i2 ], vertices[ i2 + 1 ], vertices[ i2 + 2 ]);

					i1 = vs.length / 3;

					var oid : uint, nid : uint, id : uint
					for ( j = 0; j < splineVectors.length; j++ ) {
						if ( ( j % segments ) == 0 ) {
							id = int(j / segments);

							i0 = id == 0 ? n0 : id == 1 ? n1 : n2;
							i2 = id == 0 ? n2 : id == 1 ? n0 : n1;

							ind.push(i0, i2, i1 + j);
						}

						i2 = i1 + ( j + 1 ) % splineVectors.length;

						ind.push(i0, i1 + j, i2);

						vs.push(splineVectors[ j ].x, splineVectors[ j ].y, splineVectors[ j ].z);
					}
				}
			}

			subdivisions.length = 0;

			if ( doubleSided ) ind = ind.concat(ind.concat().reverse());

			return MeshUtils.buildMesh(vs, ind);
		}

		static private function subdiv(vertices : Vector.<Vector3D>, segments : uint) : Vector.<Vector3D> {
			subdivisions = new Vector.<Vector3D>();

			var i : int, j : int, k : int = 0;
			var v : Vector3D, n : Vector3D;
			var step : Number = 1 / segments;

			for ( i = 0; i < vertices.length; i++ ) {
				v = vertices[ i ];

				n = vertices[ (i + 1) % vertices.length ];

				for ( j = 0; j < segments; j++ ) {
					subdivisions.push(new Vector3D(v.x + ( n.x - v.x ) * ( j * step ), v.y + ( n.y - v.y ) * ( j * step ), v.z + ( n.z - v.z ) * ( j * step )));
				}
			}

			return subdivisions;
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

			if ( doubleSided ) ind = ind.concat(ind.concat().reverse());

			mesh.geometry.subGeometries[ 0 ].updateVertexData(vs);
			mesh.geometry.subGeometries[ 0 ].updateIndexData(ind);
			return mesh;
		}
	}
}