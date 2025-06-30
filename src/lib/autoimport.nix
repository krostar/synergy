{root}:
# This is a high-level convenience function that combines source collection and
# module importing into a single operation. It automatically discovers all valid
# Nix modules from the specified source path and imports them with the provided
# arguments, handling the complete pipeline from filesystem discovery to
# instantiated modules.
#
# The function internally orchestrates two key operations:
# 1. Source Collection - Uses root.modules.collect to discover and filter sources
# 2. Module Import - Uses root.modules.import to load and instantiate modules
#
# This abstraction is particularly useful for scenarios where you want to disable
# synergy automatic import (for instance with a default.nix file), but still want
# to imports files or directory below the default.nix file tree.
#
# Parameters:
#   args - Arguments to pass to imported modules during instantiation
#
#   source - Filesystem path to collect and import modules from
#            Can be a directory (recursive import) or single file
#
#   squash - Optional boolean controlling result organization (default: false)
#            false: Preserve nested directory structure in results
#            true: Flatten all modules into a single attribute set level
#            Squashing is useful when directory organization is for convenience
#            but you want the final result to be flat
#
# Examples:
#   within synergy sources, with this layout
#   $src/myunit/mymodule/
#     default.nix
#     mydir/
#       a.nix
#       b.nix
#
#   in default.nix, you can still autoimport mydir using
#   {synergy-lib, ...} @ args: {
#     keyofchoice = synergy-lib.autoimport {
#       inherit args;
#       source = ./mydir;
#     };
#   }
{
  args, # arguments to provide to all imported modules during instantiation
  source, # filesystem path (directory or file) to collect modules from
  squash ? false, # whether to flatten the result structure (false = preserve hierarchy)
}: (root.modules.import {
  source = root.modules.collect source;
  inherit squash args;
})
