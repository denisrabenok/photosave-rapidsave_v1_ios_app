//
//  Constant.m
//  PhotoSave
//
//  Created by Ritesh Arora on 5/2/17.
//  Copyright © 2017 RiteshArora. All rights reserved.
//

#import "Constant.h"

@implementation Constant


-(void)GetInstaImageOrVideoFile
{
    
    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"62b2ce6e-70c7-7c63-8905-d47a10b05677" };
    NSArray *parameters = @[ @{ @"name": @"down", @"value": @"https://instagram.com/p/BTgkrR6hxBV/" } ];
    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
    
    NSError *error;
    NSMutableString *body = [NSMutableString string];
    for (NSDictionary *param in parameters) {
        [body appendFormat:@"--%@\r\n", boundary];
        if (param[@"fileName"]) {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
            [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
            [body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
            if (error) {
                NSLog(@"%@", error);
            }
        } else {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
            [body appendFormat:@"%@", param[@"value"]];
        }
    }
    [body appendFormat:@"\r\n--%@--\r\n", boundary];
    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://112.196.17.27:8088/instagram/process.php"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:50.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        const void *buffer = NULL;
                                                        size_t size = 0;
                                                        dispatch_data_t new_data_file = dispatch_data_create_map(data, &buffer, &size);
                                                        if(new_data_file){ /* to avoid warning really - since dispatch_data_create_map demands we care about the return arg */}
                                                        
                                                        NSData *nsdata = [[NSData alloc] initWithBytes:buffer length:size];
                                                        NSString *str = [[NSString alloc] initWithData:nsdata encoding:NSUTF8StringEncoding];
                                                        
//                                                        UIImage *image = [UIImage imageWithData:nsdata];
//                                                        imagePreview.image = image;
                                                        
                                                    }
                                                }];
    [dataTask resume];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //    [responseData appendData:data];
    
    const void *buffer = NULL;
    size_t size = 0;
    dispatch_data_t new_data_file = dispatch_data_create_map(data, &buffer, &size);
    if(new_data_file){ /* to avoid warning really - since dispatch_data_create_map demands we care about the return arg */}
    
    NSData *nsdata = [[NSData alloc] initWithBytes:buffer length:size];
    NSString *str = [[NSString alloc] initWithData:nsdata encoding:NSUTF8StringEncoding];
    
//    UIImage *image = [UIImage imageWithData:nsdata];
//    imagePreview.image = image;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}


@end
