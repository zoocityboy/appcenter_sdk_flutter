# Example, mobile Application

![Made by EmbedIt](https://img.shields.io/badge/Made_by-EmbedIt-blue?style=flat-square)
![Powered by EIT Platform](https://img.shields.io/badge/Powered_by-EIT_Platform-lightgreen?style=flat-square)

# Getting start 🚀

## About

- Multiplatform: This means that the application is available on multiple platforms such as iOS and Android. This allows customers to use the application on different devices.

- Flutter: [Flutter](https://www.flutter.dev) is an open-source framework for mobile application development. [Flutter](https://www.flutter.dev) allows developers to create beautiful and fast applications for mobile devices.

- Azure: Azure is a cloud platform from Microsoft. Hosting your application on Azure means that your application will be running in the cloud and will be available to users anytime and anywhere.

- Figma: [Figma](https://www.figma.com/) is a design and prototyping tool. Using Figma allows developers and designers to collaborate on the design of the application and create beautiful user interfaces.

- Banking application: Application is intended for banking purposes such as payments and financial management.

- Serbian market: Application is intended for the Serbian market. This means that application will have specific features and properties that are relevant to this market.

## Design system

[Figma - Design System](https://www.figma.com/file/KK1gW4LesuJyQMoFfUVIUb/%F0%9F%A4%96-MobiKit---System?node-id=114-3985&t=KCSVFQzuRUf4FoPR-0)

[Figma - All Flows](https://www.figma.com/files/team/1212711332215014911/Mobi-Banka?fuid=1044916222529096107)

## EIT Core packages

| Title                                                                                 | Description                                                             |
| ------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| [Design system](https://dev.azure.com/Mobi-MobileApp/MobileApp/_git/eit_designsystem) | Storybook for UIKit                                                     |
| [UIKit](https://dev.azure.com/Mobi-MobileApp/MobileApp/_git/eit_uikit)                | Design system implementation in flutter                                 |
| [Monitoring](https://dev.azure.com/Mobi-MobileApp/MobileApp/_git/eit_monitoring)      | Core component for monitoring tools                                     |
| [Networking](https://dev.azure.com/Mobi-MobileApp/MobileApp/_git/eit_networking)      | Flutter network communication, retry logic, interceptors, security etc. |
| [Storage](https://dev.azure.com/Mobi-MobileApp/MobileApp/_git/eit_storage)            | Secure storage for Flutter projects                                     |

## EIT Bricks

| Title                                                                                        | Description                                                      |
| -------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| [Feature](https://dev.azure.com/Mobi-MobileApp/MobileApp/_git/eit_brick_feature)             | Dynamic template for scaffolding feature in layered architecture |
| [Feature Tests](https://dev.azure.com/Mobi-MobileApp/MobileApp/_git/eit_brick_feature_tests) | Generate tests for new feature                                   |
| App                                                                                          | Generate custom app template                                     |
| Module                                                                                       | Generate custom app module                                       |
| Package                                                                                      | Generate custom app package                                      |
| Plugin                                                                                       | Generate custom app plugin                                       |

## Project specific packages

| Title                                                                           | Description                  |
| ------------------------------------------------------------------------------- | ---------------------------- |
| [Translate](https://dev.azure.com/Mobi-MobileApp/MobileApp/_git/mobi_translate) | Localization for flutter app |

## Storybook

[Not yet online]()

Currently is available only locally

# How to start ✨

## Setup git

### SSH Authentication

Before you start, you have to setup your device to use [SSH Authentication](https://learn.microsoft.com/en-us/azure/devops/repos/git/use-ssh-keys-to-authenticate?view=azure-devops)

Clone project from Azure Devops

```bash
# clone with ssh
git clone git@ssh.dev.azure.com:v3/Mobi-MobileApp/MobileApp/mobi_app

# with submodules (external packages for local development)
git clone --recurse-submodules ...
```

```bash
# macOS, Linux
sh firstrun.sh

# or
chmod +x firstrun.sh
./firstrun.sh

```

```ps
# windows
.\firstrun.cmd
```

Everything should be green, prepared to run.

## Open project

```bash
# open project in your preffered IDE

cd mobi_app

# Visual Studio Code
code .

# for Android Studio
studio .
```

# Developer experience

| Tool                                                 | description             |
| ---------------------------------------------------- | ----------------------- |
| [FVM](https://fvm.app/docs/getting_started/overview) | Flutter version manager |
| [Melos](https://melos.invertase.dev/)                | Monorepo orchestrator   |
| [Mason](https://docs.brickhub.dev/)                  | Template generator      |
| [Git](https://git-scm.com/)                          | Come on!                |

## Testing on beta versions

We are using FVM testing app on future versions of flutter.

```bash
# install new version
fvm install beta

# switch version used by project
fvm use beta --force

# clear project dependencies
melos clean

# bootstrap with new version
melos bootstrap
```

## Run cmdline command with fvm

if you want to use specific flutter/dart command outside melos, then you have to use

```bash
cd apps/mobi_bank

# run command with fvm prefix
fvm flutter pub get
```
