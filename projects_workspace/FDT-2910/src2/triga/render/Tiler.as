package triga.render {
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.geom.*;

	/**
	 * http://www.btinternet.com/~cateran/simple/
	 * @author nicoptere
	 */
	public class Tiler {
		static private var shape : Shape = new Shape();
		static private var matrix : Matrix = new Matrix();
		static private var box : Shape = new Shape();
		static private var boxMatrix : Matrix = new Matrix();
		static private var radial : Shape = new Shape();
		static private var radialMatrix : Matrix = new Matrix();

		static private function initRadialGradient(w : int = 100, h : int = 100, ratioS : int = 0, ratioE : int = 255, alphaS : Number = 1, alphaE : Number = 0) : void {
			radial.graphics.clear();
			radialMatrix.createGradientBox(w, h, 0, 0, 0);
			radial.graphics.beginGradientFill('radial', [0xFFFFFF, 0xFFFFFF], [alphaS, alphaE], [ratioS, ratioE], radialMatrix);
			radial.graphics.drawRect(0, 0, w, h);
		}

		static private function initInvertRadialGradient(w : int = 100, h : int = 100, ratioS : int = 0, ratioE : int = 255) : void {
			initRadialGradient(w, h, ratioS, ratioE, 0, 1);
		}

		/**
		 * 
		 * @param	w
		 * @param	h
		 * @param	ratioS
		 * @param	ratioE
		 * @param	alphaS
		 * @param	alphaE
		 */
		static private function initBoxGradient(w : int = 100, h : int = 100, ratioS : int = 0, ratioE : int = 255, alphaS : Number = 0, alphaE : Number = 1) : void {
			box.graphics.clear();
			boxMatrix.createGradientBox(w, h, 0, 0, 0);

			var step : int = ( ratioE - ratioS ) / 4 + 1;
			var alphaM : Number = ( alphaE - alphaS ) / 2;

			box.graphics.beginGradientFill('linear', [0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [alphaS, alphaM, alphaE, alphaM, alphaS], [ratioS, ratioS + step, ratioS + step * 2, ratioS + step * 3, ratioE], boxMatrix);
			box.graphics.drawRect(0, 0, w, h);

			boxMatrix.createGradientBox(w, h, Math.PI / 2, 0, 0);
			box.graphics.beginGradientFill('linear', [0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [alphaS, alphaM, alphaE, alphaM, alphaS], [ratioS, ratioS + step, ratioS + step * 2, ratioS + step * 3, ratioE], boxMatrix);
			box.graphics.drawRect(0, 0, w, h);
		}

		/**
		 * 
		 * @param	w
		 * @param	h
		 * @param	ratioS
		 * @param	ratioE
		 */
		static private function initInvertBoxGradient(w : int = 100, h : int = 100, ratioS : int = 0, ratioE : int = 255) : void {
			initBoxGradient(w, h, ratioS, ratioE, 1, 0);
		}

		static public function symmetryHorizontal(bd : BitmapData) : BitmapData {
			var tmp : BitmapData = bd.clone();
			var half : BitmapData = new BitmapData(bd.width / 2, bd.height, true, 0x00000000);
			half.draw(bd, new Matrix(-1, 0, 0, 1, half.width, 0), null, null);
			tmp.draw(half, new Matrix(1, 0, 0, 1, half.width, 0));
			return tmp;
		}

		static public function symmetryVertical(bd : BitmapData) : BitmapData {
			var tmp : BitmapData = bd.clone();
			var half : BitmapData = new BitmapData(bd.width, bd.height / 2, true, 0x00000000);
			half.draw(bd, new Matrix(1, 0, 0, -1, 0, half.height), null, null);
			tmp.draw(half, new Matrix(1, 0, 0, 1, 0, half.height));
			return tmp.clone();
		}

		static public function flipHorizontal(bd : BitmapData) : BitmapData {
			var tmp : BitmapData = bd.clone();
			tmp.draw(bd, new Matrix(-1, 0, 0, 1, bd.width, 0));
			return tmp.clone();
		}

		static public function flipVertical(bd : BitmapData) : BitmapData {
			var tmp : BitmapData = bd.clone();
			tmp.draw(bd, new Matrix(1, 0, 0, -1, 0, bd.height));
			return tmp.clone();
		}

		static public function diagonalMirror(bd : BitmapData, direction : int = 0) : BitmapData {
			var w : int = bd.width;
			var h : int = bd.height;

			var vertices : Vector.<Number>;
			var indices : Vector.<int>;
			var uvs : Vector.<Number>;
			var p0 : Point, p1 : Point, p2 : Point, p3 : Point;

			// TOP LEFT -> BOTTOM RIGHT
			if ( direction == 0 ) {
				p0 = new Point(0, h);
				p1 = new Point(0, 0);
				p2 = new Point(w, 0);
				p3 = new Point(w, h);
				uvs = Vector.<Number>([0, 1, 0, 0, 1, 0, 0, 0]);
			}

			// TOP RIGHT -> BOTTOM LEFT
			if ( direction == 1 ) {
				p0 = new Point(0, 0);
				p1 = new Point(w, 0);
				p2 = new Point(w, h);
				p3 = new Point(0, h);
				uvs = Vector.<Number>([0, 0, 1, 0, 1, 1, 1, 0]);
			}

			// BOTTOM RIGHT -> TOP LEFT
			if ( direction == 2 ) {
				p0 = new Point(w, 0);
				p1 = new Point(w, h);
				p2 = new Point(0, h);
				p3 = new Point(0, 0);
				uvs = Vector.<Number>([1, 0, 1, 1, 0, 1, 1, 1]);
			}

			// BOTTOM LEFT -> TOP RIGHT
			if ( direction == 3 ) {
				p0 = new Point(w, h);
				p1 = new Point(0, h);
				p2 = new Point(0, 0);
				p3 = new Point(w, 0);
				uvs = Vector.<Number>([1, 1, 0, 1, 0, 0, 0, 1]);
			}
			vertices = Vector.<Number>([p0.x, p0.y, p1.x, p1.y, p2.x, p2.y, p3.x, p3.y]);
			indices = Vector.<int>([0, 1, 2, 0, 2, 3]);

			for each ( var i:Number in vertices )
				var src : BitmapData = bd.clone();
			var shape : Shape = new Shape();
			shape.graphics.beginBitmapFill(bd, null, false);
			shape.graphics.drawTriangles(vertices, indices, uvs);
			src.draw(shape);

			shape = null;
			indices = null;
			vertices = uvs = null;
			p0 = p1 = p2 = p3 = null;
			return src;
		}

		static public function centreTile(bd : BitmapData) : BitmapData {
			var w : int = bd.width;
			var h : int = bd.height;

			var src : BitmapData = new BitmapData(w, h, true, 0x00000000);
			w = int(w / 2);
			h = int(h / 2);
			if ( w % 2 != 0 ) w += 1;
			if ( h % 2 != 0 ) h += 1;
			var tmp : BitmapData = new BitmapData(w, h, true, 0x00000000);

			var pt : Point = new Point(0, 0);
			var rect : Rectangle = new Rectangle(0, 0, w, h);

			// rect0
			tmp.copyPixels(bd, rect, pt);
			tmp = symmetryVertical(flipVertical(symmetryHorizontal(flipHorizontal(tmp))));
			src.draw(tmp);

			// rect1
			rect.x = w;
			tmp.copyPixels(bd, rect, pt);
			tmp = symmetryVertical(flipVertical(symmetryHorizontal(tmp)));
			src.draw(tmp, new Matrix(1, 0, 0, 1, w, 0));

			// rect2
			rect.x = 0;
			rect.y = h;
			tmp.copyPixels(bd, rect, pt);
			tmp = symmetryHorizontal(symmetryVertical(flipHorizontal(tmp)));
			src.draw(tmp, new Matrix(1, 0, 0, 1, 0, h));

			// rect3
			rect.x = w;
			rect.y = h;
			tmp.copyPixels(bd, rect, pt);
			tmp = symmetryVertical(symmetryHorizontal(tmp));
			src.draw(tmp, new Matrix(1, 0, 0, 1, w, h));

			return src;
		}

		static public function blintz(bd : BitmapData) : BitmapData {
			var w : int = bd.width;
			var h : int = bd.height;

			var src : BitmapData = new BitmapData(w, h, true, 0x00000000);

			w = int(w / 2 + .5);
			h = int(h / 2 + .5);

			var tmp : BitmapData = new BitmapData(w, h, true, 0x00000000);
			var pt : Point = new Point(0, 0);
			var rect : Rectangle = new Rectangle(0, 0, w, h);

			// rect0
			tmp.copyPixels(bd, rect, pt);
			tmp = diagonalMirror(tmp, 2);
			src.draw(tmp);

			// rect1
			rect.x = w;
			tmp.copyPixels(bd, rect, pt);
			tmp = diagonalMirror(tmp, 3);
			src.draw(tmp, new Matrix(1, 0, 0, 1, w, 0));

			// rect2
			rect.x = 0;
			rect.y = h;
			tmp.copyPixels(bd, rect, pt);
			tmp = diagonalMirror(tmp, 1);
			src.draw(tmp, new Matrix(1, 0, 0, 1, 0, h));

			// rect3
			rect.x = w;
			rect.y = h;
			tmp.copyPixels(bd, rect, pt);
			tmp = diagonalMirror(tmp, 0);
			src.draw(tmp, new Matrix(1, 0, 0, 1, w, h));
			return src;
		}

		static public function cornerMirror(bd : BitmapData, direction : int = 0) : BitmapData {
			var matrix : Matrix;
			if ( direction == 1 ) matrix = new Matrix(-1, 0, 0, 1, bd.width, 0);
			if ( direction == 2 ) matrix = new Matrix(-1, 0, 0, -1, bd.width, bd.height);
			if ( direction == 3 ) matrix = new Matrix(1, 0, 0, -1, 0, bd.height);
			var tmp : BitmapData = bd.clone();
			tmp.draw(bd, matrix);
			return symmetryHorizontal(symmetryVertical(tmp));
		}

		static public function halfWrap(bd : BitmapData) : BitmapData {
			var w : int = bd.width;
			var h : int = bd.height;

			var tmp : BitmapData = new BitmapData(w, h, true, 0x00000000);

			w /= 2;
			h /= 2;

			// step 0
			matrix.tx = w;
			matrix.ty = h;
			tmp.draw(bd, matrix);

			// step 1
			matrix.tx = -w;
			matrix.ty = h;
			tmp.draw(bd, matrix);

			// step 2
			matrix.tx = w;
			matrix.ty = -h;
			tmp.draw(bd, matrix);

			// step 3
			matrix.tx = -w;
			matrix.ty = -h;
			tmp.draw(bd, matrix);
			return tmp;
		}

		static public function quickTile(bd : BitmapData) : BitmapData {
			var tmp : BitmapData = new BitmapData(bd.width, bd.height, true, 0x00000000);

			var src : BitmapData = radialGradient(bd);

			tmp = halfWrap(src);

			tmp.draw(src);

			return tmp;
		}

		static public function quickTileBox(bd : BitmapData) : BitmapData {
			var tmp : BitmapData = new BitmapData(bd.width, bd.height, true, 0x00000000);

			var src : BitmapData = radialGradient(bd);

			tmp.draw(boxGradient(bd));

			tmp.draw(halfWrap(src));

			return tmp;
		}

		static public function radialGradient(bd : BitmapData, ratioS : int = 128, ratioE : int = 255, invert : Boolean = false) : BitmapData {
			var w : int = bd.width;
			var h : int = bd.height;

			if ( !invert ) {
				initRadialGradient(w, h, ratioS, ratioE);
			} else {
				initInvertRadialGradient(w, h, ratioS, ratioE);
			}

			var gradient : BitmapData = new BitmapData(w, h, true, 0x00000000);
			gradient.draw(radial);

			var tmp : BitmapData = new BitmapData(w, h, true, 0x00000000);
			tmp.draw(bd);
			tmp.copyChannel(gradient, tmp.rect, new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);

			return tmp;
		}

		static public function invertRadialGradient(bd : BitmapData, ratioS : int = 128, ratioE : int = 255) : BitmapData {
			return radialGradient(bd, ratioS, ratioE, true);
		}

		static public function boxGradient(bd : BitmapData, ratioS : int = 0, ratioE : int = 255, invert : Boolean = false) : BitmapData {
			var w : int = bd.width;
			var h : int = bd.height;

			if ( !invert ) {
				initBoxGradient(w, h, ratioS, ratioE);
			} else {
				initInvertBoxGradient(w, h, ratioS, ratioE);
			}

			var gradient : BitmapData = new BitmapData(w, h, true, 0x00000000);
			gradient.draw(box);

			var tmp : BitmapData = new BitmapData(w, h, true, 0x00000000);
			tmp.draw(bd);
			tmp.copyChannel(gradient, tmp.rect, new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);

			return tmp;
		}

		static public function invertBoxGradient(bd : BitmapData, ratioS : int = 0, ratioE : int = 255) : BitmapData {
			return boxGradient(bd, ratioS, ratioE, true);
		}

		static public function pizzaSlice(bd : BitmapData, slice : int = 0) : BitmapData {
			var w : int = bd.width;
			var h : int = bd.height;

			var tmp : BitmapData = new BitmapData(w, h, true, 0x00000000);

			w = int(w / 2);
			h = int(h / 2);

			if ( w % 2 != 0 ) w += 1;
			if ( h % 2 != 0 ) h += 1;

			var pat : BitmapData = new BitmapData(w, h, true, 0x00000000);

			// selects the square source rect to duplicate
			var rect : Rectangle = new Rectangle(int(( slice % 4) / 2) * w, int(slice / 4) * h, w, h);
			pat.copyPixels(bd, rect, new Point());

			// we have the corners now which half should be copied diagonally
			if ( slice == 0 || slice == 6 ) tmp.draw(diagonalMirror(pat, 3));
			if ( slice == 1 || slice == 7 ) tmp.draw(diagonalMirror(pat, 1));
			if ( slice == 2 || slice == 4 ) tmp.draw(diagonalMirror(pat, 0));
			if ( slice == 3 || slice == 5 ) tmp.draw(diagonalMirror(pat, 2));

			tmp = symmetryHorizontal(tmp.clone());
			tmp = symmetryVertical(tmp.clone());

			return tmp;
		}
	}
}