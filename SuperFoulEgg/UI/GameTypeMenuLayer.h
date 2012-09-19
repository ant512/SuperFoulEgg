#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "MenuRectLayer.h"
#import "MenuControlsLayer.h"

@interface GameTypeMenuLayer : CCLayer {
	MenuRectLayer *_rectLayer;
	MenuControlsLayer *_controlsLayer;
	NSMutableArray *_options;
	NSString *_title;
}

@property (readwrite, retain, nonatomic) NSString *title;

+ (CCScene*)scene;
- (id)init;
- (void)loadBackground;
- (void)addOption:(NSString *)option;

@end
