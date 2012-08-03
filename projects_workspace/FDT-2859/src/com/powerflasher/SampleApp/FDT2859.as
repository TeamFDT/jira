package com.powerflasher.SampleApp
{
	import flash.events.Event;
	import flash.display.Sprite;

	public class FDT2859 extends Sprite implements Party
	{
		public function FDT2859()
		{
			this.stage.addEventListener(Event.ENTER_FRAME, party);
		}

		private function party(event : Event) : void
		{
		}

		public function zipy() : void
		{
		}
	}
}
