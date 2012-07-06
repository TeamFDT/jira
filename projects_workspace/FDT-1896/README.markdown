This example illustrates the situation where breakpoints aren't triggered within the FDT Max debugger
--------------------------------------

1. Create a new FDT project with the sample files
2. Set a breakpoint in ExternalSwf.as
3. Build with ant
4. Click the first button
5. The new swf gets loaded

5.1. Click the new button to trigger the break point
5.2. Click the first button to unload the swf

6. The first button can be clicked to reload the swf
7. The swf has been reloaded
7.1 Clicking the new button will not trigger the breakpoint, and debugging via fdt is impossible