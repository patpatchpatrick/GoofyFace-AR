//
//  ShaderModifiers.m
//  WeirdFace
//
//  Created by Patrick Doyle on 7/22/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ShaderModifiers.h"

@implementation ShaderModifier

- (void) someMethod {
    NSLog(@"SomeMethod Ran");
   // [myMaterial setValue:@1.0 forKeyPath:@"mixLevel"];
}

@end

/*
 
 CODE TO USE IN SWIFT IF YOU NEED TO ACCESS OBJ - C Object
 var instanceOfCustomObject: ShaderModifier = ShaderModifier()
 instanceOfCustomObject.someProperty = "Hello World"
 print(instanceOfCustomObject.someProperty)
 instanceOfCustomObject.someMethod() */
