/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: 
 * Version 	  	: 
 * Description 	: 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
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
package com.kurst.visuals.particles {
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.kurst.events.eventDispatcher;
	import com.kurst.visuals.data.ParticleVO;
	import com.kurst.visuals.events.ParticleControllerEvent;

	import org.papervision3d.core.geom.Particles;
	import org.papervision3d.core.geom.renderables.Particle;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.materials.special.ParticleMaterial;
	import org.papervision3d.objects.DisplayObject3D;

	// import com.as3dmod.core.Vector3D;
	public class ParticleController extends eventDispatcher {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var _defaultColour : int = 0xFFFFFF;
		private var _gridSize : uint = 8;
		private var _cubeWidth : uint = 200;
		private var _cubeSpacing : uint = 400;
		private var _defaultAlpha : Number = 1;
		private var _particleSize : int = 180;
		private var _worldSize : int = 6000
		private var _particleShape : int = 1;
		private var _fadeDownDecay : Number = .85;
		private var _fadeUpDecay : Number = .8;
		private var _seqMultiplier : Number = 0.001
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public var particles : Particles;
		public var particleData : Vector.<ParticleVO>;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function ParticleController() {
			particles = new Particles();
			particleData = new Vector.<ParticleVO>();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function create() : void {
			var previousDataItem : ParticleVO
			// var counter	 : int = 0;
			var data : ParticleVO = new ParticleVO();

			// Default / Initial particle grid Layout
			for ( var xC : int = 0 ; xC <= _gridSize ; xC++ ) {
				for ( var yC : int = 0 ; yC <= _gridSize ; yC++ ) {
					for ( var zC : int = 0 ; zC <= _gridSize ; zC++ ) {
						var pm : ParticleMaterial = new ParticleMaterial(_defaultColour, _defaultAlpha, _particleShape);
						// pm.interactive									= true;
						var p : Particle = new Particle(pm, _particleSize);
						p.x = ( (_cubeWidth + _cubeSpacing) * xC ) - ( (_cubeWidth + _cubeSpacing) * _gridSize ) / 2
						p.y = ( (_cubeWidth + _cubeSpacing) * yC ) - ( (_cubeWidth + _cubeSpacing) * _gridSize ) / 2
						p.z = ( (_cubeWidth + _cubeSpacing) * zC ) - ( (_cubeWidth + _cubeSpacing) * _gridSize ) / 2

						data = new ParticleVO()
						data.audioMultiplier = 2;
						data.defaultColour = _defaultColour;
						data.previous = previousDataItem;
						data.size = _particleSize;
						data.particle = p;
						data.particleMaterial = pm;
						data.fadeDownDecay = _fadeDownDecay;
						data.fadeUpDecay = _fadeUpDecay;

						( particleData.length > 0 ) ? particleData[particleData.length - 1 ].next = data : null;

						particleData.push(data);
						particles.addParticle(p)
						previousDataItem = data;
					}
				}
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function toInitFormation(resetColour : Number = NaN, duration : Number = 3, colourFunction : Function = null) : void {
			var data : ParticleVO = new ParticleVO();
			var particleCounter : int = 0;
			var tweenProps : Object
			var delay : Number = 0;
			// Default / Initial particle grid Layout
			for ( var xC : int = 0 ; xC <= _gridSize ; xC++ ) {
				for ( var yC : int = 0 ; yC <= _gridSize ; yC++ ) {
					for ( var zC : int = 0 ; zC <= _gridSize ; zC++ ) {
						data = particleData[particleCounter];
						delay = particleCounter * _seqMultiplier;

						tweenProps = new Object();
						tweenProps.x = ( (_cubeWidth + _cubeSpacing) * xC ) - ( (_cubeWidth + _cubeSpacing) * _gridSize ) / 2
						tweenProps.y = ( (_cubeWidth + _cubeSpacing) * yC ) - ( (_cubeWidth + _cubeSpacing) * _gridSize ) / 2
						tweenProps.z = ( (_cubeWidth + _cubeSpacing) * zC ) - ( (_cubeWidth + _cubeSpacing) * _gridSize ) / 2
						tweenProps.delay = delay

						data.vertice = null;
						data.animationComplete = false;
						data.targetDo3d = null;

						if ( data.hidden )
							showParticle(data, duration, delay)

						if ( colourFunction != null ) {
							if ( !isNaN(resetColour))
								tweenParticleColour(data, colourFunction(), duration, delay);
						} else {
							if ( !isNaN(resetColour))
								tweenParticleColour(data, resetColour, duration, delay);
						}

						TweenMax.to(data.particle, duration, tweenProps)
						particleCounter++;
					}
				}
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function destroy() : void {
			for ( var i : int = 0 ; i < particleData.length ; i++ )
				particleData[i].destroy();

			TweenMax.killAll();

			particleData = null
			particles.removeAllParticles();
			particles = null;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function linkUnusedToObjectVertex(do3d : DisplayObject3D, targetColour : Number = NaN, animationTime : Number = 2, startIndex : int = 0, endIndex : int = -1, autoSpaceToObject : Boolean = true, colourTweenDelay : Number = 0) : void {
			startIndex
			endIndex
			autoSpaceToObject

			var noVertices : int = do3d.geometry.vertices.length;
			var particleVo : ParticleVO;
			var vertexCounter : int = 0;

			for ( var c : int = 0 ; c < particleData.length - 1 ;c++ ) {
				particleVo = particleData[c];

				if ( particleVo.vertice == null && ( vertexCounter < noVertices ) ) {
					// ------------------------------------------------
					// Show particle if hidden

					if (particleVo.hidden)
						showParticle(particleVo, animationTime, ( animationTime == 0 ) ? 0 : ( animationTime == 0 ) ? 0 : vertexCounter * _seqMultiplier)

					// ------------------------------------------------
					// Calc global vertex position

					var v : Number3D = new Number3D(do3d.geometry.vertices[vertexCounter].x, do3d.geometry.vertices[vertexCounter].y, do3d.geometry.vertices[vertexCounter].z);
					Matrix3D.multiplyVector(do3d.world, v);

					// ------------------------------------------------
					// tween properties

					var tweenProps : Object = new Object();

					tweenProps.ease = Expo.easeInOut;
					tweenProps.x = ( v.x )
					// + do3d.x
					tweenProps.y = ( v.y )
					// + do3d.y
					tweenProps.z = ( v.z )
					tweenProps.onComplete = particleAnimationComplete;
					tweenProps.onCompleteParams = [particleVo]
					tweenProps.delay = ( animationTime == 0 ) ? 0 : vertexCounter * _seqMultiplier;

					// ------------------------------------------------
					// update particle VO properties
					particleVo.animationComplete = false;
					particleVo.vertice = do3d.geometry.vertices[vertexCounter];
					particleVo.targetDo3d = do3d;

					// ------------------------------------------------
					// Colour tween
					if ( !isNaN(targetColour) )
						tweenParticleColour(particleVo, targetColour, animationTime, ( animationTime == 0 ) ? 0 : ( vertexCounter * _seqMultiplier ) + colourTweenDelay)

					// ------------------------------------------------
					// tween
					TweenMax.killTweensOf(particleVo.particle)
					TweenMax.to(particleVo.particle, animationTime, tweenProps);

					vertexCounter++
				}
			}

			tweenProps = new Object();
			tweenProps.delay = vertexCounter * _seqMultiplier
			tweenProps.onComplete = particlesLinked;
			TweenMax.to(this, animationTime, tweenProps)
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function linkToObjectVertex(do3d : DisplayObject3D, targetColour : Number = NaN, animationTime : Number = 2, detachUnusedParticle : Boolean = true, startIndex : int = 0, endIndex : int = -1, autoSpaceToObject : Boolean = true, hideUnused : Boolean = false, colourFunction : Function = null, useCallback : Boolean = true, colourTweenDelay : Number = 0, delay : Number = NaN) : void {
			endIndex = ( endIndex == -1 ) ? particleData.length - 1 : endIndex;

			// Math.ceil

			// trace('--linkToObjectVertex-------------------------------------------')

			var animationDelay : Number = ( isNaN(delay) ) ? _seqMultiplier : delay
			var counter : int = startIndex
			var i : Number = 0;
			var avialableParticles : int = endIndex - startIndex;
			var tweenProps : Object;
			var tweenCProps : Object;
			// var particle			: Particle
			var particleVo : ParticleVO;
			var vertexID : int
			var vertexIncrement : int = ( avialableParticles < do3d.geometry.vertices.length && autoSpaceToObject ) ? Math.ceil(do3d.geometry.vertices.length / avialableParticles) : 1 ;
			vertexIncrement = ( autoSpaceToObject ) ? Math.ceil(do3d.geometry.vertices.length / avialableParticles) : vertexIncrement;
			vertexIncrement = ( vertexIncrement == 0 ) ? 1 : vertexIncrement;
			// trace( 'autoSpaceToObject: ' + (autoSpaceToObject) );
			// trace( 'avialableParticles: ' + (avialableParticles) );
			// trace( 'do3d.geometry.vertices.length: ' + (do3d.geometry.vertices.length) );
			// trace( 'vertexIncrement: ' + vertexIncrement )

			var c : int
			var vertexCounter : int = 0
			var prevVertexID : int = -1;

			// var tst : Array = new Array()

			while (i++ < do3d.geometry.vertices.length ) {
				if ( i < endIndex ) {
					vertexID = Math.round(vertexCounter * vertexIncrement);
					// trace('vertexID: ' + vertexID );
					// tst.push(vertexID)
					// ------------------------------------------------
					// if ( particleData[counter] == null ) return ;

					// ------------------------------------------------
					// Show particle if hidden

					if ( counter < particleData.length ) {
						// if ( counter < particleData.length && vertexID != prevVertexID ) {

						if ( particleData[counter].hidden)
							showParticle(particleData[counter], animationTime, ( animationTime == 0 ) ? 0 : i * animationDelay)

						// ------------------------------------------------
						// Calc global vertex position

						if ( vertexID < do3d.geometry.vertices.length) {
							var v : Number3D = new Number3D(do3d.geometry.vertices[vertexID].x, do3d.geometry.vertices[vertexID].y, do3d.geometry.vertices[vertexID].z);
							Matrix3D.multiplyVector(do3d.world, v);

							// ------------------------------------------------
							// Tween Properties

							tweenProps = new Object();
							tweenProps.ease = Expo.easeInOut;
							tweenProps.x = v.x
							tweenProps.y = v.y
							tweenProps.z = v.z
							tweenProps.onComplete = particleAnimationComplete;
							tweenProps.onCompleteParams = [particleData[counter]]
							tweenProps.delay = ( animationTime == 0 ) ? 0 : i * animationDelay;

							// ------------------------------------------------
							// update particle vo properties

							particleData[counter].animationComplete = false;
							particleData[counter].vertice = do3d.geometry.vertices[vertexID];
							particleData[counter].targetDo3d = do3d;

							// ------------------------------------------------
							// colour tween

							if ( colourFunction != null ) {
								tweenParticleColour(particleData[counter], colourFunction(), animationTime, ( animationTime == 0 ) ? 0 : ( i * animationDelay ) + colourTweenDelay);
							} else {
								if ( !isNaN(targetColour) )
									tweenParticleColour(particleData[counter], targetColour, animationTime, ( animationTime == 0 ) ? 0 : ( i * animationDelay  ) + colourTweenDelay);
							}
							// ------------------------------------------------
							// Tween

							TweenMax.killTweensOf(particleData[counter].particle)
							TweenMax.to(particleData[counter].particle, animationTime, tweenProps);
						}
					}

					counter++;
					vertexCounter++;

					prevVertexID = vertexID;
				}
			}

			// trace('tst: ' + tst.toString())

			// ------------------------------------------------
			// detach partucles attached to vertices
			if ( detachUnusedParticle ) {
				for ( c = counter ; c < particleData.length ; c++ ) {
					particleVo = particleData[c]
					particleVo.animationComplete = false;
					particleVo.vertice = null;
					particleVo.targetDo3d = null;

					if ( particleVo.hidden)
						showParticle(particleVo, animationTime, ( animationTime == 0 ) ? 0 : c * animationDelay)
				}
			}

			// ------------------------------------------------
			// detach partucles attached to vertices
			if ( hideUnused ) {
				for ( c = counter ; c < particleData.length ; c++ ) {
					particleVo = particleData[c]
					hideParticle(particleVo, animationTime, i * animationDelay);
				}
			}

			if ( useCallback ) {
				// ------------------------------------------------
				// end tween event
				tweenCProps = new Object();
				tweenCProps.delay = counter * animationDelay
				tweenCProps.onComplete = particlesLinked;
				TweenMax.to(this, animationTime, tweenCProps)
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function randomizeUnattachedParticlesOpt(forceRandom : Boolean = false, resetColour : Number = NaN, duration : Number = 3, useCallback : Boolean = true, colourTweenDelay : Number = 0) : void {
			var particleData : ParticleVO = particleData[0]
			var counter : uint = 0;
			var	tweenProps : Object = new Object();
			// var	tweenCProps 	: Object 		= new Object();

			while ( particleData ) {
				// ------------------------------------------------
				// if particle is not attached to vertice ( or random is enforced )

				if ( !particleData.hidden && particleData.vertice == null || forceRandom ) {
					TweenMax.killTweensOf(particleData.particle);
					tweenProps = new Object();
					// ------------------------------------------------
					// tween properties random position in world bounds

					tweenProps.x = Math.random() * (_worldSize * 2 ) - _worldSize;
					tweenProps.y = Math.random() * (_worldSize * 2 ) - _worldSize;
					tweenProps.z = Math.random() * (_worldSize * 2 ) - _worldSize;
					tweenProps.delay = counter / ( duration * 1000 );
					tweenProps.ease = Expo.easeInOut

					// ------------------------------------------------
					// update particle VO properties ( detach from vertice

					particleData.vertice = null;
					particleData.targetDo3d = null;
					particleData.animationComplete = true;

					// ------------------------------------------------
					// Show particle if hidden
					// if ( particleData[counter].hidden) showParticle( particleData , duration ,  counter/ ( duration * 1000 ) )

					if ( !isNaN(resetColour) )
						tweenParticleColour(particleData, resetColour, duration, ( counter / ( duration * 1000 ) ) + colourTweenDelay)

					// ------------------------------------------------
					// tween
					TweenMax.to(particleData.particle, duration, tweenProps);

					counter++;
				}

				particleData = particleData.next;
			}

			// ------------------------------------------------
			// end tween event

			counter++;

			if ( useCallback ) {
				tweenProps = new Object();
				tweenProps.delay = counter / 1000;
				tweenProps.onComplete = onParticlesDetached;

				TweenMax.to(this, duration, tweenProps);
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function detachfromObjectVertex(forceRandom : Boolean = false, resetColour : Number = NaN, duration : Number = 3, delayDivisor : Number = 1000, colourTweenDelay : Number = 0, forceColour : Boolean = false) : void {
			var particleData : ParticleVO = particleData[0]
			var counter : uint = 0;
			var	tweenProps : Object = new Object();
			// var	tweenCProps 	: Object 		= new Object();

			while ( particleData ) {
				// ------------------------------------------------
				// if particle is attached to vertice ( or random is enforced )

				if ( particleData.vertice != null || forceRandom ) {
					// ------------------------------------------------
					// Tween Properties

					tweenProps = new Object();
					tweenProps.x = Math.random() * (_worldSize * 2 ) - _worldSize;
					tweenProps.y = Math.random() * (_worldSize * 2 ) - _worldSize;
					tweenProps.z = Math.random() * (_worldSize * 2 ) - _worldSize;
					tweenProps.delay = counter / delayDivisor;
					tweenProps.ease = Expo.easeInOut

					particleData.vertice = null;
					particleData.targetDo3d = null;
					particleData.animationComplete = true;

					if ( !isNaN(resetColour) )
						tweenParticleColour(particleData, resetColour, duration - .5, ( counter / delayDivisor ) + colourTweenDelay)

					TweenMax.to(particleData.particle, duration, tweenProps);

					counter++;
				} else if ( forceColour ) {
					if ( !isNaN(resetColour) )
						tweenParticleColour(particleData, resetColour, duration - .5, ( counter / delayDivisor ) + colourTweenDelay)

					counter++;
				}

				particleData = particleData.next;
			}

			// ------------------------------------------------
			// end tween event

			counter++;
			tweenProps = new Object();
			tweenProps.delay = counter / delayDivisor ;

			// trace('tweenProps.delay: ' + tweenProps.delay )
			tweenProps.onComplete = onParticlesDetached;

			TweenMax.to(this, duration, tweenProps);
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function hideUnused(duration : Number = 1, delay : Number = 0) : void {
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function showParticle(particleData : ParticleVO, duration : Number = 1, delay : Number = 0) : void {
			particleData.hidden = false;
			particles.addParticle(particleData.particle);

			TweenMax.killTweensOf(particleData.particleMaterial);

			var tweenProps : Object = new Object();

			tweenProps.delay = delay;
			tweenProps.fillAlpha = 1;

			TweenMax.to(particleData.particleMaterial, duration, tweenProps);
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function hideParticle(particleData : ParticleVO, duration : Number = 1, delay : Number = 0) : void {
			particleData.animationComplete = true;
			particleData.vertice = null;
			particleData.targetDo3d = null;
			particleData.hidden = true;

			var tweenProps : Object = new Object();

			tweenProps.delay = delay;
			tweenProps.fillAlpha = 0;
			tweenProps.onComplete = hideParticleComplete
			tweenProps.onCompleteParams = [particleData]

			TweenMax.to(particleData.particleMaterial, duration, tweenProps);
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function tweenParticleColour(particleData : ParticleVO, targetColour : int, duration : Number, delay : Number) : void {
			TweenMax.killTweensOf(particleData.coloursTween)
			particleData.coloursTween.fillColor = particleData.particleMaterial.fillColor

			var tweenCProps : Object = new Object();
			tweenCProps.delay = delay
			tweenCProps.hexColors = {fillColor:targetColour};
			tweenCProps.onUpdate = updateColour
			tweenCProps.onUpdateParams = [particleData, particleData.coloursTween]

			TweenMax.to(particleData.coloursTween, duration, tweenCProps);
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get defaultColour() : int {
			return _defaultColour;
		}

		public function set defaultColour(defaultColour : int) : void {
			_defaultColour = defaultColour;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get gridSize() : uint {
			return _gridSize;
		}

		public function set gridSize(gridSize : uint) : void {
			_gridSize = gridSize;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get cubeWidth() : uint {
			return _cubeWidth;
		}

		public function set cubeWidth(cubeWidth : uint) : void {
			_cubeWidth = cubeWidth;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get cubeSpacing() : uint {
			return _cubeSpacing;
		}

		public function set cubeSpacing(cubeSpacing : uint) : void {
			_cubeSpacing = cubeSpacing;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get defaultAlpha() : Number {
			return _defaultAlpha;
		}

		public function set defaultAlpha(defaultAlpha : Number) : void {
			_defaultAlpha = defaultAlpha;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get particleSize() : int {
			return _particleSize;
		}

		public function set particleSize(particleSize : int) : void {
			_particleSize = particleSize;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get length() : uint {
			return particleData.length;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get worldSize() : int {
			return _worldSize;
		}

		public function set worldSize(worldSize : int) : void {
			_worldSize = worldSize;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get fadeDownDecay() : Number {
			return _fadeDownDecay;
		}

		public function set fadeDownDecay(fadeDownDecay : Number) : void {
			_fadeDownDecay = fadeDownDecay;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get fadeUpDecay() : Number {
			return _fadeUpDecay;
		}

		public function set fadeUpDecay(fadeUpDecay : Number) : void {
			_fadeUpDecay = fadeUpDecay;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get particleShape() : int {
			return _particleShape;
		}

		public function set particleShape(particleShape : int) : void {
			_particleShape = particleShape;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function hideParticleComplete(particleData : ParticleVO) : void {
			particleData.hidden = true;
			particles.removeParticle(particleData.particle);
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function particleAnimationComplete(particleData : ParticleVO) : void {
			particleData.animationComplete = true;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function onParticlesDetached() : void {
			dispatchEvent(new ParticleControllerEvent(ParticleControllerEvent.PARTICLES_DETACHED))
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function particlesLinked() : void {
			dispatchEvent(new ParticleControllerEvent(ParticleControllerEvent.PARTICLES_ATTACHED))
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function updateColour(p : ParticleVO, colourObj : Object) : void {
			p.particleMaterial.fillColor = colourObj.fillColor;
		}

		public function get seqMultiplier() : Number {
			return _seqMultiplier;
		}

		public function set seqMultiplier(seqMultiplier : Number) : void {
			_seqMultiplier = seqMultiplier;
		}
	}
}