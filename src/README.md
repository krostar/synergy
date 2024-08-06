# Synergy: A Nix Framework for modular and reusable configuration
Synergy is designed to simplify and streamline the process of configuring systems, development environments, and any other nix related projects using a modular approach. It provides a structured way to organize and manage configurations, making them more maintainable, reusable, and scalable in growing projects.

Synergy encourages breaking down configurations into smaller, self-contained units. Each units then define modules (like packages, or dev shells, or nixos configurations, ...), or reuse / combine them from other units.

Modules are defined in Nix expression files and loaded dynamically, allowing for flexible organization and code reuse.

## Library
The lib directory contains the core functionality of Synergy, including:

- Module loading and evaluation: functions for loading, evaluating, and managing module along with their dependencies.
- Source management: utilities for collecting, filtering, and processing source files.
- Attribute set manipulation: helper functions for working with Nix attribute sets, such as merging, filtering, and renaming keys.

## Collectors
The collectors directory houses nix modules responsible for gathering specific configuration and simplify the process of aggregating configuration data from different units/modules into a unified result.
