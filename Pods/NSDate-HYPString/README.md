# NSDate-HYPString

[![CI Status](http://img.shields.io/travis/hyperoslo/NSDate-HYPString.svg?style=flat)](https://travis-ci.org/hyperoslo/NSDate-HYPString)
[![Version](https://img.shields.io/cocoapods/v/NSDate-HYPString.svg?style=flat)](http://cocoadocs.org/docsets/NSDate-HYPString)
[![License](https://img.shields.io/cocoapods/l/NSDate-HYPString.svg?style=flat)](http://cocoadocs.org/docsets/NSDate-HYPString)
[![Platform](https://img.shields.io/cocoapods/p/NSDate-HYPString.svg?style=flat)](http://cocoadocs.org/docsets/NSDate-HYPString)

## Usage

```objc
- (NSString *)hyp_timeString;

- (NSString *)hyp_dateString;

- (NSString *)hyp_dateStringWithFormat:(NSString *)format;

- (NSString *)hyp_timeRangeStringToEndDate:(NSDate *)endDate;

- (NSString *)hyp_dateRangeStringToEndDate:(NSDate *)endDate;

- (NSString *)hyp_dateRangeStringToEndDate:(NSDate *)endDate
                                withFormat:(NSString *)format;
```

## Installation

**NSDate-HYPString** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NSDate-HYPString'
```

## Author

Hyper, teknologi@hyper.no

## License

**NSDate-HYPString** is available under the MIT license. See the LICENSE file for more info.
