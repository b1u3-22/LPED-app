# Mobile application for LPED

* Client application for communication with the electronic playing dice
* The repository for the dice itself can be found [here](https://github.com/b1u3-22/LPED)

> This project started as a bachelors thesis, the original repository can be found [here](https://git.fit.vutbr.cz/xsedla2e/BP-LPED)

## Features
* Written in Flutter
* Supports adding and configuring multiple dice
* Shows the landed numbers from the added dice 
* Automatic warning when the battery level is below 15% tery state

## Structure
1. `lib/components`
    * UI components used throughout the app
2. `lib/model/device`
    * Models for containing information about the die
3. `lib/pages`
    * The two main pages `play` and `devices` page
        * `play` page actively scans for Bluetooth messages and displays the status of all dice and sum of all values. Devices can be hidden or excluded from the sum
        * `devices` page is used for managing existing devices and adding new ones
        
4. `lib/bluetooth.dart`
    * Functions for decoding messages from die
5. `lib/storage.dart`
    * Storage controller for saving and retrieving die information
6. `lib/typography.dart`
    * Text styles

## Compatibility
This app has only been tested on Android