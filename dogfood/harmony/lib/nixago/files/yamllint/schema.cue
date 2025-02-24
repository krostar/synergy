// yamllint
//
// yamllint uses a set of rules to check source files for
// problems.
@jsonschema(schema="http://json-schema.org/draft-04/schema#")
@jsonschema(id="https://json.schemastore.org/yamllint.json")

{
	#ignore

	// Extends
	extends?: string

	// YAML Files
	"yaml-files"?: [...string] | *["*.yaml", "*.yml", ".yamllint"]

	// Locale
	//
	// This is passed to Python's locale.setlocale.
	locale?: string
	rules?: null | {
		// Braces
		//
		// Use this rule to control the use of flow mappings or number of
		// spaces inside braces ({ and }).
		braces?: (#toggle | bool | #allRules & {
			// Forbid
			//
			// Used to forbid the use of flow mappings which are denoted by
			// surrounding braces ({ and }).
			forbid?: (bool | "non-empty") & (bool | string) | *false

			// Minimum Spaces Inside
			//
			// Defines the minimal number of spaces required inside braces.
			"min-spaces-inside"?: number | *0

			// Max Spaces Inside
			//
			// Defines the maximal number of spaces allowed inside braces.
			"max-spaces-inside"?: number | *0

			// Minimum Spaces Inside Empty
			//
			// Defines the minimal number of spaces required inside empty
			// braces.
			"min-spaces-inside-empty"?: number | *-1

			// Max Spaces Inside Empty
			//
			// Defines the maximal number of spaces allowed inside empty
			// braces.
			"max-spaces-inside-empty"?: number | *-1
			...
		}) & _ | *"enable"

		// Brackets
		//
		// Use this rule to control the use of flow sequences or the
		// number of spaces inside brackets ([ and ]).
		brackets?: (#toggle | bool | #allRules & {
			// Forbid
			//
			// Used to forbid the use of flow sequences which are denoted by
			// surrounding brackets ([ and ]).
			forbid?: (bool | "non-empty") & (bool | string) | *false

			// Minimum Spaces Inside
			//
			// Defines the minimal number of spaces required inside brackets.
			"min-spaces-inside"?: number | *0

			// Max Spaces Inside
			//
			// Defines the maximal number of spaces allowed inside brackets.
			"max-spaces-inside"?: number | *0

			// Minimum Spaces Inside Empty
			//
			// Defines the minimal number of spaces required inside empty
			// brackets.
			"min-spaces-inside-empty"?: number | *-1

			// Max Spaces Inside Empty
			//
			// Defines the maximal number of spaces allowed inside empty
			// brackets.
			"max-spaces-inside-empty"?: number | *-1
			...
		}) & _ | *"enable"

		// Colons
		//
		// Use this rule to control the number of spaces before and after
		// colons (:).
		colons?: (#toggle | bool | #allRules & {
			// Max Spaces Before
			//
			// Defines the maximal number of spaces allowed before colons (use
			// -1 to disable).
			"max-spaces-before"?: number | *0

			// Max Spaces After
			//
			// Defines the maximal number of spaces allowed after colons (use
			// -1 to disable).
			"max-spaces-after"?: number | *1
			...
		}) & _ | *"enable"

		// Commas
		//
		// Use this rule to control the number of spaces before and after
		// commas (,).
		commas?: (#toggle | bool | #allRules & {
			// Max Spaces Before
			//
			// Defines the maximal number of spaces allowed before commas (use
			// -1 to disable).
			"max-spaces-before"?: number | *0

			// Minimum Spaces After
			//
			// Defines the minimal number of spaces required after commas.
			"min-spaces-after"?: number | *1

			// Max Spaces After
			//
			// Defines the maximal number of spaces allowed after commas (use
			// -1 to disable).
			"max-spaces-after"?: number | *1
			...
		}) & _ | *"enable"

		// Comments
		//
		// Use this rule to control the position and formatting of
		// comments.
		comments?: (#toggle | bool | #allRules & {
			// Require Starting Space
			//
			// Require a space character right after the #.
			"require-starting-space"?: bool | *true

			// Ignore Shebangs
			//
			// Ignore a shebang at the beginning of the file when
			// require-starting-space is set.
			"ignore-shebangs"?: bool | *true

			// Minimum Spaces from Content
			//
			// Used to visually separate inline comments from content.
			"min-spaces-from-content"?: number | *2
			...
		}) & _ | *{
			level: "warning"
			...
		}

		// Comments Indentation
		//
		// Use this rule to force comments to be indented like content.
		"comments-indentation"?: (#toggle | bool | #allRules) & _ | *{
			level: "warning"
			...
		}

		// Document End
		//
		// Use this rule to require or forbid the use of document end
		// marker (...).
		"document-end"?: (#toggle | bool | #allRules & {
			// Present
			//
			// True when the document end marker is required, or to false when
			// it is forbidden.
			present?: bool | *true
			...
		}) & _ | *"disable"

		// Document Start
		//
		// Use this rule to require or forbid the use of document start
		// marker (---).
		"document-start"?: (#toggle | bool | #allRules & {
			// Present
			//
			// True when the document start marker is required, or to false
			// when it is forbidden.
			present?: bool | *true
			...
		}) & _ | *{
			level: "warning"
			...
		}

		// Empty Lines
		//
		// Use this rule to set a maximal number of allowed consecutive
		// blank lines.
		"empty-lines"?: (#toggle | bool | #allRules & {
			// Max
			//
			// Defines the maximal number of empty lines allowed in the
			// document.
			max?: number | *2

			// Max Start
			//
			// Defines the maximal number of empty lines allowed at the
			// beginning of the file.
			"max-start"?: number | *0

			// Max End
			"max-end"?: number | *0
			...
		}) & _ | *"enable"

		// Empty Values
		//
		// Use this rule to prevent nodes with empty content, that
		// implicitly result in null values.
		"empty-values"?: (#toggle | bool | #allRules & {
			// Forbid in Block Mappings
			//
			// Prevent empty values in block mappings.
			"forbid-in-block-mappings"?: bool | *true

			// Forbid in Flow Mappings
			//
			// Prevent empty values in flow mappings.
			"forbid-in-flow-mappings"?: bool | *true
			...
		}) & _ | *"disable"

		// Hyphens
		//
		// Use this rule to control the number of spaces after hyphens
		// (-).
		hyphens?: (#toggle | bool | #allRules & {
			// Max Spaces After
			//
			// Defines the maximal number of spaces allowed after hyphens.
			"max-spaces-after"?: number | *1
			...
		}) & _ | *"enable"

		// Indentation
		//
		// Use this rule to control the indentation.
		indentation?: (#toggle | bool | #allRules & {
			// Spaces
			//
			// Defines the indentation width, in spaces.
			spaces?: (number | "consistent") & (number | string) | *"consistent"

			// Indent Sequences
			//
			// Defines whether block sequences should be indented or not (when
			// in a mapping, this indentation is not mandatory – some people
			// perceive the - as part of the indentation).
			"indent-sequences"?: (bool | ("whatever" | "consistent")) & (bool | string) | *true

			// Check Multi Line Strings
			//
			// Defines whether to lint indentation in multi-line strings.
			"check-multi-line-strings"?: bool | *false
			...
		}) & _ | *"enable"

		// Key Duplicates
		//
		// Use this rule to prevent multiple entries with the same key in
		// mappings.
		"key-duplicates"?: (#toggle | bool | #allRules) & _ | *"enable"

		// Key Ordering
		//
		// Use this rule to enforce alphabetical ordering of keys in
		// mappings.
		"key-ordering"?: (#toggle | bool | #allRules) & _ | *"disable"

		// Line Length
		//
		// Use this rule to set a limit to lines length.
		"line-length"?: (#toggle | bool | #allRules & {
			// Max
			//
			// Defines the maximal (inclusive) length of lines.
			max?: number | *80

			// Allow Non-Breakable Words
			//
			// Used to allow non breakable words (without spaces inside) to
			// overflow the limit.
			"allow-non-breakable-words"?: bool | *true

			// Allow Non-Breakable Inline Mappings
			//
			// Implies allow-non-breakable-words and extends it to also allow
			// non-breakable words in inline mappings.
			"allow-non-breakable-inline-mappings"?: bool | *true
			...
		}) & _ | *"enable"

		// New Line at End of File
		//
		// Use this rule to require a new line character (
		// ) at the end of files.
		"new-line-at-end-of-file"?: (#toggle | bool | #allRules) & _ | *"enable"

		// New Lines
		//
		// Use this rule to force the type of new line characters.
		"new-lines"?: (#toggle | bool | #allRules & {
			// Type
			//
			// Unix to use UNIX-typed new line characters (
			// ), or dos to use DOS-typed new line characters (
			// ).
			type?: "unix" | "dos" | "platform" | *"unix"
			...
		}) & _ | *"enable"

		// Octal Values
		//
		// Use this rule to prevent values with octal numbers.
		"octal-values"?: (#toggle | bool | #allRules & {
			// Forbid Implicit Octal
			//
			// Prevent numbers starting with 0.
			"forbid-implicit-octal"?: bool | *true

			// Forbid Explicit Octal
			//
			// Prevent numbers starting with 0o.
			"forbid-explicit-octal"?: bool | *true
			...
		}) & _ | *"disable"

		// Quoted Strings
		//
		// Use this rule to forbid any string values that are not quoted,
		// or to prevent quoted strings without needing it.
		"quoted-strings"?: (#toggle | bool | #allRules & {
			// Quote Type
			//
			// Defines allowed quotes.
			"quote-type"?: "single" | "double" | "any" | *"any"

			// Required
			//
			// Defines whether using quotes in string values is required.
			required?: (bool | "only-when-needed") & (bool | string) | *true

			// Extra Required
			//
			// List of PCRE regexes to force string values to be quoted, if
			// they match any regex.
			"extra-required"?: [...string]

			// Extra Allowed
			//
			// List of PCRE regexes to allow quoted string values, even if
			// required: only-when-needed is set.
			"extra-allowed"?: [...string]
			...
		}) & _ | *"disable"

		// Tailing Spaces
		//
		// Use this rule to forbid trailing spaces at the end of lines.
		"trailing-spaces"?: (#toggle | bool | #allRules) & _ | *"enable"

		// Truthy
		//
		// Use this rule to forbid non-explictly typed truthy values other
		// than allowed ones (by default: true and false), for example
		// YES or off.
		truthy?: (#toggle | bool | #allRules & {
			// Allowed Values
			//
			// Defines the list of truthy values which will be ignored during
			// linting.
			"allowed-values"?: [..."TRUE" | "True" | "true" | "FALSE" | "False" | "false" | "YES" | "Yes" | "yes" | "NO" | "No" | "no" | "ON" | "On" | "on" | "OFF" | "Off" | "off"] | *["true", "false"]

			// Check Keys
			//
			// Disables verification for keys in mappings.
			"check-keys"?: bool | *true
			...
		}) & _ | *{
			level: "warning"
			...
		}
		...
	}
}

#ignore: {
	"ignore"?: string | [...string]
} | {
	"ignore-from-file"?: string | [...string]
}

#toggle: "enable" | "disable"

#allRules: {
	// Level
	level?: string | *"warning"
	ignore?: string | [...string]
	...
}
