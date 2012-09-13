package {
	import mx.core.MovieClipAsset;
	import flash.display.MovieClip;
	import away3d.entities.Mesh;
	
	import away3d.filters.BloomFilter3D;
	import away3d.filters.MotionBlurFilter3D;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.PlaneGeometry;

	import com.kurst.away3d.Away3DBase;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import away3d.containers.ObjectContainer3D;
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="640", height="480")]
	public class kurst3DForceMapV2 extends Sprite {

		private static const MARGIN:		int = 10;
		private static const UI_Y_OPEN:		int = 200;
		private static const UI_Y_CLOSED:	int = 314;
		
		private var posMultiplierX : int = 3;
		private var posMultiplierY : int = 2;
		private var posMultiplierZ : int = 2;
				
		private const stageArea : int = 200;
		private var threeDView : Away3DBase;
		private const NUM_PARTICLES : int = 2000;
		private var particles : Vector.<ParticleV2>;
		private var forceMap:BitmapData = new BitmapData( stageArea, stageArea , false, 0x000000 );
		private var _offsets:Array = [new Point(), new Point()];
		private var seed:Number = Math.floor( Math.random() * 0xFFFF );
		private var bmp : Bitmap;
		
		private var _offsetSpeed1:			Number		= 1.0;
		private var _offsetSpeed2:			Number		= -1.0;
		private var _speedMultiplier:		Number		= 1;

		private var _baseX:					int			= 100;
		private var _baseY:					int			= 100;
		
		private var container : ObjectContainer3D;
		
		

		public function kurst3DForceMapV2() {
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			addChild( threeDView = new Away3DBase() );

			//seed = Math.random() * 2000 << 0;
			
			threeDView.x = 0;
			threeDView.y = 0;
			threeDView.width = stage.stageWidth;
			threeDView.height = stage.stageHeight;
			threeDView.view.filters3d = [new MotionBlurFilter3D(.6) ];
			
			
			
			container = new ObjectContainer3D();
			container.x -= ( stageArea * posMultiplierX ) / 2 ;
			container.y -= ( stageArea * posMultiplierY ) / 2 ;
			threeDView.scene.addChild(container);
			threeDView.enableHoverController( true , 600 );
			resetFunc();
			init3d();
			
			addEventListener(Event.ENTER_FRAME , onEnterFrame , false ,0 , true );
			stage.addEventListener( Event.RESIZE , onResize , false ,0 , true );
			
            var timer:Timer = new Timer(500)
            timer.addEventListener(TimerEvent.TIMER, resetFunc);
            timer.start();
			
			bmp = new Bitmap( forceMap );
			addChild( bmp );
			
		}

		private function onResize(event : Event) : void {
			
			threeDView.width = stage.stageWidth;
			threeDView.height = stage.stageHeight;
		}

		private function init3d() : void {
						
			var mat 		: ColorMaterial = new ColorMaterial( 0xffffff );
				mat.bothSides = true;
			var planeGeom 	: PlaneGeometry = new PlaneGeometry( 3 , 3 );
			var mesh 		: Mesh	;//= new Mesh( planeGeom , mat );
			
			particles = new Vector.<ParticleV2>();
			
			for ( var c : int = 0 ; c < NUM_PARTICLES ; c ++ ){
				
				mesh = new Mesh( planeGeom , mat ); 
				
                var px:Number = Math.random() * stageArea;
                var py:Number = Math.random() * stageArea;
                var pz:Number = Math.random() * stageArea;
				
                particles.push( new ParticleV2(mesh , px, py, pz) );

				container.addChild(mesh)
				//threeDView.add3DChild( mesh );
				
			}


			
		}

		private function onEnterFrame(event : Event) : void {

			_offsets[0].x += _offsetSpeed1;
			_offsets[0].y += _offsetSpeed1;
			
			_offsets[1].x += _offsetSpeed2;
			_offsets[1].y += _offsetSpeed2;
			
			forceMap.perlinNoise( _baseX, _baseY, 2, seed, false, true, 10, true, _offsets );
			forceMap.fillRect( new Rectangle ( 50 , 50 , 20 , 20 ) , 0xffffff );
			var brightness:Number;
			var radians:Number;
			var angle:Number;
			var speed:Number;
			
			var pixel:int;
            var len:uint = particles.length;
            var p : ParticleV2
            for (var i:uint = 0; i < len; i++) {
                
				p = particles[i];
				pixel = forceMap.getPixel( p.mesh.x / posMultiplierX , p.mesh.y / posMultiplierY );
				
				brightness = pixel / 0xFFFFFF;
				speed = 0.1 + brightness * p.speed * _speedMultiplier;
				angle = 360 * brightness * p.wander;
				radians = angle * Math.PI / 180;
				
				p.mesh.x += Math.cos( radians ) * speed * posMultiplierX ;
				p.mesh.y += Math.sin( radians ) * speed * posMultiplierY;
				p.mesh.z = brightness * stageArea * posMultiplierZ ;
				
				//particle.rotation = angle;
				//*
				if ( p.mesh.x < 0 ) p.mesh.x = stageArea * posMultiplierX - 10;
				else if ( p.mesh.x > stageArea * posMultiplierX ) p.mesh.x = 10;
				
				if ( p.mesh.y < 0 ) p.mesh.y = stageArea * posMultiplierY - 10;
				else if ( p.mesh.y > stageArea * posMultiplierY) p.mesh.y = 10;
				//*/
						
//				p.ox = p.mesh.x;
//				p.oy = p.mesh.y;
//				p.oz = p.mesh.z;
								
				
            }
            
			threeDView.render();
		}
		
        private function resetFunc(e:Event = null):void{
			
			/*
            forceMap.perlinNoise(stageArea / 2, stageArea / 2, 3, seed, false, false, 1|2|4|0, false, offset );
            offset[0].x += 13.5;
            offset[1].y += 13;
			
			
			//forceMap.fillRect( new Rectangle ( 20 , 20 , 210 , 210 ) , 0x000000);
            seed = Math.floor( Math.random() * 0xFFFFFF );
			*/
        }
		
	}
}
