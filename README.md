# PIA Profile Generator

Generate iOS/OS X configuration profiles for [Private Internet Access][pia] VPNs.

[pia]: https://www.privateinternetaccess.com


## Prerequisites

You'll need the free [Apple Configurator](https://itunes.apple.com/us/app/apple-configurator/id434433123?mt=12) to sign the generated configuration profile (this is required on iOS devices).

You'll also need a working Ruby environment and the [Bundler](http://bundler.io/) gem.


## Usage

1. Clone the repository on to your local machine:

  ```sh
  git clone git@github.com:matiaskorhonen/pia_profile_generator.git
  ```

2. Install the dependencies with bundler

  ```sh
  bundle install
  ```

3. Configure which VPN servers you want to include. Make a copy of the server list, then edit `pia-servers.yml` to enable individual servers.

  ```sh
  cp pia-servers-full.yml pia-servers.yml
  ```

4. Run the generator script

  ```sh
  bundle exec ./generate.rb
  ```

  The script will ask for your L2TP username and password. You can find these on the PIA Client Control Panel.

  ![PPTP/L2TP/SOCKS Username and Password](http://shots.matiaskorhonen.fi/PPTPL2TPSOCKS_Username_and_Password.png)

5. Open the Apple Configurator app, click **+** under the profiles section, choose **Import profile…**, then find the configuration profile you just generated.

  ![Apple Configurator](http://shots.matiaskorhonen.fi/Apple_Configurator_1.png)

6. Select the profile you just imported and click the export button

  ![Export profile](http://shots.matiaskorhonen.fi/Apple_Configurator_Export_Profile.png)

7. Export the profile to a location of your choosing (e.g. Dropbox). Remember to sign it!

  ![Export and sign the profile](http://shots.matiaskorhonen.fi/Apple_Configurator_2015-02-15_at_16.11.56.png)

8. Open the profile on your **iOS device**, for example by:

  * Email the profile to yourself and open the attachment in the default iOS Mail app
  * Upload the file to Dropbox and open the Dropbox link in Safari
  * Upload the profile to your own server and open the URL in Safari on your iPhone or iPad

  Follow the iOS prompts to install the profile.

  It is also possible to install the profile with the Apple Configurator app, but I've never tried it.

9. On **OS X** simple double click the profile file to install it.


## Copyright & License

Licensed under the MIT License. See the [LICENSE](/LICENSE) file for details.

Copyright (c) 2015 Matias Korhonen
