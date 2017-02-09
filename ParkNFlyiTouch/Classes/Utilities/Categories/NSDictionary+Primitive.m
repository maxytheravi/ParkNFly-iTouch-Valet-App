//
//    Copyright (c) 2012 Norman Basham
//    http://www.apache.org/licenses/LICENSE-2.0
//

#import "NSDictionary+Primitive.h"

@implementation NSDictionary (Primitive)

-(BOOL)hasKey:(NSString*)key {
    NSObject* o = self[key];
    BOOL has = o != nil;
    return has;
}

-(BOOL)boolForKey:(NSString*)key {
    BOOL i = [self[key] boolValue];
    return i;
}

-(int)intForKey:(NSString*)key {
    int i = [self[key] intValue];
    return i;
}

- (NSInteger) integerForKey:(NSString *)key {
    NSInteger i = [self[key] integerValue];
    return i;
}

- (NSUInteger) unsignedIntegerForKey:(NSString *)key {
    NSUInteger i = [self[key] unsignedIntegerValue];
    return i;
}

- (CGFloat) cgFloatForKey:(NSString *)key {
    CGFloat f = [self[key] doubleValue];
    return f;
}

-(int)charForKey:(NSString*)key {
    char i = [self[key] charValue];
    return i;
}

-(float)floatForKey:(NSString*)key {
    float i = [self[key] floatValue];
    return i;
}

-(CGPoint)pointForKey:(NSString*)key {
    CGPoint o = CGPointFromString(self[key]);
    return o;
}

-(CGSize)sizeForKey:(NSString*)key {
    CGSize o = CGSizeFromString(self[key]);
    return o;
}

-(CGRect)rectForKey:(NSString*)key {
    CGRect o = CGRectFromString(self[key]);
    return o;
}

#pragma mark - Custom Methods
- (NSString *)getInnerTextForKey:(NSString *)key
{
    id obj = [self getObjectFromDictionaryWithKeys:@[key]];
    if ([obj isKindOfClass:[NSDictionary class]] && [obj hasKey:@"innerText"]) {
        return [obj getStringFromDictionaryWithKeys:@[@"innerText"]];
    }
    
    return @"";
}

- (NSString *)getAttributedDataForKey:(NSString *)key
{
    id obj = [self getObjectFromDictionaryWithKeys:@[key]];
    if ([obj isKindOfClass:[NSDictionary class]] && [obj hasKey:@"attributedData"]) {
        return @"";//[obj getStringFromDictionaryWithKeys:@[@"attributedData",@"i:nil"]];
    }
    
    return @"";
}

- (NSString *)getStringFromDictionaryWithKeys:(NSArray *)keysArr
{
    id obj = [self getObjectFromDictionaryWithKeys:keysArr];
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    } else if ([obj isKindOfClass:[NSDictionary class]] && [obj hasKey:@"innerText"]) {
        return [obj getStringFromDictionaryWithKeys:@[@"innerText"]];
    } else if ([obj isKindOfClass:[NSDictionary class]] && [obj hasKey:@"attributedData"]) {
        return [obj getStringFromDictionaryWithKeys:@[@"attributedData"]];
    } else if ([obj isKindOfClass:[NSDictionary class]] && [obj hasKey:@"i:nil"]) {
        return @"";//[obj getStringFromDictionaryWithKeys:@[@"i:nil"]];
    }
    
    return @"";
}

- (NSInteger)getIntegerFromDictionaryWithKeys:(NSArray *)keysArr
{
    id obj = [self getObjectFromDictionaryWithKeys:keysArr];
    if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) {
        return [obj integerValue];
    } else if ([obj isKindOfClass:[NSDictionary class]] && [obj hasKey:@"innerText"]) {
        return [obj getIntegerFromDictionaryWithKeys:@[@"innerText"]];
    }
    
    return 0;
}

- (BOOL)getBoolFromDictionaryWithKeys:(NSArray *)keysArr
{
    id obj = [self getStringFromDictionaryWithKeys:keysArr];
    if ([obj isEqualToString:@"true"]) {
        return TRUE;
    }
    
    return 0;
}

- (double)getDoubleFromDictionaryWithKeys:(NSArray *)keysArr
{
    id obj = [self getObjectFromDictionaryWithKeys:keysArr];
    if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) {
        return [obj doubleValue];
    } else if ([obj isKindOfClass:[NSDictionary class]] && [obj hasKey:@"innerText"]) {
        return [obj getDoubleFromDictionaryWithKeys:@[@"innerText"]];
    }
    
    return 0;
}

