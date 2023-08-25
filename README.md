1. Flutter app that commission a Matter device using MatterSupport and Matter framework in Apple
2. I am using my own Matter controller (ESP Matter over Wifi device)
3. For creating the controller and the stuff it needs (MTRKeypair, MTRStorage Delegate, etc), I used [CHIPTool](https://github.com/project-chip/connectedhomeip/tree/master/src/darwin/CHIPTool) code.
4. Using MatterSupport means using my own custom ecosystem, not homekit.