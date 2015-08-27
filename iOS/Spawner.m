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

+ (NSURL *)templateJSBundlePath {
  return [[NSBundle mainBundle] URLForResource:@"template" withExtension:@"jsbundle"].path;
}

+ (NSURL *)indexIOSJSBundlePath {
  return [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"ios.js"].path;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(spawn:(NSString *)code)
{
  [[NSFileManager defaultManager] removeItemAtPath:[[self class] reactJSBundlePath] error:nil];

  NSString *template = [NSString stringWithContentsOfFile:[[self class] templateJSBundlePath] encoding:NSUTF8StringEncoding error:nil];
  template = [template stringByReplacingOccurrencesOfString:@"'self-hosted-react-native';" withString:code];

  [template writeToFile:[[self class] reactJSBundlePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];

  [self.bridge reload];
}

RCT_EXPORT_METHOD(curentSource:(RCTResponseSenderBlock)callback)
{
  NSString *source = [NSString stringWithContentsOfFile:[[self class] indexIOSJSBundlePath] encoding:NSUTF8StringEncoding error:nil];
  callback(@[[NSNull null], source]);
}

@synthesize bridge = _bridge;

@end
