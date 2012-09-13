package {
	import away3d.primitives.LineSegment;
	import flash.geom.Vector3D;
	import away3d.entities.Mesh;
		
	public class ParticleV2 {
		
		
		public static const MIN_SPEED:int = 1;
		public static const MAX_SPEED:int = 4;
		
		public static const MIN_WANDER:Number = 0.8;
		public static const MAX_WANDER:Number = 1.2;
		
		public var speed:Number;
		public var wander : Number;
		public var mesh : Mesh;
		
		public var s : Vector3D;
		public var e : Vector3D;
		public var line : LineSegment;
		public var next : ParticleV2;

	    function ParticleV2( mesh : Mesh , x:Number, y:Number, z:Number ) {

			speed = Math.random() * (MAX_SPEED - MIN_SPEED) + MIN_SPEED;
			wander = Math.random() * (MAX_WANDER - MIN_WANDER) + MIN_WANDER;
			
			this.mesh 	= mesh;
			
			if ( mesh != null ) {
					
		        this.mesh.x = x;
				this.mesh.y = y;
				this.mesh.z = z;
			
			}
			
			
	    }

	}

}
