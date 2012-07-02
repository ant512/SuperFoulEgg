#import "MainMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"
#import "Pad.h"
#import "Settings.h"
#import "CCDirector.h"
#import "GameLayer.h"
#import "RectLayer.h"

const int SZShadowOffset = 5;

@implementation MainMenuLayer

+ (CCScene *)scene {
	
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenuLayer *layer = [MainMenuLayer node];
	
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}

- (id)init {
	
	if ((self = [super init])) {
		self.isKeyboardEnabled = YES;
		
		[self loadBackground];
		
		RectLayer *rect = [[RectLayer alloc] init];
		[rect.rectangles addObject:[NSValue valueWithRect:CGRectMake(300, 320, 300, 150)]];

		[self addChild:rect];
		
		[self addCentredShadowedLabelWithString:@"Game Type" atY:self.boundingBox.size.height - 100];
		[self addCentredShadowedLabelWithString:@"Practice" atY:self.boundingBox.size.height - 300];
		[self addCentredShadowedLabelWithString:@"Easy" atY:self.boundingBox.size.height - 380];
		[self addCentredShadowedLabelWithString:@"Medium" atY:self.boundingBox.size.height - 460];
		[self addCentredShadowedLabelWithString:@"Hard" atY:self.boundingBox.size.height - 540];
		[self addCentredShadowedLabelWithString:@"2 Player" atY:self.boundingBox.size.height - 620];
	}
	return self;
}

- (void)addCentredShadowedLabelWithString:(NSString *)text atY:(CGFloat)y {
	CCLabelTTF *shadow = [CCLabelTTF labelWithString:text fontName:@"Lucida Grande" fontSize:50];
	CCLabelTTF *label = [CCLabelTTF labelWithString:text fontName:@"Lucida Grande" fontSize:50];
	
	shadow.position = CGPointMake((self.boundingBox.size.width / 2) - SZShadowOffset, y - SZShadowOffset);
	
	ccColor3B color;
	color.b = 0;
	color.g = 0;
	color.r = 0;
	
	shadow.color = color;
	shadow.opacity = 192;
	
	label.position = CGPointMake(self.boundingBox.size.width / 2, y);
	
	[self addChild:shadow];
	[self addChild:label];
}

- (void)loadBackground {
	int x = [[CCDirector sharedDirector] winSize].width / 2;
	int y = [[CCDirector sharedDirector] winSize].height / 2;
	
	CCSprite* background = [CCSprite spriteWithFile:@"menubackground.png"];
	background.position = ccp(x, y);
	[background.texture setAliasTexParameters];
	[self addChild:background z:0];
}

- (BOOL)ccKeyUp:(NSEvent*)event {
	
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic]; 
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[GameLayer scene]]];
	
	return YES;
}

@end
