import "list"

@jsonschema(schema="http://json-schema.org/draft-07/schema#")
@jsonschema(id="https://json.schemastore.org/golangci-lint.json")

// Options for analysis running,
run?: {
	// Number of concurrent runners. Defaults to the number of
	// available CPU cores.
	concurrency?: int & >=0

	// Timeout for the analysis.
	timeout?: =~"^\\d*[sm]$" | *"1m"

	// Exit code when at least one issue was found.
	"issues-exit-code"?: int | *1

	// Enable inclusion of test files.
	tests?: bool | *true

	// List of build tags to pass to all linters.
	"build-tags"?: [...string]

	// Option to pass to "go list -mod={option}".
	// See "go help modules" for more information.
	"modules-download-mode"?: "mod" | "readonly" | "vendor"

	// Allow multiple parallel golangci-lint instances running. If
	// disabled, golangci-lint acquires file lock on start.
	"allow-parallel-runners"?: bool | *false

	// Allow multiple golangci-lint instances running, but serialize
	// them around a lock.
	"allow-serial-runners"?: bool | *false

	// Targeted Go version.
	go?: string | *"1.17"
}

// Output configuration options.
output?: {
	// Output formats to use.
	formats?: [...{
		path?:  ("stdout" | "stderr" | string) & string | *"stdout"
		format: "colored-line-number" | "line-number" | "json" | "colored-tab" | "tab" | "html" | "checkstyle" | "code-climate" | "junit-xml" | "junit-xml-extended" | "github-actions" | "teamcity" | "sarif" | *"colored-line-number"
	}]

	// Print lines of code with issue.
	"print-issued-lines"?: bool | *true

	// Print linter name in the end of issue text.
	"print-linter-name"?: bool | *true

	// Make issues output unique by line.
	"uniq-by-line"?: bool | *true

	// Add a prefix to the output file references.
	"path-prefix"?: string | *""

	// Show statistics per linter.
	"show-stats"?: bool | *false
	"sort-order"?: [..."linter" | "severity" | "file"]

	// Sort results by: filepath, line and column.
	"sort-results"?: bool | *true
}

