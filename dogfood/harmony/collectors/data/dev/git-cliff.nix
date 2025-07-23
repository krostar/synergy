{
  data,
  unit,
  ...
}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    dev.git-cliff = with lib.types; {
      enable = lib.mkEnableOption "git-cliff";
      settings = lib.mkOption {
        type = types.submodule {
          options = {
            changelog = lib.mkOption {
              default = null;
              description = "Changelog generation configuration.";
              type = lib.types.nullOr (lib.types.submodule {
                options = {
                  header = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "The changelog header template.";
                  };
                  body = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "The changelog body template.";
                  };
                  footer = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "The changelog footer template.";
                  };
                  trim = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                    description = "Trim whitespace from the changelog.";
                  };
                  output = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Path to the changelog output file.";
                  };
                  render_always = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                    description = "Render the changelog body even if there are no releases.";
                  };
                  postprocessors = lib.mkOption {
                    type = lib.types.nullOr (lib.types.listOf (lib.types.submodule {
                      options = {
                        pattern = lib.mkOption {
                          type = lib.types.str;
                          description = "The regex pattern to search for.";
                        };
                        replace = lib.mkOption {
                          type = lib.types.str;
                          description = "The replacement string.";
                        };
                      };
                    }));
                    default = null;
                  };
                  link_parsers = lib.mkOption {
                    type = lib.types.nullOr (lib.types.listOf (lib.types.submodule {
                      options = {
                        pattern = lib.mkOption {
                          type = lib.types.str;
                          description = "The regex pattern to find references.";
                        };
                        href = lib.mkOption {
                          type = lib.types.str;
                          description = "The destination URL.";
                        };
                        text = lib.mkOption {
                          type = lib.types.nullOr lib.types.str;
                          default = null;
                          description = "The text to display for the link.";
                        };
                      };
                    }));
                    default = null;
                  };
                };
              });
            };

            git = lib.mkOption {
              default = null;
              description = "Git-related configuration.";
              type = lib.types.nullOr (lib.types.submodule {
                options = {
                  conventional_commits = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                    description = "Enable parsing of conventional commits.";
                  };
                  require_conventional = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                    description = "Exit with a non-zero exit code if a commit is not conventional.";
                  };
                  filter_unconventional = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                    description = "Filter out unconventional commits.";
                  };
                  split_commits = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                    description = "Split commit messages into separate lines.";
                  };
                  commit_preprocessors = lib.mkOption {
                    type = lib.types.nullOr (lib.types.listOf (lib.types.submodule {
                      options = {
                        pattern = lib.mkOption {
                          type = lib.types.str;
                          description = "The regex pattern to search for in the commit message.";
                        };
                        replace = lib.mkOption {
                          type = lib.types.str;
                          description = "The replacement string.";
                        };
                      };
                    }));
                    default = null;
                  };
                  commit_parsers = lib.mkOption {
                    type = lib.types.nullOr (lib.types.listOf (lib.types.submodule {
                      options = {
                        message = lib.mkOption {
                          type = lib.types.nullOr lib.types.str;
                          default = null;
                          description = "Regex for the commit subject.";
                        };
                        body = lib.mkOption {
                          type = lib.types.nullOr lib.types.str;
                          default = null;
                          description = "Regex for the commit body.";
                        };
                        group = lib.mkOption {
                          type = lib.types.str;
                          description = "The group to assign the commit to.";
                        };
                        scope = lib.mkOption {
                          type = lib.types.nullOr lib.types.str;
                          default = null;
                          description = "The scope of the commit.";
                        };
                        skip = lib.mkOption {
                          type = lib.types.nullOr lib.types.bool;
                          default = null;
                          description = "If true, skips the commit entirely.";
                        };
                        breaking = lib.mkOption {
                          type = lib.types.nullOr lib.types.bool;
                          default = null;
                          description = "If true, marks the commit as a breaking change.";
                        };
                      };
                    }));
                    default = null;
                  };
                  protect_breaking_commits = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                    description = "Prevent breaking change commits from being grouped.";
                  };
                  filter_commits = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                    description = "Filter out commits that are not part of any group.";
                  };
                  tag_pattern = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Regex for matching git tags.";
                  };
                  skip_tags = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Regex for skipping git tags.";
                  };
                  ignore_tags = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Regex for ignoring git tags.";
                  };
                  topo_order = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                    description = "Sort commits in topological order.";
                  };
                  sort_commits = lib.mkOption {
                    type = lib.types.nullOr (lib.types.enum ["newest" "oldest"]);
                    default = null;
                    description = "Commit sorting order.";
                  };
                  latest_tag = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Force a specific tag to be considered the latest.";
                  };
                  ignore_paths = lib.mkOption {
                    type = lib.types.nullOr (lib.types.listOf lib.types.str);
                    default = null;
                    description = "Ignore commits that only modify specified paths.";
                  };
                  breaking_pattern = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Regex to identify breaking changes in commit messages.";
                  };
                  recurse_submodules = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                    description = "Recurse into submodules to process their commits.";
                  };
                };
              });
            };

            remote = lib.mkOption {
              default = null;
              description = "Remote Git provider configuration for link generation.";
              type = lib.types.nullOr (lib.types.submodule {
                options = {
                  github = lib.mkOption {
                    type = lib.types.nullOr (lib.types.submoduleWith {
                      modules = [
                        {
                          options = {
                            owner = lib.mkOption {type = lib.types.str;};
                            repo = lib.mkOption {type = lib.types.str;};
                            token = lib.mkOption {
                              type = lib.types.nullOr lib.types.str;
                              default = null;
                            };
                          };
                        }
                      ];
                    });
                    default = null;
                  };
                  gitlab = lib.mkOption {
                    type = lib.types.nullOr (lib.types.submoduleWith {
                      modules = [
                        {
                          options = {
                            owner = lib.mkOption {type = lib.types.str;};
                            repo = lib.mkOption {type = lib.types.str;};
                            token = lib.mkOption {
                              type = lib.types.nullOr lib.types.str;
                              default = null;
                            };
                            api_url = lib.mkOption {
                              type = lib.types.nullOr lib.types.str;
                              default = null;
                            };
                            native_tls = lib.mkOption {
                              type = lib.types.nullOr lib.types.bool;
                              default = null;
                            };
                            branch = lib.mkOption {
                              type = lib.types.nullOr lib.types.str;
                              default = null;
                            };
                          };
                        }
                      ];
                    });
                    default = null;
                  };
                  gitea = lib.mkOption {
                    type = lib.types.nullOr (lib.types.submoduleWith {
                      modules = [
                        {
                          options = {
                            owner = lib.mkOption {type = lib.types.str;};
                            repo = lib.mkOption {type = lib.types.str;};
                            token = lib.mkOption {
                              type = lib.types.nullOr lib.types.str;
                              default = null;
                            };
                            api_url = lib.mkOption {
                              type = lib.types.nullOr lib.types.str;
                              default = null;
                            };
                            native_tls = lib.mkOption {
                              type = lib.types.nullOr lib.types.bool;
                              default = null;
                            };
                          };
                        }
                      ];
                    });
                    default = null;
                  };
                  bitbucket = lib.mkOption {
                    type = lib.types.nullOr (lib.types.submoduleWith {
                      modules = [
                        {
                          options = {
                            owner = lib.mkOption {type = lib.types.str;};
                            repo = lib.mkOption {type = lib.types.str;};
                            token = lib.mkOption {
                              type = lib.types.nullOr lib.types.str;
                              default = null;
                            };
                          };
                        }
                      ];
                    });
                    default = null;
                  };
                };
              });
            };

            bump = lib.mkOption {
              default = null;
              description = "Version bumping configuration.";
              type = lib.types.nullOr (lib.types.submodule {
                options = {
                  initial_tag = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "The initial tag to use for the first bump.";
                  };
                  features_always_bump_minor = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                    description = "Always bump minor version for new features.";
                  };
                  breaking_always_bump_major = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                    description = "Always bump major version for breaking changes.";
                  };
                  custom_major_increment_regex = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Regex for custom commits that increment the major version.";
                  };
                  custom_minor_increment_regex = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Regex for custom commits that increment the minor version.";
                  };
                  bump_type = lib.mkOption {
                    type = lib.types.nullOr (lib.types.enum ["major" "minor" "patch"]);
                    default = null;
                    description = "Force a specific bump type.";
                  };
                  files = lib.mkOption {
                    type = lib.types.nullOr (lib.types.listOf (lib.types.submodule {
                      options = {
                        path = lib.mkOption {
                          type = lib.types.str;
                          description = "Path to the file.";
                        };
                        pattern = lib.mkOption {
                          type = lib.types.str;
                          description = "Regex to find the version, must contain a `version` named capture group.";
                        };
                        env = lib.mkOption {
                          type = lib.types.nullOr lib.types.str;
                          default = null;
                          description = "Environment variable containing the new content.";
                        };
                        replace = lib.mkOption {
                          type = lib.types.nullOr lib.types.str;
                          default = null;
                          description = "The new content to write.";
                        };
                        pre_bump = lib.mkOption {
                          type = lib.types.nullOr lib.types.bool;
                          default = null;
                          description = "Pre-fill the version for the new version.";
                        };
                      };
                    }));
                    default = null;
                  };
                };
              });
            };

            github = lib.mkOption {
              default = null;
              description = "GitHub release integration settings.";
              type = lib.types.nullOr (lib.types.submodule {
                options = {
                  release_branch = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Target branch for the release PR.";
                  };
                  release_pr_title = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Title of the release PR.";
                  };
                  release_body = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Body of the release PR.";
                  };
                  release_draft = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                    description = "Create the GitHub release as a draft.";
                  };
                  release_prerelease = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                    description = "Mark the GitHub release as a pre-release.";
                  };
                  release_replace = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                    description = "Replace an existing release.";
                  };
                  release_name = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Template for the release name.";
                  };
                };
              });
            };

            gitlab = lib.mkOption {
              default = null;
              description = "GitLab release integration settings.";
              type = lib.types.nullOr (lib.types.submodule {
                options = {
                  release_description = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Template for the GitLab release description.";
                  };
                  release_milestones = lib.mkOption {
                    type = lib.types.nullOr (lib.types.listOf lib.types.str);
                    default = null;
                    description = "List of milestones to associate with the release.";
                  };
                  release_assets = lib.mkOption {
                    type = lib.types.nullOr (lib.types.listOf (lib.types.submodule {
                      options = {
                        name = lib.mkOption {type = lib.types.str;};
                        url = lib.mkOption {
                          type = lib.types.nullOr lib.types.str;
                          default = null;
                        };
                        filepath = lib.mkOption {
                          type = lib.types.nullOr lib.types.str;
                          default = null;
                        };
                        link_type = lib.mkOption {
                          type = lib.types.nullOr (lib.types.enum ["other" "image" "package"]);
                          default = null;
                        };
                      };
                    }));
                    default = null;
                    description = "List of assets to attach to the GitLab release.";
                  };
                };
              });
            };
          };
        };
        default = {};
        apply = unit.lib.attrsets.removeNullOrEmptyAttrs;
      };
    };
  });
}
