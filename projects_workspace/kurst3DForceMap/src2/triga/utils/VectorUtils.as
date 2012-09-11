package triga.utils {
	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class VectorUtils {
		/**
		 * shrinks a Vector.<Number> down to a given length
		 * @param	values original vector of values
		 * @param	length the desired length
		 * @return a vector of values matching the desired length
		 */
		static public function compress(values : Vector.<Number>, length : uint) : Vector.<Number> {
			var tmp : Vector.<Number> = new Vector.<Number>();
			var i : Number;
			if ( values.length == 1 ) {
				i = length;
				while ( i-- ) tmp.push(values[0]);
				return tmp;
			}

			var inputLength : uint = values.length - 2;
			var outputLength : uint = length - 2;
			tmp.push(values[ 0 ]);
			i = 0;
			var j : int = 0;
			while (j < inputLength) {
				var diff : uint = ( i + 1 ) * inputLength - ( j + 1 ) * outputLength;
				if (diff < inputLength / 2 ) {
					i++;
					tmp.push(values[ j++ ]);
				} else j++;
			}
			tmp.push(values[ inputLength + 1 ]);
			return tmp;
		}

		/**
		 * compresses 2 vectors of numbers
		 * @param	u first set of vectors to compress
		 * @param	v second set of vectors to compress
		 * @param	length0 the desired length for vector u
		 * @param	length1 the desired length for vector v
		 * @return a Vector.<Number> of doublets (x,y) of the given length interpolating the original values
		 */
		static public function compress2D(u : Vector.<Number>, v : Vector.<Number>, length0 : uint, length1 : uint) : Vector.<Number> {
			var _u : Vector.<Number> = compress(u, length0);
			var _v : Vector.<Number> = compress(v, length1);
			var tmp : Vector.<Number> = new Vector.<Number>();

			for (var i : int = 0; i < length0; i++) {
				for (var j : int = 0; j < length1; j++) {
					tmp.push(_u[ i ], _v[ j ]);
				}
			}

			return tmp;
		}

		/**
		 * compresses 3 vectors of numbers
		 * @param	u first set of vectors to compress
		 * @param	v second set of vectors to compress
		 * @param	w second set of vectors to compress
		 * @param	length0 the desired length for vector u
		 * @param	length1 the desired length for vector v
		 * @param	length2 the desired length for vector w
		 * @return a Vector.<Number> of triplets (x,y,z) of the given length interpolating the original values
		 */
		static public function compress3D(u : Vector.<Number>, v : Vector.<Number>, w : Vector.<Number>, length0 : uint, length1 : uint, length2 : uint) : Vector.<Number> {
			var _u : Vector.<Number> = compress(u, length0);
			var _v : Vector.<Number> = compress(v, length1);
			var _w : Vector.<Number> = compress(w, length2);

			var tmp : Vector.<Number> = new Vector.<Number>();

			for (var i : int = 0; i < length0; i++) {
				for (var j : int = 0; j < length1; j++) {
					for (var k : int = 0; k < length2; k++) {
						tmp.push(_u[ i ], _v[ j ], _w[ k ]);
					}
				}
			}

			return tmp;
		}

		/**
		 * expands the content of a vector.<Number> to match a given length
		 * @param	values original vector of values
		 * @param	length the desired length of the new Vector
		 * @return a Vector.<Number> of the given length interpolating the original values
		 */
		static public function expand(values : Vector.<Number>, length : uint) : Vector.<Number> {
			var tmp : Vector.<Number> = new Vector.<Number>();
			var i : Number;
			if ( values.length == 1 ) {
				i = length;
				while ( i-- ) tmp.push(values[0]);
				return tmp;
			}

			var step : Number = 1 / ( ( values.length - 1 ) / (length - 1) );
			for ( i = 0; i < length; i += step ) {
				var val0 : Number = values[ int(i / step) ];

				var max : int = ( int(i / step) + 1 );
				if ( max > values.length - 1 ) max = values.length - 1;
				var val1 : Number = values[ max ];

				var delta : int = ( i + step > length ) ? ( length - i ) : step;
				for (var j : Number = 0; j < delta; j++) {
					tmp.push(lerp(j / delta, val0, val1));
				}
			}
			while ( tmp.length < length ) tmp.push(values[ values.length - 1 ]);

			return tmp;
		}

		/**
		 * expands 2 vectors of numbers and combines them together
		 * @param	u first set of vectors to expand
		 * @param	v second set of vectors to expand
		 * @param	length0 the desired length for vector u
		 * @param	length1 the desired length for vector v
		 * @return a Vector.<Number> of doublets (x,y) of the given length interpolating the original values
		 */
		static public function expand2D(u : Vector.<Number>, v : Vector.<Number>, length0 : uint, length1 : uint) : Vector.<Number> {
			var _u : Vector.<Number> = expand(u, length0);
			var _v : Vector.<Number> = expand(v, length1);
			var tmp : Vector.<Number> = new Vector.<Number>();

			for (var i : int = 0; i < length0; i++) {
				for (var j : int = 0; j < length1; j++) {
					tmp.push(_u[ i ], _v[ j ]);
				}
			}
			return tmp;
		}

		/**
		 * expands 3 vectors of numbers
		 * @param	u first set of vectors to expand
		 * @param	v second set of vectors to expand
		 * @param	w second set of vectors to expand
		 * @param	length0 the desired length for vector u
		 * @param	length1 the desired length for vector v
		 * @param	length2 the desired length for vector w
		 * @return a Vector.<Number> of triplets (x,y,z) of the given length interpolating the original values
		 */
		static public function expand3D(u : Vector.<Number>, v : Vector.<Number>, w : Vector.<Number>, length0 : uint, length1 : uint, length2 : uint) : Vector.<Number> {
			var _u : Vector.<Number> = expand(u, length0);
			var _v : Vector.<Number> = expand(v, length1);
			var _w : Vector.<Number> = expand(w, length2);

			var tmp : Vector.<Number> = new Vector.<Number>();

			for (var i : int = 0; i < length0; i++) {
				for (var j : int = 0; j < length1; j++) {
					for (var k : int = 0; k < length2; k++) {
						tmp.push(_u[ i ], _v[ j ], _w[ k ]);
					}
				}
			}
			return tmp;
		}

		static private function lerp(t : Number, min : Number, max : Number) : Number {
			return min + ( max - min ) * t;
		}
	}
}