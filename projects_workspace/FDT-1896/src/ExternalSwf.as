package
{
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;

    /**
     * (c) HuzuTech 2011
     */
    public class ExternalSwf extends Sprite implements ITestInterface
    {
        public var testButton:TestButton;

        public function ExternalSwf()
        {
            testButton = new TestButton();
            testButton.label = "Click Me!!";
            addChild(testButton);


        }

        public function getDisplayObjectContainer():DisplayObjectContainer
        {
            return this;
        }
    }
}
