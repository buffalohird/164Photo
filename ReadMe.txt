
Ansel Duff
Buffalo Hird
Project3
Computer Science 164

README.txt - Instructions on constructing our iOSapplication.

What We've Done:

	* Implemented ALL functionality
	* Written all of our effects methods (these are subject to change for our release to the App Store!
	* Given user capability of opening (selecting), taking, editing, and storing photos
	* Created an editing environment
	* Created a gallery of edited photos
    
Some Design Decisions

	* As mentioned in our alpha, we wanted to give the user more editing flexibility. We did this with finishing our crop feature as well as giving the user a slider
	  with which the magnitude of each effect may be modified.
	* As hinted at throughout our whole project, we want to eventually (this summer) go commercial with a refined version of this app. Thus even though right now it's
	  designed for our CS164 release, we are keeping scalability in mind. Some of the design decisions may not seem optimal right now but we are keeping scalability in
	  mind to try to make adding features down the road easier.
		-> Any specific instances of this are noted in comments

Known Issues/Things to Improve Upon  
	
	* Our crop/resize functionality is sometimes incorrect (it's not our fault, srsly).  But actually, the third-party framework we use doesn't always play nicely with iOS 5's camera app.  We didn't notice this until late into the game because we, like you, mostly used the simulator and it only happens for some photos.  Ideally for our app store release we'd just completely self-write our crop/resize functionality, but the parts we borrow from other projects right now mess up at times.  We didn't spend much time trying to fix it (relatively) because it isn't our problem really and we couldn't figure it out.  It didn't seem right to spend more than a couple hours trying on it when it doesn't reflect our actual efforts.  Functionality works, but you might occasionaly have a rotated photo, stretched photo, our slightly-off cropped photo.  Find these under categories
        TLDR: it's not our code that is occasionally bad, we found out too late to find a new library or make our own ~1000 line one
	* As of right now, our app is still pretty resource heavy. After using it for a while, we've noticed that iOS "cuts us off" and crashed the app when we are demanding
	  too much from the OS. This is clearly sub-optimal. We've tried to combat this by editing smaller images, using lower resolution overlays, loading overlays into
	  instance variables, etc. However, it's not all the way there yet. It is, however, plenty fast on the simulator and on a device using lower megapixel photos
      
    * We releaize one page says "164Foto" and one says "16Foto".  It'll change for the app store to a different name so we didn't put the art time in to fix that

Testing Notes:
1.) We've found testing in the simulator pretty convenient. As you mentioned in your notes about our Project3 alpha, we know that you don't own an iOS device; but that's perfectly OK! If you just run the simulator and download (save)
	some images off the intergooglez into the stock Photos app, you're all set. As mentioned in our alpha, though, trying to take a photo in the simulator triggers a crash (for obvious reasons). The take a photo version works fine on
	an actual iOS device