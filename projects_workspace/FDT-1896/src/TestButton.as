package
{
    import flash.events.MouseEvent;
    import com.bit101.components.PushButton;

    /**
     * (c) HuzuTech 2011
     */
    public class TestButton extends PushButton
    {
        public function TestButton()
        {
            addEventListener(MouseEvent.CLICK, onClicked);
        }

        private function onClicked(event : MouseEvent) : void
        {
            /*
             * Add a breakpoint on the trace call
             */
            trace("test function called");
        }
    }
}
