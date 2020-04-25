# Package

version       = "1.0.0"
author        = "Tyler Stubenvoll"
description   = "A commandline tool for checking if a domain is up."
license       = "GPL-3.0"
srcDir        = "src"
bin           = @["isup"]

backend       = "cpp"

# Dependencies

requires "nim >= 1.2.0"