- (id)getObjectFromDictionaryWithKeys:(NSArray *)keysArr
{
    __block id object = self;
    [keysArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]] && ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSMutableDictionary class]])) {
            object = [object valueForKey:obj];
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSMutableString class]]) {
                object = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
        } else if ([obj isKindOfClass:[NSNumber class]] && ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSMutableArray class]]) && [object count] > [obj integerValue]) {
            object = object[[obj integerValue]];
        } else {
            object = nil;
        }
    }];
    
    return object;
}

@end

@implementation NSMutableDictionary(Primitive)

-(void)setBool:(BOOL)i forKey:(NSString*)key {
    self[key] = @(i);
}

-(void)setInt:(int)i forKey:(NSString*)key {
    self[key] = @(i);
}

-(void)setInteger:(NSInteger)i forKey:(NSString *)key {
    self[key] = @(i);
}

-(void)setUnsignedInteger:(NSUInteger)i forKey:(NSString *)key {
    self[key] = @(i);
}

-(void)setCGFloat:(CGFloat)f forKey:(NSString *)key {
    self[key] = @(f);
}

-(void)setChar:(char)c forKey:(NSString*)key {
    self[key] = @(c);
}

-(void)setFloat:(float)i forKey:(NSString*)key {
    self[key] = @(i);
}

-(void)setPoint:(CGPoint)o forKey:(NSString*)key{
    self[key] = NSStringFromCGPoint(o);
}

-(void)setSize:(CGSize)o forKey:(NSString*)key {
    self[key] = NSStringFromCGSize(o);
}

-(void)setRect:(CGRect)o forKey:(NSString*)key {
    self[key] = NSStringFromCGRect(o);
}

#pragma mark - Custom Methods
- (NSString *)getInnerTextForKey:(NSString *)key
{
    id obj = [self getObjectFromDictionaryWithKeys:@[key]];
    if ([obj isKindOfClass:[NSDictionary class]] && [obj hasKey:@"innerText"]) {
        return [obj getStringFromDictionaryWithKeys:@[@"innerText"]];
    }
    
    return @"";
}

- (NSString *)getAttributedDataForKey:(NSString *)key
{
    id obj = [self getObjectFromDictionaryWithKeys:@[key]];
    if ([obj isKindOfClass:[NSDictionary class]] && [obj hasKey:@"attributedData"]) {
        return @"";//[obj getStringFromDictionaryWithKeys:@[@"attributedData",@"i:nil"]];
    }
    
    return @"";
}

- (NSString *)getStringFromDictionaryWithKeys:(NSArray *)keysArr
{
    id obj = [self getObjectFromDictionaryWithKeys:keysArr];
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    } else if ([obj isKindOfClass:[NSDictionary class]] && [obj hasKey:@"innerText"]) {
        return [obj getStringFromDictionaryWithKeys:@[@"innerText"]];
    } else if ([obj isKindOfClass:[NSDictionary class]] && [obj hasKey:@"attributedData"]) {
        return [obj getStringFromDictionaryWithKeys:@[@"attributedData"]];
    } else if ([obj isKindOfClass:[NSDictionary class]] && [obj hasKey:@"i:nil"]) {
        return @"";//[obj getStringFromDictionaryWithKeys:@[@"i:nil"]];
    }
    
    return @"";
}

- (NSInteger)getIntegerFromDictionaryWithKeys:(NSArray *)keysArr
{
    id obj = [self getObjectFromDictionaryWithKeys:keysArr];
    if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) {
        return [obj integerValue];
    } else if ([obj isKindOfClass:[NSDictionary class]] && [obj hasKey:@"innerText"]) {
        return [obj getIntegerFromDictionaryWithKeys:@[@"innerText"]];
    }
    
    return 0;
}

- (BOOL)getBoolFromDictionaryWithKeys:(NSArray *)keysArr
{
    id obj = [self getStringFromDictionaryWithKeys:keysArr];
    if ([obj isEqualToString:@"true"]) {
        return TRUE;
    }
    
    return 0;
}

- (double)getDoubleFromDictionaryWithKeys:(NSArray *)keysArr
{
    id obj = [self getObjectFromDictionaryWithKeys:keysArr];
    if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) {
        return [obj doubleValue];
    } else if ([obj isKindOfClass:[NSDictionary class]] && [obj hasKey:@"innerText"]) {
        return [obj getDoubleFromDictionaryWithKeys:@[@"innerText"]];
    }
    
    return 0;
}

- (id)getObjectFromDictionaryWithKeys:(NSArray *)keysArr
{
    __block id object = self;
    [keysArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]] && ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSMutableDictionary class]])) {
            object = [object valueForKey:obj];
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSMutableString class]]) {
                object = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
        } else if ([obj isKindOfClass:[NSNumber class]] && ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSMutableArray class]]) && [object count] > [obj integerValue]) {
            object = object[[obj integerValue]];
        } else {
            object = nil;
        }
    }];
    
    return object;
}

@end
