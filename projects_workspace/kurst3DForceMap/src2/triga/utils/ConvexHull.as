package triga.utils {
	import flash.geom.Vector3D;

	import triga.shapes.TrigaFace;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class ConvexHull {
		static private var validFaces : Vector.<TrigaFace>;
		static private var visibleFaces : Vector.<TrigaFace>;
		static private var tmpFaces : Vector.<TrigaFace>;

		/**
		 * performs a convexhull in 3D
		 * @param	points the Vector3D cloud
		 * @return  a series of indices to create the faces of the hull
		 */
		static public function compute(vertices : Vector.<Number>) : Vector.<uint> {
			var i : uint, ti : uint, i0 : uint, i1 : uint, i2 : uint, i3 : uint;
			var v : Vector3D = new Vector3D();
			var face : TrigaFace, other : TrigaFace;

			// finds the biggest possible convex volume

			var min : Vector3D = new Vector3D(Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY);
			var max : Vector3D = new Vector3D(Number.NEGATIVE_INFINITY, Number.NEGATIVE_INFINITY, Number.NEGATIVE_INFINITY);

			for ( i = 0; i < vertices.length; i += 3 ) {
				v.x = vertices[ i ];
				v.y = vertices[ i + 1 ];
				v.z = vertices[ i + 2 ];

				if ( v.x < min.x ) {
					min.x = v.x;
					i0 = i / 3;
				}
				if ( v.y < min.y ) {
					min.y = v.y;
					i2 = i / 3;
				}

				if ( v.x > max.x ) {
					max.x = v.x;
					i1 = i / 3;
				}
				if ( v.z > max.z ) {
					max.z = v.z;
					i3 = i / 3;
				}
			}

			var centroid : Vector3D;
			centroid = new Vector3D(( vertices[ i0 * 3 ] + vertices[ i1 * 3 ] + vertices[ i2 * 3 ] + vertices[ i3 * 3 ] ) * .25, ( vertices[ i0 * 3 + 1 ] + vertices[ i1 * 3 + 1 ] + vertices[ i2 * 3 + 1 ] + vertices[ i3 * 3 + 1 ] ) * .25, ( vertices[ i0 * 3 + 2 ] + vertices[ i1 * 3 + 2 ] + vertices[ i2 * 3 + 2 ] + vertices[ i3 * 3 + 2 ] ) * .25);

			face = new TrigaFace(vertices, i0, i1, i2);
			other = new TrigaFace(vertices, i1, i2, i3);
			if ( face.isPointCoplanar(other.centroid) ) {
				i0 = 0;
				i1 = 1;
				i2 = 2;
				i3 = 3;
				centroid = new Vector3D(( vertices[ i0 * 3 ] + vertices[ i1 * 3 ] + vertices[ i2 * 3 ] + vertices[ i3 * 3 ] ) * .25, ( vertices[ i0 * 3 + 1 ] + vertices[ i1 * 3 + 1 ] + vertices[ i2 * 3 + 1 ] + vertices[ i3 * 3 + 1 ] ) * .25, ( vertices[ i0 * 3 + 2 ] + vertices[ i1 * 3 + 2 ] + vertices[ i2 * 3 + 2 ] + vertices[ i3 * 3 + 2 ] ) * .25);
			}

			tmpFaces = Vector.<TrigaFace>([new TrigaFace(vertices, i0, i1, i2), new TrigaFace(vertices, i0, i2, i3), new TrigaFace(vertices, i0, i3, i1), new TrigaFace(vertices, i1, i2, i3)]);

			validFaces = new Vector.<TrigaFace>();
			for each ( var f:TrigaFace in tmpFaces) {
				if ( f.isFacing(centroid) ) {
					f.flip();
				}
				validFaces.push(new TrigaFace(vertices, f.i0, f.i1, f.i2));
			}

			visibleFaces = new Vector.<TrigaFace>();

			for ( i = 0; i < vertices.length; i += 3 ) {
				// current vertex index
				ti = i / 3;

				// for each avaiable vertices
				v.x = vertices[ i ];
				v.y = vertices[ i + 1 ];
				v.z = vertices[ i + 2 ];

				// checks the point's visibility from all faces
				visibleFaces.length = 0;
				visibility :
				for each ( face in validFaces ) {
					if ( face.isPointCoplanar(v) ) {
						visibleFaces.length = 0;
						break visibility;
					}

					if ( face.isFacing(v) ) {
						visibleFaces.push(face);
					}
				}

				// the vertex is not visible : it is inside the convex hull, keep on
				if ( visibleFaces.length == 0 ) {
					continue;
				}

				// creates all possible new faces from the visibleFaces
				tmpFaces.length = 0;
				for each ( face in visibleFaces ) {
					tmpFaces.push(new TrigaFace(vertices, ti, face.i0, face.i1), new TrigaFace(vertices, ti, face.i1, face.i2), new TrigaFace(vertices, ti, face.i2, face.i0));

					validFaces.splice(validFaces.indexOf(face), 1);
				}

				for each ( face in tmpFaces ) {
					// search if there is a point in front of the face :
					// this means the face doesn't belong to the convex hull
					search :
					for each ( other in tmpFaces ) {
						if ( face != other ) {
							if ( face.isFacing(other.centroid) ) {
								face = null;
								break search;
							}
						}
					}
					// the face has no point in front of it, it is valid
					if ( face != null ) {
						validFaces.push(face);
					}
				}
			}

			var result : Vector.<uint> = new Vector.<uint>();
			for each ( face in validFaces ) {
				result.push(face.i0, face.i1, face.i2);
			}

			validFaces = null;
			visibleFaces = null;
			tmpFaces = null;

			return result;
		}
	}
}
