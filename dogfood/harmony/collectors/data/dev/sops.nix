{data, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    dev.sops = {
      creation_rules = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule {
          options = {
            age = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Age key specification";
            };

            aws_profile = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "AWS profile to use";
            };

            azure_keyvault = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Azure Key Vault specification";
            };

            encrypted_comment_regex = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Regex for encrypted comments";
            };

            encrypted_regex = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Regex for encrypted content";
            };

            encrypted_suffix = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Suffix for encrypted files";
            };

            gcp_kms = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "GCP KMS specification";
            };

            hc_vault_transit_uri = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "HashiCorp Vault transit URI";
            };

            key_groups = lib.mkOption {
              type = lib.types.listOf (lib.types.submodule {
                options = {
                  age = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    default = [];
                    description = "Age keys";
                  };

                  azure_keyvault = lib.mkOption {
                    type = lib.types.listOf (lib.types.submodule {
                      options = {
                        key = lib.mkOption {
                          type = lib.types.str;
                          description = "Azure Key Vault key name";
                        };

                        vaultUrl = lib.mkOption {
                          type = lib.types.str;
                          description = "Azure Key Vault URL";
                        };

                        version = lib.mkOption {
                          type = lib.types.str;
                          description = "Key version";
                        };
                      };
                    });
                    default = [];
                    description = "Azure Key Vault keys";
                  };

                  gcp_kms = lib.mkOption {
                    type = lib.types.listOf (lib.types.submodule {
                      options = {
                        resource_id = lib.mkOption {
                          type = lib.types.str;
                          description = "GCP KMS resource ID";
                        };
                      };
                    });
                    default = [];
                    description = "GCP KMS keys";
                  };

                  hc_vault = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    default = [];
                    description = "HashiCorp Vault keys";
                  };

                  KMS = lib.mkOption {
                    type = lib.types.listOf (lib.types.submodule {
                      options = {
                        aws_profile = lib.mkOption {
                          type = lib.types.str;
                          description = "AWS profile";
                        };

                        arn = lib.mkOption {
                          type = lib.types.str;
                          description = "KMS key ARN";
                        };

                        context = lib.mkOption {
                          type = lib.types.attrsOf (lib.types.nullOr lib.types.str);
                          default = {};
                          description = "Encryption context";
                        };

                        role = lib.mkOption {
                          type = lib.types.nullOr lib.types.str;
                          default = null;
                          description = "IAM role to assume";
                        };
                      };
                    });
                    default = [];
                    description = "AWS KMS keys";
                  };

                  Merge = lib.mkOption {
                    type = lib.types.listOf lib.types.attrs;
                    default = [];
                    description = "Key groups to merge";
                  };

                  PGP = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    default = [];
                    description = "PGP keys";
                  };
                };
              });
              default = [];
              description = "Key groups for this creation rule";
            };

            KMS = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "KMS key specification";
            };

            mac_only_encrypted = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = null;
              description = "Whether to only encrypt MAC";
            };

            path_regex = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Path regex for this rule";
            };

            PGP = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "PGP key specification";
            };

            shamir_threshold = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
              description = "Shamir secret sharing threshold";
            };

            unencrypted_comment_regex = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Regex for unencrypted comments";
            };

            unencrypted_regex = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Regex for unencrypted content";
            };

            unencrypted_suffix = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Suffix for unencrypted files";
            };
          };
        });
        default = [];
        description = "SOPS creation rules";
      };

      destination_rules = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule {
          options = {
            gcs_bucket = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "GCS bucket for destination";
            };

            gcs_prefix = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "GCS prefix for destination";
            };

            omit_extensions = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = null;
              description = "Whether to omit file extensions";
            };

            path_regex = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Path regex for this destination rule";
            };

            recreation_rule = lib.mkOption {
              type = lib.types.nullOr lib.types.attrs;
              default = null;
              description = "Recreation rule (references creation rule structure)";
            };

            s3_bucket = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "S3 bucket for destination";
            };

            s3_prefix = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "S3 prefix for destination";
            };

            vault_address = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Vault address";
            };

            vault_kv_mount_name = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Vault KV mount name";
            };

            vault_kv_version = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
              description = "Vault KV version";
            };

            vault_path = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Vault path";
            };
          };
        });
        default = [];
        description = "SOPS destination rules";
      };

      stores = lib.mkOption {
        type = lib.types.submodule {
          options = {
            dotenv = lib.mkOption {
              type = lib.types.nullOr lib.types.attrs;
              default = null;
              description = "Dotenv store configuration";
            };

            ini = lib.mkOption {
              type = lib.types.nullOr lib.types.attrs;
              default = null;
              description = "INI store configuration";
            };

            json_binary = lib.mkOption {
              type = lib.types.nullOr (lib.types.submodule {
                options = {
                  indent = lib.mkOption {
                    type = lib.types.int;
                    description = "JSON binary indentation";
                  };
                };
              });
              default = null;
              description = "JSON binary store configuration";
            };

            json = lib.mkOption {
              type = lib.types.nullOr (lib.types.submodule {
                options = {
                  indent = lib.mkOption {
                    type = lib.types.int;
                    description = "JSON indentation";
                  };
                };
              });
              default = null;
              description = "JSON store configuration";
            };

            yaml = lib.mkOption {
              type = lib.types.nullOr (lib.types.submodule {
                options = {
                  indent = lib.mkOption {
                    type = lib.types.int;
                    description = "YAML indentation";
                  };
                };
              });
              default = null;
              description = "YAML store configuration";
            };
          };
        };
        default = {};
        description = "SOPS stores configuration";
      };
    };
  });
}
