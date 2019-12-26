#define LogDebug(message, ...) \
	NSLog((@"[LockWidgets] (DEBUG) " message), ##__VA_ARGS__)
#define LogInfo(message, ...) \
	NSLog((@"[LockWidgets] (INFO) " message), ##__VA_ARGS__)