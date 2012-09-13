package triga.render {
	import away3d.textures.BitmapCubeTexture;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class CubeMapUtils {
		static public function createCubeMap(bd : BitmapData, method : int = 0) : BitmapCubeTexture {
			var w : int = bd.width;
			var h : int = bd.height;

			var step_x : int = 4;
			var step_y : int = 3;

			var order : Array = [];
			switch( method ) {
				case 0:
					/**
					 * __|y+|__|__
					 * x-|z-|x+|z+
					 * __|y-|__|__
					 */
					order = [-1, 2, -1, -1, 1, 4, 0, 5, -1, 3, -1, -1];
					break;
				case 1:
					/**
					 * __|y+|__|__
					 * x-|z-|x+|z+
					 * __|__|y-|__
					 */
					order = [-1, 2, -1, -1, 1, 4, 0, 5, -1, -1, 3, -1];
					break;
				case 2:
					/**
					 * __|y+|__
					 * x-|z-|x+
					 * __|y-|__
					 * __|z+|__
					 */
					step_x = 3;
					step_y = 4;
					order = [-1, 2, -1, 1, 4, 0, -1, 3, -1, -1, 5, -1];
					break;
			}

			var rect : Rectangle = new Rectangle(0, 0, int(w / step_x), int(h / step_y));
			var tmp : BitmapData = new BitmapData(int(w / step_x), int(h / step_y), true, 0xFF0000);

			var eMaps : Array = new Array(6);

			for ( var i : int = 0; i < order.length; i++ ) {
				if ( order[ i ] != -1 ) {
					rect.x = i % step_x * rect.width;
					rect.y = int(i / step_x) * rect.height;

					tmp.fillRect(tmp.rect, 0xFF0000);

					tmp.copyPixels(bd, rect, new Point(), null, null, true);

					eMaps[ order[ i ] ] = tmp.clone();
				}
			}
			return new BitmapCubeTexture(eMaps[0], eMaps[1], eMaps[2], eMaps[3], eMaps[4], eMaps[5]);
		}
	}
}