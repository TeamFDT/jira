package 
{
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	import test.Example;
	
	
//++++ Uncomment the next line or "Organize Imports" to make it work ++++  
//	import test2.Example;

	public class Main extends Sprite
	{
		public function Main()
		{
			var input: *;
			
			input = new test.Example();
			var a: test.Example = test.Example(input);
			trace( getQualifiedClassName(a) );
			
			input = new test2.Example();
			var b: test2.Example = (test2.Example)(input);
			trace( getQualifiedClassName(b) );
		}
	}
}
