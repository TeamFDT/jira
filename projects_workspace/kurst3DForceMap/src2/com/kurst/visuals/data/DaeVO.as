package com.kurst.visuals.data {
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.DisplayObject3D;

	/**
	 * @author karim
	 */
	public class DaeVO {
		public var initScale : Number = 1
		public var daeGeometry : DisplayObject3D;
		public var id : String;
		public var uri : String;
		public var dae : DAE;
		public var loaded : Boolean = false;
		public var xml : XML;
		public var group : String;
	}
}
