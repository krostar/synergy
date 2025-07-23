#PostProcessor: {pattern: string, replace: string}
#LinkParser: {pattern: string, href: string, text?: string}
#CommitPreProcessor: {pattern: string, replace: string}
#CommitParser: {message?: string, body?: string, group: string, scope?: string, skip?: bool, breaking?: bool}
#BumpFile: {path: string, pattern: string, env?: string, replace?: string, pre_bump?: bool}
#GitLabAsset: {name: string, url?: string, filepath?: string, link_type?: "other" | "image" | "package"}

changelog?: {
	header?:        string
	body?:          string
	footer?:        string
	trim?:          bool
	output?:        string
	render_always?: bool
	postprocessors?: [...#PostProcessor]
	link_parsers?: [...#LinkParser]
}

git?: {
	conventional_commits?:  bool
	filter_unconventional?: bool
	require_conventional?:  bool
	split_commits?:         bool
	commit_preprocessors?: [...#CommitPreProcessor]
	commit_parsers?: [...#CommitParser]
	protect_breaking_commits?: bool
	filter_commits?:           bool
	tag_pattern?:              string
	skip_tags?:                string
	ignore_tags?:              string
	topo_order?:               bool
	sort_commits?:             string | "newest" | "oldest"
	latest_tag?:               string
	ignore_paths?: [...string]
	breaking_pattern?:   string
	recurse_submodules?: bool
}

remote?: {
	github?: {owner: string, repo: string, token?: string}
	gitlab?: {owner: string, repo: string, token?: string, api_url?: string, native_tls?: bool, branch?: string}
	gitea?: {owner: string, repo: string, token?: string, api_url?: string, native_tls?: bool}
	bitbucket?: {owner: string, repo: string, token?: string}
}

bump?: {
	initial_tag?:                  string
	features_always_bump_minor?:   bool
	breaking_always_bump_major?:   bool
	custom_major_increment_regex?: string
	custom_minor_increment_regex?: string
	bump_type?:                    "major" | "minor" | "patch"
	files?: [...#BumpFile]
}

github?: {
	release_branch?:     string
	release_pr_title?:   string
	release_body?:       string
	release_draft?:      bool
	release_prerelease?: bool
	release_replace?:    bool
	release_name?:       string
}

gitlab?: {
	release_description?: string
	release_milestones?: [...string]
	release_assets?: [...#GitLabAsset]
}
