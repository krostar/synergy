{super}:
# This is the main entry point for using Synergy in a Nix flake. It provides a
# streamlined interface that handles the complete Synergy evaluation pipeline
# and extracts the flake outputs in a format ready for direct use in flake
# outputs functions.
#
# The function orchestrates several key operations:
# 1. configuration processing - handles flake inputs and evaluation parameters
# 2. source collection - discovers and processes Synergy source modules
# 3. module evaluation - runs the complete Synergy evaluation pipeline
# 4. output extraction - extracts flake outputs from the evaluation
#
# Integration Philosophy:
# This function is designed to make Synergy adoption as seamless as possible
# for existing Nix flake users. It requires minimal changes to flake.nix files
# while providing access to Synergy's full capabilities for configuration management,
# build orchestration, and cross-system dependencies.
#
# The function abstracts away all Synergy-specific concepts (collectors, modules,
# evaluation contexts) and presents a familiar flake-oriented interface that
# integrates naturally with existing Nix workflows.
#
# Parameters:
#   inputs - Flake inputs attribute set (required)
#         Must include 'self' and any dependencies referenced by modules
#         Typically passed directly from the flake's outputs function
#         Used for dependency resolution and flake context
#
#   src - Path to Synergy sources directory (optional)
#         Directory containing the Synergy module sources to evaluate
#         If null, evaluation will proceed with empty sources
#         Typically points to a subdirectory of the flake root
#
#   eval - Inline module configuration (optional, default: {})
#         Additional module configuration to merge with collected sources
#         Useful for overrides, quick configuration, or computed values
#         Takes precedence over collected module configurations
#
#   collectors - List of collector modules to use (optional)
#         Custom collectors for specialized source discovery patterns
#         Defaults to standard Synergy collectors if not specified
#         Advanced feature for extending source collection behavior
#
# Examples:
#     outputs = { synergy, ... } @ inputs: synergy.lib.mkFlake {
#       inherit inputs;
#       src = ./synergy;
#     };
args:
(super.modules.eval args).config.flake
