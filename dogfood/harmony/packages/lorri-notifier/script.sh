#!/bin/sh

lorri internal stream-events --kind live |
  jq --unbuffered '(
    (.Started?   | values | "Build starting in \(.nix_file)"),
    (.Completed? | values | "Build complete in \(.nix_file)"),
    (.Failure?   | values | "Build failed in \(.nix_file)")
  )' |
  xargs --no-run-if-empty --replace \
    terminal-notifier -title Lorri -group lorri-events -message "{}" -contentImage "$ICON"
