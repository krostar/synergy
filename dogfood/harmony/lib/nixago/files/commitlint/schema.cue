import "list"

@jsonschema(schema="http://json-schema.org/draft-07/schema#")
@jsonschema(id="https://json.schemastore.org/commitlintrc.json")
null | bool | number | string | [...] | {
	// Resolvable ids to commitlint configurations to extend
	extends?: matchN(1, [[...string], string])

	// Resolvable id to conventional-changelog parser preset to import
	// and use
	parserPreset?: matchN(1, [string, close({
		name?:       string
		path?:       string
		parserOpts?: _
	})])

	// Custom URL to show upon failure
	helpUrl?: string

	// Resolvable id to package, from node_modules, which formats the
	// output
	formatter?: string

	// Rules to check against
	rules?: {
		...
	} & {
		[string]: #rule
	}

	// Resolvable ids of commitlint plugins from node_modules
	plugins?: [...string]

	// Additional commits to ignore, defined by ignore matchers
	ignores?: [...]

	// Whether commitlint uses the default ignore rules
	defaultIgnores?: bool
	...
}

#rule: list.MaxItems(3) & [0 | 1 | 2, "always" | "never", _] & [_, _, ...]
