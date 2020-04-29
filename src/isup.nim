#[
  isup - a simple CLI tool for hitting the isitup.org API.
         Written in nim. Install with `nimble install`

  Copyright Tyler Stubenvoll, GPLv3.0
]#

import httpclient
import strutils
import os
import parseopt
import json

proc checkIsUp(http: HttpClient, url: string) =
  let response = json.parseJson(http.getContent("https://isitup.org/" & url & ".json"))
  case response["status_code"].getInt():
  of 1:
    echo(url, " is up.")
  of 2:
    echo(url, " is down.")
  else:
    echo(url, " is invalid.")

# httpclient doesn't handle proxying. It also
# doesn't like empty proxy settings and the 
# documentation is a bit lax. So we'll intpret
# no settings as meaning there is no proxy needed.
proc getProxySettings(): string =
  let proxy_settings = if existsEnv("https_proxy"):
    getEnv("https_proxy")
  elif existsEnv("HTTPS_PROXY"):
     getEnv("HTTPS_PROXY")
  elif existsEnv("http_proxy"):
    getEnv("http_proxy")
  elif existsEnv("HTTP_PROXY"):
    getEnv("HTTP_PROXY")
  else:
    ""
  
  return proxy_settings

# Creates a new httpclient, with proxy settings
# if need be.
proc getHttpClient(): HttpClient =
  let proxy_settings = getProxySettings()

  if proxy_settings.isEmptyOrWhitespace():
    return newHttpClient()
  else:
    return newHttpClient(proxy=newProxy(url=proxy_settings))

proc print_help() =
  echo("isup - a quick 'is it up' website checker using isitup.org API.\n")
  echo("example: is-up www.google.com www.facebook.com")
  echo("Options:")
  echo("-h, --help: Print this message and exit")
  echo("-v, --version: Print version and exit")
  echo("<argument>: Up to N number of domains checked, in order.")

proc print_version() =
  echo("isup version 1.0.1, GPLv3 Copyright 2020")

when isMainModule:
  if os.paramCount() < 1:
    stderr.writeLine("Please provide at least one argument.")
    print_help()
    system.quit(QuitFailure)

  var client = getHttpClient()
  var emptyNoVal = initOptParser()
  for kind, key, val in emptyNoVal.getopt():
    case kind:
    of cmdShortOption, cmdLongOption:
      if key == "help" or key == "h":
        print_help()
        system.quit(QuitSuccess)
      elif key == "version" or key == "v":
        print_version()
        system.quit(QuitSuccess)
      else:
        stderr.writeLine("Unknown option: " & key)
        system.quit(QuitFailure)
    of cmdArgument:
      checkIsUp(client, key)
    else:
      doAssert(false, "An impossible state has been reached")
      system.quit(QuitFailure)
