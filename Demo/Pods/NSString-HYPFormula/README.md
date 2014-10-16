# NSString-HYPFormula

[![Build Status](https://img.shields.io/travis/hyperoslo/NSString-HYPFormula.svg?style=flat)](https://travis-ci.org/hyperoslo/NSString-HYPFormula)

Creating and running string-based formulas have never been this easy

``` objc

NSDictionary *values = @{
    @"hourly_pay"    : @150,
    @"work_per_week" : @32.5
};
NSNumber *result = [@"hourly_pay * work_per_week" hyp_runFormulaWithDictionary:values];
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

[Hyper](http://hyper.no) made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to hire you.

## License

NSString-HYPFormula is available under the MIT license. See the [LICENSE](https://raw.githubusercontent.com/hyperoslo/NSString-HYPFormula/master/LICENSE.md) file for more info.
