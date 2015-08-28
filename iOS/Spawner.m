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

RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;

- (void) setBridge: (RCTBridge*)newBridge {
  BOOL isNew = (_bridge != newBridge);
  _bridge = newBridge;
  if(isNew){
    [self addRevertToReactDevMenu];
  }
}

- (void)addRevertToReactDevMenu {
  dispatch_block_t block = ^{
    [self revert];
    [self.bridge reload];
  };

  [self.bridge.devMenu addItem:@"Revert" handler:block];
}

- (void)replaceBundle: (NSString*) code {
  [[NSFileManager defaultManager] removeItemAtPath:[[self class] reactJSBundlePath] error:nil];

  NSString *template = [NSString stringWithContentsOfFile:[[self class] templateJSBundlePath] encoding:NSUTF8StringEncoding error:nil];
  template = [template stringByReplacingOccurrencesOfString:@"'self-hosted-react-native';" withString:code];

  [template writeToFile:[[self class] reactJSBundlePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)revert {
  NSInteger prevVersion = [[self class] loadedVersion] - 1;
  NSString *code = [NSString stringWithContentsOfFile:[[self class] codeFilePath:prevVersion] encoding:NSUTF8StringEncoding error:nil];

  [self replaceBundle:code];

  //Rollback version
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:[NSNumber numberWithInt:prevVersion] forKey:@"sourceVersion"];
  [defaults synchronize];
}

RCT_EXPORT_METHOD(spawn:(NSString *)code) {
  [self replaceBundle:code];

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

RCT_EXPORT_METHOD(curentSource:(RCTResponseSenderBlock)callback) {
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

RCT_EXPORT_METHOD(versions:(RCTResponseSenderBlock)callback) {
  NSInteger version = 1;
  NSMutableArray *versions = [[NSMutableArray alloc] init];

  while([[NSFileManager defaultManager] fileExistsAtPath:[[self class] codeFilePath:version]]){
    NSNumber* versionWrapped = [NSNumber numberWithInt:version];
    [versions addObject:versionWrapped];
    version++;
  }

  callback(@[versions]);
}

RCT_EXPORT_METHOD(source:(NSInteger)version callback:(RCTResponseSenderBlock)callback) {
  NSString *source = [NSString stringWithContentsOfFile:[[self class] codeFilePath:version] encoding:NSUTF8StringEncoding error:nil];
  callback(@[[NSNull null], source]);
}

RCT_EXPORT_METHOD(loadedVersion:(RCTResponseSenderBlock)callback) {
  NSNumber *version = [NSNumber numberWithInt:[[self class] loadedVersion]];
  callback(@[version]);
}

RCT_EXPORT_METHOD(currentVersion:(RCTResponseSenderBlock)callback) {
  NSInteger version = [[self class] loadedVersion];
  NSInteger nextVersion = version + 1;
  if([[NSFileManager defaultManager] fileExistsAtPath:[[self class] codeFilePath:nextVersion]]){
    callback(@[[NSNumber numberWithInt:nextVersion]]);
  }else{
    callback(@[[NSNumber numberWithInt:version]]);
  }
}

@end
