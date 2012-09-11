package triga.render {
	import away3d.containers.View3D;

	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class ViewHelper {
		static private var shape : Shape = new Shape();

		static public function grainyBackground(view : View3D, size : uint = 256, stretch : Boolean = true, low : int = 0, high : int = 16) : void {
			// TODO: grainyBackground - fix for Away Beta 4

			var bg : BitmapData = new BitmapData(size, size, false, 0);
			bg.noise(Math.random() * 0xFFFFFFFF, low, high, 7, true);
			/*
			view.backgroundImage = bg;
			view.backgroundImageFitToViewPort = stretch;
			
			view.background
			 */
		}

		static public function vignette(view : View3D, size : uint = 256, stretch : Boolean = false, color : uint = 0, alpha : Number = 1, ratio : int = 128) : void {
			// TODO: vignette - fix for Away Beta 4
			view.backgroundColor = color;
			var bg : BitmapData = new BitmapData(size, size, true, 0xFFFFFFFF);
			/*
			if ( view.backgroundImage == null )
			{ 
			view.backgroundImage = new BitmapData( size, size, true, 0xFFFFFFFF );
			}
			bg = view.backgroundImage;
			 */
			var m : Matrix = new Matrix();
			m.createGradientBox(bg.width, bg.height);
			shape.graphics.beginGradientFill(GradientType.RADIAL, [color, color], [0, alpha], [ratio, 0xFF], m);
			shape.graphics.drawRect(0, 0, bg.width, bg.height);

			bg.draw(shape);
			shape.graphics.clear();
			/*
			view.backgroundImage = bg;
			view.backgroundImageFitToViewPort = stretch;
			 */
		}

		static public function verticalGradient(view : View3D, topColor : int = 0xFFFFFF, bottomColor : int = 0, stretch : Boolean = true) : void {
			// TODO: verticalGradient - fix for Away Beta 4

			var bg : BitmapData = new BitmapData(2, 2, false, topColor);
			bg.setPixel(0, 1, bottomColor);
			bg.setPixel(1, 1, bottomColor);

			/*
			view.backgroundImage = bg;
			view.backgroundImageFitToViewPort = true;
			 */
		}
	}
}