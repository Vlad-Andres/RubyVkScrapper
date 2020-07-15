# VK profiles collection script 
This script was created in the purpose of learning web scrapping and automatization with ruby. Use it at your own risk. We do not encourage any illegal actions.

## Features: 
* Scrapping and downloading data about profiles that meet requirements set by you in the config.yml file
* Automatization in sending messages to each of the profile collected or found in the correct format in the profiles.json file.

## Installation
> Requirements:
* Ruby 2.6 or higher
* Chrome Version 83, if another version go to [this](https://chromedriver.chromium.org/downloads) link, download for your version and replace the chromedriver in the project folder

> Setting up/Run: 
```
 $ gem install bundler
```
```
 $ bundle install
```
```
 $ ruby main.rb
```
Follow the commands on the console to use the script



### Formats of the files you may want to change: 
> profiles.json:
```json
    [
        {
            "name":"Example name",
            "url":"vk.com/123456"
        },
        {
            "name":"Another profile",
            "url":"vk.com/picprof24"
        }
    ]
```
> msg.json:  <i> Contains messages that will be in random order send to each of the profiles </i>
```json
["a message here", "another message here"]
```
> pref.cfg <i> Change only the values to your credentials and search preferences </i>

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
