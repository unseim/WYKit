//
//  UIImage+RemoteSize.m
//  WYKit
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//


#import "UIImage+RemoteSize.h"
#import <objc/runtime.h>
typedef NS_ENUM(NSUInteger, RemoteImageType) {
    NoneRemoteImage = 1,
    PNGRemoteImage,
    JPGRemoteImage,
    GIFRemoteImage,
};

static const void *UIImageSizeBlockKey = &UIImageSizeBlockKey;
static const void *RecieveDataKey = &RecieveDataKey;
static const void *RemoteImageTypeKey = &RemoteImageTypeKey;

@interface NSString (RemoteSize)
@property (nonatomic, copy) UIImageSizeBlock imageSizeBlock;
@property (nonatomic, strong) NSMutableData *recieveData;
@property (nonatomic, assign) RemoteImageType imageType;

@end

@implementation NSString (RemoteSize)

- (void)setImageSizeBlock:(UIImageSizeBlock) block {
    objc_setAssociatedObject(self, UIImageSizeBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (UIImageSizeBlock)imageSizeBlock {
    return objc_getAssociatedObject(self, UIImageSizeBlockKey);
}
- (void)setRecieveData:(NSMutableData *)recieveData {
    objc_setAssociatedObject(self, RecieveDataKey, recieveData, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableData*)recieveData {
    return objc_getAssociatedObject(self, RecieveDataKey);
}
- (void)setImageType:(RemoteImageType)imageType {
    objc_setAssociatedObject(self, RemoteImageTypeKey, [NSNumber numberWithInt:imageType], OBJC_ASSOCIATION_ASSIGN);
}
- (RemoteImageType)imageType {
    NSNumber *type =  objc_getAssociatedObject(self, RemoteImageTypeKey);
    return [type intValue];
}
//#pragma mark -
//#pragma mark - image header size
//CGSize pngImageSizeWithHeaderData(NSData *data)
//{
//    int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
//    [data getBytes:&w1 range:NSMakeRange(0, 1)];
//    [data getBytes:&w2 range:NSMakeRange(1, 1)];
//    [data getBytes:&w3 range:NSMakeRange(2, 1)];
//    [data getBytes:&w4 range:NSMakeRange(3, 1)];
//    int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
//    
//    int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
//    [data getBytes:&h1 range:NSMakeRange(4, 1)];
//    [data getBytes:&h2 range:NSMakeRange(5, 1)];
//    [data getBytes:&h3 range:NSMakeRange(6, 1)];
//    [data getBytes:&h4 range:NSMakeRange(7, 1)];
//    int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
//    
//    return CGSizeMake(w, h);
//}
//
//static inline CGSize jpgImageSizeWithExactData(NSData *data)
//{
//    short w1 = 0, w2 = 0;
//    [data getBytes:&w1 range:NSMakeRange(2, 1)];
//    [data getBytes:&w2 range:NSMakeRange(3, 1)];
//    short w = (w1 << 8) + w2;
//    
//    short h1 = 0, h2 = 0;
//    [data getBytes:&h1 range:NSMakeRange(0, 1)];
//    [data getBytes:&h2 range:NSMakeRange(1, 1)];
//    short h = (h1 << 8) + h2;
//    
//    return CGSizeMake(w, h);
//}
//
//CGSize jpgImageSizeWithHeaderData(NSData *data)
//{
//#ifdef DEBUG
//    // @"bytes=0-209"
//    //assert([data length] == 210);
//#endif
//    short word = 0x0;
//    [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
//    if (word == 0xdb) {
//        [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
//        if (word == 0xdb) {
//            // 两个DQT字段
//            NSData *exactData = [data subdataWithRange:NSMakeRange(0xa3, 0x4)];
//            return jpgImageSizeWithExactData(exactData);
//        } else {
//            // 一个DQT字段
//            NSData *exactData = [data subdataWithRange:NSMakeRange(0x5e, 0x4)];
//            return jpgImageSizeWithExactData(exactData);
//        }
//    } else {
//        return CGSizeZero;
//    }
//}
//
//CGSize gifImageSizeWithHeaderData(NSData *data)
//{
//    short w1 = 0, w2 = 0;
//    [data getBytes:&w1 range:NSMakeRange(1, 1)];
//    [data getBytes:&w2 range:NSMakeRange(0, 1)];
//    short w = (w1 << 8) + w2;
//    
//    short h1 = 0, h2 = 0;
//    [data getBytes:&h1 range:NSMakeRange(3, 1)];
//    [data getBytes:&h2 range:NSMakeRange(2, 1)];
//    short h = (h1 << 8) + h2;
//    
//    return CGSizeMake(w, h);
//}


#pragma mark -
#pragma mark - NSURLConnectionDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"recieved data length : %zd", [self.recieveData length]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    if(!self.recieveData) {
        self.recieveData = [NSMutableData data];
    }
    [self.recieveData appendData:data];

    //Parse metadata
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error
{
   
}

@end


NSString *const kPngRangeValue = @"bytes=16-23";
NSString *const kJpgRangeValue = @"bytes=0-209";
NSString *const kGifRangeValue = @"bytes=6-9";

@implementation UIImage (RemoteSize)

#pragma mark - 判断文件类型

+ (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x52:
            // R as RIFF for WEBP
            if ([data length] < 12) {
                return nil;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"image/webp";
            }
            
            return nil;
    }
    return nil;
}


+ (CGSize)PNGImageSizeWithRangeHeader:(NSData *)data{
    const unsigned char *cString = [data bytes];
    const NSInteger length = [data length];
    char type[5];
    int offset = 8;
    
    uint32_t chunkSize = 0;
    int chunkSizeSize = sizeof(chunkSize);
    if( offset+chunkSizeSize > length )
        return CGSizeZero;
    
    memcpy(&chunkSize, cString+offset, chunkSizeSize);
    chunkSize = OSSwapInt32(chunkSize);
    offset += chunkSizeSize;
    
    if( offset + chunkSize > length )
        return CGSizeZero;
    
    memcpy(&type, cString+offset, 4); type[4]='\0';
    offset += 4;
    
    if(strcmp(type, "IHDR") == 0 ) {   //Should always be first
        uint32_t width = 0, height = 0;
        memcpy(&width, cString+offset, 4);
        offset += 4;
        width = OSSwapInt32(width);
        memcpy(&height, cString+offset, 4);
        offset += 4;
        height = OSSwapInt32(height);
        return CGSizeMake(width, height);
    }
    return CGSizeZero;
}

+(CGSize)JPGImageSizeWithRangeHeader:(NSData *)data{
    const unsigned char *cString = [data bytes];
    const NSInteger length = [data length];
    int offset = 4;
    uint32_t block_length = cString[offset]*256 + cString[offset+1];
    
    while (offset<length) {
        offset += block_length;
        
        if( offset >= length )
            break;
        if( cString[offset] != 0xFF )
            break;
        if( cString[offset+1] == 0xC0 ||
           cString[offset+1] == 0xC1 ||
           cString[offset+1] == 0xC2 ||
           cString[offset+1] == 0xC3 ||
           cString[offset+1] == 0xC5 ||
           cString[offset+1] == 0xC6 ||
           cString[offset+1] == 0xC7 ||
           cString[offset+1] == 0xC9 ||
           cString[offset+1] == 0xCA ||
           cString[offset+1] == 0xCB ||
           cString[offset+1] == 0xCD ||
           cString[offset+1] == 0xCE ||
           cString[offset+1] == 0xCF ) {
            
            uint32_t width = 0, height = 0;
            
            height = cString[offset+5]*256 + cString[offset+6];
            width = cString[offset+7]*256 + cString[offset+8];
            
            return CGSizeMake(width, height);
            
        }
        else {
            offset += 2;
            block_length = cString[offset]*256 + cString[offset+1];
        }
        
    }
    return CGSizeZero;
}

+(CGSize)GIFImageSizeWithRangeHeader:(NSData *)data{
    const unsigned char *cString = [data bytes];
    
    int offset = 6;
    uint32_t width = 0, height = 0;
    memcpy(&width, cString+offset, 2);
    offset += 2;
    
    memcpy(&height, cString+offset, 2);
    offset += 2;
    return CGSizeMake(width, height);
}

+(CGSize)BMPImageSizeWithRangeHeader:(NSData *)data{
    const unsigned char *cString = [data bytes];
    
    int offset = 18;
    int width = 0, height = 0;
    memcpy(&width, cString+offset, 4);
    offset += 4;
    
    memcpy(&height, cString+offset, 4);
    offset += 4;
    return CGSizeMake(width, height);
}


+ (void)requestRemoteSize:(NSString*)url completion:(UIImageSizeBlock)completion
{
    url.imageSizeBlock = completion;
    
    NSURL *imgURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imgURL];
    
    
    if ([self checkSupportResume:imgURL]) {
        NSLog(@"support resume download");
        if ([[imgURL pathExtension] hasSuffix:@"gif"]) {
            url.imageType = GIFRemoteImage;
            [request setValue:kGifRangeValue forHTTPHeaderField:@"Range"];
        }
        if ([[imgURL pathExtension] hasSuffix:@"jpg"] || [[imgURL pathExtension] hasSuffix:@"jpeg"]) {
            url.imageType = JPGRemoteImage;
            [request setValue:kJpgRangeValue forHTTPHeaderField:@"Range"];
        }
        if ([[imgURL pathExtension] hasSuffix:@"png"]) {
            url.imageType = PNGRemoteImage;
            [request setValue:kPngRangeValue forHTTPHeaderField:@"Range"];
        }
    }else
    {
        NSLog(@"not support resume download");
        url.imageType = NoneRemoteImage;
    }
    
    [request setValue:@"bytes=0-9" forHTTPHeaderField:@"Range"];

//    NSURLConnection* conn = [NSURLConnection connectionWithRequest:request delegate:imgURL];
//    [conn scheduleInRunLoop: [NSRunLoop mainRunLoop] forMode: NSDefaultRunLoopMode];
//    [conn start];
//    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        switch (url.imageType) {
            case PNGRemoteImage:
            {
                CGSize size = [[self class] PNGImageSizeWithRangeHeader:data];
                NSLog(@"png image size : %@", NSStringFromCGSize(size));
            }
                break;
                
            case JPGRemoteImage:
            {
                CGSize size = [[self class] JPGImageSizeWithRangeHeader:data];
                NSLog(@"jpg image size : %@", NSStringFromCGSize(size));
            }
                break;
                
            case GIFRemoteImage:
            {
                CGSize size = [[self class] GIFImageSizeWithRangeHeader:data];
                NSLog(@"gif image size : %@", NSStringFromCGSize(size));
            }
                break;
            case NoneRemoteImage:
            {
                UIImage *image = [UIImage imageWithData:data];
                NSLog(@"no header image size : %@", NSStringFromCGSize(image.size));
            }
                break;
            default:
                break;
        }
        //data 即是图片的数据头
    }];
   

}

