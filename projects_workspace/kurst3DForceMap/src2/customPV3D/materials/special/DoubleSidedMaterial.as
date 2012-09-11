package customPV3D.materials.special {
	import flash.display.*;
	import flash.geom.Matrix;

	import org.papervision3d.core.render.command.RenderTriangle;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.core.geom.renderables.*;
	import org.papervision3d.core.material.TriangleMaterial;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.core.render.data.RenderSessionData;
	import org.papervision3d.core.render.draw.ITriangleDrawer;

	public class DoubleSidedMaterial extends TriangleMaterial implements ITriangleDrawer {
		private var _front : MaterialObject3D
		private var _back : MaterialObject3D

		public function DoubleSidedMaterial(frontMaterial : MaterialObject3D = null, backMaterial : MaterialObject3D = null) {
			front = frontMaterial;
			back = backMaterial;
			doubleSided = true;
		};

		public function get front() : MaterialObject3D {
			return _front;
		}

		public function set front(material : MaterialObject3D) : void {
			_front = material
			registerMaterial(_front, false)
		}

		public function get back() : MaterialObject3D {
			return _back;
		}

		public function set back(material : MaterialObject3D) : void {
			_back = material
			registerMaterial(_back, true)
		}

		private function registerMaterial(material : MaterialObject3D, opposite : Boolean) : void {
			if (material != null) {
				trace("register", material, opposite)
				material.opposite = opposite

				for each (var do3d:DisplayObject3D in objects) {
					material.registerObject(do3d);
				}
			}
		}

		public function get materials() : Array {
			var m : Array = new Array
			if (_front != null) m.push(_front)
			if (_back != null) m.push(_back)
			return m
		}

		public function set materials(materials : Array) : void {
			for each (var material:MaterialObject3D in materials) {
				if (!material.opposite) front = material
				else back = material
			}
		}

		override public function registerObject(displayObject3D : DisplayObject3D) : void {
			super.registerObject(displayObject3D);
			if (front != null) front.registerObject(displayObject3D);
			if (back != null) back.registerObject(displayObject3D);
		}

		override public function unregisterObject(displayObject3D : DisplayObject3D) : void {
			super.unregisterObject(displayObject3D);
			if (front != null) front.unregisterObject(displayObject3D);
			if (back != null) back.unregisterObject(displayObject3D);
		}

		override public function drawTriangle(triangle : RenderTriangle, graphics : Graphics, renderSessionData : RenderSessionData, altBitmap : BitmapData = null, altUV : Matrix = null) : void {
			var vertex0 : Vertex3DInstance;
			var vertex1 : Vertex3DInstance;
			var vertex2 : Vertex3DInstance;
			var x0 : Number;
			var y0 : Number;
			var x1 : Number;
			var y1 : Number;
			var x2 : Number;
			var y2 : Number;
			var draw : Boolean;

			var material : MaterialObject3D;

			vertex0 = triangle.v0
			vertex1 = triangle.v1
			vertex2 = triangle.v2

			x0 = vertex0.x;
			y0 = vertex0.y;
			x1 = vertex1.x;
			y1 = vertex1.y;
			x2 = vertex2.x;
			y2 = vertex2.y;

			var side : Number = ( x2 - x0 ) * ( y1 - y0 ) - ( y2 - y0 ) * ( x1 - x0 )

			material = side > 0 ? _front : _back;

			if (material != null) material.drawTriangle(triangle, graphics, renderSessionData, altBitmap, altUV)
		};
	}
}