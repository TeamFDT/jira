package 
{
	import flash.display.Sprite;

	public class Main extends Sprite
	{
		public function Main()
		{
			var test: Test = new Test();
			
			var a: Boolean = test || true;
			var b: Boolean = true || test;
		}
	}
}
