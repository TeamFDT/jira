package triga.spline.utils {
	import flash.geom.Point;

	public class Triangulator2D {
		// http://forum.unity3d.com/threads/27223-Polygon-triangulation-code
		// http://www.unifycommunity.com/wiki/index.php?title=Triangulator
		static private var  m_points : Vector.<Point>;

		static public function compute(points : Vector.<Point>) : Vector.<uint> {
			m_points = points.concat();

			var indices : Vector.<uint> = new Vector.<uint>();

			var n : int = m_points.length;
			if (n <= 3) return Vector.<uint>([1, 0, 2]);

			var v : int;
			var V : Vector.<int> = new Vector.<int>();

			if (Area() > 0) {
				for ( v = 0; v < n; v++) V.push(v);
			} else {
				for ( v = 0; v < n; v++) V.push((n - 1) - v);
			}

			var nv : int = n;
			var count : int = 2 * nv;
			var m : int
			for ( m = 0, v = nv - 1; nv > 2; ) {
				if ((count--) <= 0) return indices;

				var u : int = v;
				if (nv <= u) u = 0;

				v = u + 1;
				if (nv <= v) v = 0;

				var w : int = v + 1;
				if (nv <= w) w = 0;

				if ( Snip(u, v, w, nv, V)) {
					var a : int, b : int, c : int, s : int, t : int;
					a = V[u];
					b = V[v];
					c = V[w];
					indices.push(a);
					indices.push(b);
					indices.push(c);

					m++;
					for (s = v, t = v + 1; t < nv; s++, t++) {
						V[s] = V[t];
					}
					nv--;
					count = 2 * nv;
				}
			}

			indices.reverse();
			return indices;
		}

		static private function Area() : Number {
			var n : int = m_points.length;
			var A : Number = 0;
			var  p : int, q : int;
			for ( p = n - 1, q = 0; q < n; p = q++ ) {
				var pval : Point = m_points[p];
				var qval : Point = m_points[q];
				A += pval.x * qval.y - qval.x * pval.y;
			}
			return (A * 0.5);
		}

		static private function Snip(u : int, v : int, w : int, n : int, V : Vector.<int>) : Boolean {
			var p : int;
			var A : Point = m_points[ V[u] ];
			var B : Point = m_points[ V[v] ];
			var C : Point = m_points[ V[w] ];

			if ( .000000001 > (((B.x - A.x) * (C.y - A.y)) - ((B.y - A.y) * (C.x - A.x)))) return false;

			for (p = 0; p < n; p++) {
				if ((p == u) || (p == v) || (p == w)) continue;

				var P : Point = m_points[V[p]];

				if (InsideTriangle(A, B, C, P)) return false;
			}
			return true;
		}

		static private function InsideTriangle(A : Point, B : Point, C : Point, P : Point) : Boolean {
			var ax : Number, ay : Number, bx : Number, by : Number, cx : Number, cy : Number, apx : Number, apy : Number, bpx : Number, bpy : Number, cpx : Number, cpy : Number;
			var cCROSSap : Number, bCROSScp : Number, aCROSSbp : Number;

			ax = C.x - B.x;
			ay = C.y - B.y;
			bx = A.x - C.x;
			by = A.y - C.y;
			cx = B.x - A.x;
			cy = B.y - A.y;
			apx = P.x - A.x;
			apy = P.y - A.y;
			bpx = P.x - B.x;
			bpy = P.y - B.y;
			cpx = P.x - C.x;
			cpy = P.y - C.y;

			aCROSSbp = ax * bpy - ay * bpx;
			cCROSSap = cx * apy - cy * apx;
			bCROSScp = bx * cpy - by * cpx;

			return ((aCROSSbp >= 0.0) && (bCROSScp >= 0.0) && (cCROSSap >= 0.0));
		}
	}
}