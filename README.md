# CustomActionButton

Assign custom action into iPhone 15 Pro's Action Button.

1. Build this framework.

2. Run these commands.

```
 % xcrun simctl spawn booted launchctl debug system/com.apple.SpringBoard --environment DYLD_INSERT_LIBRARIES=${PATH_TO_EXECUTABLE}
 
 % xcrun simctl spawn booted launchctl stop com.apple.SpringBoard
```
