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

* Having a CoreData model in your project (oh man 🤦‍♂️). In this case you need to create the model in a separate project, an xcode supported project, setup the entities, the configurations etc, then import (copy the file over) it to your package. This is not the only headache you'd face. You need to put the model file in a directory at the root of the source code (Resources directory). That's not all (), in case of accessing the model, you need to call `Bundle.module`, you can find a detailed explanation about here in the [doc](https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package#Access-a-resource-in-code). This issue is still true for Localization and Asserts. (you need to have the asserts and localized strings files in the Resources directory.)

* Obviously, you don't have vim, anymore (yeah, you have some sort of a vim in xcode, which I just call it baby-vim, I have posted about it quite a few times on LinkedIn).

### Second, doing the UI in code (programmatically per say) in UIKit, instead of Storyboard which was used originally.

The fun part!

For some reason, Swift Package doesn't support storyboard. I mean you do can have a storyboard and setup all your UI components there, but the problem is that you can't call it (or maybe that is what I have experienced.), you do can though setup the UIs in xib files, and just call them the way you'd call a CoreData model or a Localized string file.

For these reasons, and also since I just love to do the UIs in code, I decided to go on with doing the UI in code.

They use a storyboard in the original project as a container-like or generic one (per say) to reuse it for both the `Feed` as well as the `CommentsImage` views (storyboards). Both of them are backed by `ListViewController` as their controller. So, since I am doing the UI in code, I made the `ListViewController` generic which takes a generic `T` of type `UITableViewCell`. And since it (the controller) needs to register the required tableView with a cell, I added an initializer to it, problem solved, two storyboards eliminated. Next, prefetchDataSource was setup in the storyboard before, now you need to configure it in code.

#### Pros
*  

#### Cons



