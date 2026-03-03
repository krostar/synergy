// yamllint
//
// yamllint uses a set of rules to check YAML source files for
// problems.

import (
	"regexp"
	"list"
)

@jsonschema(schema="https://json-schema.org/draft/2020-12/schema")
@jsonschema(id="https://json.schemastore.org/yamllint.json")
#ignorable & {
	// When writing a custom configuration file, you don’t need to
	// redefine every rule. Just extend the default configuration (or
	// any already-existing configuration file).
	extends?: string

	// To configure what yamllint should consider as YAML files when
	// listing directories, set yaml-files configuration option.
	"yaml-files"?: [...string]

	// This is passed to Python's locale.setlocale.
	locale?: string

	// When linting a document with yamllint, a series of rules are
	// checked against. A configuration file can be used to enable or
	// disable these rules, to set their level (error or warning),
	// but also to tweak their options.
	rules?: {
		// Use this rule to report duplicated anchors and aliases
		// referencing undeclared anchors.
		anchors?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Forbid Undeclared Aliases
			//
			// Set forbid-undeclared-aliases to true to avoid aliases that
			// reference an anchor that hasn't been declared (either not
			// declared at all, or declared later in the document).
			"forbid-undeclared-aliases"?: bool

			// Forbid Duplicated Anchors
			//
			// Set forbid-duplicated-anchors to true to avoid duplications of
			// a same anchor.
			"forbid-duplicated-anchors"?: bool

			// Forbid Unused Anchors
			//
			// Set forbid-unused-anchors to true to avoid anchors being
			// declared but not used anywhere in the YAML document via alias.
			"forbid-unused-anchors"?: bool
			...
		})])

		// Braces
		//
		// Use this rule to control the use of flow mappings or number of
		// spaces inside braces ({ and }).
		braces?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Forbid
			//
			// forbid is used to forbid the use of flow mappings which are
			// denoted by surrounding braces ({ and }). Use true to forbid
			// the use of flow mappings completely. Use non-empty to forbid
			// the use of all flow mappings except for empty ones.
			forbid?: matchN(1, [bool, "non-empty"])

			// Minimum Spaces Inside
			//
			// min-spaces-inside defines the minimal number of spaces required
			// inside braces.
			"min-spaces-inside"?: >=0

			// Maximum Spaces Inside
			//
			// max-spaces-inside defines the maximal number of spaces allowed
			// inside braces.
			"max-spaces-inside"?: >=0

			// Minimum Spaces Inside Empty
			//
			// min-spaces-inside-empty defines the minimal number of spaces
			// required inside empty braces. (use -1 to default to the value
			// for min-spaces-inside)
			"min-spaces-inside-empty"?: >=-1

			// Maximum Spaces Inside Empty
			//
			// max-spaces-inside-empty defines the maximal number of spaces
			// allowed inside empty braces. (use -1 to default to the value
			// for max-spaces-inside)
			"max-spaces-inside-empty"?: >=-1
			...
		})])

		// Brackets
		//
		// Use this rule to control the use of flow sequences or the
		// number of spaces inside brackets ([ and ]).
		brackets?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Forbid
			//
			// forbid is used to forbid the use of flow sequences which are
			// denoted by surrounding brackets ([ and ]). Use true to forbid
			// the use of flow sequences completely. Use non-empty to forbid
			// the use of all flow sequences except for empty ones.
			forbid?: matchN(1, [bool, "non-empty"])

			// Minimum Spaces Inside
			//
			// min-spaces-inside defines the minimal number of spaces required
			// inside brackets.
			"min-spaces-inside"?: >=0

			// Maximum Spaces Inside
			//
			// max-spaces-inside defines the maximal number of spaces allowed
			// inside brackets.
			"max-spaces-inside"?: >=0

			// Minimum Spaces Inside Empty
			//
			// min-spaces-inside-empty defines the minimal number of spaces
			// required inside empty brackets. (use -1 to default to the
			// value for min-spaces-inside)
			"min-spaces-inside-empty"?: >=-1

			// Maximum Spaces Inside Empty
			//
			// max-spaces-inside-empty defines the maximal number of spaces
			// allowed inside empty brackets. (use -1 to default to the value
			// for max-spaces-inside)
			"max-spaces-inside-empty"?: >=-1
			...
		})])

		// Colons
		//
		// Use this rule to control the number of spaces before and after
		// colons (:).
		colons?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Maximum Spaces Before
			//
			// max-spaces-before defines the maximal number of spaces allowed
			// before colons (use -1 to disable).
			"max-spaces-before"?: >=-1

			// Maximum Spaces After
			//
			// max-spaces-after defines the maximal number of spaces allowed
			// after colons (use -1 to disable).
			"max-spaces-after"?: >=-1
			...
		})])

		// Commas
		//
		// Use this rule to control the number of spaces before and after
		// commas (,).
		commas?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Maximum Spaces Before
			//
			// max-spaces-before defines the maximal number of spaces allowed
			// before commas (use -1 to disable).
			"max-spaces-before"?: >=-1

			// Minimum Spaces After
			//
			// min-spaces-after defines the minimal number of spaces required
			// after commas.
			"min-spaces-after"?: >=0

			// Maximum Spaces After
			//
			// max-spaces-after defines the maximal number of spaces allowed
			// after commas (use -1 to disable).
			"max-spaces-after"?: >=-1
			...
		})])

		// Comments
		//
		// Use this rule to control the position and formatting of
		// comments.
		comments?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Require Starting Space
			//
			// Use require-starting-space to require a space character right
			// after the #. Set to true to enable, false to disable.
			"require-starting-space"?: bool

			// Ignore Shebangs
			//
			// Use ignore-shebangs to ignore a shebang at the beginning of the
			// file when require-starting-space is set.
			"ignore-shebangs"?: bool

			// Minimum Spaces From Content
			//
			// min-spaces-from-content is used to visually separate inline
			// comments from content. It defines the minimal required number
			// of spaces between a comment and its preceding content.
			"min-spaces-from-content"?: >=0
			...
		})])

		// Comments Indentation
		//
		// Use this rule to force comments to be indented like content.
		"comments-indentation"?: matchN(1, [#toggle, #rule])

		// Document End
		//
		// Use this rule to require or forbid the use of document end
		// marker (...).
		"document-end"?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Present
			//
			// Set present to true when the document end marker is required,
			// or to false when it is forbidden.
			present?: bool
			...
		})])

		// Document Start
		//
		// Use this rule to require or forbid the use of document start
		// marker (---).
		"document-start"?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Present
			//
			// Set present to true when the document start marker is required,
			// or to false when it is forbidden.
			present?: bool
			...
		})])

		// Empty Lines
		//
		// Use this rule to set a maximal number of allowed consecutive
		// blank lines.
		"empty-lines"?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Maximum
			//
			// max defines the maximal number of empty lines allowed in the
			// document.
			max?: >=0

			// Maximum Start
			//
			// max-start defines the maximal number of empty lines allowed at
			// the beginning of the file. This option takes precedence over
			// max.
			"max-start"?: >=0

			// Maximum End
			//
			// max-end defines the maximal number of empty lines allowed at
			// the end of the file. This option takes precedence over max.
			"max-end"?: >=0
			...
		})])

		// Empty Values
		//
		// Use this rule to prevent nodes with empty content, that
		// implicitly result in null values.
		"empty-values"?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Forbid in Block Mappings
			//
			// Use forbid-in-block-mappings to prevent empty values in block
			// mappings.
			"forbid-in-block-mappings"?: bool

			// Forbid in Flow Mappings
			//
			// Use forbid-in-flow-mappings to prevent empty values in flow
			// mappings.
			"forbid-in-flow-mappings"?: bool

			// Forbid in Block Sequences
			//
			// Use forbid-in-block-sequences to prevent empty values in block
			// sequences.
			"forbid-in-block-sequences"?: bool
			...
		})])

		// Float Values
		//
		// Use this rule to limit the permitted values for floating-point
		// numbers. YAML permits three classes of float expressions:
		// approximation to real numbers, positive and negative infinity
		// and "not a number".
		"float-values"?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Require Numeral Before Decimal
			//
			// Use require-numeral-before-decimal to require floats to start
			// with a numeral (ex 0.0 instead of .0).
			"require-numeral-before-decimal"?: bool

			// Forbid Scientific Notation
			//
			// Use forbid-scientific-notation to forbid scientific notation.
			"forbid-scientific-notation"?: bool

			// Forbid NaN
			//
			// Use forbid-nan to forbid NaN (not a number) values.
			"forbid-nan"?: bool

			// Forbid Inf
			//
			// Use forbid-inf to forbid infinite values.
			"forbid-inf"?: bool
			...
		})])

		// Hyphens
		//
		// Use this rule to control the number of spaces after hyphens
		// (-).
		hyphens?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Maximum Spaces After
			//
			// max-spaces-after defines the maximal number of spaces allowed
			// after hyphens.
			"max-spaces-after"?: >=0
			...
		})])

		// Indentation
		//
		// Use this rule to control the indentation.
		indentation?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Spaces
			//
			// spaces defines the indentation width, in spaces. Set either to
			// an integer (e.g. 2 or 4, representing the number of spaces in
			// an indentation level) or to consistent to allow any number, as
			// long as it remains the same within the file.
			spaces?: matchN(1, [>=1, "consistent"])

			// Indent Sequences
			//
			// indent-sequences defines whether block sequences should be
			// indented or not (when in a mapping, this indentation is not
			// mandatory - some people perceive the - as part of the
			// indentation). Possible values: true, false, whatever and
			// consistent.
			"indent-sequences"?: matchN(1, [bool, "consistent", "whatever"])

			// Check Multi-Line Strings
			//
			// check-multi-line-strings defines whether to lint indentation in
			// multi-line strings. Set to true to enable, false to disable.
			"check-multi-line-strings"?: bool
			...
		})])

		// Key Duplicates
		//
		// Use this rule to prevent multiple entries with the same key in
		// mappings.
		"key-duplicates"?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Forbid Duplicated Merge Keys
			//
			// Use forbid-duplicated-merge-keys to forbid the usage of
			// multiple merge keys <<.
			"forbid-duplicated-merge-keys"?: bool
			...
		})])

		// Key Ordering
		//
		// Use this rule to enforce alphabetical ordering of keys in
		// mappings. The sorting order uses the Unicode code point number
		// as a default. As a result, the ordering is case-sensitive and
		// not accent-friendly (see examples below). This can be changed
		// by setting the global locale option. This allows one to sort
		// case and accents properly.
		"key-ordering"?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Ignored Keys
			//
			// ignored-keys is a list of PCRE regexes to ignore some keys
			// while checking order, if they match any regex.
			"ignored-keys"?: [...regexp.Valid]
			...
		})])

		// Line Length
		//
		// Use this rule to set a limit to lines length.
		"line-length"?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Maximum
			//
			// max defines the maximal (inclusive) length of lines.
			max?: >=0

			// Allow Non-Breakable Words
			//
			// allow-non-breakable-words is used to allow non breakable words
			// (without spaces inside) to overflow the limit. This is useful
			// for long URLs, for instance. Use true to allow, false to
			// forbid.
			"allow-non-breakable-words"?: bool

			// Allow Non-Breakable Inline Mappings
			//
			// allow-non-breakable-inline-mappings implies
			// allow-non-breakable-words and extends it to also allow
			// non-breakable words in inline mappings.
			"allow-non-breakable-inline-mappings"?: bool
			...
		})])

		// New Line At End Of File
		//
		// Use this rule to require a new line character (\n) at the end
		// of files.
		//
		// The POSIX standard requires the last line to end with a new
		// line character. All UNIX tools expect a new line at the end of
		// files. Most text editors use this convention too.
		"new-line-at-end-of-file"?: matchN(1, [#toggle, #rule])

		// New Lines
		//
		// Use this rule to force the type of new line characters.
		"new-lines"?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Type
			//
			// Set type to unix to enforce UNIX-typed new line characters
			// (\n), set type to dos to enforce DOS-typed new line characters
			// (\r\n), or set type to platform to infer the type from the
			// system running yamllint (\n on POSIX / UNIX / Linux / Mac OS
			// systems or \r\n on DOS / Windows systems).
			type?: "unix" | "dos" | "platform"
			...
		})])

		// Octal Values
		//
		// Use this rule to prevent values with octal numbers. In YAML,
		// numbers that start with 0 are interpreted as octal, but this
		// is not always wanted. For instance 010 is the city code of
		// Beijing, and should not be converted to 8.
		"octal-values"?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Forbid Implicit Octal
			//
			// Use forbid-implicit-octal to prevent numbers starting with 0.
			"forbid-implicit-octal"?: bool

			// Forbid Explicit Octal
			//
			// Use forbid-explicit-octal to prevent numbers starting with 0o.
			"forbid-explicit-octal"?: bool
			...
		})])

		// Quoted Strings
		//
		// Use this rule to forbid any string values that are not quoted,
		// or to prevent quoted strings without needing it. You can also
		// enforce the type of the quote used.
		"quoted-strings"?: matchN(1, [#toggle, #rule & matchN(2, [matchIf(null | bool | number | string | [...] | {
			required?: matchN(>=1, [false, "only-when-needed"])
			...
		}, null | bool | number | string | [...] | {
			// Extra Required
			//
			// extra-required is a list of PCRE regexes to force string values
			// to be quoted, if they match any regex. This option can only be
			// used with required: false and required: only-when-needed.
			"extra-required"?: [...regexp.Valid]
			...
		}, _), matchIf(null | bool | number | string | [...] | {
			required?: "only-when-needed"
			...
		}, null | bool | number | string | [...] | {
			// Extra Allowed
			//
			// extra-allowed is a list of PCRE regexes to allow quoted string
			// values, even if required: only-when-needed is set.
			"extra-allowed"?: [...regexp.Valid]
			...
		}, _)]) & (null | bool | number | string | [...] | {
			// Quote Type
			//
			// quote-type defines allowed quotes: single, double or any
			// (default).
			"quote-type"?: "single" | "double" | "any"

			// Required
			//
			// required defines whether using quotes in string values is
			// required (true, default) or not (false), or only allowed when
			// really needed (only-when-needed).
			required?: matchN(1, [bool, "only-when-needed"])

			// Allow Quoted Quotes
			//
			// allow-quoted-quotes allows (true) using disallowed quotes for
			// strings with allowed quotes inside. Default false.
			"allow-quoted-quotes"?: bool

			// Check Keys
			//
			// check-keys defines whether to apply the rules to keys in
			// mappings. By default, quoted-strings rules apply only to
			// values. Set this option to true to apply the rules to keys as
			// well.
			"check-keys"?: bool
			...
		})])

		// Trailing Spaces
		//
		// Use this rule to forbid trailing spaces at the end of lines.
		"trailing-spaces"?: matchN(1, [#toggle, #rule])

		// Truthy
		//
		// Use this rule to forbid non-explicitly typed truthy values
		// other than allowed ones (by default: true and false), for
		// example YES or off.
		//
		// This can be useful to prevent surprises from YAML parsers
		// transforming [yes, FALSE, Off] into [true, false, false] or
		// {y: 1, yes: 2, on: 3, true: 4, True: 5} into {y: 1, true: 5}.
		//
		// Depending on the YAML specification version used by the YAML
		// document, the list of truthy values can differ. In YAML 1.2,
		// only capitalized / uppercased combinations of true and false
		// are considered truthy, whereas in YAML 1.1 combinations of
		// yes, no, on and off are too. To make the YAML specification
		// version explicit in a YAML document, a %YAML 1.2 directive can
		// be used (see example below).
		truthy?: matchN(1, [#toggle, #rule & (null | bool | number | string | [...] | {
			// Allowed Values
			//
			// allowed-values defines the list of truthy values which will be
			// ignored during linting.
			"allowed-values"?: list.UniqueItems() & [..."TRUE" | "True" | "true" | "FALSE" | "False" | "false" | "YES" | "Yes" | "yes" | "NO" | "No" | "no" | "ON" | "On" | "on" | "OFF" | "Off" | "off"]

			// Check Keys
			//
			// check-keys disables verification for keys in mappings. By
			// default, truthy rule applies to both keys and values. Set this
			// option to false to prevent this.
			"check-keys"?: bool
			...
		})])
		...
	}
	...
}

#ignorable: matchN(0, [null | bool | number | string | [...] | {
	ignore!:             _
	"ignore-from-file"!: _
	...
}]) & {
	ignore?: string | [...string]
	"ignore-from-file"?: string | [...string]
	...
}

#rule: #ignorable & {
	level?: "error" | "warning"
	...
}

#toggle: matchN(1, ["enable" | "disable", bool])
