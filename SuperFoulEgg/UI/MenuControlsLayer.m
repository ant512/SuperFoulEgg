#import "MenuControlsLayer.h"
#import "Constants.h"
#import "Settings.h"

@implementation MenuControlsLayer

- (id)init {
	if ((self = [super init])) {
		int y = 600;
		int sub = 60;
		
		NSArray *strings = @[
		@"Menu Controls",
		[NSString stringWithFormat:@"Left: %@", [self stringFromKey:[Settings sharedSettings].keyCodeTwoLeft]],
		[NSString stringWithFormat:@"Right: %@", [self stringFromKey:[Settings sharedSettings].keyCodeTwoRight]],
		[NSString stringWithFormat:@"Up: %@", [self stringFromKey:[Settings sharedSettings].keyCodeTwoUp]],
		[NSString stringWithFormat:@"Down: %@", [self stringFromKey:[Settings sharedSettings].keyCodeTwoDown]],
		[NSString stringWithFormat:@"Next: %@", [self stringFromKey:[Settings sharedSettings].keyCodeTwoA]],
		[NSString stringWithFormat:@"Back: %@", [self stringFromKey:[Settings sharedSettings].keyCodeTwoB]],
		@"Change controls in Preferences menu"
		];
		
		for (NSString *string in strings) {
			[self addCentredShadowedLabelWithString:string atY:y];
			y -= sub;
		}
	}
	
	return self;
}

- (NSString *)stringFromKey:(unichar)key {
	switch (key) {
		case DEFAULT_KEY_CODE_TWO_LEFT:
			return @"Cursor Left";
		case DEFAULT_KEY_CODE_TWO_RIGHT:
			return @"Cursor Right";
		case DEFAULT_KEY_CODE_TWO_UP:
			return @"Cursor Up";
		case DEFAULT_KEY_CODE_TWO_DOWN:
			return @"Cursor Down";
		default:
			return [NSString stringWithCharacters:(unichar [1]){ key } length:1];
	}
	
	return nil;
}

- (void)addCentredShadowedLabelWithString:(NSString *)text atY:(CGFloat)y {
	CCLabelBMFont *shadow = [CCLabelBMFont labelWithString:text fntFile:@"font.fnt"];
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:text fntFile:@"font.fnt"];
	
	[shadow.texture setAliasTexParameters];
	[label.texture setAliasTexParameters];
	
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

- (void)draw {
    glEnable(GL_LINE_SMOOTH);
    glColor4ub(255, 255, 255, 255);
    glLineWidth(1);
	
	CGRect rect = CGRectMake(100, 630, 760, -480);
	
	ccColor4F colour = ccc4f(0, 0, 0, 0.9);
	
	ccDrawRect(rect.origin, ccp(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height));
			
	ccDrawSolidRect(rect.origin, ccp(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height), colour);
}

@end
