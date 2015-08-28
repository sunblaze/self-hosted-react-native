// Spawner.m
#import "Spawner.h"
#import "RCTLog.h"
#import "RCTBridge.h"
#import "RCTDevMenu.h"

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

+ (NSString *)templateJSBundlePath {
  return [[NSBundle mainBundle] URLForResource:@"template" withExtension:@"jsbundle"].path;
}

+ (NSString *)indexIOSJSBundlePath {
  return [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"ios.js"].path;
}

+ (NSInteger)loadedVersion {
  return [[NSUserDefaults standardUserDefaults] integerForKey:@"sourceVersion"];
}

+ (NSString *)fileName: (NSInteger)version {
  return [NSString stringWithFormat:@"version%d.ios.js", version];
}

+ (NSString *)codeFilePath: (NSInteger)version{
  return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[self fileName:version]].path;
}

+ (void)revert {
  NSInteger prevVersion = [self loadedVersion] - 1;
  NSString *code = [NSString stringWithContentsOfFile:[self codeFilePath:prevVersion] encoding:NSUTF8StringEncoding error:nil];

  // Duplicate from below (class calls had to be removed though)
  [[NSFileManager defaultManager] removeItemAtPath:[self reactJSBundlePath] error:nil];

  NSString *template = [NSString stringWithContentsOfFile:[self templateJSBundlePath] encoding:NSUTF8StringEncoding error:nil];
  template = [template stringByReplacingOccurrencesOfString:@"'self-hosted-react-native';" withString:code];

  [template writeToFile:[self reactJSBundlePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];

  //Rollback version
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:[NSNumber numberWithInt:prevVersion] forKey:@"sourceVersion"];
  [defaults synchronize];
}

+ (void)addRevertToReactDevMenu:(RCTBridge*) bridge {
  dispatch_block_t block = ^{
    [self revert];
    [bridge reload];
  };

  [bridge.devMenu addItem:@"Revert" handler:block];
}

RCT_EXPORT_MODULE();

- (void) setBridge: (RCTBridge*)newBridge;
{
  if(_bridge != newBridge){
    [[self class] addRevertToReactDevMenu:newBridge];
  }
  _bridge = newBridge;
}

RCT_EXPORT_METHOD(spawn:(NSString *)code)
{
  [[NSFileManager defaultManager] removeItemAtPath:[[self class] reactJSBundlePath] error:nil];

  NSString *template = [NSString stringWithContentsOfFile:[[self class] templateJSBundlePath] encoding:NSUTF8StringEncoding error:nil];
  template = [template stringByReplacingOccurrencesOfString:@"'self-hosted-react-native';" withString:code];

  [template writeToFile:[[self class] reactJSBundlePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];

  NSInteger newVersion = [[self class] loadedVersion] + 1;

  NSString *codePath = [[self class] codeFilePath:newVersion];

  // delete previous code version if it exists
  [[NSFileManager defaultManager] removeItemAtPath:codePath error:nil];

  // write code file
  [code writeToFile:codePath atomically:YES encoding:NSUTF8StringEncoding error:nil];

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:[NSNumber numberWithInt:newVersion] forKey:@"sourceVersion"];
  [defaults synchronize];

  [self.bridge reload];
}

RCT_EXPORT_METHOD(curentSource:(RCTResponseSenderBlock)callback)
{
  NSString *path = [[self class] indexIOSJSBundlePath];
  NSInteger version = [[self class] loadedVersion];
  NSInteger nextVersion = version + 1;
  NSString *nextVersionPath = [[self class] codeFilePath:nextVersion];

  if([[NSFileManager defaultManager] fileExistsAtPath:nextVersionPath]){
    path = nextVersionPath;
  }else if(version > 0){
    path = [[self class] codeFilePath:version];
  }
  NSString *source = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
  callback(@[[NSNull null], source]);
}

@synthesize bridge = _bridge;

@end
