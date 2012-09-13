package {
	import mx.core.MovieClipLoaderAsset;
	import mx.core.MovieClipAsset;
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
	import flash.utils.Timer;

	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="640", height="480")]
	public class kurst3DForceMap extends Sprite {
		
		private const stageArea : int = 468;
		private var threeDView : Away3DBase;
		private const NUM_PARTICLES : int = 1000;
		private var particles : Vector.<Particle>;
		private var forceMap:BitmapData = new BitmapData( stageArea / 2, stageArea / 2 , false, 0x000000 );
		private var offset:Array = [new Point(), new Point()];
		private var seed:Number = Math.floor( Math.random() * 0xFFFF );
		private var bmp : Bitmap;
		
		public function kurst3DForceMap() {
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			addChild( threeDView = new Away3DBase() );

			
			threeDView.x = 0;
			threeDView.y = 0;
			threeDView.width = stage.stageWidth;
			threeDView.height = stage.stageHeight;
			threeDView.view.filters3d = [new MotionBlurFilter3D(.6) , new BloomFilter3D(15, 15 , .9 , 9 , 3 ) ];
			//threeDView.view.backgroundColor = 0x000000;
			
			
			threeDView.enableHoverController( true , 800 );
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
			var planeGeom 	: PlaneGeometry = new PlaneGeometry( 2 , 2 );
			var mesh 		: Mesh	;//= new Mesh( planeGeom , mat );
			
			particles = new Vector.<Particle>();
			
			for ( var c : int = 0 ; c < NUM_PARTICLES ; c ++ ){
				
				mesh = new Mesh( planeGeom , mat ); 
				
                var px:Number = Math.random() * stageArea;
                var py:Number = Math.random() * stageArea;
                var pz:Number = Math.random() * stageArea * 2 - stageArea;
				
                particles.push( new Particle(mesh , px, py, pz) );

				threeDView.add3DChild( mesh );
				
			}


			
		}

		private function onEnterFrame(event : Event) : void {


            var len:uint = particles.length;
            var col:Number
            
            for (var i:uint = 0; i < len; i++) {
                
                var dots:Particle = particles[i];
                
                col = forceMap.getPixel( dots.mesh.x >> 1, dots.mesh.y >> 1);
                dots.ax += ( (col >> 8 & 0xff) - 128 ) * .0005;
                dots.ay += ( (col >> 4  & 0xff) - 128 ) * .0005;
                dots.az += ( (col >> 16  & 0xff) - 128 ) * .0005;
                dots.vx += dots.ax;
                dots.vy += dots.ay;
                dots.vz += dots.az;
                dots.mesh.x += dots.vx;
                dots.mesh.y += dots.vy;
                dots.mesh.z += dots.vz;

                var _posX:Number = dots.mesh.x;
                var _posY:Number = dots.mesh.y;
                var _posZ:Number = dots.mesh.z;
                    
                dots.ax *= .95;
                dots.ay *= .95;
                dots.az *= .95;
                dots.vx *= .90;
                dots.vy *= .90;
                dots.vz *= .90;
                
                ( _posX > stageArea ) ? dots.mesh.x = 0 :
                    ( _posX < 0 ) ? dots.mesh.x = stageArea : -stageArea;
					
                ( _posY > stageArea ) ? dots.mesh.y = 0 :
                    ( _posY < 0 ) ? dots.mesh.y = stageArea : -stageArea;
					
                ( _posZ > stageArea ) ? dots.mesh.z = -stageArea :
                    ( _posZ < -stageArea ) ? dots.mesh.z = stageArea : -stageArea;
            }
            
			threeDView.render();
		}
		
        private function resetFunc(e:Event = null):void{
			
            forceMap.perlinNoise(stageArea / 2, stageArea / 2, 3, seed, false, false, 1|2|4|0, false, offset );
            offset[0].x += 13.5;
            offset[1].y += 13;
			
			
			//forceMap.fillRect( new Rectangle ( 20 , 20 , 210 , 210 ) , 0x000000);
            seed = Math.floor( Math.random() * 0xFFFFFF );
			
        }
		
	}
}
