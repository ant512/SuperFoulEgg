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

@synthesize title = _title;

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

- (void)addOption:(NSString *)option {
	
	int width = 340;
	int height = 80;
	
	int y = self.boundingBox.size.height - 300 - (80 * _options.count);
	int x = (self.boundingBox.size.width - width) / 2;
	
	[self addCentredShadowedLabelWithString:option atY:y];
	
	[_rectLayer.rectangles addObject:[NSValue valueWithRect:NSMakeRect(x, y - 40, width, height)]];
	[_options addObject:option];
}

- (id)init {
	
	if ((self = [super init])) {
		
		_options = [[NSMutableArray array] retain];
		_title = @"Game Type";
		
		[self loadBackground];
		
		_rectLayer = [[RectLayer alloc] init];
		[self addChild:_rectLayer];
		
		[self addCentredShadowedLabelWithString:_title atY:self.boundingBox.size.height - 100];
		
		[self addOption:@"Practice"];
		[self addOption:@"Easy"];
		[self addOption:@"Medium"];
		[self addOption:@"Hard"];
		[self addOption:@"2 Player"];
		
		self.isKeyboardEnabled = YES;
	}
	
	return self;
}

- (void)dealloc {
	[_options release];
	[_title release];
	[_rectLayer release];
	
	_options = nil;
	_title = nil;
	_rectLayer = nil;
	
	[super dealloc];
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

- (BOOL)ccKeyDown:(NSEvent*)event {
	
	NSString *character = [event characters];
    unichar keyCode = [character characterAtIndex:0];
	
	if (keyCode == [Settings sharedSettings].keyCodeTwoDown) [_rectLayer selectNext];
	if (keyCode == [Settings sharedSettings].keyCodeTwoUp) [_rectLayer selectPrevious];
	
	if (keyCode == [Settings sharedSettings].keyCodeTwoA || keyCode == [Settings sharedSettings].keyCodeTwoB) {
		switch (_rectLayer.selectedIndex) {
			case 0:
				[Settings sharedSettings].gameType = GamePracticeType;
				break;
			case 1:
				[Settings sharedSettings].gameType = GameSinglePlayerType;
				[Settings sharedSettings].aiType = AIEasyType;
				break;
			case 2:
				[Settings sharedSettings].gameType = GameSinglePlayerType;
				[Settings sharedSettings].aiType = AIMediumType;
				break;
			case 3:
				[Settings sharedSettings].gameType = GameSinglePlayerType;
				[Settings sharedSettings].aiType = AIHardType;
				break;
			case 4:
				[Settings sharedSettings].gameType = GameTwoPlayerType;
				break;
		}
		
		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic]; 
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameLayer scene]]];
	}
	
	return YES;
}

@end
