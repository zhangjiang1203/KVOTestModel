
#import "TestBlockViewController.h"
#import "BlockModelTest.h"


@interface TestBlockViewController ()

@end

@implementation TestBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BlockModelTest *test = [BlockModelTest new];
    NSLog(@"block data:%d",[test testBlockData:30]);
}
@end
