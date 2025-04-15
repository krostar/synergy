# Troubleshooting

This guide helps you diagnose and fix common issues with Synergy.

## Missing source directory

**Error:**

```
Error in readSource: Directory does not exist: /path/to/nonexistent/directory
```

**Solution:**
Verify that the `src` parameter in your flake.nix points to an existing directory.
If you're using a relative path (e.g., `./nix`), make sure it's relative to your flake.nix file.

```nix
# Correct:
{
  outputs = {synergy, ...}: {
    inherit (synergy.lib.mkFlake {
      inherit inputs;
      src = ./nix;  # This directory must exist
    });
  };
}
```

## Access to pkgs

**Error:**

```
the pkgs attribute is only available in systemized result
```

**Solution:**
This error occurs when trying to access `pkgs` in a systemless context. Make sure you're:

1. Using a systemized result when accessing `pkgs`
1. Not accessing `pkgs` directly in a systemless context

Example of correct usage:

```nix
# In a unit module (will receive pkgs in systemized context)
{pkgs, ...}: {
  # Use pkgs here
}

# In a systemless context, access pkgs via results
{results, ...}: {
  # Use results.x86_64-linux.pkgs
}
```

## Dependency cycles

**Error:**

```
infinite recursion encountered
```

**Solution:**
This usually means there's a circular dependency between modules:

1. Check if module A depends on module B, which depends on module A
1. Refactor your modules to break the dependency cycle
1. Consider using a higher-level unit to coordinate between dependent modules

## Getting help

If you're still having trouble:

1. Check the README and other documentation
1. Look at the examples in the repository
1. Open an issue on GitHub with:
  - A minimal reproduction of the issue
  - Expected vs. actual behavior
  - Error messages and relevant code
