#import "BlockBase.h"

@interface NormalBlock : BlockBase {

}

- (void)connect:(BlockBase*)top right:(BlockBase*)right bottom:(BlockBase*)bottom left:(BlockBase*)left;

@end
