# NSString-HYPRelationshipParser

[![CI Status](http://img.shields.io/travis/hyperoslo/NSString-HYPRelationshipParser.svg?style=flat)](https://travis-ci.org/hyperoslo/NSString-HYPRelationshipParser)
[![Version](https://img.shields.io/cocoapods/v/NSString-HYPRelationshipParser.svg?style=flat)](http://cocoadocs.org/docsets/NSString-HYPRelationshipParser)
[![License](https://img.shields.io/cocoapods/l/NSString-HYPRelationshipParser.svg?style=flat)](http://cocoadocs.org/docsets/NSString-HYPRelationshipParser)
[![Platform](https://img.shields.io/cocoapods/p/NSString-HYPRelationshipParser.svg?style=flat)](http://cocoadocs.org/docsets/NSString-HYPRelationshipParser)

## Usage

```objc
#import "NSString+HYPRelationshipParser.h"
#import "HYPParsedRelationship.h"

- (HYPParsedRelationship *)hyp_parseRelationship;
```

## Example

```objc
HYPParsedRelationship *parsedRelationship = [@"name" hyp_parseRelationship];
/*
  parsedRelationship.attribute => @"name"
*/

HYPParsedRelationship *parsedRelationship = [@"company.name" hyp_parseRelationship];
/*
  parsedRelationship.relationship => @"company",
  parsedRelationship.to_many => NO,
  parsedRelationship.attribute => "name"
*/

HYPParsedRelationship *parsedRelationship = [@"employees[0].email" hyp_parseRelationship];
/*
  parsedRelationship.relationship => @"employees",
  parsedRelationship.index => 0,
  parsedRelationship.to_many => YES,
  parsedRelationship.attribute => @"email"
*/
```

## Installation

**NSString-HYPRelationshipParser** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

`pod 'NSString-HYPRelationshipParser'`

## Author

Hyper Interaktiv AS, ios@hyper.no

## License

**NSString-HYPRelationshipParser** is available under the MIT license. See the LICENSE file for more info.
