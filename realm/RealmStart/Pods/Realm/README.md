![Realm](https://github.com/realm/realm-cocoa/raw/master/logo.png)

Realm is a mobile database that runs directly inside phones, tablets or wearables.
This repository holds the source code for the iOS, OS X, watchOS & tvOS versions of Realm Swift & Realm Objective-C.

## Features

* **Mobile-first:** Realm is the first database built from the ground up to run directly inside phones, tablets and wearables.
* **Simple:** Data is directly [exposed as objects](https://realm.io/docs/objc/latest/#models) and [queryable by code](https://realm.io/docs/objc/latest/#queries), removing the need for ORM's riddled with performance & maintenance issues. Most of our users pick it up intuitively, getting simple apps up & running in minutes.
* **Modern:** Realm supports relationships, generics, vectorization and even Swift.
* **Fast:** Realm is faster than even raw SQLite on common operations, while maintaining an extremely rich feature set.

## Getting Started

Please see the detailed instructions in our docs to add [Realm Objective-C](https://realm.io/docs/objc/latest/#installation) _or_ [Realm Swift](https://realm.io/docs/swift/latest/#installation) to your Xcode project.

## Documentation

### Realm Objective-C

The documentation can be found at [realm.io/docs/objc/latest](https://realm.io/docs/objc/latest).  
The API reference is located at [realm.io/docs/objc/latest/api](https://realm.io/docs/objc/latest/api).

### Realm Swift

The documentation can be found at [realm.io/docs/swift/latest](https://realm.io/docs/swift/latest).  
The API reference is located at [realm.io/docs/swift/latest/api](https://realm.io/docs/swift/latest/api).

## Getting Help

- **Need help with your code?**: Look for previous questions on the  [#realm tag](https://stackoverflow.com/questions/tagged/realm?sort=newest) — or [ask a new question](https://stackoverflow.com/questions/ask?tags=realm). We actively monitor & answer questions on SO!
- **Have a bug to report?** [Open an issue](https://github.com/realm/realm-cocoa/issues/new). If possible, include the version of Realm, a full log, the Realm file, and a project that shows the issue.
- **Have a feature request?** [Open an issue](https://github.com/realm/realm-cocoa/issues/new). Tell us what the feature should do, and why you want the feature.
- Sign up for our [**Community Newsletter**](http://eepurl.com/VEKCn) to get regular tips, learn about other use-cases and get alerted of blogposts and tutorials about Realm.

## Building Realm

In case you don't want to use the precompiled version, you can build Realm yourself from source.

Prerequisites:

* Building Realm requires Xcode 7.3.
* Building Realm documentation requires [jazzy](https://github.com/realm/jazzy)

Once you have all the necessary prerequisites, building Realm.framework just takes a single command: `sh build.sh build`. You'll need an internet connection the first time you build Realm to download the core binary.

Run `sh build.sh help` to see all the actions you can perform (build ios/osx, generate docs, test, etc.).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for more details!

## License

Realm Objective-C & Realm Swift are published under the Apache 2.0 license.  
The underlying core is available under the [Realm Core Binary License](https://github.com/realm/realm-cocoa/blob/master/LICENSE#L210-L243) while we [work to open-source it under the Apache 2.0 license](https://realm.io/docs/objc/latest/#faq).

**This product is not being made available to any person located in Cuba, Iran,
North Korea, Sudan, Syria or the Crimea region, or to any other person that is
not eligible to receive the product under U.S. law.**

## Feedback

**_If you use Realm and are happy with it, all we ask is that you please consider sending out a tweet mentioning [@realm](https://twitter.com/realm) or email [help@realm.io](mailto:help@realm.io) to share your thoughts!_**

**_And if you don't like it, please let us know what you would like improved, so we can fix it!_**

![analytics](https://ga-beacon.appspot.com/UA-50247013-2/realm-cocoa/README?pixel)
