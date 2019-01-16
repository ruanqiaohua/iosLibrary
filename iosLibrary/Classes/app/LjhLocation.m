//
//  LjhLocation.m
//  iosLibrary
//
//  Created by liu on 2018/10/15.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "LjhLocation.h"
#import <CoreLocation/CoreLocation.h>

@interface LjhLocation()<CLLocationManagerDelegate>
{
    CLLocationManager   * locationmanager;
}
@end

@implementation LjhLocation

singleton_implementation(LjhLocation)

-(void)reqLocation
{
    if ([CLLocationManager locationServicesEnabled])
    {
        locationmanager = [[CLLocationManager alloc]init];
        locationmanager.delegate = self;
        [locationmanager requestAlwaysAuthorization];
        [locationmanager requestWhenInUseAuthorization];
        //设置寻址精度
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        locationmanager.distanceFilter = 5.0;
        [locationmanager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.delegate)
    {
        [self.delegate ljhLocation:self isSuccess:NO];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [locationmanager stopUpdatingHeading];
    //旧址
    CLLocation * currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc]init];
    //打印当前的经度与纬度
    self.latitude = currentLocation.coordinate.latitude;
    self.longitude = currentLocation.coordinate.longitude;
    //NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    //反地理编码
    WEAKOBJ(self);
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
    {
        if (placemarks.count > 0)
        {
            CLPlacemark * placeMark = placemarks[0];
            weak_self.country = placeMark.country;
            weak_self.city = placeMark.locality;
            weak_self.locality = placeMark.subLocality;
            weak_self.address = placeMark.name;
            if (weak_self.delegate)
            {
                [weak_self.delegate ljhLocation:weak_self isSuccess:YES];
                return;
            }
        }
        [weak_self.delegate ljhLocation:weak_self isSuccess:NO];
    }];

}

@end
