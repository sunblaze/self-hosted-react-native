// Spawner.h
#import "RCTBridgeModule.h"

@interface Spawner : NSObject <RCTBridgeModule>
+ (NSURL *)applicationDocumentsDirectory;
+ (NSURL *)reactJSBundleURL;
@end
