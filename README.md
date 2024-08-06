# Synergy

Synergy is a nix flake framework.

Its goal is to provide a set of rules (or constraints) that allow code maintainers to code in an organized way, ideally more maintainable than without using it.

Synergy is designed to simplify and streamline the process of configuring systems, development environments, and any other nix related projects using a modular approach. It provides a structured way to organize and manage configurations, making them more maintainable, reusable, and scalable in growing projects.

Synergy encourages breaking down configurations into smaller, self-contained units. Each units then define modules (like packages, or dev shells, or nixos configurations, ...), or reuse / combine them from other units.
