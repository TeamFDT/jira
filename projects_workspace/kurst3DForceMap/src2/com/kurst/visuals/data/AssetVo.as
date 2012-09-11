package com.kurst.visuals.data {
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.DisplayObject3D;

	/**
	 * @author karim
	 */
	public class AssetVo {
		public var id : String;
		public var do3d : DisplayObject3D;
		public var dae : DAE;
		public var group : String = '';
	}
}
