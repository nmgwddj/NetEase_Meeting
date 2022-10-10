// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import "MeetingPlugin.h"
#import "FLTImageUtil.h"

@implementation MeetingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"meeting_plugin"
                                  binaryMessenger:[registrar messenger]];
  MeetingPlugin *instance = [[MeetingPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  //获取模块id
  id modelName = nil;
  NSDictionary *arguments = call.arguments;
  modelName = arguments[@"module"];
  //模块校验
  if (!modelName || ![modelName isKindOfClass:[NSString class]]) {
    result(@(-1001));
    return;
  }
  //转发
#ifdef DEBUG
  NSLog(@"[iOS] Call Model:%@ Menthod:%@ argument:%@", modelName, call.method, call.arguments);
#endif
  if ([modelName isEqualToString:@"NEAssetService"] &&
      [call.method isEqualToString:@"loadAssetAsString"]) {
    NSString *fileName = [arguments objectForKey:@"fileName"];
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@""];
    BOOL isDir = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] || isDir) {
      result(nil);
      return;
    }
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    result(content);
  } else if ([modelName isEqualToString:@"ImageLoader"] &&
             [call.method isEqualToString:@"loadImage"]) {
    NSString *name = [arguments objectForKey:@"key"];
    UIImage *image = [UIImage imageNamed:name];
    if (!image) {
      result(nil);
      return;
    }
#ifdef DEBUG
    NSLog(@"[iOS] loadImage:%@x%@@%@", @(image.size.width), @(image.size.height), @(image.scale));
#endif
    // image = [FLTImageUtil scaledImage:image maxWidth:maxWidth maxHeight:maxHeight];
    NSData *data = UIImagePNGRepresentation(image);
    if (data) {
#ifdef DEBUG
      NSLog(@"[iOS] loadImage: len=%@", @(data.length));
#endif
      result(@{
        @"scale" : @(image.scale),
        @"data" : [FlutterStandardTypedData typedDataWithBytes:data],
      });
    } else {
      result(nil);
    }
    return;
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (NSDictionary *)dictionaryFromFile:(NSString *)fileName {
  NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"conf"];
  BOOL isDir = NO;
  if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] || isDir) {
    return nil;
  }
  NSData *data = [NSData dataWithContentsOfFile:path];
  NSError *error = nil;
  id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

  if (!obj || error || ![obj isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  return obj;
}

@end