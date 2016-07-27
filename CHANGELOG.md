# Change Log

All notable changes to this project will be documented here.

## Unreleased

### Added

* Response plans now include officer safety concerns.

### Fixed

* When a response plan is updated,
  officers can still see the original version
  while the new version is waiting for approval.

## [0.1.4] - 2016-07-27

### Added

* Add search fields for physical characteristics.
* Create a form for officers on the Crisis Response Team
  to create new response plans.
* Add a mechanism for the Crisis Response Team Sergeant
  to approve new response plans.

### Changed

* Automatically fill dashes for the Date of Birth field.
  This restricts the number of ways you can enter a date of birth,
  but helps you avoid needing to enter dashes by hand.
  The new accepted date format is `mm-dd-yyyy`.
* Small interface improvements for the "About the Plan" section.

## [0.1.3] - 2016-07-01

### Added

* On small screens, we show a small preview of the response plan steps,
  instead of the entire text (which often takes up a lot of space).
  Users can click "Read More" to see the entire text.
* Label a person's scars, marks, and tattoos with "SMT".
* Contacts can now have an "organization" that they're associated with.

### Changed

* Replace the magnifying glass icon in the header bar with a "home" icon.
  The icon still navigates to the main search screen,
  but it is hopefully more intuitive.
* Switching from light to dark mode is quicker and more clear,
  with a "toggle" switch to tell you what mode you're currently in.
* Slightly changed the look, and arrangement of the side menu bar.
* The "About the Plan" section got a makeover,
  which makes it easier to see when the plan was created,
  and to call the CRT from your phone.

### Fixed

* There was a bug in Internet Explorer that prevented users
  from switching between images on a response plan.
  Switching images should now work on all devices.
* The app now displays with the correct sans-serif font on MDTs.
* When the app presents a message to the user,
  such as when they successfully sign in,
  it conflicted with the position of the menu bar.
  They now play nicely together.
* The map's "zoom in" and "zoom out" buttons now appear correctly in night mode.

## [0.1.2] - 2016-06-30

### Added

* If an individual has a known address,
  display it on a map in the left column of the response plan.

### Changed

* Display an individual's emergency contacts more clearly,
  with a larger button for starting a phone call.

## [0.1.1] - 2016-06-17

### Added

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

### Fixed

* A bug caused the application to crash
  when an unrecognized date was entered into the "DOB" search field.
  Now, we show a helpful error message.

### Changed

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

[Unreleased]: https://github.com/codeforamerica/crisisresponse/compare/v0.1.4...HEAD
[0.1.4]: https://github.com/codeforamerica/crisisresponse/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/codeforamerica/crisisresponse/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/codeforamerica/crisisresponse/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/codeforamerica/crisisresponse/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/codeforamerica/crisisresponse/compare/v0.0.2...v0.1.0
[0.0.2]: https://github.com/codeforamerica/crisisresponse/compare/v0.0.1...v0.0.2
