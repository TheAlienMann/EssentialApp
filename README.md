# Essential Developer proj with a little bit of tweaks!

### First, but not most, I tried to user Swift Package instead of the originally used Framework. 

#### Pros
* You get the opportunity to use vim! (YES, that is a pro!!!)

* For most parts, it is much easier to work with Swift Packages, for instance you can open up th project (the package) in a different IDE or Editor and code there (VS Code for instance), since SourceKit-lsp supports thirds party IDEs and Edirotrs.

* You are open to use the built-in terminal in that edirot to do your git commits without leaving your enviornment.

* Running the Unit Tests and getting feedback in a much more prettified way (with the help of libraries such as [XCPretty](https://github.com/xcpretty/xcpretty) or [XCBeautify](https://github.com/tuist/xcbeautify)).

* Plus, you have the possiblity to check your code for fomatting and code conventions with the help of the legendary [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) (by the way, here you can find my own setup and configuration of this library that I regularly use [SwiftFormat & SwiftLint configs](https://github.com/TheAlienMann/SwiftLintingConfig)).

#### Cons

* Obviously, you don't have vim, anymore (yeah, you have some sort of a vim in xcode, which I just call it baby-vim).

* Everything is cool, up until you need to do the UI part. SourceKit-lsp doesn't support UIKit since, well obviously, the UIKit isn't open source. Here you need to get back to xcode.
### second, doing the UI in codee (programmatically per say) in UIKit.

