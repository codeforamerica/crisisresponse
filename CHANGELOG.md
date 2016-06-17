# Change Log

All notable changes to this project will be documented here.

## [0.1.1] - 2016-06-17

## Added

* Response plans now support multiple images.
  If a plan has more than one image,
  the app will show controls for clicking through them.
* Searching by DOB now recognizes several different date formats, including:
  - `mm/dd/yyyy`
  - `mm/dd/yy`
  - `mm-dd-yyyy`
  - `mm-dd-yy`
  - `mmddyyyy`
  - `mmddyy`
  - `yyyy-mm-dd`

## Fixed

* A bug caused the application to crash
  when an unrecognized date was entered into the "DOB" search field.
  Now, we show a helpful error message.

## Changed

* To stop things from getting to crowded in the top navigation bar,
  we've moved several links from the navigation bar to the menu.
  Click on the menu icon ( ![menu] )
  to see the links.


[menu]: https://storage.googleapis.com/material-icons/external-assets/v4/icons/svg/ic_menu_black_24px.svg

## [0.1.0] - 2016-06-08

### Note

* Due to a change in user accounts, all officers will need to log in again.

### Added

* A placeholder section for officer safety notes,
  until the actual notes get built into the app.
* Subject aliases in the left sidebar.
* Background information & notes for field testers at `/pages/about`.
* Notes about changes to the app at `/pages/changelog`.

### Fixed

* On small screens, links in the header are hidden behind a drop-down menu.

### Changed

* Display CRT contact info instead of the preparing officer's contact info.
* Section headers have been reworded to more accurately reflect the information.

## [0.0.2] - 2016-06-02

### Fixed

* The site now displays properly on Internet Explorer 9

## 0.0.1 - 2016-05-30

### Added

* Track analytics through Keen.io
* Officers can sign in with their existing SPD username and password

### Fixed

* Text entered into search or feedback fields is now visible in night mode

[Unreleased]: https://github.com/codeforamerica/crisisresponse/compare/v0.1.0...HEAD
[0.1.1]: https://github.com/codeforamerica/crisisresponse/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/codeforamerica/crisisresponse/compare/v0.0.2...v0.1.0
[0.0.2]: https://github.com/codeforamerica/crisisresponse/compare/v0.0.1...v0.0.2