// All available settings of specific linters.
"linters-settings"?: {
	dupword?: {
		// Keywords for detecting duplicate words. If this list is not
		// empty, only the words defined in this list will be detected.
		keywords?: list.UniqueItems() & [...string]

		// Keywords used to ignore detection.
		ignore?: list.UniqueItems() & [...string]
	}
	asasalint?: {
		// To specify a set of function names to exclude.
		exclude?: list.UniqueItems() & [...string]

		// To enable/disable the asasalint builtin exclusions of function
		// names.
		"use-builtin-exclusions"?: bool | *true

		// Ignore *_test.go files.
		"ignore-test"?: bool | *false
	}
	bidichk?: {
		// Disallow: LEFT-TO-RIGHT-EMBEDDING
		"left-to-right-embedding"?: bool | *false

		// Disallow: RIGHT-TO-LEFT-EMBEDDING
		"right-to-left-embedding"?: bool | *false

		// Disallow: POP-DIRECTIONAL-FORMATTING
		"pop-directional-formatting"?: bool | *false

		// Disallow: LEFT-TO-RIGHT-OVERRIDE
		"left-to-right-override"?: bool | *false

		// Disallow: RIGHT-TO-LEFT-OVERRIDE
		"right-to-left-override"?: bool | *false

		// Disallow: LEFT-TO-RIGHT-ISOLATE
		"left-to-right-isolate"?: bool | *false

		// Disallow: RIGHT-TO-LEFT-ISOLATE
		"right-to-left-isolate"?: bool | *false

		// Disallow: FIRST-STRONG-ISOLATE
		"first-strong-isolate"?: bool | *false

		// Disallow: POP-DIRECTIONAL-ISOLATE
		"pop-directional-isolate"?: bool | *false
	}
	cyclop?: {
		// Should the linter execute on test files as well
		"skip-tests"?: bool | *false

		// Max complexity the function can have
		"max-complexity"?: int & >=0 | *10

		// Max average complexity in package
		"package-average"?: >=0 | *0
	}
	decorder?: {
		"dec-order"?: [..."type" | "const" | "var" | "func"] | *[["type", "const", "var", "func"]]

		// Underscore vars (vars with "_" as the name) will be ignored at
		// all checks
		"ignore-underscore-vars"?: bool | *true

		// Order of declarations is not checked
		"disable-dec-order-check"?: bool | *true

		// Allow init func to be anywhere in file
		"disable-init-func-first-check"?: bool | *true

		// Multiple global type, const and var declarations are allowed
		"disable-dec-num-check"?: bool | *true

		// Type declarations will be ignored for dec num check
		"disable-type-dec-num-check"?: bool | *true

		// Const declarations will be ignored for dec num check
		"disable-const-dec-num-check"?: bool | *true

		// Var declarations will be ignored for dec num check
		"disable-var-dec-num-check"?: bool | *true
	}
	depguard?: {
		// Rules to apply.
		rules?: {
			{[=~"^[^.]+$" & !~"^()$"]: {
				// Used to determine the package matching priority.
				"list-mode"?: "original" | "strict" | "lax" | *"original"

				// List of file globs that will match this list of settings to
				// compare against.
				files?: [...string]

				// List of allowed packages.
				allow?: [...string]

				// Packages that are not allowed where the value is a suggestion.
				deny?: [...{
					// Description
					desc?: string

					// Package
					pkg?: string
				}]
			}}
		}
	}
	dogsled?: {
		// Check assignments with too many blank identifiers.
		"max-blank-identifiers"?: int & >=0 | *2
	}
	dupl?: {
		// Tokens count to trigger issue.
		threshold?: int & >=0 | *150
	}
	errcheck?: {
		// Report about not checking errors in type assertions, i.e.: `a
		// := b.(MyStruct)`
		"check-type-assertions"?: bool | *false

		// Report about assignment of errors to blank identifier
		"check-blank"?: bool | *false

		// List of functions to exclude from checking, where each entry is
		// a single function to exclude
		"exclude-functions"?: [...string]

		// To disable the errcheck built-in exclude list
		"disable-default-exclusions"?: bool | *false
	}
	errchkjson?: {
		"check-error-free-encoding"?: bool | *false

		// Issue on struct that doesn't have exported fields.
		"report-no-exported"?: bool | *false
	}
	errorlint?: {
		// Check whether fmt.Errorf uses the %w verb for formatting errors
		errorf?: bool | *true

		// Permit more than 1 %w verb, valid per Go 1.20
		"errorf-multi"?: bool | *true

		// Check for plain type assertions and type switches.
		asserts?: bool | *true

		// Check for plain error comparisons
		comparison?: bool | *true
		"allowed-errors"?: [...{
			err?: string
			fun?: string
		}]
		"allowed-errors-wildcard"?: [...{
			err?: string
			fun?: string
		}]
	}
	exhaustive?: {
		// Program elements to check for exhaustiveness.
		check?: list.UniqueItems() & [...string]

		// Check switch statements in generated files
		"check-generated"?: bool | *false

		// Only run exhaustive check on switches with
		// "//exhaustive:enforce" comment.
		"explicit-exhaustive-switch"?: bool | *false

		// Only run exhaustive check on map literals with
		// "//exhaustive:enforce" comment.
		"explicit-exhaustive-map"?: bool | *false

		// Switch statement requires default case even if exhaustive.
		"default-case-required"?: bool | *false

		// Presence of `default` case in switch statements satisfies
		// exhaustiveness, even if all enum members are not listed.
		"default-signifies-exhaustive"?: bool | *false

		// Enum members matching `regex` do not have to be listed in
		// switch statements to satisfy exhaustiveness
		"ignore-enum-members"?: string

		// Enum types matching the supplied regex do not have to be listed
		// in switch statements to satisfy exhaustiveness.
		"ignore-enum-types"?: string

		// Consider enums only in package scopes, not in inner scopes.
		"package-scope-only"?: bool | *false
	}
	exhaustruct?: {
		// List of regular expressions to match struct packages and names.
		include?: [...string]

		// List of regular expressions to exclude struct packages and
		// names from check.
		exclude?: [...string]
	}
	forbidigo?: {
		// Exclude code in godoc examples.
		"exclude-godoc-examples"?: bool | *true

		// Instead of matching the literal source code, use type
		// information to replace expressions with strings that contain
		// the package name and (for methods and fields) the type name.
		"analyze-types"?: bool | *true

		// List of identifiers to forbid (written using `regexp`)
		forbid?: [...(string | {
			// Pattern
			p?: string

			// Package
			pkg?: string

			// Message
			msg?: string
		}) & (string | {
			...
		})]
	}
	funlen?: {
		// Limit lines number per function.
		lines?: int | *60

		// Limit statements number per function.
		statements?: int | *40

		// Ignore comments when counting lines.
		"ignore-comments"?: bool | *false
	}
	gci?: {
		// Section configuration to compare against.
		sections?: [...("standard" | "default" | "blank" | "dot" | "alias" | "localmodule" | string) & string] | *["standard", "default"]

		// Skip generated files.
		"skip-generated"?: bool | *true

		// Enable custom order of sections.
		"custom-order"?: bool | *false

		// Drops lexical ordering for custom sections.
		"no-lex-order"?: bool | *false
	}
	ginkgolinter?: {
		// Suppress the wrong length assertion warning.
		"suppress-len-assertion"?: bool | *false

		// Suppress the wrong nil assertion warning.
		"suppress-nil-assertion"?: bool | *false

		// Suppress the wrong error assertion warning.
		"suppress-err-assertion"?: bool | *false

		// Suppress the wrong comparison assertion warning.
		"suppress-compare-assertion"?: bool | *false

		// Suppress the function all in async assertion warning.
		"suppress-async-assertion"?: bool | *false

		// Suppress warning for comparing values from different types,
		// like int32 and uint32.
		"suppress-type-compare-assertion"?: bool | *false

		// Trigger warning for ginkgo focus containers like FDescribe,
		// FContext, FWhen or FIt.
		"forbid-focus-container"?: bool | *false

		// Don't trigger warnings for HaveLen(0).
		"allow-havelen-zero"?: bool | *false

		// Force using `Expect` with `To`, `ToNot` or `NotTo`
		"force-expect-to"?: bool | *false

		// Best effort validation of async intervals (timeout and
		// polling).
		"validate-async-intervals"?: bool | *false

		// Trigger a warning for variable assignments in ginkgo containers
		// like `Describe`, `Context` and `When`, instead of in
		// `BeforeEach()`.
		"forbid-spec-pollution"?: bool | *false

		// Force using the Succeed matcher for error functions, and the
		// HaveOccurred matcher for non-function error values.
		"force-succeed"?: bool | *false
	}
	gochecksumtype?: {
		// Presence of `default` case in switch statements satisfies
		// exhaustiveness, if all members are not listed.
		"default-signifies-exhaustive"?: bool | *true
	}
	gocognit?: {
		// Minimal code complexity to report (we recommend 10-20).
		"min-complexity"?: int | *30
	}
	goconst?: {
		// Look for existing constants matching the values
		"match-constant"?: bool | *true

		// Minimum length of string constant.
		"min-len"?: int | *3

		// Minimum occurrences count to trigger.
		"min-occurrences"?: int | *3

		// Ignore test files.
		"ignore-tests"?: bool | *false

		// Ignore when constant is not used as function argument
		"ignore-calls"?: bool | *true

		// Exclude strings matching the given regular expression
		"ignore-strings"?: string

		// Search also for duplicated numbers.
		numbers?: bool | *false

		// Minimum value, only works with `numbers`
		min?: int | *3

		// Maximum value, only works with `numbers`
		max?: int | *3
	}
	gocritic?: {
		// Which checks should be enabled. By default, a list of stable
		// checks is used. To see it, run `GL_DEBUG=gocritic
		// golangci-lint run`.
		"enabled-checks"?: [...#["gocritic-checks"]]

		// Which checks should be disabled.
		"disabled-checks"?: [...#["gocritic-checks"]]

		// Enable multiple checks by tags, run `GL_DEBUG=gocritic
		// golangci-lint run` to see all tags and checks.
		"enabled-tags"?: [...#["gocritic-tags"]]

		// Disable multiple checks by tags, run `GL_DEBUG=gocritic
		// golangci-lint run` to see all tags and checks.
		"disabled-tags"?: [...#["gocritic-tags"]]

		// Settings passed to gocritic. Properties must be valid and
		// enabled check names.
		settings?: {
			captLocal?: paramsOnly?:       bool | *true
			commentedOutCode?: minLength?: number | *15
			elseif?: skipBalanced?:        bool | *true
			hugeParam?: sizeThreshold?:    number | *80
			ifElseChain?: minThreshold?:   number | *2
			nestingReduce?: bodyWidth?:    number | *5
			rangeExprCopy?: {
				sizeThreshold?: number | *512
				skipTestFuncs?: bool | *true
			}
			rangeValCopy?: {
				sizeThreshold?: number | *128
				skipTestFuncs?: bool | *true
			}
			ruleguard?: {
				debug?:   string
				enable?:  string
				disable?: string
				failOn?:  string
				rules?:   string
			}
			tooManyResultsChecker?: maxResults?: number | *5
			truncateCmp?: skipArchDependent?:    bool | *true
			underef?: skipRecvDeref?:            bool | *true
			unnamedResult?: checkExported?:      bool | *false
		}
		"disable-all"?: bool | *false
		"enable-all"?:  bool | *false
	}
	gocyclo?: {
		// Minimum code complexity to report (we recommend 10-20).
		"min-complexity"?: int | *30
	}
	godot?: {
		// Comments to be checked.
		scope?: "declarations" | "toplevel" | "all" | *"declarations"

		// List of regexps for excluding particular comment lines from
		// check.
		exclude?: [...string]

		// Check that each sentence ends with a period.
		period?: bool | *true

		// Check that each sentence starts with a capital letter.
		capital?: bool | *false

		// DEPRECATED: Check all top-level comments, not only
		// declarations.
		"check-all"?: bool | *false
	}
	godox?: {
		// Report any comments starting with one of these keywords. This
		// is useful for TODO or FIXME comments that might be left in the
		// code accidentally and should be resolved before merging.
		keywords?: [...string] | *["TODO", "BUG", "FIXME"]
	}
	gofmt?: {
		// Simplify code.
		simplify?: bool | *true

		// Apply the rewrite rules to the source before reformatting.
		"rewrite-rules"?: [...{
			pattern?:     string
			replacement?: string
		}]
	}
	interfacebloat?: {
		// The maximum number of methods allowed for an interface.
		max?: int
	}
	gofumpt?: {
		// Choose whether or not to use the extra rules that are disabled
		// by default.
		"extra-rules"?: bool | *false

		// Module path which contains the source code being formatted.
		"module-path"?: string
	}
	goheader?: ({
		template: _
		...
	} | {
		"template-path": _
		...
	}) & {
		values?: {
			// Constants to use in the template.
			const?: {
				{[=~"^.+$" & !~"^()$"]: string}
			}

			// Regular expressions to use in your template.
			regexp?: {
				{[=~"^.+$" & !~"^()$"]: string}
			}
		}

		// Template to put on top of every file.
		template?: string

		// Path to the file containing the template source.
		"template-path"?: string
	}
	goimports?: {
		// Put imports beginning with prefix after 3rd-party packages. It
		// is a comma-separated list of prefixes.
		"local-prefixes"?: string
	}
	gomoddirectives?: {
		// Allow local `replace` directives.
		"replace-local"?: bool | *true

		// List of allowed `replace` directives.
		"replace-allow-list"?: [...string]

		// Allow to not explain why the version has been retracted in the
		// `retract` directives.
		"retract-allow-no-explanation"?: bool | *true

		// Forbid the use of the `exclude` directives.
		"exclude-forbidden"?: bool | *true
	}
	gomodguard?: {
		allowed?: {
			// List of allowed modules.
			modules?: [...string]

			// List of allowed module domains.
			domains?: [...string]
		}
		blocked?: {
			// List of blocked modules.
			modules?: [...{
				{[=~"^.+$" & !~"^()$"]: {
					// Recommended modules that should be used instead.
					recommendations?: [...string]

					// Reason why the recommended module should be used.
					reason?: string
				}}
			}]

			// List of blocked module version constraints.
			versions?: [...{
				{[=~"^.*$" & !~"^()$"]: {
					// Version constraint.
					version?: string

					// Reason why the version constraint exists.
					reason: string
				}}
				...
			}]

			// Raise lint issues if loading local path with replace directive
			local_replace_directives?: bool | *true
		}
	}
	gosimple?: checks?: [...("all" | string) & string]
	gosec?: {
		// To select a subset of rules to run
		includes?: [...#["gosec-rules"]]

		// To specify a set of rules to explicitly exclude
		excludes?: [...#["gosec-rules"]]

		// Exclude generated files
		"exclude-generated"?: bool | *false

		// Filter out the issues with a lower severity than the given
		// value
		severity?: "low" | "medium" | "high" | *"low"

		// Filter out the issues with a lower confidence than the given
		// value
		confidence?: "low" | "medium" | "high" | *"low"

		// To specify the configuration of rules
		config?: {
			...
		}

		// Concurrency value
		concurrency?: int
	}
	gosmopolitan?: {
		// Allow and ignore `time.Local` usages.
		"allow-time-local"?: bool | *false

		// List of fully qualified names in the `full/pkg/path.name` form,
		// to act as "i18n escape hatches".
		"escape-hatches"?: [...string]

		// Ignore test files.
		"ignore-tests"?: bool | *false

		// List of Unicode scripts to watch for any usage in string
		// literals.
		"watch-for-scripts"?: [...string]
	}
	govet?: {
		// Settings per analyzer. Map of analyzer name to specific
		// settings.
		// Run `go tool vet help` to find out more.
		settings?: {
			[#["govet-analyzers"]]: _
		} & {
			{[=~"^.*$" & !~"^()$"]: {
				...
			}}
			...
		}

		// Enable analyzers by name.
		enable?: [...#["govet-analyzers"]]

		// Disable analyzers by name.
		disable?: [...#["govet-analyzers"]]

		// Enable all analyzers.
		"enable-all"?: bool | *false

		// Disable all analyzers.
		"disable-all"?: bool | *false
	}
	grouper?: {
		"const-require-single-const"?:   bool | *false
		"const-require-grouping"?:       bool | *false
		"import-require-single-import"?: bool | *false
		"import-require-grouping"?:      bool | *false
		"type-require-single-type"?:     bool | *false
		"type-require-grouping"?:        bool | *false
		"var-require-single-var"?:       bool | *false
		"var-require-grouping"?:         bool | *false
	}
	iface?: {
		// Enable analyzers by name.
		enable?: [...#["iface-analyzers"]]
		settings?: unused?: exclude?: [...string]
	}
	importas?: {
		// Do not allow unaliased imports of aliased packages.
		"no-unaliased"?: bool | *false

		// Do not allow non-required aliases.
		"no-extra-aliases"?: bool | *false

		// List of aliases
		alias?: [...{
			// Package path e.g.
			// knative.dev/serving/pkg/apis/autoscaling/v1alpha1
			pkg: string

			// Package alias e.g. autoscalingv1alpha1
			alias: string
		}]
	}
	inamedparam?: {
		// Skips check for interface methods with only a single parameter.
		"skip-single-param"?: bool | *false
	}

	// Use either `reject` or `allow` properties for interfaces
	// matching.
	ireturn?: ({
		allow: _
		...
	} | {
		reject: _
		...
	}) & {
		allow?: [...(string | ("anon" | "error" | "empty" | "stdlib")) & string]
		reject?: [...(string | ("anon" | "error" | "empty" | "stdlib")) & string]
	}
	lll?: {
		// Width of "\t" in spaces.
		"tab-width"?: int & >=0 | *1

		// Maximum allowed line length, lines longer will be reported.
		"line-length"?: int & >=1 | *120
	}

	// Maintainability index
	// https://docs.microsoft.com/en-us/visualstudio/code-quality/code-metrics-maintainability-index-range-and-meaning?view=vs-2022
	maintidx?: {
		// Minimum accatpable maintainability index level (see
		// https://docs.microsoft.com/en-us/visualstudio/code-quality/code-metrics-maintainability-index-range-and-meaning?view=vs-2022)
		under?: number | *20
	}
	makezero?: {
		// Allow only slices initialized with a length of zero.
		always?: bool | *false
	}
	loggercheck?: {
		// Allow check for the github.com/go-kit/log library.
		kitlog?: bool | *true

		// Allow check for the k8s.io/klog/v2 library.
		klog?: bool | *true

		// Allow check for the github.com/go-logr/logr library.
		logr?: bool | *true

		// Allow check for the "sugar logger" from go.uber.org/zap
		// library.
		zap?: bool | *true

		// Require all logging keys to be inlined constant strings.
		"require-string-key"?: bool | *false

		// Require printf-like format specifier (%s, %d for example) not
		// present.
		"no-printf-like"?: bool | *false

		// List of custom rules to check against, where each rule is a
		// single logger pattern, useful for wrapped loggers.
		rules?: [...string]
	}

	// Correct spellings using locale preferences for US or UK.
	// Default is to use a neutral variety of English.
	misspell?: {
		locale?: "US" | "UK"

		// List of words to ignore.
		"ignore-words"?: [...string]

		// Mode of the analysis.
		mode?: "restricted" | "" | "default" | *""

		// Extra word corrections.
		"extra-words"?: [...{
			correction?: string
			typo?:       string
		}]
	}
	musttag?: functions?: [...{
		name?:      string
		tag?:       string
		"arg-pos"?: int
	}]
	nakedret?: {
		// Report if a function has more lines of code than this value and
		// it has naked returns.
		"max-func-lines"?: int & >=0 | *30
	}
	nestif?: {
		// Minimum complexity of "if" statements to report.
		"min-complexity"?: int | *5
	}
	nilnil?: {
		// In addition, detect opposite situation (simultaneous return of
		// non-nil error and valid value).
		"detect-opposite"?: bool | *false

		// List of return types to check.
		"checked-types"?: [..."chan" | "func" | "iface" | "map" | "ptr" | "uintptr" | "unsafeptr"] | *["chan", "func", "iface", "map", "ptr", "uintptr", "unsafeptr"]
	}
	nlreturn?: {
		// set block size that is still ok
		"block-size"?: >=0 | *0
	}
	mnd?: {
		// List of file patterns to exclude from analysis.
		"ignored-files"?: [...string]

		// Comma-separated list of function patterns to exclude from the
		// analysis.
		"ignored-functions"?: [...string]

		// List of numbers to exclude from analysis.
		"ignored-numbers"?: [...string]

		// The list of enabled checks, see
		// https://github.com/tommy-muehle/go-mnd/#checks for
		// description.
		checks?: [..."argument" | "case" | "condition" | "operation" | "return" | "assign"]
	}
	nolintlint?: {
		// Enable to ensure that nolint directives are all used.
		"allow-unused"?: bool | *true

		// Exclude these linters from requiring an explanation.
		"allow-no-explanation"?: [...#linters]

		// Enable to require an explanation of nonzero length after each
		// nolint directive.
		"require-explanation"?: bool | *false

		// Enable to require nolint directives to mention the specific
		// linter being suppressed.
		"require-specific"?: bool | *false
	}
	reassign?: patterns?: [...string]
	nonamedreturns?: {
		// Report named error if it is assigned inside defer.
		"report-error-in-defer"?: bool | *false
	}
	paralleltest?: {
		// Ignore missing calls to `t.Parallel()` and only report
		// incorrect uses of it.
		"ignore-missing"?: bool | *false

		// Ignore missing calls to `t.Parallel()` in subtests. Top-level
		// tests are still required to have `t.Parallel`, but subtests
		// are allowed to skip it.
		"ignore-missing-subtests"?: bool | *false
	}
	perfsprint?: {
		// Optimizes even if it requires an int or uint type cast.
		"int-conversion"?: bool | *true

		// Optimizes into `err.Error()` even if it is only equivalent for
		// non-nil errors.
		"err-error"?: bool | *false

		// Optimizes `fmt.Errorf`.
		errorf?: bool | *true

		// Optimizes `fmt.Sprintf` with only one argument.
		sprintf1?: bool | *true

		// Optimizes into strings concatenation.
		strconcat?: bool | *true
	}

	// We do not recommend using this linter before doing performance
	// profiling.
	// For most programs usage of `prealloc` will be premature
	// optimization.
	prealloc?: {
		// Report preallocation suggestions only on simple loops that have
		// no returns/breaks/continues/gotos in them.
		simple?: bool | *true

		// Report preallocation suggestions on range loops.
		"range-loops"?: bool | *true

		// Report preallocation suggestions on for loops.
		"for-loops"?: bool | *false
	}
	predeclared?: {
		// Comma-separated list of predeclared identifiers to not report
		// on.
		ignore?: string

		// Include method names and field names (i.e., qualified names) in
		// checks.
		q?: bool | *false
	}
	promlinter?: {
		strict?: _
		"disabled-linters"?: [..."Help" | "MetricUnits" | "Counter" | "HistogramSummaryReserved" | "MetricTypeInName" | "ReservedChars" | "CamelCase" | "UnitAbbreviations"]
	}
	protogetter?: {
		"skip-generated-by"?: [...string]
		"skip-files"?: [...string]

		// Skip any generated files from the checking.
		"skip-any-generated"?: bool | *false

		// Skip first argument of append function.
		"replace-first-arg-in-append"?: bool | *false
	}
	revive?: {
		"max-open-files"?:          int
		"ignore-generated-header"?: bool
		confidence?:                number
		severity?:                  "warning" | "error"
		"enable-all-rules"?:        bool | *false
		rules?: [...{
			// The rule name
			name:      #["revive-rules"]
			disabled?: bool
			severity?: "warning" | "error"
			exclude?: [...string]
			arguments?: [...]
		}]
	}
	rowserrcheck?: packages?: [...string]
	sloglint?: {
		// Enforce using key-value pairs only (incompatible with
		// attr-only).
		"kv-only"?: bool | *false

		// Enforce not using global loggers.
		"no-global"?: "" | "all" | "default" | *""

		// Enforce not mixing key-value pairs and attributes.
		"no-mixed-args"?: bool | *true

		// Enforce using methods that accept a context.
		context?: "" | "all" | "scope" | *""

		// Enforce using static values for log messages.
		"static-msg"?: bool | *false

		// Enforce a single key naming convention.
		"key-naming-case"?: "snake" | "kebab" | "camel" | "pascal"

		// Enforce using attributes only (incompatible with kv-only).
		"attr-only"?: bool | *false

		// Enforce using constants instead of raw keys.
		"no-raw-keys"?: bool | *false

		// Enforce not using specific keys.
		"forbidden-keys"?: [...string]

		// Enforce putting arguments on separate lines.
		"args-on-sep-lines"?: bool | *false
	}
	spancheck?: {
		// Checks to enable.
		checks?: [..."end" | "record-error" | "set-status"]

		// A list of regexes for function signatures that silence
		// `record-error` and `set-status` reports if found in the call
		// path to a returned error.
		"ignore-check-signatures"?: [...string]

		// A list of regexes for additional function signatures that
		// create spans.
		"extra-start-span-signatures"?: [...string]
	}
	staticcheck?: checks?: [...("all" | string) & string]
	stylecheck?: {
		checks?: [...("all" | string) & string] | *["all", "-ST1000", "-ST1003", "-ST1016", "-ST1020", "-ST1021", "-ST1022"]

		// By default, ST1001 forbids all uses of dot imports in non-test
		// packages. This setting allows setting a whitelist of import
		// paths that can be dot-imported anywhere.
		"dot-import-whitelist"?: [...string]

		// ST1013 recommends using constants from the net/http package
		// instead of hard-coding numeric HTTP status codes. This setting
		// specifies a list of numeric status codes that this check does
		// not complain about.
		"http-status-code-whitelist"?: [..."100" | "101" | "102" | "103" | "200" | "201" | "202" | "203" | "204" | "205" | "206" | "207" | "208" | "226" | "300" | "301" | "302" | "303" | "304" | "305" | "306" | "307" | "308" | "400" | "401" | "402" | "403" | "404" | "405" | "406" | "407" | "408" | "409" | "410" | "411" | "412" | "413" | "414" | "415" | "416" | "417" | "418" | "421" | "422" | "423" | "424" | "425" | "426" | "428" | "429" | "431" | "451" | "500" | "501" | "502" | "503" | "504" | "505" | "506" | "507" | "508" | "510" | "511"] | *["200", "400", "404", "500"]

		// ST1003 check, among other things, for the correct
		// capitalization of initialisms. The set of known initialisms
		// can be configured with this option.
		initialisms?: [...string | *["ACL", "API", "ASCII", "CPU", "CSS", "DNS", "EOF", "GUID", "HTML", "HTTP", "HTTPS", "ID", "IP", "JSON", "QPS", "RAM", "RPC", "SLA", "SMTP", "SQL", "SSH", "TCP", "TLS", "TTL", "UDP", "UI", "GID", "UID", "UUID", "URI", "URL", "UTF8", "VM", "XML", "XMPP", "XSRF", "XSS", "SIP", "RTP", "AMQP", "DB", "TS"]]
	}
	tagalign?: {
		// Align and sort can be used together or separately.
		align?: bool | *true

		// Whether enable tags sort.
		sort?: bool | *true

		// Specify the order of tags, the other tags will be sorted by
		// name.
		order?: [...string]

		// Whether enable strict style.
		strict?: bool | *false
	}
	tagliatelle?: case?: {
		// Use the struct field name to check the name of the struct tag.
		"use-field-name"?: bool | *false
		rules?: {
			{[=~"^.+$" & !~"^()$"]: "camel" | "pascal" | "kebab" | "snake" | "goCamel" | "goPascal" | "goKebab" | "goSnake" | "upper" | "upperSnake" | "lower" | "header"}
			...
		}
	}
	tenv?: {
		// The option `all` will run against whole test files (`_test.go`)
		// regardless of method/function signatures.
		all?: bool | *false
	}
	testifylint?: {
		// Enable all checkers.
		"enable-all"?: bool | *false

		// Disable all checkers.
		"disable-all"?: bool | *false

		// Enable specific checkers.
		enable?: [..."blank-import" | "bool-compare" | "compares" | "contains" | "empty" | "encoded-compare" | "error-is-as" | "error-nil" | "expected-actual" | "float-compare" | "formatter" | "go-require" | "len" | "negative-positive" | "nil-compare" | "regexp" | "require-error" | "suite-broken-parallel" | "suite-dont-use-pkg" | "suite-extra-assert-call" | "suite-subtest-run" | "suite-thelper" | "useless-assert"] | *["blank-import", "bool-compare", "compares", "contains", "empty", "encoded-compare", "error-is-as", "error-nil", "expected-actual", "float-compare", "formatter", "go-require", "len", "negative-positive", "nil-compare", "regexp", "require-error", "suite-broken-parallel", "suite-dont-use-pkg", "suite-extra-assert-call", "suite-subtest-run", "useless-assert"]

		// Disable specific checkers.
		disable?: [..."blank-import" | "bool-compare" | "compares" | "contains" | "empty" | "encoded-compare" | "error-is-as" | "error-nil" | "expected-actual" | "float-compare" | "formatter" | "go-require" | "len" | "negative-positive" | "nil-compare" | "regexp" | "require-error" | "suite-broken-parallel" | "suite-dont-use-pkg" | "suite-extra-assert-call" | "suite-subtest-run" | "suite-thelper" | "useless-assert" | *["suite-thelper"]]
		"bool-compare"?: {
			// To ignore user defined types (over builtin bool).
			"ignore-custom-types"?: bool | *false
		}
		"expected-actual"?: {
			// Regexp for expected variable name.
			pattern?: string | *"(^(exp(ected)?|want(ed)?)([A-Z]\\w*)?$)|(^(\\w*[a-z])?(Exp(ected)?|Want(ed)?)$)"
		}
		formatter?: {
			// To enable go vet's printf checks.
			"check-format-string"?: bool | *true

			// To require f-assertions (e.g. assert.Equalf) if format string
			// is used, even if there are no variable-length variables.
			"require-f-funcs"?: bool | *false
		}
		"go-require"?: {
			// To ignore HTTP handlers (like http.HandlerFunc).
			"ignore-http-handlers"?: bool | *false
		}
		"require-error"?: {
			// Regexp for assertions to analyze. If defined, then only matched
			// error assertions will be reported.
			"fn-pattern"?: string | *""
		}
		"suite-extra-assert-call"?: {
			// To require or remove extra Assert() call?
			mode?: "remove" | "require" | *"remove"
		}
	}
	testpackage?: {
		// Files with names matching this regular expression are skipped.
		"skip-regexp"?: string

		// List of packages that don't end with _test that tests are
		// allowed to be in.
		"allow-packages"?: list.UniqueItems() & [...string]
	}
	thelper?: {
		test?: {
			// Check if `t.Helper()` begins helper function.
			begin?: bool | *true

			// Check if *testing.T is first param of helper function.
			first?: bool | *true

			// Check if *testing.T param has t name.
			name?: bool | *true
		}
		benchmark?: {
			// Check if `b.Helper()` begins helper function.
			begin?: bool | *true

			// Check if *testing.B is first param of helper function.
			first?: bool | *true

			// Check if *testing.B param has b name.
			name?: bool | *true
		}
		tb?: {
			// Check if `tb.Helper()` begins helper function.
			begin?: bool | *true

			// Check if *testing.TB is first param of helper function.
			first?: bool | *true

			// Check if *testing.TB param has tb name.
			name?: bool | *true
		}
		fuzz?: {
			// Check if `f.Helper()` begins helper function.
			begin?: bool | *true

			// Check if *testing.F is first param of helper function.
			first?: bool | *true

			// Check if *testing.F param has f name.
			name?: bool | *true
		}
	}
	usestdlibvars?: {
		// Suggest the use of http.MethodXX.
		"http-method"?: bool | *true

		// Suggest the use of http.StatusXX.
		"http-status-code"?: bool | *true

		// Suggest the use of time.Weekday.String().
		"time-weekday"?: bool | *false

		// Suggest the use of time.Month.String().
		"time-month"?: bool | *false

		// Suggest the use of time.Layout.
		"time-layout"?: bool | *false

		// Suggest the use of crypto.Hash.String().
		"crypto-hash"?: bool | *false

		// Suggest the use of rpc.DefaultXXPath.
		"default-rpc-path"?: bool | *false

		// Suggest the use of sql.LevelXX.String().
		"sql-isolation-level"?: bool | *false

		// Suggest the use of tls.SignatureScheme.String().
		"tls-signature-scheme"?: bool | *false

		// Suggest the use of constant.Kind.String().
		"constant-kind"?: bool | *false
	}
	unconvert?: {
		"fast-math"?: bool | *false
		safe?:        bool | *false
	}
	unparam?: {
		// Inspect exported functions. Set to true if no external
		// program/library imports your code.
		//
		// WARNING: if you enable this setting, unparam will report a lot
		// of false-positives in text editors:
		// if it's called for subdir of a project it can't find external
		// interfaces. All text editor integrations
		// with golangci-lint call it on a directory with the changed
		// file.
		"check-exported"?: bool | *false
	}
	unused?: {
		"field-writes-are-uses"?:     bool | *true
		"post-statements-are-reads"?: bool | *false
		"exported-fields-are-used"?:  bool | *true
		"parameters-are-used"?:       bool | *true
		"local-variables-are-used"?:  bool | *true
		"generated-is-used"?:         bool | *true
	}
	varnamelen?: {
		// Variables used in at most this N-many lines will be ignored.
		"max-distance"?: int | *5

		// The minimum length of a variable's name that is considered
		// `long`.
		"min-name-length"?: int | *3

		// Check method receiver names.
		"check-receiver"?: bool | *false

		// Check named return values.
		"check-return"?: bool | *false

		// Check type parameters.
		"check-type-param"?: bool | *false

		// Ignore `ok` variables that hold the bool return value of a type
		// assertion
		"ignore-type-assert-ok"?: bool | *false

		// Ignore `ok` variables that hold the bool return value of a map
		// index.
		"ignore-map-index-ok"?: bool | *false

		// Ignore `ok` variables that hold the bool return value of a
		// channel receive.
		"ignore-chan-recv-ok"?: bool | *false

		// Optional list of variable names that should be ignored
		// completely.
		"ignore-names"?: [...string] | *[[]]

		// Optional list of variable declarations that should be ignored
		// completely.
		"ignore-decls"?: [...string]
	}
	whitespace?: {
		// Enforces newlines (or comments) after every multi-line if
		// statement
		"multi-if"?: bool | *false

		// Enforces newlines (or comments) after every multi-line function
		// signature
		"multi-func"?: bool | *false
	}
	wrapcheck?: {
		// An array of strings which specify substrings of signatures to
		// ignore.
		ignoreSigs?: [...string] | *[".Errorf(", "errors.New(", "errors.Unwrap(", ".Wrap(", ".Wrapf(", ".WithMessage(", ".WithMessagef(", ".WithStack("]

		// An array of strings which specify regular expressions of
		// signatures to ignore.
		ignoreSigRegexps?: [...string] | *[""]

		// An array of glob patterns which, if any match the package of
		// the function returning the error, will skip wrapcheck analysis
		// for this error.
		ignorePackageGlobs?: [...string] | *[""]

		// An array of glob patterns which, if matched to an underlying
		// interface name, will ignore unwrapped errors returned from a
		// function whose call is defined on the given interface.
		ignoreInterfaceRegexps?: [...string] | *[""]
	}
	wsl?: {
		// Controls if you may cuddle assignments and anything without
		// needing an empty line between them.
		"allow-assign-and-anything"?: bool | *false

		// Allow calls and assignments to be cuddled as long as the lines
		// have any matching variables, fields or types.
		"allow-assign-and-call"?: bool | *true

		// Allow declarations (var) to be cuddled.
		"allow-cuddle-declarations"?: bool | *false

		// A list of call idents that everything can be cuddled with.
		"allow-cuddle-with-calls"?: [...string]

		// AllowCuddleWithRHS is a list of right hand side variables that
		// is allowed to be cuddled with anything.
		"allow-cuddle-with-rhs"?: [...string]

		// Allow multiline assignments to be cuddled.
		"allow-multiline-assign"?: bool | *true

		// Allow leading comments to be separated with empty lines.
		"allow-separated-leading-comment"?: bool | *false

		// Allow trailing comments in ending of blocks.
		"allow-trailing-comment"?: bool | *false

		// When force-err-cuddling is enabled this is a list of names used
		// for error variables to check for in the conditional.
		"error-variable-names"?: [...string]

		// Force newlines in end of case at this limit (0 = never).
		"force-case-trailing-whitespace"?: int & >=0 | *0

		// Causes an error when an If statement that checks an error
		// variable doesn't cuddle with the assignment of that variable.
		"force-err-cuddling"?: bool | *false

		// Causes an error if a short declaration (:=) cuddles with
		// anything other than another short declaration.
		"force-short-decl-cuddling"?: bool | *false

		// If true, append is only allowed to be cuddled if appending
		// value is matching variables, fields or types on line above.
		"strict-append"?: bool | *true
	}
	copyloopvar?: "check-alias"?: bool | *false

	// The custom section can be used to define linter plugins to be
	// loaded at runtime. See README of golangci-lint for more
	// information.
	// Each custom linter should have a unique name.
	custom?: {
		{[=~"^.*$" & !~"^()$"]: ({
			type?: "module", ...
		} | {
			path: _, ...
		}) & {
			// The plugin type.
			type?: "module" | "goplugin" | *"goplugin"

			// The path to the plugin *.so. Can be absolute or local.
			path?: string

			// The description of the linter, for documentation purposes only.
			description?: string

			// Intended to point to the repo location of the linter, for
			// documentation purposes only.
			"original-url"?: string

			// Plugins settings/configuration. Only work with plugin based on
			// `linterdb.PluginConstructor`.
			settings?: {
				...
			}
		}}
		...
	}
}
linters?: {
	// List of enabled linters.
	enable?: [...#linters]

	// List of disabled linters.
	disable?: [...#linters]

	// Whether to enable all linters. You can re-disable them with
	// `disable` explicitly.
	"enable-all"?: bool | *false

	// Whether to disable all linters. You can re-enable them with
	// `enable` explicitly.
	"disable-all"?: bool | *false

	// Allow to use different presets of linters
	presets?: [..."bugs" | "comment" | "complexity" | "error" | "format" | "import" | "metalinter" | "module" | "performance" | "sql" | "style" | "test" | "unused"]

	// Enable run of fast linters.
	fast?: bool | *false
}
issues?: {
	// List of regular expressions of issue texts to exclude.
	// But independently from this option we use default exclude
	// patterns. Their usage can be controlled through
	// `exclude-use-default`.
	exclude?: [...string]

	// Exclude configuration per-path, per-linter, per-text and
	// per-source
	"exclude-rules"?: [...{
		path?:          string
		"path-except"?: string
		linters?: [...#linters]
		text?:   string
		source?: string
	}]

	// Independently from option `exclude` we use default exclude
	// patterns. This behavior can be disabled by this option.
	"exclude-use-default"?: bool | *true

	// If set to true, exclude and exclude-rules regular expressions
	// become case sensitive.
	"exclude-case-sensitive"?: bool | *false

	// Mode of the generated files analysis.
	"exclude-generated"?: "lax" | "strict" | "disable" | *"lax"

	// Which directories to exclude: issues from them won't be
	// reported.
	"exclude-dirs"?: [...string]

	// Enable exclusion of directories "vendor", "third_party",
	// "testdata", "examples", "Godeps", and "builtin".
	"exclude-dirs-use-default"?: bool | *true

	// Which files to exclude: they will be analyzed, but issues from
	// them will not be reported.
	"exclude-files"?: [...string]

	// The list of ids of default excludes to include or disable.
	include?: [...string]

	// Maximum issues count per one linter. Set to 0 to disable.
	"max-issues-per-linter"?: int & >=0 | *50

	// Maximum count of issues with the same text. Set to 0 to
	// disable.
	"max-same-issues"?: int & >=0 | *3

	// Show only new issues: if there are unstaged changes or
	// untracked files, only those changes are analyzed, else only
	// changes in HEAD~ are analyzed.
	new?: bool | *false

	// Show only new issues created after this git revision.
	"new-from-rev"?: string

	// Show only new issues created in git patch with this file path.
	"new-from-patch"?: string

	// Fix found issues (if it's supported by the linter).
	fix?: bool | *false

	// Show issues in any part of update files (requires new-from-rev
	// or new-from-patch).
	"whole-files"?: bool | *false
}
severity?: {
	// Set the default severity for issues. If severity rules are
	// defined and the issues do not match or no severity is provided
	// to the rule this will be the default severity applied.
	// Severities should match the supported severity names of the
	// selected out format.
	"default-severity": string | *""

	// If set to true, severity-rules regular expressions become case
	// sensitive.
	"case-sensitive"?: bool | *false

	// When a list of severity rules are provided, severity
	// information will be added to lint issues. Severity rules have
	// the same filtering capability as exclude rules except you are
	// allowed to specify one matcher per severity rule.
	// Only affects out formats that support setting severity
	// information.
	rules?: [...({
		path: _
		...
	} | {
		"path-except": _
		...
	} | {
		linters: _
		...
	} | {
		text: _
		...
	} | {
		source: _
		...
	}) & {
		severity:       string
		path?:          string
		"path-except"?: string
		linters?: [...#linters]
		text?:   string
		source?: string
	}]
}

#: "gocritic-checks": "appendAssign" | "appendCombine" | "argOrder" | "assignOp" | "badCall" | "badCond" | "badLock" | "badRegexp" | "badSorting" | "badSyncOnceFunc" | "boolExprSimplify" | "builtinShadow" | "builtinShadowDecl" | "captLocal" | "caseOrder" | "codegenComment" | "commentFormatting" | "commentedOutCode" | "commentedOutImport" | "defaultCaseOrder" | "deferInLoop" | "deferUnlambda" | "deprecatedComment" | "docStub" | "dupArg" | "dupBranchBody" | "dupCase" | "dupImport" | "dupSubExpr" | "dynamicFmtString" | "elseif" | "emptyDecl" | "emptyFallthrough" | "emptyStringTest" | "equalFold" | "evalOrder" | "exitAfterDefer" | "exposedSyncMutex" | "externalErrorReassign" | "filepathJoin" | "flagDeref" | "flagName" | "hexLiteral" | "httpNoBody" | "hugeParam" | "ifElseChain" | "importShadow" | "indexAlloc" | "initClause" | "ioutilDeprecated" | "mapKey" | "methodExprCall" | "nestingReduce" | "newDeref" | "nilValReturn" | "octalLiteral" | "offBy1" | "paramTypeCombine" | "preferDecodeRune" | "preferFilepathJoin" | "preferFprint" | "preferStringWriter" | "preferWriteByte" | "ptrToRefParam" | "rangeAppendAll" | "rangeExprCopy" | "rangeValCopy" | "redundantSprint" | "regexpMust" | "regexpPattern" | "regexpSimplify" | "returnAfterHttpError" | "ruleguard" | "singleCaseSwitch" | "sliceClear" | "sloppyLen" | "sloppyReassign" | "sloppyTypeAssert" | "sortSlice" | "sprintfQuotedString" | "sqlQuery" | "stringConcatSimplify" | "stringXbytes" | "stringsCompare" | "switchTrue" | "syncMapLoadAndDelete" | "timeExprSimplify" | "todoCommentWithoutDetail" | "tooManyResultsChecker" | "truncateCmp" | "typeAssertChain" | "typeDefFirst" | "typeSwitchVar" | "typeUnparen" | "uncheckedInlineErr" | "underef" | "unlabelStmt" | "unlambda" | "unnamedResult" | "unnecessaryBlock" | "unnecessaryDefer" | "unslice" | "valSwap" | "weakCond" | "whyNoLint" | "wrapperFunc" | "yodaStyleExpr"

#: "gocritic-tags": "diagnostic" | "style" | "performance" | "experimental" | "opinionated" | "security"

#: "gosec-rules": "G101" | "G102" | "G103" | "G104" | "G106" | "G107" | "G108" | "G109" | "G110" | "G111" | "G112" | "G113" | "G114" | "G115" | "G201" | "G202" | "G203" | "G204" | "G301" | "G302" | "G303" | "G304" | "G305" | "G306" | "G307" | "G401" | "G402" | "G403" | "G404" | "G405" | "G406" | "G501" | "G502" | "G503" | "G504" | "G505" | "G506" | "G507" | "G601" | "G602"

#: "govet-analyzers": "appends" | "asmdecl" | "assign" | "atomic" | "atomicalign" | "bools" | "buildtag" | "cgocall" | "composites" | "copylocks" | "deepequalerrors" | "defers" | "directive" | "errorsas" | "fieldalignment" | "findcall" | "framepointer" | "httpresponse" | "ifaceassert" | "loopclosure" | "lostcancel" | "nilfunc" | "nilness" | "printf" | "reflectvaluecompare" | "shadow" | "shift" | "sigchanyzer" | "slog" | "sortslice" | "stdmethods" | "stringintconv" | "structtag" | "testinggoroutine" | "tests" | "timeformat" | "unmarshal" | "unreachable" | "unsafeptr" | "unusedresult" | "unusedwrite"

#: "revive-rules": "add-constant" | "argument-limit" | "atomic" | "banned-characters" | "bare-return" | "blank-imports" | "bool-literal-in-expr" | "call-to-gc" | "cognitive-complexity" | "comment-spacings" | "comments-density" | "confusing-naming" | "confusing-results" | "constant-logical-expr" | "context-as-argument" | "context-keys-type" | "cyclomatic" | "datarace" | "deep-exit" | "defer" | "dot-imports" | "duplicated-imports" | "early-return" | "empty-block" | "empty-lines" | "enforce-map-style" | "enforce-repeated-arg-type-style" | "enforce-slice-style" | "error-naming" | "error-return" | "error-strings" | "errorf" | "exported" | "file-header" | "file-length-limit" | "filename-format" | "flag-parameter" | "function-length" | "function-result-limit" | "get-return" | "identical-branches" | "if-return" | "import-alias-naming" | "import-shadowing" | "imports-blocklist" | "increment-decrement" | "indent-error-flow" | "line-length-limit" | "max-control-nesting" | "max-public-structs" | "modifies-parameter" | "modifies-value-receiver" | "nested-structs" | "optimize-operands-order" | "package-comments" | "range" | "range-val-address" | "range-val-in-closure" | "receiver-naming" | "redefines-builtin-id" | "redundant-import-alias" | "string-format" | "string-of-int" | "struct-tag" | "superfluous-else" | "time-equal" | "time-naming" | "unchecked-type-assertion" | "unconditional-recursion" | "unexported-naming" | "unexported-return" | "unhandled-error" | "unnecessary-stmt" | "unreachable-code" | "unused-parameter" | "unused-receiver" | "use-any" | "useless-break" | "var-declaration" | "var-naming" | "waitgroup-by-value"

#: "iface-analyzers": "identical" | "unused" | "opaque"

#linters: ("asasalint" | "asciicheck" | "bidichk" | "bodyclose" | "canonicalheader" | "containedctx" | "contextcheck" | "copyloopvar" | "cyclop" | "decorder" | "depguard" | "dogsled" | "dupl" | "dupword" | "durationcheck" | "errcheck" | "errchkjson" | "errname" | "errorlint" | "exhaustive" | "exhaustruct" | "exportloopref" | "fatcontext" | "forbidigo" | "forcetypeassert" | "funlen" | "gci" | "ginkgolinter" | "gocheckcompilerdirectives" | "gochecknoglobals" | "gochecknoinits" | "gochecksumtype" | "gocognit" | "goconst" | "gocritic" | "gocyclo" | "godot" | "godox" | "err113" | "gofmt" | "gofumpt" | "goheader" | "goimports" | "gomoddirectives" | "gomodguard" | "goprintffuncname" | "gosec" | "gosimple" | "gosmopolitan" | "govet" | "grouper" | "iface" | "importas" | "inamedparam" | "ineffassign" | "interfacebloat" | "intrange" | "ireturn" | "lll" | "loggercheck" | "maintidx" | "makezero" | "mirror" | "misspell" | "mnd" | "musttag" | "nakedret" | "nestif" | "nilerr" | "nilnil" | "nlreturn" | "noctx" | "nolintlint" | "nonamedreturns" | "nosprintfhostport" | "paralleltest" | "perfsprint" | "prealloc" | "predeclared" | "promlinter" | "protogetter" | "reassign" | "recvcheck" | "revive" | "rowserrcheck" | "sloglint" | "sqlclosecheck" | "staticcheck" | "stylecheck" | "tagalign" | "tagliatelle" | "tenv" | "testableexamples" | "testifylint" | "testpackage" | "thelper" | "tparallel" | "unconvert" | "unparam" | "unused" | "usestdlibvars" | "varnamelen" | "wastedassign" | "whitespace" | "wrapcheck" | "wsl" | "zerologlint" | string) & string
