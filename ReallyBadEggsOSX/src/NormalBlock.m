#import "NormalBlock.h"

@implementation NormalBlock

- (void)connect:(BlockBase*)top right:(BlockBase*)right bottom:(BlockBase*)bottom left:(BlockBase*)left {
	
	BOOL topSet = top != NULL && [top class] == [self class] && [top isConnectable];
	BOOL rightSet = right != NULL && [right class] == [self class] && [top isConnectable];
	BOOL bottomSet = bottom != NULL && [bottom class] == [self class] && [top isConnectable];
	BOOL leftSet = left != NULL && [left class] == [self class] && [top isConnectable];
	
	[self setConnectionTop:topSet right:rightSet bottom:bottomSet left:leftSet];
}

@end
