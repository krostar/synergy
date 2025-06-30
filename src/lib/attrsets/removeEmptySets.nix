{lib}:
# This function implements a cleaning algorithm that recursively traverses nested
# attribute set structures and removes all empty attribute sets while preserving
# the overall hierarchy and all meaningful content. It's designed to eliminate
# structural noise from complex nested configurations.
#
# Examples:
#     removeEmptySets {
#       services = {
#         web = { port = 80; ssl = {}; };
#         api = {};
#         database = {
#           primary = { host = "localhost"; };
#           replica = {};
#         };
#       };
#       monitoring = {};
#     }
#     => {
#          services = {
#            web = { port = 80; };
#            database = {
#              primary = { host = "localhost"; };
#            };
#          };
#        }
attr: let
  cleanAttrs = attrs:
    lib.attrsets.filterAttrs (_: v: v != {}) (
      lib.attrsets.mapAttrs (
        _: value:
          if builtins.isAttrs value && !lib.attrsets.isDerivation value
          then cleanAttrs value
          else value
      )
      attrs
    );
in
  cleanAttrs attr
