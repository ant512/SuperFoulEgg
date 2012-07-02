#import "SZPoint.h"

@implementation SZPoint

@synthesize x = _x;
@synthesize y = _y;

- (id)initWithX:(int)x y:(int)y {
	if ((self = [super init])) {
		_x = x;
		_y = y;
	}

	return self;
}

@end
