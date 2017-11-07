# messenger-iOS

This is an iOS Application for DeerMichel's messenger backend.

## Project Background

The main intent behind this project was to get some first experience with Swift as well as to feel the
awesomeness of the language a friend of mine so repeatedly tried to persuade me of. And I have to admit:
As much as I loathed Swift for the many things it does differently, as much do I like it for some things
(like Optionals or elaborate Enums) now I know it a little better.

## Features

Well, this is a messenger. What do you expect it to do? :)  
Most important feature: one can send awesome messages to other awesome people. If you want to have a full overview of
the messenger's features, have a look at the [API Documentation](https://github.com/DeerMichel/messenger).

## Internals

The App uses [Alamofire](https://github.com/Alamofire/Alamofire) for most API interaction and
[socket.io](https://socket.io) for the 'instant' part in 'Instant Messaging'. As for the architecture side of things,
it's not the most fancy of it's kind. But who cares as long as it works, right? 😬

If you want to try and run the application yourself, make sure to place your API entry point and socket url in the
[API.plist](Messenger/API.plist).
