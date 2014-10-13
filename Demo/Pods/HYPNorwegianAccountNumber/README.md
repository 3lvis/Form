# HYPNorwegianAccountNumber

[![Build Status](https://img.shields.io/travis/hyperoslo/HYPNorwegianAccountNumber.svg?style=flat)](https://travis-ci.org/hyperoslo/HYPNorwegianAccountNumber)

Makes validating Norwegian account numbers easy as pie

#### Short example:

``` objc
if ([HYPNorwegianAccountNumber validateWithString:@"xxxxxxxxxxx"]) {
    NSLog(@"$$$");
}
```

#### Long example:

``` objc
HYPNorwegianAccountNumber *accountNumber;
accountNumber = [[HYPNorwegianAccountNumber alloc] initWithString:@"xxxxxxxxxxx"];

if (accountNumber.isValid) {
    NSLog(@"$$$");
}
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

HYPNorwegianAccountNumber is available under the MIT license. See the [LICENSE](https://raw.githubusercontent.com/hyperoslo/HYPNorwegianSSN/develop/LICENSE.md) file for more info.
