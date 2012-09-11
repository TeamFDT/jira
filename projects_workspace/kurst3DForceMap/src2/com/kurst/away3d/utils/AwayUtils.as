package com.kurst.away3d.utils {
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import away3d.core.math.Matrix3DUtils;
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;

	// _bounds.fromExtremes(-_width * .5 * _scaleX, -_height * .5 * _scaleY, 0, _width * .5 * _scaleX, _height * .5 * _scaleY, 0);
	public class AwayUtils {
		
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private static function pixelPerfectCameraValue(fov : Number, h : Number) : Number {
			var fovy : Number = fov * Math.PI / 180;
			return  -( h / 2 ) / Math.tan(fovy / 2);
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function getCameraPixelPerfectDepth(camera : Camera3D, viewHeight : Number) : Vector3D {
			var pxPerfectCameraValue : Number = pixelPerfectCameraValue((camera.lens as PerspectiveLens).fieldOfView, viewHeight)
			var positionCamera : Vector3D = Matrix3DUtils.getForward(camera.transform);

			var position : Vector3D = new Vector3D(camera.position.x + positionCamera.x * - ( pxPerfectCameraValue ), camera.position.y + positionCamera.y * - ( pxPerfectCameraValue ), camera.position.z + positionCamera.z * - ( pxPerfectCameraValue ));

			return position;
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function getPixelPerfectDepth(fieldOfView : Number, camPosition : Vector3D, camTransform : Matrix3D, viewHeight : Number) : Vector3D {
			var pxPerfectCameraValue : Number = pixelPerfectCameraValue(fieldOfView, viewHeight)
			var fwdCamPosition : Vector3D = Matrix3DUtils.getForward(camTransform);

			var position : Vector3D = new Vector3D(camPosition.x + fwdCamPosition.x * - ( pxPerfectCameraValue ), camPosition.y + fwdCamPosition.y * - ( pxPerfectCameraValue ), camPosition.z + fwdCamPosition.z * - ( pxPerfectCameraValue ));

			return position;
		}

	}
}
