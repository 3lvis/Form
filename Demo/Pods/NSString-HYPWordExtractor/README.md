#NSString-HYPWordExtractor

[![Build Status](https://img.shields.io/travis/hyperoslo/NSString-HYPWordExtractor.svg?style=flat)](https://travis-ci.org/hyperoslo/NSString-HYPWordExtractor)

A super easy way of extracting all or only unique words from an NSString

#### Extracting unique words would look like this:
``` objc
NSString *string = @"first_name last_name";
NSSet *uniqueWords = [string hyp_uniqueWords];
```

Would produce

```
uniqueWords: {(
    "first_name",
    "last_name"
)}

```
#### Extracting all words would look like this:
``` objc
NSString *string = @"first_name last_name last_name";
NSArray *words = [string hyp_words];
```

Would produce

```
words: (
    "first_name",
    "last_name",
    "last_name"
)
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

NSString-HYPWordExtractor is available under the MIT license. See the [LICENSE](https://raw.githubusercontent.com/hyperoslo/NSString-HYPWordExtractor/master/LICENSE.md) file for more info.
