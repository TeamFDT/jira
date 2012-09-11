package triga.spline.shapes.sections {
	import away3d.core.base.SubGeometry;
	import away3d.materials.MaterialBase;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	import triga.spline.shapes.Section;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Frame extends Section {
		public function Frame(innerRect : Rectangle, outerRect : Rectangle, material : MaterialBase = null) {
			if ( !outerRect.containsRect(innerRect) ) {
				var tmp : Rectangle = outerRect.clone();
				outerRect = innerRect.clone();
				innerRect = tmp;
			}

			// var points:Vector.<Point> = Vector.<Point>(	[
			// outerRect.topLeft.clone(),
			// new Point( outerRect.right, outerRect.top ),
			// outerRect.bottomRight.clone(),
			// new Point( outerRect.left, outerRect.bottom ),
			// outerRect.topLeft.clone(),
			//
			// innerRect.topLeft.clone(),
			// new Point( innerRect.left, innerRect.bottom ),
			// innerRect.bottomRight.clone(),
			// new Point( innerRect.right, innerRect.top ),
			// innerRect.topLeft.clone()
			// ]);
			// var indices:Vector.<uint> = Vector.<uint>( [ 	0, 1, 8,
			// 0, 8, 9,
			// 1, 2, 7,
			// 1, 7, 8,
			// 2, 3, 6,
			// 2, 6, 7,
			// 3, 4, 5,
			// 3, 5, 6
			// ] );

			var points : Vector.<Point> = Vector.<Point>([outerRect.topLeft.clone(), new Point(outerRect.right, outerRect.top), outerRect.bottomRight.clone(), new Point(outerRect.left, outerRect.bottom),
			// outerRect.topLeft.clone(), 
			innerRect.topLeft.clone(), new Point(innerRect.right, innerRect.top), innerRect.bottomRight.clone(), new Point(innerRect.left, innerRect.bottom),// innerRect.topLeft.clone()
			]);
			super(points, material);

			var indices : Vector.<uint> = Vector.<uint>([0, 1, 4, 1, 5, 4, 1, 2, 5, 2, 6, 5, 2, 3, 6, 3, 7, 6, 3, 0, 4, 3, 4, 7]);
			indices = indices.concat(indices.concat().reverse());
			super.geometry.subGeometries[0].updateIndexData(indices);
		}
	}
}