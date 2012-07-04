package com.powerflasher.profiling.bitmap
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.system.System;
	import flash.utils.setTimeout;

	[SWF(width='800', height='600', backgroundColor='#ffffff', framerate='31')]

	public class CopyBitmap extends Sprite {

		[Embed(source='FDT4.png')]
		private var EmbeddedImage : Class;

		public function CopyBitmap() {
			init();
		}
		
		private function init() : void {
			trace("1. start timers");
			setTimeout(createImages, 3000);
			setTimeout(createBitmapCopies, 6000);
			setTimeout(clear, 9000);
		}

		private function createImages() : void {
			trace("2. adding images using bitmap objects");
			for (var i : int = 0;i < 6; i++) {
				var b : Bitmap = new EmbeddedImage();
				b.x = i * 130;
				addChild(b);				
			}
		}

		private function createBitmapCopies() : void {
			trace("3. adding images using BitmapData references");
			var bitmap : Bitmap = new EmbeddedImage();
			for (var i : int = 0;i < 6; i++) {
				var b : Bitmap = new Bitmap(bitmap.bitmapData);
				b.x = i * 130;
				b.y = 150;
				addChild(b);				
			}
		}

		private function clear() : void {
			trace("4. removing all children");
			while(numChildren > 0){
				removeChildAt(0);
			}
			setTimeout(runGC, 2000);
		}
		
		private function runGC() : void {
			trace("5. Garbage Collection");
			System.gc();
			trace("starting over ...\n");
			setTimeout(init, 3000);
		}
	}
}
