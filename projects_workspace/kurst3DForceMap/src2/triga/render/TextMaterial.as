package triga.render {
	import away3d.materials.BitmapMaterial;

	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class TextMaterial extends BitmapMaterial {
		private var _text : String;
		private var _font : String = "Verdana";
		private var _size : Number = 12;
		private var _color : uint = 0x808080;
		private var _background : Boolean = false;
		private var _backgroundColour : uint = 0x000000;
		private var _multiline : Boolean = true;

		public function TextMaterial(text : String, size : Number = 12, color : uint = 0x808080, font : String = "Verdana") {
			super();
			_text = text;
			_font = font;
			_size = size;
			_color = color;
			reset();
		}

		private function reset(textFormat : TextFormat = null) : void {
			var tf : TextField = new TextField();

			tf.multiline = _multiline;
			tf.htmlText = text;
			textFormat ||= new TextFormat(font, size, color)
			tf.setTextFormat(textFormat);
			tf.background = _background;
			tf.backgroundColor = _backgroundColour;
			tf.autoSize = TextFieldAutoSize.LEFT;

			var x : uint = 1;
			while ( x < Math.max(tf.width, tf.height) ) x <<= 1;

			var m : Matrix = new Matrix(1, 0, 0, 1, ( x - tf.width ) * .5, ( x - tf.height ) * .5);

			bitmapData = new BitmapData(x, x, true, 0x00000000);
			bitmapData.draw(tf, m);
			this.alphaBlending = true;
			smooth = false;
		}

		public function get text() : String {
			return _text;
		}

		public function set text(value : String) : void {
			_text = value;
			reset();
		}

		public function get font() : String {
			return _font;
		}

		public function set font(value : String) : void {
			_font = value;
			reset();
		}

		public function get size() : Number {
			return _size;
		}

		public function set size(value : Number) : void {
			_size = value;
			reset();
		}

		public function get color() : uint {
			return _color;
		}

		public function set color(value : uint) : void {
			_color = value;
			reset();
		}

		public function get background() : Boolean {
			return _background;
		}

		public function set background(background : Boolean) : void {
			_background = background;
			reset();
		}

		public function get backgroundColour() : uint {
			return _backgroundColour;
		}

		public function set backgroundColour(backgroundColour : uint) : void {
			_backgroundColour = backgroundColour;
			reset();
		}
	}
}