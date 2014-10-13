#HYPNorwegianSSN

[![Build Status](https://img.shields.io/travis/hyperoslo/HYPNorwegianSSN.svg?style=flat)](https://travis-ci.org/hyperoslo/HYPNorwegianSSN)

A convenient way of validating and extracting info from a Norwegian Social Security Number

``` objc
HYPNorwegianSSN *ssn = [[HYPNorwegianSSN alloc] initWithString:@"xxxxxxxxxxx"];

if (ssn.isValid) {
    NSLog(@"Yeap, this is valid alright, tell me more about this so called person.");
    [self gainInterest:YES];
}

if (ssn.isDNumber) {
    NSLog(@"OMG! A potential swede");
    [self runAndHide];
}

if (ssn.isFemale) {
    NSLog(@"Oh, it's a woman!");
    [self comesBack];
}

NSLog(@"Are you sure? Remember what happened last time?");

if (!ssn.isMale) {
    NSLog(@"Yeah I'm sure, this is not an Aerosmith song!");
    [self startWhistlingOnTune:@"Aerosmith -  Dude (looks like a lady)"];
    NSLog(@"Doh!");
}

if (ssn.age >= 18 && ssn.age < 35) {
    NSLog(@"Dear diary, jackpot");
    [self enableTheSmoulder:YES];
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

HYPNorwegianSSN is available under the MIT license. See the [LICENSE](https://github.com/hyperoslo/HYPNorwegianSSN/raw/develop/LICENSE.md) file for more info.
