# NSDictionary-HYPNestedAttributes

[![CI Status](http://img.shields.io/travis/hyperoslo/NSDictionary-HYPNestedAttributes.svg?style=flat)](https://travis-ci.org/hyperoslo/NSDictionary-HYPNestedAttributes)
[![Version](https://img.shields.io/cocoapods/v/NSDictionary-HYPNestedAttributes.svg?style=flat)](http://cocoadocs.org/docsets/NSDictionary-HYPNestedAttributes)
[![License](https://img.shields.io/cocoapods/l/NSDictionary-HYPNestedAttributes.svg?style=flat)](http://cocoadocs.org/docsets/NSDictionary-HYPNestedAttributes)
[![Platform](https://img.shields.io/cocoapods/p/NSDictionary-HYPNestedAttributes.svg?style=flat)](http://cocoadocs.org/docsets/NSDictionary-HYPNestedAttributes)

This is a category on NSDictionary that converts the flat relationships in a dictionary to a nested attributes format.

## JSON Nested Attributes

```objc
NSDictionary *dictionary = @{@"first_name" : @"Chris",
                             @"contacts[0].name" : @"Tim",
                             @"contacts[0].phone_number" : @"444444",
                             @"contacts[1].name" : @"Johannes",
                             @"contacts[1].phone_number" : @"555555"};


NSDictionary *nestedAttributesDictionary = [dictionary hyp_JSONNestedAttributes];
```

```json
"first_name": "Chris",
"contacts": [
  {
    "name": "Tim",
    "phone_number": "444444"
  },
  {
    "name": "Johannes",
    "phone_number": "555555"
  }
]
```

## Rails Nested Attributes

```objc
NSDictionary *dictionary = @{@"first_name" : @"Chris",
                             @"contacts[0].name" : @"Tim",
                             @"contacts[0].phone_number" : @"444444",
                             @"contacts[1].name" : @"Johannes",
                             @"contacts[1].phone_number" : @"555555"};


NSDictionary *nestedAttributesDictionary = [dictionary hyp_railsNestedAttributes];
```

```json
"first_name": "Chris",
"contacts_attributes": {
    "0": {
      "name": "Tim",
      "phone_number": "444444"
    },
    "1": {
      "name": "Johannes",
      "phone_number": "555555"
    }
 }
```

## Installation

**NSDictionary-HYPNestedAttributes** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NSDictionary-HYPNestedAttributes'
```

## Author

Hyper Interaktiv AS, ios@hyper.no

## License

**NSDictionary-HYPNestedAttributes** is available under the MIT license. See the LICENSE file for more info.
