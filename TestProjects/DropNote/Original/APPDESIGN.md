# App design

I'd like to cover a few topics regarding project structure, design decisions and used dependencies.

- [Package manager and tools](#package-manager-and-tools)
- [Swinject & RxSwift](#dependencies)
- [Files structure](#files-structure)
- [MVVM](#mvvm)
- [Tests](#tests)
- [Storyboards](#storyboards)
- [Persistence](#persistence)
- [Networking](#networking)

## Package manager and tools

Starting with tools, there are two I'd like to mention that I found very useful.

Firstly, [swiftgen](https://github.com/AliSoftware/SwiftGen). Really great app which parses assets catalogs, localizable strings, color files, storyboards and provides for them swift files with proper enumarations. Thanks to that, I'm safe at compile time when I want to access e.g. an image and I don't have to write strings anywhere, but enum cases instead.
There are a few tools like this, but I chose `swiftgen` because it provides the most elegant API (in my opinion) - it extends UIKit classes with convenience initializers.

Secondly, [fastlane](https://github.com/fastlane/fastlane). Amazing when it comes to managing app in iTunesConnect, managing provisioning profiles and certificates, setting up build variants, sending betas to TestFlight (which I use a lot) and many, many more. Recommended.

As a package manager [CocoaPods](https://cocoapods.org) is used. That's pretty straightforward. The most important dependencies in a Podfile are: `Swinject` and `RxSwift`.

## Dependencies

### Swinject

[Swinject](https://github.com/Swinject/Swinject) is a lightweight dependencies injection framework. I'm a big fan of dependency injection and making it automatic, so I've been to [Objection](http://objection-framework.org) and [Typhoon](http://typhoonframework.org) in Objective-C world. In Swift, there was no pure solution until Swinject appeared. It's clean and easy to understand, so if you look for something a little more fancy than manual injection, that's good choice.

### RxSwift

I like experimenting, trying new things, exercising myself in thinking differently that I'm used to. First time I used [Reactive Cocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) 2.x in Objective-C was a few years ago, then with Swift 1.x Reactive Cocoa 3 was published. With Swift 2.x Reactive Cocoa 4 came up along with RxSwift (or maybe earlier).

There's been so much said about RxSwift already. Let me just express that for me (and I hope for readers of my code) RxSwift make the code more verbose. I can focus on what I want to achieve, not how to do it. This mix of functional and reactive paradigm needs a little bit different mindset than usual imperative programming and has a steep learning curve, but after a while the effort pays off.

## Files structure

When I look on a project structure I'd like to have an idea what's the domain and what it is all about. In Dropnote, all top folders, exluding `Shared`, are feature names, e.g. `Brewings`, `Settings` or `NewBrew`. Some of them have sub-features, e.g. in `Settings` there are `Units` and `Sequence`.

In every top directory you'll find an (Swinject) assembly file that configures components and dependencies for this feature, and sub-directories: `View`, `ViewModel`, `Model`.

## MVVM

MVVM architecture is very popular nowadays and in Dropnote you'll find my variation. All views and view controllers belong to View layer, view model objects in ViewModel and models or controllers in Model.

I try to stick to following rules:

- View layer is responsible only for presentation,
- ViewModel layer combines presentation with data and user actions,
- Model layer contains more complex logic on data,
- objects ownership is unidirectional: View -> ViewModel -> Model,
- data flow is unidirectional as well: View <- ViewModel <- Model.

Applying this everywhere makes the project consistent and puts me in comfortable position - it doesn't matter which feature or file I want to explore, they all are written in same manner and look similar.

## Tests

Short note on tests.

There are no tests or specs in the project. It has not been written using TDD.

So to speak, I had limited resources and time, so with that size of the app I decided rather to ship than fully test. I hope the most fragile parts will have specs soon.

## Storyboards

Since the very beginning of my iOS journey I haven't used Interface Build nor Storybards if didn't have to.

So, there was layout on frames at first. After that, AutoLayout with all its benefits and pains came in. Finally, I decided to try Storybards in my company internal project. I put whole app in one storyboard and it was a mistake.
Then I had a couple of different approaches. In Dropnote, I created (almost) one storyboard per view controller. It was not a very good move as well.

As a result of all above, I don't like storyboards and Interface Builder. There's a long list of what I don't like: I have code and layout in two different and very well separated places, reusability of UI compoments is very limited, graphical views composing may seem cool but in a longer perspective maintaining storyboard is a pain, there are some merge conflicts hard to resolve, I can't code review the storyboard XML in a way I can do it with code, swift is incompatibile with storyboard (e.g. you can't use generic view controllers), I don't have control over when and how view controllers are created (therefore, in Swift you have to use unwrapped optional for properties), etc.

That's all probably quite controversial and subjective, but for me is enough to enjoy writing layout in code. Of course, once I started using storyboards in Dropnote, I won't drop them. This is an experiment and has to be continued (unless I rewrite everything).

## Persistence

There are persistent layers in the project. `NSUserDefaults` are used to store user preferences about units nad brewing step sequences. CoreData is used to store brews and all related entities.

The CoreData stack I found suitable for this project is:

- one writing context on private queue - for writing directly to persistent store,
- one main context on main queue - for reading,
- zero to many background contexts on private queue, created on demand - for writing.

## Networking

Currently, Dropnote is quite self-contained app. It doesn't require anything but user input. So there's no networking layer in the project.
