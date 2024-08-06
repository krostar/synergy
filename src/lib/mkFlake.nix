{super}:
/*
Evaluates Synergy modules and returns only the flake output.
*/
args: (super.modules.eval args).config.flake
