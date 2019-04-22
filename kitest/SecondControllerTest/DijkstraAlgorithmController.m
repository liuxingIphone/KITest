//
//  DijkstraAlgorithmController.m
//  kitest
//
//  Created by Huamo on 2017/12/18.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "DijkstraAlgorithmController.h"

@interface DijkstraAlgorithmController ()

@end

@implementation DijkstraAlgorithmController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Dijkstra算法";
    
    [DijkstraAlgorithmController findShortestRoad];
}


+ (void)findShortestRoad{
    
    NSArray *allPath = @[@[@"0", @"1", @"12", @"9999", @"9999", @"9999"]
                         ,@[@"9999", @"0", @"9", @"3", @"9999", @"9999"]
                         ,@[@"9999", @"9999", @"0", @"9999", @"5", @"9999"]
                         ,@[@"9999", @"9999", @"4", @"0", @"13", @"15"]
                         ,@[@"9999", @"9999", @"9999", @"9999", @"0", @"4"]
                         ,@[@"9999", @"9999", @"9999", @"9999", @"9999", @"0"]];
    
    NSMutableArray *disArray = [[NSMutableArray alloc]initWithCapacity:allPath.count];
    for (NSInteger i=0; i<allPath.count; i++) {
        disArray[i] = allPath[0][i];
    }
    //NSLog(@"-----%@", disArray);
    
    NSMutableArray *bookArray = [[NSMutableArray alloc]initWithCapacity:allPath.count];
    for (NSInteger i=0; i<allPath.count; i++) {
        bookArray[i] = @"0";
    }
    
    bookArray[0] = @"1";
    
    NSInteger u=-1,min;
    for (NSInteger i=0; i<=allPath.count-2; i++) {
        min = 9999;
        
        for (NSInteger j=0; j<=allPath.count-1; j++) {
            if ([bookArray[j] integerValue]==0 && [disArray[j] integerValue]<min) {
                min = [disArray[j] integerValue];
                u = j;
            }
        }
        
        bookArray[u] = @"1";
        for (NSInteger v = 0; v<=allPath.count-1; v++) {
            if ([allPath[u][v] integerValue] < 9999) {
                if ([disArray[v] integerValue] > [disArray[u] integerValue] + [allPath[u][v] integerValue]) {
                    disArray[v] = [NSString stringWithFormat:@"%ld", [disArray[u] integerValue] + [allPath[u][v] integerValue]];
                }
            }
        }
    }
    
    NSLog(@"%@", disArray);
    NSLog(@"%@", bookArray);
    
}



+ (void)findShortestRoad_Floyd{
    
    int e[6][6] = {{0,1,12,100,100,100},
        {100,0,9,3,100,100},
        {100,100,0,100,5,100},
        {100,100,4,0,13,15},
        {100,100,100,100,0,4},
        {100,100,100,100,100,0}
    };
    
    NSInteger n = 6;
    NSInteger k=0,i=0,j=0;
    
    
    for(k=0;k<=n-1;k++)
        for(i=0;i<=n-1;i++)
            for(j=0;j<=n-1;j++)
                if(e[i][j]>e[i][k]+e[k][j] )
                    e[i][j]=e[i][k]+e[k][j];
    
    
    
    for(i=0;i<=n-1;i++){
        for(j=0;j<=n-1;j++){
            if (i==0 && j==n-1) {
                printf("%10d",e[i][j]);
            }
        }
    }
    
}





@end
