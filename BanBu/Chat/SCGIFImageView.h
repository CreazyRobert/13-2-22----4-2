//
//  SCGIFImageView.h
//  TestGIF
//
//  Created by shichangone on 11-7-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
@interface AnimatedGifFrame : NSObject
{
	NSData *data;
	NSData *header;
	double delay;
	int disposalMethod;
	CGRect area;
}

@property (nonatomic, copy) NSData *header;
@property (nonatomic, copy) NSData *data;
@property (nonatomic) double delay;
@property (nonatomic) int disposalMethod;
@property (nonatomic) CGRect area;

@end

@interface SCGIFImageView : UIImageView <SDImageCacheDelegate,SDWebImageManagerDelegate> {
	NSData *GIF_pointer;
	NSMutableData *GIF_buffer;
	NSMutableData *GIF_screen;
	NSMutableData *GIF_global;
	NSMutableArray *GIF_frames;
	
	int GIF_sorted;
	int GIF_colorS;
	int GIF_colorC;
	int GIF_colorF;
	int animatedGifDelay;
	
	int dataPointer;
    
    NSString *URL;
    BOOL isLoading;
    SDWebImageManager *manager;
}
@property (nonatomic, retain) NSMutableArray *GIF_frames;
@property(nonatomic,retain)NSString *gifFile;
@property (nonatomic,retain)NSString *URL;
@property(nonatomic,retain)NSData *gifData;
@property (nonatomic,retain)SDWebImageManager *manager;
// 设定属性传入路径

-(void)setGifFile:(NSString *)gifFile;



- (id)initWithGIFFile:(NSString*)gifFilePath;
- (id)initWithGIFData:(NSData*)gifImageData;

- (void)loadImageData;

+ (NSMutableArray*)getGifFrames:(NSData*)gifImageData;
+ (BOOL)isGifImage:(NSData*)imageData;

- (void) decodeGIF:(NSData *)GIFData;
- (void) GIFReadExtensions;
- (void) GIFReadDescriptor;
- (bool) GIFGetBytes:(int)length;
- (bool) GIFSkipBytes: (int) length;
- (NSData*) getFrameAsDataAtIndex:(int)index;
- (UIImage*) getFrameAsImageAtIndex:(int)index;

#pragma 刘杨
-(void)initWithURL:(NSString *)string;
@end
