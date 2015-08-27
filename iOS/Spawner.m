// Spawner.m
#import "Spawner.h"
#import "RCTLog.h"
#import "RCTBridge.h"

@implementation Spawner

+ (NSURL *)applicationDocumentsDirectory {
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSURL *)reactJSBundleURL {
  return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"react.jsbundle"];
}

+ (NSString *)reactJSBundlePath {
  return [self reactJSBundleURL].path;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(spawn:(NSString *)code)
{
  RCTLogInfo(@"Should spawn with the following code: %@", code);

  [[NSFileManager defaultManager] removeItemAtPath:[[self class] reactJSBundlePath] error:nil];
  [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] URLForResource:@"main-alt" withExtension:@"jsbundle"].path
          toPath:[[self class] reactJSBundlePath]
          error:nil];

  [self.bridge reload];
}

RCT_EXPORT_METHOD(curentSource:(RCTResponseSenderBlock)callback)
{
  NSString *source = [NSString stringWithContentsOfFile:[[self class] reactJSBundlePath] encoding:NSUTF8StringEncoding error:nil];
  callback(@[[NSNull null], source]);
}

@synthesize bridge = _bridge;

@end
