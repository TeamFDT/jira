package {
	import away3d.entities.Mesh;

	public class Particle {
		
	    public var vx:Number = 0;
	    public var vy:Number = 0;
	    public var vz:Number = 0;
	    public var ax:Number = 0;
	    public var ay:Number = 0;
	    public var az:Number = 0;
		
		public var mesh : Mesh
		
	    function Particle( mesh : Mesh , x:Number, y:Number, z:Number ) {
			
			this.mesh 	= mesh;
			
			
	        this.mesh.x = x;
			this.mesh.y = y;
			this.mesh.z = z;
			
	    }
		
	}
}
