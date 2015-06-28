//
//  Business.m
//  Yelp
//
//  Created by Allen Chiang on 6/25/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"

@interface Business()

- (NSString *)valueForKeyPathWithArrayIndex: (NSDictionary *)dictionary keyPath:(NSString *)keyPath index:(NSInteger)index;

@end

@implementation Business

- (NSString *)valueForKeyPathWithArrayIndex: (NSDictionary *)dictionary keyPath:(NSString *)keyPath index:(NSInteger)index {
    NSString *value = @"";
    NSArray *aItems = [dictionary valueForKeyPath:keyPath];
    if (aItems.count > 0) {
        value = aItems[0];
    }
    return value;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.imageUrl = dictionary[@"image_url"];
        self.numReviews = [dictionary[@"review_count"] integerValue];
        self.ratingImageUrl = dictionary[@"rating_img_url"];

        NSString *street = [self valueForKeyPathWithArrayIndex:dictionary keyPath:@"location.address" index:0];
        NSString *neighborhood = [self valueForKeyPathWithArrayIndex:dictionary keyPath:@"location.neighborhoods" index:0];
        self.address = [NSString stringWithFormat:@"%@, %@", street, neighborhood];
        
        float milesPerMeter = 0.000621371;
        self.distance = [dictionary[@"distance"] integerValue] * milesPerMeter;
        
        NSArray *categories = dictionary[@"categories"];
        NSMutableArray *categoryNames = [NSMutableArray array];
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categoryNames addObject:obj[0]];
        }];
        self.categories = [categoryNames componentsJoinedByString:@","];
    }
    return self;
}

+ (NSArray *)initBusinessesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *aBusinesses = [NSMutableArray array];
    for (NSDictionary *dict in dictionaries) {
        Business *bussiness = [[Business alloc] initWithDictionary:dict];
        [aBusinesses addObject:bussiness];
    }
    return aBusinesses;
}

@end
