# VPN Config

Generate iOS/OS X configuration profiles for VPNs.

Only L2TP [Private Internet Access](https://www.privateinternetaccess.com/) VPNs are supported out of the box at the moment, but it's possible to provide your own data file (pull requests are also welcome, if you want to add support for your VPN provider).

## Installation

A working Ruby is required (preferably Ruby 2.2.0 or above).

Install it in the usual manner:

    gem install vpn-config

## Usage

To get basic help, run: `vpn-config help`

For information on a specific command: `vpn-config help COMMAND`

### Generate a signed configuration file

By default VPN Config will generate `.mobileconfig` files signed with a built-in self-signed “snake oil” certificate.

To generate a configuration file for the default VPN Provider (Private Internet Access), run:

```sh
vpn-config generate --username=foo --password=bar test.mobileconfig
```

To select specific endpoints, use the `--endpoints` option:

```sh
vpn-config generate --username=foo --password=bar \
--endpoints "US East" "Canada" "Hong Kong" test.mobileconfig
```

To sign with your own certificate, simply provide the path and passphrase (the certificate **must** be a PKCS12 file):

```sh
vpn-config generate --username=foo --password=bar \
--certificate-path my.p12 --certificate-pass SuperSecret test.mobileconfig
```

### Supply your own data file

If you wish, you can use your own VPN list instead of the built-in list:

```sh
vpn-config generate --username=foo --password=bar \
--data-file mydata.yml --provider "My Provider" test.mobileconfig
```

Use the [data/providers.yml](https://github.com/matiaskorhonen/vpn-config/blob/master/data/providers.yml) file as an example of how to format your list.

## Private Internet Access L2TP credentials

Don't try to use your PIA account credentials to log in to PIA VPNs. Instead you will find a separate set of credentials on the [Client Control Panel](https://www.privateinternetaccess.com/pages/client-control-panel):

![PPTP/L2TP/SOCKS Username and Password](http://shots.matiaskorhonen.fi/PPTPL2TPSOCKS_Username_and_Password.png)

Generate the credentials if you haven't already…

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Unit tests

Run the Minitest/Minispec tests with: `rake test`

## Contributing

1. Fork it ( https://github.com/matiaskorhonen/vpn-config/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright & License

Licensed under the MIT License. See the [LICENSE.txt](/LICENSE.txt) file for details.

Copyright (c) 2015 Matias Korhonen