+ (BOOL)checkSupportResume:(NSURL*)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"HEAD";//0-9 range
    [request setValue:@"bytes=0-9" forHTTPHeaderField:@"Range"];

    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSHTTPURLResponse *resp = (NSHTTPURLResponse*)response;
    //        NSLog(@"resp%@", [resp allHeaderFields]);
    //        NSLog(@"文件长度-%lld",response.expectedContentLength);
    BOOL support =  resp.statusCode ==206?YES:NO;
    
    return support;
}

//+(NSString*)checkImageType:(NSURL*)url{
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"GET";
//    __block NSString *string;
//    [request setValue:@"bytes=0-2" forHTTPHeaderField:@"Range"];
//    
//    
//    NSURLResponse *response;
//    NSData *data= [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//    //        NSLog(@"resp%@", [resp allHeaderFields]);
//    //        NSLog(@"文件长度-%lld",response.expectedContentLength);
//    
//    string = [self contentTypeForImageData:data];
//    NSLog(@"string%@",string);
//    return string;
//}
////Parse metadata
//const unsigned char* cString = [receivedData bytes];
//const NSInteger length = [receivedData length];
//
//const char pngSignature[8] = {137, 80, 78, 71, 13, 10, 26, 10};
//const char bmpSignature[2] = {66, 77};
//const char gifSignature[2] = {71, 73};
//const char jpgSignature[2] = {255, 216};
//
//if(!self.sizeRequestType )
//{
//    if( memcmp(pngSignature, cString, 8) == 0 )
//    {
//        self.sizeRequestType = @"PNG";
//    }
//    else if( memcmp(bmpSignature, cString, 2) == 0 )
//    {
//        self.sizeRequestType = @"BMP";
//    }
//    else if( memcmp(jpgSignature, cString, 2) == 0 )
//    {
//        self.sizeRequestType = @"JPG";
//    }
//    else if( memcmp(gifSignature, cString, 2) == 0 )
//    {
//        self.sizeRequestType = @"GIF";
//    }
//}
@end
