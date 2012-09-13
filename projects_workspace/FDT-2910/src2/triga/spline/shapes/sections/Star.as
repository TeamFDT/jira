package triga.spline.shapes.sections {
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;

	import flash.geom.Point;

	import triga.spline.shapes.Section;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Star extends Section {
		public function Star(branchCount : uint, innerRadius : Number, outerRadius : Number, material : MaterialBase = null) {
			var points : Vector.<Point> = new Vector.<Point>();
			branchCount = Math.max(3, branchCount);
			var delta : Number = ( Math.PI * 2 ) / ( branchCount * 2 )
			for ( var i : int = 0; i < branchCount * 2;  i += 2 ) {
				var a0 : Number = i * delta;
				points.push(new Point(Math.cos(a0) * innerRadius, Math.sin(a0) * innerRadius));

				var a1 : Number = ( i + 1 ) * delta;
				points.push(new Point(Math.cos(a1) * outerRadius, Math.sin(a1) * outerRadius));
			}

			super(points, material);
		}
	}
}