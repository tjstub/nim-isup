# isup -- a simple isitup.org wrapper

## Introduction

`isup` is a simple tool for checking if a domain is down, using
[isitup.org](https:://isitup.org)'s API.

It's inspired by [is-up-cli](https://github.com/sindresorhus/is-up-cli) but to my own preference and in Nim-lang. It also adds the ability to query multiple sites in one command, if that's your sort of thing.

## Install

Install using `nimble`, nim's package manager.

```sh
$ nimble install
```

You will need to have an SSL library installed. This tool assumes you're on a unix-machine of some sort, as proxy settings are sourced from the environment.

## Examples

### List help:

```sh
$ isup --help
```

### List version

```sh
$ isup --version
```

### Query site status

```
$ isup www.google.com
```

## Community

This tool was written mostly for my own use and to learn Nim. Please feel
free to drop any crtiques and let me know what you think!
