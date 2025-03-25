# Kite

A simple news aggregator application using Flutter inspired by
[Kite](https://kite.kagi.com/).

Based on the Flutter
[MVVM architecture](https://docs.flutter.dev/app-architecture).

## Getting Started

This project uses [Flutter Version Management (FVM)](https://fvm.app/) to manage
SDK versions.

Can be installed via `brew`:

```sh
brew tap leoafarias/fvm
brew install fvm
```

Once installed, run:

```sh
fvm install
```

This will install the Flutter version defined in the project.

To run Flutter commands:

```sh
# Use
fvm flutter <command>
# Instead of
flutter <command>
```

Recommended to alias this in `.bashrc` or equivalent.

### Pre-Commit

Install [`pre-commit`](https://pre-commit.com/) via your preferred method e.g.
`brew`:

```sh
brew install pre-commit
```

And then in the repo root run:

```sh
pre-commit install
```

This will use the `.pre-commit-config.yaml` to use the listed plugins.

## Running the App

Ensure that running:

```sh
flutter doctor
```

Shows iOS and Android development is setup correctly.

Open either the iOS or Android Simulator and run:

```sh
flutter run
```
