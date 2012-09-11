package com.kurst.visuals.data {
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.materials.special.ParticleMaterial;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.core.geom.renderables.Particle;

	/**
	 * @author karim
	 */
	public class ParticleVO {
		public var particle : Particle;
		public var colour : uint = 0xFFFFFF;
		public var defaultColour : uint = 0xFFFFFF;
		public var audioMultiplier : int = 2
		public var fadeDownDecay : Number = .85;
		public var fadeUpDecay : Number = .8;
		public var minSize : Number = .1
		public var vertice : Vertex3D = null;
		public var trackSpeed : Number;
		public var targetDo3d : DisplayObject3D
		public var next : ParticleVO;
		public var previous : ParticleVO;
		public var size : int;
		public var particleMaterial : ParticleMaterial;
		public var coloursTween : Object = new Object();
		public var animationComplete : Boolean = true;
		public var hidden : Boolean = false;
		public var extra : Object = new Object();

		public function calcGlobalPos() : Number3D {
			if ( vertice == null ) return null;

			var v : Number3D = new Number3D(vertice.x, vertice.y, vertice.z);
			Matrix3D.multiplyVector(targetDo3d.world, v);

			return v;
		}

		public function destroy() : void {
			particle = null;
			vertice = null;
			targetDo3d = null
			next = null;
			previous = null;
			particleMaterial = null;
		}
	}
}
