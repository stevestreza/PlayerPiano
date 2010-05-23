Overview
========

PlayerPiano is a streaming music client for Pandora. It uses the [pianobar](http://github.com/amazingsyco/pianobar) project to load the data and play music through OS X's audio sound system. The goal is to provide a very low-overhead player that integrates with the OS wherever possible. It doesn't use WebKit or Flash to stream audio, so PlayerPiano takes almost no CPU or RAM to run.

Currently, PlayerPiano requires that a build of the pianobar command-line application be placed within the application bundle (this was done to get the app running quickly). In the future, I'd like to link against the pianobar libraries directly to better control the interface for interacting with Pandora. See the wishlist below if you're interested in hacking on PlayerPiano.

Dependencies
============

* [VillainousStyle](http://github.com/amazingsyco/VillainousStyle)
* our fork of [pianobar](http://github.com/amazingsyco/pianobar)
* [Growl](http://growl.info/)

Install
=======

1. `git clone git://github.com/amazingsyco/PlayerPiano.git`
2. `cd PlayerPiano`
3. `git submodule init`
4. `git submodule update`
5. Open the Xcode project for PlayerPiano and build the application

Set Up
======

You need to add your Pandora account information to the settings. To do this, you need to execute two commands from the command line:

* `defaults write com.villainware.PlayerPiano pandoraEmail your@email.com`
* `defaults write com.villainware.PlayerPiano pandoraPassword yourPassword`

Once you do this, restart PlayerPiano.

License
=======

See the LICENSE.md file for license information.

Contributors
============

* Steve Streza
* Josh Weinberg
* Matt Ball

Wishlist
========

* Add UI for creating and switching between multiple accounts
* Add media playback key control
* Add a Share button for posting the song to Twitter/Facebook/Last.fm/AIM/etc