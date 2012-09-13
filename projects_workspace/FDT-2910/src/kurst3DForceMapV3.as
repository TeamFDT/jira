package {
	import flash.geom.Vector3D;
import flash.utils.getTimer;
	import away3d.entities.Mesh;
	import away3d.entities.SegmentSet;
	
	import away3d.filters.BloomFilter3D;
	import away3d.filters.MotionBlurFilter3D;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.LineSegment;

	import com.kurst.away3d.Away3DBase;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import away3d.containers.ObjectContainer3D;

	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="640", height="480")]
	public class kurst3DForceMapV3 extends Sprite {

		
		private var posMultiplierX 				: int = 8;
		private var posMultiplierY 				: int = 5;
		private var posMultiplierZ 				: int = 3;
				
		private const stageArea : int = 200;
		private var threeDView : Away3DBase;
		private const NUM_PARTICLES : int = 8000;
		private var particles : Vector.<ParticleV2>;
		private var forceMap:BitmapData = new BitmapData( stageArea, stageArea , false, 0x000000 );
		private var _offsets:Array = [new Point(), new Point()];
		private var seed:Number = Math.floor( Math.random() * 0xFFFF );
		private var bmp : Bitmap;
		
		private var _offsetSpeed1:			Number		= .5;
		private var _offsetSpeed2:			Number		= -.5;
		private var _speedMultiplier:		Number		= 1;

		private var _baseX:					int			= 90;
		private var _baseY:					int			= 90;
		
		private var txt						: TextField
		
		private var container : ObjectContainer3D;
		private var s 					: SegmentSet;
		
		public function kurst3DForceMapV3() {
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			addChild( threeDView = new Away3DBase() );


			threeDView.x = 0;
			threeDView.y = 0;
			threeDView.width = stage.stageWidth;
			threeDView.height = stage.stageHeight;
			threeDView.view.filters3d = [new MotionBlurFilter3D(.8) , new BloomFilter3D(15, 15 , .9 , 9 , 3 ) ];
			
			s = new SegmentSet();
			threeDView.scene.addChild(s);
			
			container = new ObjectContainer3D();
			s.x -= ( stageArea * posMultiplierX ) / 2 ;
			s.y -= ( stageArea * posMultiplierY ) / 2 ;
			threeDView.scene.addChild(container);
			threeDView.enableHoverController( true , 900 );
			resetFunc();
			init3d();
			
			addEventListener(Event.ENTER_FRAME , onEnterFrame , false ,0 , true );
			stage.addEventListener( Event.RESIZE , onResize , false ,0 , true );
			
            var timer:Timer = new Timer(500)
            timer.addEventListener(TimerEvent.TIMER, resetFunc);
            timer.start();
			
			bmp = new Bitmap( forceMap );
			addChild( bmp );
			/*
			txt = new TextField();
			txt.background = true;
			addChild( txt );
			*/
			
		}

		private function onResize(event : Event) : void {
			
			threeDView.width = stage.stageWidth;
			threeDView.height = stage.stageHeight;
		}

		private function init3d() : void {
			
			var mat 		: ColorMaterial = new ColorMaterial( 0xffffff );
				mat.bothSides 				= true;
			
			particles = new Vector.<ParticleV2>();
			
			for ( var c : int = 0 ; c < NUM_PARTICLES ; c ++ ){
				
                var px:Number = Math.random() * stageArea;
                var py:Number = Math.random() * stageArea;
                var pz:Number = Math.random() * stageArea;
				
				var v : Vector3D 	= new Vector3D();
					v.x 			= px;
					v.y 			= py;
					v.z 			= pz;
					
				var p : ParticleV2 = new ParticleV2( null , px, py, pz)
					p.line 			= new LineSegment( v , new Vector3D( px ,py ,pz + 1 ) , 0xffffff, 0x7e7e7e , 1 );
					
				if ( c > 0 ) {
					
					particles[ c - 1 ].next = p;
					
				}
				
				particles.push( p );

				s.addSegment( p.line );
				
			}
			
		}

		private function onEnterFrame(event : Event) : void {

			_offsets[0].x 		+= _offsetSpeed1;
			_offsets[0].y 		+= _offsetSpeed1;
			
			_offsets[1].x 		+= _offsetSpeed2;
			_offsets[1].y 		+= _offsetSpeed2;
			
			forceMap.perlinNoise( _baseX, _baseY, 2, seed, false, true, 10, true, _offsets );
			forceMap.fillRect( new Rectangle ( 50 , 50 , 20 , 20 ) , 0xffffff );
			
			var brightness		: Number;
			var radians			: Number;
			var angle			: Number;
			var speed			: Number;
			var pixel			: int;
            var p 				: ParticleV2 = particles[0];
			var initPos 		: Vector3D;
			
			//var st : Number = getTimer();
			//*
            while( p.next ){
                
				initPos 		= p.line.end.clone();
				pixel 			= forceMap.getPixel( p.line.end.x / posMultiplierX , p.line.end.y / posMultiplierY );
				
				brightness 		= pixel / 0xFFFFFF;
				speed 			= 0.1 + brightness * p.speed * _speedMultiplier;
				angle 			= 360 * brightness * p.wander;
				radians 		= angle * Math.PI / 180;
				
				p.line.end.x 	+= Math.cos( radians ) * speed * posMultiplierX ;
				p.line.end.y 	+= Math.sin( radians ) * speed * posMultiplierY;
				p.line.end.z 	= brightness * stageArea * posMultiplierZ ;
				
				p.line.start 	= initPos;;
				
				if ( p.line.end.x < 0 ){
					
					 p.line.end.x 		= stageArea * posMultiplierX - 10;
					 p.line.start.x 	= stageArea * posMultiplierX - 10;
					 
				} else if ( p.line.end.x > stageArea * posMultiplierX ) {
					
					p.line.end.x 		= 10;
					p.line.start.x 		= 10;
					
				}
				
				if ( p.line.end.y < 0 ) {
					
					p.line.end.y 		= stageArea * posMultiplierY - 10;
					p.line.start.y 		= stageArea * posMultiplierY - 10;
					
				} else if ( p.line.end.y > stageArea * posMultiplierY) {
					
					p.line.end.y 		= 10;
					p.line.start.y 		= 10;
					
				}
				
				if ( Vector3D.distance(p.line.end, p.line.start) > 30 ){
					p.line.start = p.line.end;
				}
				
				p = p.next;
				
            }
			//*/
			
			
			//txt.text = String ( getTimer() - st  );
			threeDView.render();
		}
		
        private function resetFunc(e:Event = null):void{

        }
		
	}
}
