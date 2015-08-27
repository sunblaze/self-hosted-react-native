// Spawner.m
#import "Spawner.h"
#import "RCTLog.h"
#import "RCTBridge.h"

@implementation Spawner

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(spawn:(NSString *)code)
{
  RCTLogInfo(@"Should spawn with the following code: %@", code);

  // Duplicated from AppDelegate.m
  NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
  NSURL *reactJSBundleURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"react.jsbundle"];

  [[NSFileManager defaultManager] removeItemAtPath:reactJSBundleURL.path error:nil];
  [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] URLForResource:@"main-alt" withExtension:@"jsbundle"].path
          toPath:reactJSBundleURL.path
          error:nil];

  [self.bridge reload];
}

@synthesize bridge = _bridge;

@end
