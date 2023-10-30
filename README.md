# Essential Developer proj with a little bit of tweaks!

### First, but not most, I tried to use Swift Package instead of the originally used Framework. 

#### Pros

* For the most parts, it is much easier to work with Swift Packages, for instance you can open up the project (the package) in a different IDE or Editor and code there (VS Code for instance), since SourceKit-lsp supports thirds party IDEs and Edirotrs.

* You get the opportunity to use vim! (YES, that is a pro!!!)

* You are open to use the built-in terminal in that edirot to do your git commits without leaving your enviornment (yes, I know you can do git stuff inside xcode!).

* Running the Unit Tests and getting feedback in a much more prettified way (with the help of libraries such as [XCPretty](https://github.com/xcpretty/xcpretty) or [XCBeautify](https://github.com/tuist/xcbeautify)).

* Plus, you have the possiblity to check your code for fomatting and code conventions with the help of the legendary [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) (by the way, here you can find my own setup and configuration of this library that I regularly use [SwiftFormat & SwiftLint configs](https://github.com/TheAlienMann/SwiftLintingConfig)).

#### Cons

* Everything is cool, up until you need to do the UI part and/or have a CoreData model in your project. SourceKit-lsp doesn't support UIKit, since, well obviously, the UIKit isn't open source. Here you need to get back to xcode.

* Having a CoreData model in your project (oh man 🤦‍♂️). In this case you need to create the model in a separate project, an xcode supported project, setup the entities, the configurations etc, then import (copy the file over) it to your package. This is not the only headache you'd face. You need to put the model file in a directory at the root of the source code (Resources directory). 

* Obviously, you don't have vim, anymore (yeah, you have some sort of a vim in xcode, which I just call it baby-vim, I have posted about it quite a few times on LinkedIn).

### Second, doing the UI in code (programmatically per say) in UIKit, instead of Storyboard which was used originally.

