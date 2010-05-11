Overview
========

PlayerPiano is a streaming music client for Pandora. It uses the [pianobar](http://github.com/PromyLOPh/pianobar) project to load the data and play music through OS X's audio sound system. The goal is to provide a very low-overhead player that integrates with the OS wherever possible. It doesn't use WebKit or Flash to stream audio, so PlayerPiano takes almost no CPU and about 20 MB of RAM to run.

Currently, PlayerPiano requires that a build of the pianobar command-line application be placed within the application bundle (this was done to get the app running quickly). In the future, I'd like to link against the pianobar libraries directly to better control the interface for interacting with Pandora. See the wishlist below if you're interested in hacking on PlayerPiano.

Dependencies
============

* [VillainousStyle](http://github.com/amazingsyco/VillainousStyle)
* [pianobar](http://github.com/PromyLOPh/pianobar)
  * [...and pianobar's dependencies](http://github.com/PromyLOPh/pianobar/blob/master/INSTALL)

Install
=======

**NOTE: These instructions are not quite working. I'm trying to make the projects build a universal application which is self-contained. Some of the dependent libraries are making this difficult. To work around for now, you'll need to build pianobar and its libraries manually first. Once you have that working, you'll need to drop the pianboar executable inside the application binary, and it'll work. Sorry for the royal pain in the ass that this is. :)**

1. `git clone git://github.com/amazingsyco/PlayerPiano.git`
2. `cd PlayerPiano`
3. `git submodule init`
4. `git submodule update`
5. For each of the audio libraries in the contrib directory (libao, libfaad2, and libmad), you will need to run `./configure` to generate makefiles
6. Open the Xcode project for PlayerPiano and build the application

Set Up
======

You need to add your Pandora account information to the settings. To do this, you need to execute two commands from the command line:

* `defaults write com.villainware.PlayerPiano pandoraEmail your@email.com`
* `defaults write com.villainware.PlayerPiano pandoraPassword yourPassword`

Once you do this, restart PlayerPiano.

License
=======

See the LICENSE.md file for license information.

Wishlist
========

* Link the pianobar libraries directly into the application and use the native APIs to control Pandora playback
* Add UI for creating and switching between multiple accounts
* Add station creation
* Add Growl notifications
* Add media playback key control
* Add link to iTunes store and the Amazon MP3 store
* Add a Share button for posting the song to Twitter/Facebook/Last.fm/AIM/etc