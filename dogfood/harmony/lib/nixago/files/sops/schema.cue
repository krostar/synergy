creation_rules?: [..._#creationRule]
destination_rules?: [..._#destinationRule]
stores?: {
	dotenv?: {}
	ini?: {}
	json_binary?: {indent: int}
	json?: {indent: int}
	yaml?: {indent: int}
}

_#creationRule: {
	age?:                     string
	aws_profile?:             string
	azure_keyvault?:          string
	encrypted_comment_regex?: string
	encrypted_regex?:         string
	encrypted_suffix?:        string
	gcp_kms?:                 string
	hc_vault_transit_uri?:    string
	key_groups?: [..._#keyGroup]
	KMS?:                       string
	mac_only_encrypted?:        bool
	path_regex?:                string
	PGP?:                       string
	shamir_threshold?:          int
	unencrypted_comment_regex?: string
	unencrypted_regex?:         string
	unencrypted_suffix?:        string
}

_#destinationRule: {
	gcs_bucket?:          string
	gcs_prefix?:          string
	omit_extensions?:     bool
	path_regex?:          string
	recreation_rule?:     _#creationRule
	s3_bucket?:           string
	s3_prefix?:           string
	vault_address?:       string
	vault_kv_mount_name?: string
	vault_kv_version?:    int
	vault_path?:          string
}

_#keyGroup: {
	age?: [...string]
	azure_keyvault?: [..._#azureKVKey]
	gcp_kms?: [..._#gcpKmsKey]
	hc_vault?: [...string]
	KMS?: [..._#kmsKey]
	Merge?: [..._#keyGroup]
	PGP?: [...string]
}

_#kmsKey: {
	aws_profile: string
	arn:         string
	context: {[string]: null | string}
	role?: string
}

_#gcpKmsKey: {
	resource_id: string
}

_#azureKVKey: {
	key:      string
	vaultUrl: string
	version:  string
}
