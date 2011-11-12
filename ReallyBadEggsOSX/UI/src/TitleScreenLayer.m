#import "TitleScreenLayer.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"
#import "Pad.h"
#import "Settings.h"
#import "CCDirector.h"
#import "GameLayer.h"

@implementation TitleScreenLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TitleScreenLayer *layer = [TitleScreenLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if ((self = [super init])) {
		
		sranddev();
		
		self.isKeyboardEnabled = YES;
		
		[self loadBackground];
		[self loadSounds];
	}
	return self;
}

- (void)loadSounds {
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"title.mp3"];
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"title.mp3"];
}

- (void)loadBackground {
	int x = [[CCDirector sharedDirector] winSize].width / 2;
	int y = [[CCDirector sharedDirector] winSize].height / 2;
	
	CCSprite* title = [CCSprite spriteWithFile:@"title.png"];
	title.position = ccp(x, y);
	[title.texture setAliasTexParameters];
	[self addChild:title z:0];
}

- (BOOL)ccKeyUp:(NSEvent*)event {
	
	// Jump to menu system
	[[CCDirector sharedDirector] replaceScene: [GameLayer scene]];
	
	return YES;
}

@end
