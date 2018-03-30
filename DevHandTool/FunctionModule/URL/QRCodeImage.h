//
//  QRCodeImage.h
//  QRCode
//
//

#import <AppKit/AppKit.h>
#import <Cocoa/Cocoa.h>
#import <CoreImage/CoreImage.h>

@interface QRCodeImage : NSImage

//pre
+ (NSImage *)qrImageWithContent:(NSString *)content
                           size:(CGFloat)size;
/*
 色值 0~255
 */
+ (NSImage *)qrImageWithContent:(NSString *)content
                           size:(CGFloat)size
                            red:(NSInteger)red
                          green:(NSInteger)green
                           blue:(NSInteger)blue;


+(NSImage *)qrImageWithContent:(NSString *)content
                          logo:(NSImage *)logo
                          size:(CGFloat)size
                           red:(NSInteger)red
                         green:(NSInteger)green
                          blue:(NSInteger)blue;


@end
