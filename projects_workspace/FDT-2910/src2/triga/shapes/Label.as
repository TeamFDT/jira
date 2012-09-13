package triga.shapes {
	import away3d.entities.Sprite3D;

	import flash.geom.Vector3D;

	import triga.render.TextMaterial;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Label extends Sprite3D {
		private var _textMaterial : TextMaterial;

		public function Label(position : Vector3D = null, text : String = '', color : uint = 0x808080, size : Number = 12, font : String = "Verdana") {
			_textMaterial = new TextMaterial(text, size, color, font);

			super(_textMaterial, _textMaterial.bitmapData.width, _textMaterial.bitmapData.height);

			this.position = position || new Vector3D();
		}

		public function get textMaterial() : TextMaterial {
			return _textMaterial;
		}

		public function set textMaterial(textMaterial : TextMaterial) : void {
			_textMaterial = textMaterial;
		}
	}
}