/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.pv3d.objects.PlaneX
 * Version 	  	: 
 * Description 	: 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: 
 * Date 			: 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 *
 * PROPERTIES
 * 
 *
 * EVENTS
 * 
 * 
 ********************************************************************************************************************************************************************************
 * 				:
 *
 *
 *********************************************************************************************************************************************************************************
 * NOTES			:
 **********************************************************************************************************************************************************************************/
package com.kurst.pv3d.objects {
	import org.papervision3d.objects.primitives.Plane;
	// import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.core.math.NumberUV;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.geom.renderables.Triangle3D;

	public class PlaneX extends Plane {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function PlaneX(material : MaterialObject3D = null, width : Number = 0, height : Number = 0, segmentsW : Number = 0, segmentsH : Number = 0) {
			super(material, width, height, segmentsW, segmentsH);
		}

		/**
		 * Sets the scale along the local X axis as applied from the registration point of the object.
		 */
		public function setSize(width : Number, height : Number) : void {
			var gridX : Number = this.segmentsW;
			var gridY : Number = this.segmentsH;
			// var gridX1 : Number = gridX + 1;
			var gridY1 : Number = gridY + 1;

			var vertices : Array = this.geometry.vertices;
			var faces : Array = this.geometry.faces;

			var textureX : Number = width / 2;
			var textureY : Number = height / 2;

			var iW : Number = width / gridX;
			var iH : Number = height / gridY;

			var count : Number = 0;

			// Vertices
			for ( var ix : int = 0;ix < gridX + 1;ix++ ) {
				for ( var iy : int = 0;iy < gridY1;iy++ ) {
					var x : Number = ix * iW - textureX;
					var y : Number = iy * iH - textureY;

					var v : Vertex3D = vertices[count];

					v.x = x;
					v.y = y;

					count++;
				}
			}

			count = 0;

			// Faces
			var uvA : NumberUV;
			var uvC : NumberUV;
			var uvB : NumberUV;

			for (  ix = 0;ix < gridX;ix++ ) {
				for (  iy = 0;iy < gridY;iy++ ) {
					// Triangle A
					var f : Triangle3D = faces[count];

					// Triangle A
					var a : Vertex3D = vertices[ ix * gridY1 + iy     ];
					var c : Vertex3D = vertices[ ix * gridY1 + (iy + 1) ];
					var b : Vertex3D = vertices[ (ix + 1) * gridY1 + iy     ];

					uvA = new NumberUV(ix / gridX, iy / gridY);
					uvC = new NumberUV(ix / gridX, (iy + 1) / gridY);
					uvB = new NumberUV((ix + 1) / gridX, iy / gridY);

					f.vertices = [a, b, c];
					f.uv = [uvA, uvB, uvC];

					// Triangle B
					f = faces[count + 1];

					a = vertices[ (ix + 1) * gridY1 + (iy + 1) ];
					c = vertices[ (ix + 1) * gridY1 + iy     ];
					b = vertices[ ix * gridY1 + (iy + 1) ];

					uvA = new NumberUV((ix + 1) / gridX, (iy + 1) / gridY);
					uvC = new NumberUV((ix + 1) / gridX, iy / gridY);
					uvB = new NumberUV(ix / gridX, (iy + 1) / gridY);

					f.vertices = [a, b, c];
					f.uv = [uvA, uvB, uvC];

					count += 2;
				}
			}
			this.geometry.dirty = true;
			// this.geometry.aabbDirty = true;
			this.geometry.ready = true;
		}

		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// GGGGG  EEEEEEE TTTTTT          SSSSS EEEEEEE TTTTTT
		// GG      EE        TT           SS     EE        TT
		// GG  GGG EEEE      TT            SSSS  EEEE      TT
		// GG   GG EE        TT               SS EE        TT
		// GGGGG  EEEEEEE   TT           SSSSS  EEEEEEE   TT
		//
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get width() : Number {
			return (geometry.aabb.maxX - geometry.aabb.minX) * scaleX;
		}

		public function get height() : Number {
			return (geometry.aabb.maxY - geometry.aabb.minY) * scaleY;
		}

		public function get widthNoScale() : Number {
			return (geometry.aabb.maxX - geometry.aabb.minX)
			// *scaleX;
		}

		public function get heightNoScale() : Number {
			return (geometry.aabb.maxY - geometry.aabb.minY)
			// *scaleY;
		}
	}
}