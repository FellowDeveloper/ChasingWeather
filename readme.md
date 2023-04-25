# Example Weather Fetching App

Sample iOS app with a couple of simple screens to showcase some good and some not so good techniques

### Not so good - Navigation
Storyboard based navigation and passing parameters with "prepareForSegue" is error prone and exposes target view controller implementation.

I feel like something along the user intent handling pattern would serve better for navigation.

### Not so good - Data Structs
Views use data structs mapped 1:1 from JSON. Better to flatten response and extract what is needed only


## Dependencies Centralization

Dependency management is crucial. Even in app this size creation of all dependencies looks fairly hairy. For simplicity app dependencies are in AppDelegate.serviceLocator struct

Can be swapped when testing / debugging / changing implementation

## Unit Testing
DetailViewController
* Have tests in place to make sure UI elements contain appropriate values after setting report
Data Parsing
* Test for decoding data structs from json

## Separation of concerns & testability

App uses fake location engine when run in sumulator to simplify development & testing

## Misc iOS concepts
* Performing storyboard based view controller transition
* Notification Posting / Listening
* Custom table view cell view design in separate xib
* Custom table view cell registration
* Custom map annotation view with callout
* Saving / loading files (image icon cashe)
* Saving small bits of data (reposts history in user defaults)


