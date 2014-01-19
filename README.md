OnsNieuws
=========

**PLEASE NOTE:** This app was never released, due to not being able to monotize on it. There are some bugs still, mainly with regards to caching data IIRC. I wasn't allowed to monotize on this app due to NOS news gathering is payed for with public money.

_Ons Nieuws_ is a simple app that demonstrates some techniques used in iPhone projects. Feel free to use fragments of the code in your own projects, though one is not allowed to publish the whole project on the AppStore. 

So, what could an aspiring iOS programmer learn from this project?
- Proper use of a _Singleton_ (see: AudioPlayer)
- Extending existing classes with new functionality through _Categories_.
- Notifications / NotificationCenter ([I've documented the approach in this StackOverflow post][0]).
- Programming readable Objective-C (mainly method and parameter naming, classes should use a prefix).
- Archiving / unarchiving data using NSCoder.
- Integrate Facebook into an app.

**PLEASE NOTE 2:** I haven't tested the code in the past year or so. In case the NOS website has been updated, the parsing code might fail, though it should be pretty easy to get a functional app again by updating the parser code. 

[0]: http://stackoverflow.com/questions/9877110/objective-c-need-help-creating-an-avaudioplayer-singleton/9880450#9880450
