//
//  ViewController.m
//  NSOperationSimple
//
//  Created by Budhathoki,Bipin on 7/17/15.
//  Copyright (c) 2015 Budhathoki,Bipin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self startPrintingGCD_sync];
    
}


-(void)dispatchAsync {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSLog(@"First Log");
        
    });
    
    NSLog(@"Second Log");
}

-(void)dispatchSync {
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSLog(@"First Log");
        
    });
    
    NSLog(@"Second Log");
}

-(void)startPrintingGCD{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self printCount];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self printName];
    });
    
    //update ui on main queue
    dispatch_async(dispatch_get_main_queue(), ^(void){
       //update your ui here
    });
}

-(void)startPrintingGCD_sync{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self printCount];
    });
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self printName];
    });
    
    //update ui on main queue
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //update your ui here
    });
}

-(void)startPrinting
{
    //First we have to create the invocation operation.
    NSInvocationOperation *countingOp = [[NSInvocationOperation alloc] initWithTarget:self
                                                                             selector:@selector(printCount)
                                                                               object:nil];
    
    NSInvocationOperation *nameOp = [[NSInvocationOperation alloc] initWithTarget:self
                                                                         selector:@selector(printName)
                                                                           object:nil];
    
    countingOp.completionBlock = ^(void){
        NSLog(@"All numbers Printed");
    };
    
    //count is printed before name.
    //[nameOp addDependency:countingOp];
    
    
    NSOperationQueue *theQueue = [[NSOperationQueue alloc] init];
    theQueue.name = @"Counting Queue";
    [theQueue addOperations:@[countingOp, nameOp] waitUntilFinished:NO];
    
    [theQueue addOperationWithBlock:^(void){
        for(int i=1; i<10; i ++){
            NSLog(@"%s", "XXXXXXXX");
        }
    }];
    //[theQueue addOperation:nameOp];
    //[theQueue addOperation:countingOp];
}

-(void)printCount
{
    for(int i = 1; i <= 10; i++)
    {
        NSLog(@"%d", i);
    }
}

-(void)printName
{
    for(int i = 1; i <= 10; i++)
    {
        NSLog(@"Sakura Kinomoto");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
