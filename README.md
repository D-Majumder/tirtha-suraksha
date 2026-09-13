# Tirtha Suraksha

A safety and accessibility companion app for pilgrimage sites, built with Flutter for Smart India Hackathon 2025.

## Overview

Tirtha Suraksha is a mobile app aimed at improving safety, navigation, and accessibility for visitors at large Indian pilgrimage sites. It combines map-based navigation, a 360-degree panoramic viewer for select monasteries, and groundwork for offline peer-to-peer communication between nearby devices.

## Features

- Home, monastery/site detail, and SOS screens
- Video playback for site media (video_player, chewie)
- Map-based navigation using the Google Maps Flutter plugin
- A 360-degree panoramic viewer covering two monasteries, Rumtek and Phodong, displayed through an in-app web view (flutter_inappwebview)
- Groundwork for offline, nearby-device communication using Bluetooth Low Energy and device-discovery APIs (flutter_reactive_ble, nearby_connections); this is present in the app's dependencies as infrastructure, not a fully described end-to-end feature

## Not yet implemented

The app currently shows an explicit "under development" placeholder screen for the following two features:

- Temple History
- Festival Schedule

## Future work

- AI-based crowd analysis via CCTV footage (not implemented; mentioned as a future direction in earlier project material)

## Tech stack

- Flutter (Android, iOS, and desktop build targets are present in the repository)
- Google Maps Flutter plugin
- Bluetooth Low Energy and nearby-device discovery APIs

Implementation note: no Firebase package appears in this repository's pubspec.yaml or in its Android build configuration. Firebase is therefore not listed as part of the current implementation, regardless of how the project has been described elsewhere.

## Setup

    git clone https://github.com/D-Majumder/Tirtha-Suraksha
    cd Tirtha-Suraksha
    flutter pub get
    flutter run

## Limitations

Two advertised features, Temple History and Festival Schedule, are UI placeholders only, with no underlying functionality yet. The offline communication groundwork (Bluetooth and nearby-device APIs) is present as a dependency but has not been independently verified here as a complete, working feature end-to-end.

## License

No license file is currently present in this repository. Without one, all rights to the code are reserved by the author by default.
