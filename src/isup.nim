#[
  isup - a simple CLI tool for hitting the isitup.org API.
         Written in nim. Install with `nimble install`

  Copyright Tyler Stubenvoll, GPLv3.0
]#

import httpclient
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

# httpclient doesn't handle proxying. This proxying
# assumes then that you're keeping the proxy-info somewhere
# in a unix environment variable.
proc getProxy(): httpclient.Proxy =
  var url = ""
  if existsEnv("https_proxy"):
    url = getEnv("https_proxy")
  elif existsEnv("HTTPS_PROXY"):
    url = getEnv("HTTPS_PROXY")
  elif existsEnv("http_proxy"):
    url = getEnv("http_proxy")
  elif existsEnv("HTTP_PROXY"):
    url = getEnv("HTTP_PROXY")

  return newProxy(url=url)

proc print_help() =
  echo("is-up - a quick 'is it up' website checker using isitup.org API.\n")
  echo("example: is-up www.google.com www.facebook.com")
  echo("Options:")
  echo("-h, --help: Print this message and exit")
  echo("<argument>: Up to N number of domains checked, in order.")

when isMainModule:
  if os.paramCount() < 1:
    stderr.writeLine("Please provide at least one argument.")
    print_help()
    system.quit(QuitFailure)

  var client = newHttpClient(proxy=getProxy())
  var emptyNoVal = initOptParser()
  for kind, key, val in emptyNoVal.getopt():
    case kind:
    of cmdShortOption, cmdLongOption:
      if key == "help" or key == "h":
        print_help()
        system.quit(QuitSuccess)
      else:
        stderr.writeLine("Unknown option: " & key)
        system.quit(QuitFailure)
    of cmdArgument:
      checkIsUp(client, key)
    else:
      doAssert(false, "An impossible state has been reached")
      system.quit(QuitFailure)