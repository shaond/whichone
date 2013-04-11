//
//  Authenticator.m
//  likedislike
//
//  Created by Herbert Yeung on 3/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MobileAuthenticator.h"

@implementation MobileAuthenticator

-(NSString *) simpleValidate: (NSString *) mobileNumber {    

    NSMutableString *mobileNumberFormatted = [NSMutableString stringWithCapacity:mobileNumber.length];
    
    //Remove all non numeric characters
    NSScanner *scanner = [NSScanner scannerWithString:mobileNumber];
    NSCharacterSet *allowedChars = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:allowedChars intoString:&buffer]) {
            [mobileNumberFormatted appendString:buffer];     
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    // Check country you are currently in
    NSLocale* currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString* countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    // Based on ISO Standard ISO-3166 http://en.wikipedia.org/wiki/ISO_3166-1
    if([countryCode isEqualToString: @"AU"]) {
        if([mobileNumber hasPrefix:@"+61"]){
            return [@"00" stringByAppendingString:mobileNumberFormatted];
        }
        else if(mobileNumberFormatted.length == 10) { 
            return [@"0061" stringByAppendingString:[mobileNumberFormatted substringFromIndex:1]];            
        }
        else {
            NSLog(@"Possibly entered in area code as part of mobile number - AU");
        }
    }
    else if([countryCode isEqualToString: @"NZ"]) {
        //Refer to: http://en.wikipedia.org/wiki/Telephone_numbers_in_New_Zealand#Mobile_Phones
        if([mobileNumber hasPrefix:@"+64"]){
            return [@"00" stringByAppendingString:mobileNumberFormatted];
        }
        else if([mobileNumber hasPrefix:@"02"]) { 
            return [@"0064" stringByAppendingString:[mobileNumberFormatted substringFromIndex:1]];            
        }
        else {
            NSLog(@"Wrong interpretation of area code - NZ");
        }
    }
    else if([countryCode isEqualToString: @"US"] || [countryCode isEqualToString: @"CA"]) {
        /*In US phone numbers consist of 3-digit area code (123) plus a seven digit number. In some parts of the country you have to dial all 10 digits for a local call. 
         In other parts you only have to dial the 7 digit number. If dialing outside of your area you have to put a '1' at the very beginning.*/
        if (mobileNumberFormatted.length == 10) {
            return [@"001" stringByAppendingString:mobileNumberFormatted];            
        }
        else if (mobileNumberFormatted.length == 11) {
            return [@"00" stringByAppendingString:mobileNumberFormatted]; 
        }
        else if (mobileNumberFormatted.length == 7) {
            NSLog(@"No 3 digit area code was given - US/CA");
        }
    }
    else if([countryCode isEqualToString: @"IN"]) {
        if (mobileNumberFormatted.length == 10) {
            return [@"0091" stringByAppendingString:mobileNumberFormatted];            
        }
        else if (mobileNumberFormatted.length == 11 && [mobileNumber hasPrefix:@"0"]) {
            return [@"0091" stringByAppendingString:[mobileNumberFormatted substringFromIndex:1]];            
        }
        else if ([mobileNumber hasPrefix:@"+91"]) {
            return [@"00" stringByAppendingString:mobileNumberFormatted];            
        }

    }
    else if([countryCode isEqualToString: @"GB"]) {
        if (mobileNumberFormatted.length == 11 && [mobileNumberFormatted hasPrefix:@"07"]) {
            return [@"0044" stringByAppendingString:[mobileNumberFormatted substringFromIndex:1]];            
        }
        else if (mobileNumberFormatted.length == 10 && [mobileNumberFormatted hasPrefix:@"7"]) {
            return [@"0044" stringByAppendingString:mobileNumberFormatted];            
        }
        else if ([mobileNumber hasPrefix:@"+44"]) {
            return [@"00" stringByAppendingString:mobileNumberFormatted];            
        }
    }
    else if([countryCode isEqualToString: @"IE"]) {
        if ([mobileNumberFormatted hasPrefix:@"08"]) {
            return [@"00353" stringByAppendingString:[mobileNumberFormatted substringFromIndex:1]];            
        }
    }
    
    return nil;
}

-(NSString*) getPINValue: (NSString *) mobileNumber {
    // Check mobile number is correct format (remove plus symbols and check locale)
    mobileNumber = [self simpleValidate:mobileNumber];
    
    if (!mobileNumber) {
        NSLog(@"No mobile number was entered");
        return @"Error";
    }
    
    // Create the URL from a string.
    NSURL *url = [NSURL URLWithString:[@"https://whichone.funkhq.com/add/phone/" stringByAppendingString:mobileNumber]];
    
    // Create a request object using the URL.
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Prepare for the response back from the server    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    // Send a synchronous request to the server (i.e. sit and wait for the response)
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check if an error occurred    
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        // Do something to handle/advise user.
        return @"Error";
    }
    
    // Convert the response data to a string.
    NSString *responseString = [[NSString alloc] initWithData:responseData  encoding:NSUTF8StringEncoding];    
    // View the data returned - should be ready for parsing.
    NSLog(@"%@", responseString);
    [responseString release];
    
    return mobileNumber;
}

@end
