//
//  VehicleDataManager.m
//  JumpstartObjc1Homework
//
//  Created by James Derry on 2/1/14.
//  Copyright (c) 2014 James Derry. All rights reserved.
//

#import "VehicleDataManager.h"

#define kWebServiceBaseUrl @"http://www.fueleconomy.gov"

@interface VehicleDataManager ()
{
    NSXMLParser *parser;
    NSString *currentElement;
}

@end


@implementation VehicleDataManager

- (id)init
{
    self = [super init];
    if (self) {
        //initialize
        currentElement = nil;
    }
    return self;
}

#pragma mark Our Methods

- (void)vehicleModels
{
    // fueleconomy.gov web service endpoint returns all 2014 vehicle models
    NSString *endpoint = @"/ws/rest/vehicle/menu/make?year=2014";
    
    /* sample results returned:
     
     <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
     <menuItems>
        <menuItem>
            <text>Acura</text>
            <value>Acura</value>
        </menuItem>
        <menuItem>
            <text>Aston Martin</text>
            <value>Aston Martin</value>
        </menuItem>
     </menuItems>
     
    */
    
    NSString *modelsUrl = [NSString stringWithFormat:@"%@%@", kWebServiceBaseUrl, endpoint];
    
    [self carDataFromWebServiceWithUrl:modelsUrl];
    
}

- (void)carDataFromWebServiceWithUrl:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    parser.delegate = self;  //if you forget this no data returned
    
    [parser parse]; //hit web service and start parsing xml returned
}

#pragma mark NSXMLParserDelegate Methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    currentElement = [NSString stringWithString:elementName];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // we only care about the text element
    if ([[currentElement lowercaseString] isEqualToString:@"text"]) {
        NSLog(@"%@", string);
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
}

@end
