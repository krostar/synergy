import "list"

@jsonschema(schema="http://json-schema.org/draft-07/schema#")
@jsonschema(id="https://json.schemastore.org/golangci-lint.json")
close({
	version!: string

	// Options for analysis running,
	run?: close({
		// Number of concurrent runners. Defaults to the number of
		// available CPU cores.
		concurrency?: int & >=0

		// Timeout for the analysis.
		timeout?: =~"^((\\d+h)?(\\d+m)?(\\d+(?:\\.\\d)?s)?|0)$"

		// Exit code when at least one issue was found.
		"issues-exit-code"?: int

		// Enable inclusion of test files.
		tests?: bool

		// List of build tags to pass to all linters.
		"build-tags"?: [...string]

		// Option to pass to "go list -mod={option}".
		// See "go help modules" for more information.
		"modules-download-mode"?: "mod" | "readonly" | "vendor"

		// Allow multiple parallel golangci-lint instances running. If
		// disabled, golangci-lint acquires file lock on start.
		"allow-parallel-runners"?: bool

		// Allow multiple golangci-lint instances running, but serialize
		// them around a lock.
		"allow-serial-runners"?: bool

		// Targeted Go version.
		go?:                   string
		"relative-path-mode"?: #."relative-path-modes"
	})

	// Output configuration options.
	output?: close({
		// Output formats to use.
		formats?: close({
			text?: close({
				path?:                 #."formats-path"
				"print-linter-name"?:  bool
				"print-issued-lines"?: bool
				colors?:               bool
			})
			json?: #."simple-format"
			tab?: close({
				path?:                #."formats-path"
				"print-linter-name"?: bool
				colors?:              bool
			})
			html?:           #."simple-format"
			checkstyle?:     #."simple-format"
			"code-climate"?: #."simple-format"
			"junit-xml"?: close({
				path?:     #."formats-path"
				extended?: bool
			})
			teamcity?: #."simple-format"
			sarif?:    #."simple-format"
		})
		"path-mode"?: string

		// Add a prefix to the output file references.
		"path-prefix"?: string

		// Show statistics per linter.
		"show-stats"?: bool
		"sort-order"?: [..."linter" | "severity" | "file"]
	})
	linters?: close({
		default?: "standard" | "all" | "none" | "fast"

		// List of enabled linters.
		enable?: [...#."linter-names"]

		// List of disabled linters.
		disable?: [...#."linter-names"]

		// All available settings of specific linters.
		settings?: close({
			dupword?:                  _#defs."/definitions/settings/definitions/dupwordSettings"
			asasalint?:                _#defs."/definitions/settings/definitions/asasalintSettings"
			bidichk?:                  _#defs."/definitions/settings/definitions/bidichkSettings"
			cyclop?:                   _#defs."/definitions/settings/definitions/cyclopSettings"
			decorder?:                 _#defs."/definitions/settings/definitions/decorderSettings"
			depguard?:                 _#defs."/definitions/settings/definitions/depguardSettings"
			dogsled?:                  _#defs."/definitions/settings/definitions/dogsledSettings"
			dupl?:                     _#defs."/definitions/settings/definitions/duplSettings"
			embeddedstructfieldcheck?: _#defs."/definitions/settings/definitions/embeddedstructfieldcheckSettings"
			errcheck?:                 _#defs."/definitions/settings/definitions/errcheckSettings"
			errchkjson?:               _#defs."/definitions/settings/definitions/errchkjsonSettings"
			errorlint?:                _#defs."/definitions/settings/definitions/errorlintSettings"
			exhaustive?:               _#defs."/definitions/settings/definitions/exhaustiveSettings"
			exhaustruct?:              _#defs."/definitions/settings/definitions/exhaustructSettings"
			fatcontext?:               _#defs."/definitions/settings/definitions/fatcontextSettings"
			forbidigo?:                _#defs."/definitions/settings/definitions/forbidigoSettings"
			funcorder?:                _#defs."/definitions/settings/definitions/funcorderSettings"
			funlen?:                   _#defs."/definitions/settings/definitions/funlenSettings"
			ginkgolinter?:             _#defs."/definitions/settings/definitions/ginkgolinterSettings"
			gochecksumtype?:           _#defs."/definitions/settings/definitions/gochecksumtypeSettings"
			gocognit?:                 _#defs."/definitions/settings/definitions/gocognitSettings"
			goconst?:                  _#defs."/definitions/settings/definitions/goconstSettings"
			gocritic?:                 _#defs."/definitions/settings/definitions/gocriticSettings"
			gocyclo?:                  _#defs."/definitions/settings/definitions/gocycloSettings"
			godot?:                    _#defs."/definitions/settings/definitions/godotSettings"
			godox?:                    _#defs."/definitions/settings/definitions/godoxSettings"
			interfacebloat?:           _#defs."/definitions/settings/definitions/interfacebloatSettings"
			goheader?:                 _#defs."/definitions/settings/definitions/goheaderSettings"
			gomoddirectives?:          _#defs."/definitions/settings/definitions/gomoddirectivesSettings"
			gomodguard?:               _#defs."/definitions/settings/definitions/gomodguardSettings"
			gosec?:                    _#defs."/definitions/settings/definitions/gosecSettings"
			gosmopolitan?:             _#defs."/definitions/settings/definitions/gosmopolitanSettings"
			govet?:                    _#defs."/definitions/settings/definitions/govetSettings"
			grouper?:                  _#defs."/definitions/settings/definitions/grouperSettings"
			iface?:                    _#defs."/definitions/settings/definitions/ifaceSettings"
			importas?:                 _#defs."/definitions/settings/definitions/importasSettings"
			inamedparam?:              _#defs."/definitions/settings/definitions/inamedparamSettings"
			ireturn?:                  _#defs."/definitions/settings/definitions/ireturnSettings"
			lll?:                      _#defs."/definitions/settings/definitions/lllSettings"
			maintidx?:                 _#defs."/definitions/settings/definitions/maintidxSettings"
			makezero?:                 _#defs."/definitions/settings/definitions/makezeroSettings"
			loggercheck?:              _#defs."/definitions/settings/definitions/loggercheckSettings"
			misspell?:                 _#defs."/definitions/settings/definitions/misspellSettings"
			musttag?:                  _#defs."/definitions/settings/definitions/musttagSettings"
			nakedret?:                 _#defs."/definitions/settings/definitions/nakedretSettings"
			nestif?:                   _#defs."/definitions/settings/definitions/nestifSettings"
			nilnil?:                   _#defs."/definitions/settings/definitions/nilnilSettings"
			nlreturn?:                 _#defs."/definitions/settings/definitions/nlreturnSettings"
			mnd?:                      _#defs."/definitions/settings/definitions/mndSettings"
			nolintlint?:               _#defs."/definitions/settings/definitions/nolintlintSettings"
			reassign?:                 _#defs."/definitions/settings/definitions/reassignSettings"
			recvcheck?:                _#defs."/definitions/settings/definitions/recvcheckSettings"
			nonamedreturns?:           _#defs."/definitions/settings/definitions/nonamedreturnsSettings"
			paralleltest?:             _#defs."/definitions/settings/definitions/paralleltestSettings"
			perfsprint?:               _#defs."/definitions/settings/definitions/perfsprintSettings"
			prealloc?:                 _#defs."/definitions/settings/definitions/preallocSettings"
			predeclared?:              _#defs."/definitions/settings/definitions/predeclaredSettings"
			promlinter?:               _#defs."/definitions/settings/definitions/promlinterSettings"
			protogetter?:              _#defs."/definitions/settings/definitions/protogetterSettings"
			revive?:                   _#defs."/definitions/settings/definitions/reviveSettings"
			rowserrcheck?:             _#defs."/definitions/settings/definitions/rowserrcheckSettings"
			sloglint?:                 _#defs."/definitions/settings/definitions/sloglintSettings"
			spancheck?:                _#defs."/definitions/settings/definitions/spancheckSettings"
			staticcheck?:              _#defs."/definitions/settings/definitions/staticcheckSettings"
			tagalign?:                 _#defs."/definitions/settings/definitions/tagalignSettings"
			tagliatelle?:              _#defs."/definitions/settings/definitions/tagliatelleSettings"
			testifylint?:              _#defs."/definitions/settings/definitions/testifylintSettings"
			testpackage?:              _#defs."/definitions/settings/definitions/testpackageSettings"
			thelper?:                  _#defs."/definitions/settings/definitions/thelperSettings"
			usestdlibvars?:            _#defs."/definitions/settings/definitions/usestdlibvarsSettings"
			usetesting?:               _#defs."/definitions/settings/definitions/usetestingSettings"
			unconvert?:                _#defs."/definitions/settings/definitions/unconvertSettings"
			unparam?:                  _#defs."/definitions/settings/definitions/unparamSettings"
			unused?:                   _#defs."/definitions/settings/definitions/unusedSettings"
			varnamelen?:               _#defs."/definitions/settings/definitions/varnamelenSettings"
			whitespace?:               _#defs."/definitions/settings/definitions/whitespaceSettings"
			wrapcheck?:                _#defs."/definitions/settings/definitions/wrapcheckSettings"
			wsl?:                      _#defs."/definitions/settings/definitions/wslSettings"
			wsl_v5?:                   _#defs."/definitions/settings/definitions/wslSettingsV5"
			copyloopvar?:              _#defs."/definitions/settings/definitions/copyloopvarSettings"
			custom?:                   _#defs."/definitions/settings/definitions/customSettings"
		})
		exclusions?: close({
			generated?:     "strict" | "lax" | "disable"
			"warn-unused"?: bool
			presets?: [..."comments" | "std-error-handling" | "common-false-positives" | "legacy"]
			rules?: [...matchN(>=1, [{
				path!: _
				...
			}, {
				"path-except"!: _
				...
			}, {
				linters!: _
				...
			}, {
				text!: _
				...
			}, {
				source!: _
				...
			}]) & {
				path?:          string
				"path-except"?: string
				linters?: [...#."linter-names"]
				text?:   string
				source?: string
				...
			}]
			paths?: [...string]
			"paths-except"?: [...string]
		})
	})
	formatters?: close({
		// List of enabled formatters.
		enable?: [...#."formatter-names"]
		settings?: close({
			gci?:       _#defs."/definitions/settings/definitions/gciSettings"
			gofmt?:     _#defs."/definitions/settings/definitions/gofmtSettings"
			gofumpt?:   _#defs."/definitions/settings/definitions/gofumptSettings"
			goimports?: _#defs."/definitions/settings/definitions/goimportsSettings"
			golines?:   _#defs."/definitions/settings/definitions/golinesSettings"
		})
		exclusions?: close({
			generated?: "strict" | "lax" | "disable"
			paths?: [...string]
			"warn-unused"?: bool
		})
	})
	issues?: close({
		// Maximum issues count per one linter. Set to 0 to disable.
		"max-issues-per-linter"?: int & >=0

		// Maximum count of issues with the same text. Set to 0 to
		// disable.
		"max-same-issues"?: int & >=0

		// Show only new issues: if there are unstaged changes or
		// untracked files, only those changes are analyzed, else only
		// changes in HEAD~ are analyzed.
		new?: bool

		// Show only new issues created after the best common ancestor
		// (merge-base against HEAD).
		"new-from-merge-base"?: string

		// Show only new issues created after this git revision.
		"new-from-rev"?: string

		// Show only new issues created in git patch with this file path.
		"new-from-patch"?: string

		// Fix found issues (if it's supported by the linter).
		fix?: bool

		// Make issues output unique by line.
		"uniq-by-line"?: bool

		// Show issues in any part of update files (requires new-from-rev
		// or new-from-patch).
		"whole-files"?: bool
	})
	severity?: close({
		// Set the default severity for issues. If severity rules are
		// defined and the issues do not match or no severity is provided
		// to the rule this will be the default severity applied.
		// Severities should match the supported severity names of the
		// selected out format.
		default!: string

		// When a list of severity rules are provided, severity
		// information will be added to lint issues. Severity rules have
		// the same filtering capability as exclude rules except you are
		// allowed to specify one matcher per severity rule.
		// Only affects out formats that support setting severity
		// information.
		rules?: [...matchN(>=1, [{
			path!: _
			...
		}, {
			"path-except"!: _
			...
		}, {
			linters!: _
			...
		}, {
			text!: _
			...
		}, {
			source!: _
			...
		}]) & close({
			severity!:      string
			path?:          string
			"path-except"?: string
			linters?: [...#."linter-names"]
			text?:   string
			source?: string
		})]
	})
})

#: "formats-path": matchN(>=1, ["stdout" | "stderr", string])

// Usable formatter names.
#: "formatter-names": "gci" | "gofmt" | "gofumpt" | "goimports" | "golines" | "swaggo"

#: "gocritic-checks": "appendAssign" | "appendCombine" | "argOrder" | "assignOp" | "badCall" | "badCond" | "badLock" | "badRegexp" | "badSorting" | "badSyncOnceFunc" | "boolExprSimplify" | "builtinShadow" | "builtinShadowDecl" | "captLocal" | "caseOrder" | "codegenComment" | "commentFormatting" | "commentedOutCode" | "commentedOutImport" | "defaultCaseOrder" | "deferInLoop" | "deferUnlambda" | "deprecatedComment" | "docStub" | "dupArg" | "dupBranchBody" | "dupCase" | "dupImport" | "dupSubExpr" | "dynamicFmtString" | "elseif" | "emptyDecl" | "emptyFallthrough" | "emptyStringTest" | "equalFold" | "evalOrder" | "exitAfterDefer" | "exposedSyncMutex" | "externalErrorReassign" | "filepathJoin" | "flagDeref" | "flagName" | "hexLiteral" | "httpNoBody" | "hugeParam" | "ifElseChain" | "importShadow" | "indexAlloc" | "initClause" | "ioutilDeprecated" | "mapKey" | "methodExprCall" | "nestingReduce" | "newDeref" | "nilValReturn" | "octalLiteral" | "offBy1" | "paramTypeCombine" | "preferDecodeRune" | "preferFilepathJoin" | "preferFprint" | "preferStringWriter" | "preferWriteByte" | "ptrToRefParam" | "rangeAppendAll" | "rangeExprCopy" | "rangeValCopy" | "redundantSprint" | "regexpMust" | "regexpPattern" | "regexpSimplify" | "returnAfterHttpError" | "ruleguard" | "singleCaseSwitch" | "sliceClear" | "sloppyLen" | "sloppyReassign" | "sloppyTypeAssert" | "sortSlice" | "sprintfQuotedString" | "sqlQuery" | "stringConcatSimplify" | "stringXbytes" | "stringsCompare" | "switchTrue" | "syncMapLoadAndDelete" | "timeExprSimplify" | "todoCommentWithoutDetail" | "tooManyResultsChecker" | "truncateCmp" | "typeAssertChain" | "typeDefFirst" | "typeSwitchVar" | "typeUnparen" | "uncheckedInlineErr" | "underef" | "unlabelStmt" | "unlambda" | "unnamedResult" | "unnecessaryBlock" | "unnecessaryDefer" | "unslice" | "valSwap" | "weakCond" | "whyNoLint" | "wrapperFunc" | "yodaStyleExpr"

#: "gocritic-tags": "diagnostic" | "style" | "performance" | "experimental" | "opinionated" | "security"

#: "gosec-rules": "G101" | "G102" | "G103" | "G104" | "G106" | "G107" | "G108" | "G109" | "G110" | "G111" | "G112" | "G114" | "G115" | "G201" | "G202" | "G203" | "G204" | "G301" | "G302" | "G303" | "G304" | "G305" | "G306" | "G307" | "G401" | "G402" | "G403" | "G404" | "G405" | "G406" | "G501" | "G502" | "G503" | "G504" | "G505" | "G506" | "G507" | "G601" | "G602"

#: "govet-analyzers": "appends" | "asmdecl" | "assign" | "atomic" | "atomicalign" | "bools" | "buildtag" | "cgocall" | "composites" | "copylocks" | "deepequalerrors" | "defers" | "directive" | "errorsas" | "fieldalignment" | "findcall" | "framepointer" | "hostport" | "httpmux" | "httpresponse" | "ifaceassert" | "loopclosure" | "lostcancel" | "nilfunc" | "nilness" | "printf" | "reflectvaluecompare" | "shadow" | "shift" | "sigchanyzer" | "slog" | "sortslice" | "stdmethods" | "stdversion" | "stringintconv" | "structtag" | "testinggoroutine" | "tests" | "timeformat" | "unmarshal" | "unreachable" | "unsafeptr" | "unusedresult" | "unusedwrite" | "waitgroup"

#: "iface-analyzers": "identical" | "unused" | "opaque" | "unexported"

// Usable linter names.
#: "linter-names": matchN(>=1, ["arangolint" | "asasalint" | "asciicheck" | "bidichk" | "bodyclose" | "canonicalheader" | "containedctx" | "contextcheck" | "copyloopvar" | "cyclop" | "decorder" | "depguard" | "dogsled" | "dupl" | "dupword" | "durationcheck" | "embeddedstructfieldcheck" | "errcheck" | "errchkjson" | "errname" | "errorlint" | "exhaustive" | "exhaustruct" | "exptostd" | "fatcontext" | "forbidigo" | "forcetypeassert" | "funcorder" | "funlen" | "ginkgolinter" | "gocheckcompilerdirectives" | "gochecknoglobals" | "gochecknoinits" | "gochecksumtype" | "gocognit" | "goconst" | "gocritic" | "gocyclo" | "godot" | "godox" | "err113" | "goheader" | "gomoddirectives" | "gomodguard" | "goprintffuncname" | "gosec" | "gosimple" | "gosmopolitan" | "govet" | "grouper" | "iface" | "importas" | "inamedparam" | "ineffassign" | "interfacebloat" | "intrange" | "ireturn" | "lll" | "loggercheck" | "maintidx" | "makezero" | "mirror" | "misspell" | "mnd" | "musttag" | "nakedret" | "nestif" | "nilerr" | "nilnesserr" | "nilnil" | "nlreturn" | "noctx" | "noinlineerr" | "nolintlint" | "nonamedreturns" | "nosprintfhostport" | "paralleltest" | "perfsprint" | "prealloc" | "predeclared" | "promlinter" | "protogetter" | "reassign" | "recvcheck" | "revive" | "rowserrcheck" | "sloglint" | "sqlclosecheck" | "staticcheck" | "stylecheck" | "tagalign" | "tagliatelle" | "testableexamples" | "testifylint" | "testpackage" | "thelper" | "tparallel" | "unconvert" | "unparam" | "unused" | "usestdlibvars" | "usetesting" | "varnamelen" | "wastedassign" | "whitespace" | "wrapcheck" | "wsl" | "wsl_v5" | "zerologlint", string])

#: "relative-path-modes": "gomod" | "gitroot" | "cfg" | "wd"

#: "revive-rules": "add-constant" | "argument-limit" | "atomic" | "banned-characters" | "bare-return" | "blank-imports" | "bool-literal-in-expr" | "call-to-gc" | "cognitive-complexity" | "comment-spacings" | "comments-density" | "confusing-naming" | "confusing-results" | "constant-logical-expr" | "context-as-argument" | "context-keys-type" | "cyclomatic" | "datarace" | "deep-exit" | "defer" | "dot-imports" | "duplicated-imports" | "early-return" | "empty-block" | "empty-lines" | "enforce-map-style" | "enforce-repeated-arg-type-style" | "enforce-slice-style" | "enforce-switch-style" | "error-naming" | "error-return" | "error-strings" | "errorf" | "exported" | "file-header" | "file-length-limit" | "filename-format" | "flag-parameter" | "function-length" | "function-result-limit" | "get-return" | "identical-branches" | "if-return" | "import-alias-naming" | "import-shadowing" | "imports-blocklist" | "increment-decrement" | "indent-error-flow" | "line-length-limit" | "max-control-nesting" | "max-public-structs" | "modifies-parameter" | "modifies-value-receiver" | "nested-structs" | "optimize-operands-order" | "package-comments" | "range-val-address" | "range-val-in-closure" | "range" | "receiver-naming" | "redefines-builtin-id" | "redundant-build-tag" | "redundant-import-alias" | "redundant-test-main-exit" | "string-format" | "string-of-int" | "struct-tag" | "superfluous-else" | "time-date" | "time-equal" | "time-naming" | "unchecked-type-assertion" | "unconditional-recursion" | "unexported-naming" | "unexported-return" | "unhandled-error" | "unnecessary-format" | "unnecessary-stmt" | "unreachable-code" | "unused-parameter" | "unused-receiver" | "use-any" | "use-errors-new" | "use-fmt-print" | "useless-break" | "var-declaration" | "var-naming" | "waitgroup-by-value"

#: "simple-format": close({
	path?: #."formats-path"
})

#: "staticcheck-checks": "*" | "all" | "SA*" | "-SA*" | "SA1*" | "-SA1*" | "SA1000" | "-SA1000" | "SA1001" | "-SA1001" | "SA1002" | "-SA1002" | "SA1003" | "-SA1003" | "SA1004" | "-SA1004" | "SA1005" | "-SA1005" | "SA1006" | "-SA1006" | "SA1007" | "-SA1007" | "SA1008" | "-SA1008" | "SA1010" | "-SA1010" | "SA1011" | "-SA1011" | "SA1012" | "-SA1012" | "SA1013" | "-SA1013" | "SA1014" | "-SA1014" | "SA1015" | "-SA1015" | "SA1016" | "-SA1016" | "SA1017" | "-SA1017" | "SA1018" | "-SA1018" | "SA1019" | "-SA1019" | "SA1020" | "-SA1020" | "SA1021" | "-SA1021" | "SA1023" | "-SA1023" | "SA1024" | "-SA1024" | "SA1025" | "-SA1025" | "SA1026" | "-SA1026" | "SA1027" | "-SA1027" | "SA1028" | "-SA1028" | "SA1029" | "-SA1029" | "SA1030" | "-SA1030" | "SA1031" | "-SA1031" | "SA1032" | "-SA1032" | "SA2*" | "-SA2*" | "SA2000" | "-SA2000" | "SA2001" | "-SA2001" | "SA2002" | "-SA2002" | "SA2003" | "-SA2003" | "SA3*" | "-SA3*" | "SA3000" | "-SA3000" | "SA3001" | "-SA3001" | "SA4*" | "-SA4*" | "SA4000" | "-SA4000" | "SA4001" | "-SA4001" | "SA4003" | "-SA4003" | "SA4004" | "-SA4004" | "SA4005" | "-SA4005" | "SA4006" | "-SA4006" | "SA4008" | "-SA4008" | "SA4009" | "-SA4009" | "SA4010" | "-SA4010" | "SA4011" | "-SA4011" | "SA4012" | "-SA4012" | "SA4013" | "-SA4013" | "SA4014" | "-SA4014" | "SA4015" | "-SA4015" | "SA4016" | "-SA4016" | "SA4017" | "-SA4017" | "SA4018" | "-SA4018" | "SA4019" | "-SA4019" | "SA4020" | "-SA4020" | "SA4021" | "-SA4021" | "SA4022" | "-SA4022" | "SA4023" | "-SA4023" | "SA4024" | "-SA4024" | "SA4025" | "-SA4025" | "SA4026" | "-SA4026" | "SA4027" | "-SA4027" | "SA4028" | "-SA4028" | "SA4029" | "-SA4029" | "SA4030" | "-SA4030" | "SA4031" | "-SA4031" | "SA4032" | "-SA4032" | "SA5*" | "-SA5*" | "SA5000" | "-SA5000" | "SA5001" | "-SA5001" | "SA5002" | "-SA5002" | "SA5003" | "-SA5003" | "SA5004" | "-SA5004" | "SA5005" | "-SA5005" | "SA5007" | "-SA5007" | "SA5008" | "-SA5008" | "SA5009" | "-SA5009" | "SA5010" | "-SA5010" | "SA5011" | "-SA5011" | "SA5012" | "-SA5012" | "SA6*" | "-SA6*" | "SA6000" | "-SA6000" | "SA6001" | "-SA6001" | "SA6002" | "-SA6002" | "SA6003" | "-SA6003" | "SA6005" | "-SA6005" | "SA6006" | "-SA6006" | "SA9*" | "-SA9*" | "SA9001" | "-SA9001" | "SA9002" | "-SA9002" | "SA9003" | "-SA9003" | "SA9004" | "-SA9004" | "SA9005" | "-SA9005" | "SA9006" | "-SA9006" | "SA9007" | "-SA9007" | "SA9008" | "-SA9008" | "SA9009" | "-SA9009" | "ST*" | "-ST*" | "ST1*" | "-ST1*" | "ST1000" | "-ST1000" | "ST1001" | "-ST1001" | "ST1003" | "-ST1003" | "ST1005" | "-ST1005" | "ST1006" | "-ST1006" | "ST1008" | "-ST1008" | "ST1011" | "-ST1011" | "ST1012" | "-ST1012" | "ST1013" | "-ST1013" | "ST1015" | "-ST1015" | "ST1016" | "-ST1016" | "ST1017" | "-ST1017" | "ST1018" | "-ST1018" | "ST1019" | "-ST1019" | "ST1020" | "-ST1020" | "ST1021" | "-ST1021" | "ST1022" | "-ST1022" | "ST1023" | "-ST1023" | "S*" | "-S*" | "S1*" | "-S1*" | "S1000" | "-S1000" | "S1001" | "-S1001" | "S1002" | "-S1002" | "S1003" | "-S1003" | "S1004" | "-S1004" | "S1005" | "-S1005" | "S1006" | "-S1006" | "S1007" | "-S1007" | "S1008" | "-S1008" | "S1009" | "-S1009" | "S1010" | "-S1010" | "S1011" | "-S1011" | "S1012" | "-S1012" | "S1016" | "-S1016" | "S1017" | "-S1017" | "S1018" | "-S1018" | "S1019" | "-S1019" | "S1020" | "-S1020" | "S1021" | "-S1021" | "S1023" | "-S1023" | "S1024" | "-S1024" | "S1025" | "-S1025" | "S1028" | "-S1028" | "S1029" | "-S1029" | "S1030" | "-S1030" | "S1031" | "-S1031" | "S1032" | "-S1032" | "S1033" | "-S1033" | "S1034" | "-S1034" | "S1035" | "-S1035" | "S1036" | "-S1036" | "S1037" | "-S1037" | "S1038" | "-S1038" | "S1039" | "-S1039" | "S1040" | "-S1040" | "QF*" | "-QF*" | "QF1*" | "-QF1*" | "QF1001" | "-QF1001" | "QF1002" | "-QF1002" | "QF1003" | "-QF1003" | "QF1004" | "-QF1004" | "QF1005" | "-QF1005" | "QF1006" | "-QF1006" | "QF1007" | "-QF1007" | "QF1008" | "-QF1008" | "QF1009" | "-QF1009" | "QF1010" | "-QF1010" | "QF1011" | "-QF1011" | "QF1012" | "-QF1012"

#: "tagliatelle-cases": "" | "camel" | "pascal" | "kebab" | "snake" | "goCamel" | "goPascal" | "goKebab" | "goSnake" | "upper" | "upperSnake" | "lower" | "header"

#: "wsl-checks": "assign" | "branch" | "decl" | "defer" | "expr" | "for" | "go" | "if" | "inc-dec" | "label" | "range" | "return" | "select" | "send" | "switch" | "type-switch" | "append" | "assign-exclusive" | "assign-expr" | "err" | "leading-whitespace" | "trailing-whitespace"

#settings: _

_#defs: "/definitions/settings/definitions/asasalintSettings": close({
	// To specify a set of function names to exclude.
	exclude?: list.UniqueItems() & [...string]

	// To enable/disable the asasalint builtin exclusions of function
	// names.
	"use-builtin-exclusions"?: bool
})

_#defs: "/definitions/settings/definitions/bidichkSettings": close({
	// Disallow: LEFT-TO-RIGHT-EMBEDDING
	"left-to-right-embedding"?: bool

	// Disallow: RIGHT-TO-LEFT-EMBEDDING
	"right-to-left-embedding"?: bool

	// Disallow: POP-DIRECTIONAL-FORMATTING
	"pop-directional-formatting"?: bool

	// Disallow: LEFT-TO-RIGHT-OVERRIDE
	"left-to-right-override"?: bool

	// Disallow: RIGHT-TO-LEFT-OVERRIDE
	"right-to-left-override"?: bool

	// Disallow: LEFT-TO-RIGHT-ISOLATE
	"left-to-right-isolate"?: bool

	// Disallow: RIGHT-TO-LEFT-ISOLATE
	"right-to-left-isolate"?: bool

	// Disallow: FIRST-STRONG-ISOLATE
	"first-strong-isolate"?: bool

	// Disallow: POP-DIRECTIONAL-ISOLATE
	"pop-directional-isolate"?: bool
})

_#defs: "/definitions/settings/definitions/copyloopvarSettings": close({
	"check-alias"?: bool
})

// The custom section can be used to define linter plugins to be
// loaded at runtime. See README of golangci-lint for more
// information.
// Each custom linter should have a unique name.
_#defs: "/definitions/settings/definitions/customSettings": {
	{[=~"^.*$"]: matchN(1, [{
		type!: "module"
		...
	}, {
		path!: _
		...
	}]) & close({
		// The plugin type.
		type?: "module" | "goplugin"

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
	})
	}
	...
}

_#defs: "/definitions/settings/definitions/cyclopSettings": close({
	// Max complexity the function can have
	"max-complexity"?: int & >=0

	// Max average complexity in package
	"package-average"?: >=0
})

_#defs: "/definitions/settings/definitions/decorderSettings": close({
	"dec-order"?: [..."type" | "const" | "var" | "func"]

	// Underscore vars (vars with "_" as the name) will be ignored at
	// all checks
	"ignore-underscore-vars"?: bool

	// Order of declarations is not checked
	"disable-dec-order-check"?: bool

	// Allow init func to be anywhere in file
	"disable-init-func-first-check"?: bool

	// Multiple global type, const and var declarations are allowed
	"disable-dec-num-check"?: bool

	// Type declarations will be ignored for dec num check
	"disable-type-dec-num-check"?: bool

	// Const declarations will be ignored for dec num check
	"disable-const-dec-num-check"?: bool

	// Var declarations will be ignored for dec num check
	"disable-var-dec-num-check"?: bool
})

_#defs: "/definitions/settings/definitions/depguardSettings": close({
	// Rules to apply.
	rules?: close({
		{[=~"^[^.]+$"]: close({
			// Used to determine the package matching priority.
			"list-mode"?: "original" | "strict" | "lax"

			// List of file globs that will match this list of settings to
			// compare against.
			files?: [...string]

			// List of allowed packages.
			allow?: [...string]

			// Packages that are not allowed where the value is a suggestion.
			deny?: [...close({
				// Description
				desc?: string

				// Package
				pkg?: string
			})]
		})
		}
	})
})

_#defs: "/definitions/settings/definitions/dogsledSettings": close({
	// Check assignments with too many blank identifiers.
	"max-blank-identifiers"?: int & >=0
})

_#defs: "/definitions/settings/definitions/duplSettings": close({
	// Tokens count to trigger issue.
	threshold?: int & >=0
})

_#defs: "/definitions/settings/definitions/dupwordSettings": close({
	// Keywords for detecting duplicate words. If this list is not
	// empty, only the words defined in this list will be detected.
	keywords?: list.UniqueItems() & [...string]

	// Keywords used to ignore detection.
	ignore?: list.UniqueItems() & [...string]
})

_#defs: "/definitions/settings/definitions/embeddedstructfieldcheckSettings": close({
	// Checks that sync.Mutex and sync.RWMutex are not used as
	// embedded fields.
	"forbid-mutex"?: bool
})

_#defs: "/definitions/settings/definitions/errcheckSettings": close({
	// Report about not checking errors in type assertions, i.e.: `a
	// := b.(MyStruct)`
	"check-type-assertions"?: bool

	// Report about assignment of errors to blank identifier
	"check-blank"?: bool

	// List of functions to exclude from checking, where each entry is
	// a single function to exclude
	"exclude-functions"?: [...string]

	// To disable the errcheck built-in exclude list
	"disable-default-exclusions"?: bool

	// Display function signature instead of selector
	verbose?: bool
})

_#defs: "/definitions/settings/definitions/errchkjsonSettings": close({
	"check-error-free-encoding"?: bool

	// Issue on struct that doesn't have exported fields.
	"report-no-exported"?: bool
})

_#defs: "/definitions/settings/definitions/errorlintSettings": close({
	// Check whether fmt.Errorf uses the %w verb for formatting errors
	errorf?: bool

	// Permit more than 1 %w verb, valid per Go 1.20
	"errorf-multi"?: bool

	// Check for plain type assertions and type switches.
	asserts?: bool

	// Check for plain error comparisons
	comparison?: bool
	"allowed-errors"?: [...close({
		err?: string
		fun?: string
	})]
	"allowed-errors-wildcard"?: [...close({
		err?: string
		fun?: string
	})]
})

_#defs: "/definitions/settings/definitions/exhaustiveSettings": close({
	// Program elements to check for exhaustiveness.
	check?: list.UniqueItems() & [...string]

	// Only run exhaustive check on switches with
	// "//exhaustive:enforce" comment.
	"explicit-exhaustive-switch"?: bool

	// Only run exhaustive check on map literals with
	// "//exhaustive:enforce" comment.
	"explicit-exhaustive-map"?: bool

	// Switch statement requires default case even if exhaustive.
	"default-case-required"?: bool

	// Presence of `default` case in switch statements satisfies
	// exhaustiveness, even if all enum members are not listed.
	"default-signifies-exhaustive"?: bool

	// Enum members matching `regex` do not have to be listed in
	// switch statements to satisfy exhaustiveness
	"ignore-enum-members"?: string

	// Enum types matching the supplied regex do not have to be listed
	// in switch statements to satisfy exhaustiveness.
	"ignore-enum-types"?: string

	// Consider enums only in package scopes, not in inner scopes.
	"package-scope-only"?: bool
})

_#defs: "/definitions/settings/definitions/exhaustructSettings": close({
	// List of regular expressions to match struct packages and names.
	include?: [...string]

	// List of regular expressions to exclude struct packages and
	// names from check.
	exclude?: [...string]
})

_#defs: "/definitions/settings/definitions/fatcontextSettings": close({
	// Check for potential fat contexts in struct pointers.
	"check-struct-pointers"?: bool
})

_#defs: "/definitions/settings/definitions/forbidigoSettings": close({
	// Exclude code in godoc examples.
	"exclude-godoc-examples"?: bool

	// Instead of matching the literal source code, use type
	// information to replace expressions with strings that contain
	// the package name and (for methods and fields) the type name.
	"analyze-types"?: bool

	// List of identifiers to forbid (written using `regexp`)
	forbid?: [...close({
		// Pattern
		pattern?: string

		// Package
		pkg?: string

		// Message
		msg?: string
	})]
})

_#defs: "/definitions/settings/definitions/funcorderSettings": close({
	// Checks that constructors are placed after the structure
	// declaration.
	constructor?: bool

	// Checks if the exported methods of a structure are placed before
	// the non-exported ones.
	"struct-method"?: bool

	// Checks if the constructors and/or structure methods are sorted
	// alphabetically.
	alphabetical?: bool
})

_#defs: "/definitions/settings/definitions/funlenSettings": close({
	// Limit lines number per function.
	lines?: int

	// Limit statements number per function.
	statements?: int

	// Ignore comments when counting lines.
	"ignore-comments"?: bool
})

_#defs: "/definitions/settings/definitions/gciSettings": close({
	// Section configuration to compare against.
	sections?: [...matchN(>=1, ["standard" | "default" | "blank" | "dot" | "alias" | "localmodule", string])]

	// Checks that no inline Comments are present.
	"no-inline-comments"?: bool

	// Checks that no prefix Comments(comment lines above an import)
	// are present.
	"no-prefix-comments"?: bool

	// Enable custom order of sections.
	"custom-order"?: bool

	// Drops lexical ordering for custom sections.
	"no-lex-order"?: bool
})

_#defs: "/definitions/settings/definitions/ginkgolinterSettings": close({
	// Suppress the wrong length assertion warning.
	"suppress-len-assertion"?: bool

	// Suppress the wrong nil assertion warning.
	"suppress-nil-assertion"?: bool

	// Suppress the wrong error assertion warning.
	"suppress-err-assertion"?: bool

	// Suppress the wrong comparison assertion warning.
	"suppress-compare-assertion"?: bool

	// Suppress the function all in async assertion warning.
	"suppress-async-assertion"?: bool

	// Suppress warning for comparing values from different types,
	// like int32 and uint32.
	"suppress-type-compare-assertion"?: bool

	// Trigger warning for ginkgo focus containers like FDescribe,
	// FContext, FWhen or FIt.
	"forbid-focus-container"?: bool

	// Don't trigger warnings for HaveLen(0).
	"allow-havelen-zero"?: bool

	// Force using `Expect` with `To`, `ToNot` or `NotTo`
	"force-expect-to"?: bool

	// Best effort validation of async intervals (timeout and
	// polling).
	"validate-async-intervals"?: bool

	// Trigger a warning for variable assignments in ginkgo containers
	// like `Describe`, `Context` and `When`, instead of in
	// `BeforeEach()`.
	"forbid-spec-pollution"?: bool

	// Force using the Succeed matcher for error functions, and the
	// HaveOccurred matcher for non-function error values.
	"force-succeed"?: bool

	// Force adding assertion descriptions to gomega matchers.
	"force-assertion-description"?: bool
})

_#defs: "/definitions/settings/definitions/gochecksumtypeSettings": close({
	// Presence of `default` case in switch statements satisfies
	// exhaustiveness, if all members are not listed.
	"default-signifies-exhaustive"?: bool

	// Include shared interfaces in the exhaustiviness check.
	"include-shared-interfaces"?: bool
})

_#defs: "/definitions/settings/definitions/gocognitSettings": close({
	// Minimal code complexity to report (we recommend 10-20).
	"min-complexity"?: int
})

_#defs: "/definitions/settings/definitions/goconstSettings": close({
	// Look for existing constants matching the values
	"match-constant"?: bool

	// Minimum length of string constant.
	"min-len"?: int

	// Minimum occurrences count to trigger.
	"min-occurrences"?: int

	// Ignore when constant is not used as function argument
	"ignore-calls"?: bool

	// Exclude strings matching the given regular expression
	"ignore-string-values"?: [...string]

	// Search also for duplicated numbers.
	numbers?: bool

	// Minimum value, only works with `numbers`
	min?: int

	// Maximum value, only works with `numbers`
	max?: int

	// Detects constants with identical values
	"find-duplicates"?: bool

	// Evaluates of constant expressions like Prefix + "suffix"
	"eval-const-expressions"?: bool
})

_#defs: "/definitions/settings/definitions/gocriticSettings": close({
	// Which checks should be enabled. By default, a list of stable
	// checks is used. To see it, run `GL_DEBUG=gocritic
	// golangci-lint run`.
	"enabled-checks"?: [...#."gocritic-checks"]

	// Which checks should be disabled.
	"disabled-checks"?: [...#."gocritic-checks"]

	// Enable multiple checks by tags, run `GL_DEBUG=gocritic
	// golangci-lint run` to see all tags and checks.
	"enabled-tags"?: [...#."gocritic-tags"]

	// Disable multiple checks by tags, run `GL_DEBUG=gocritic
	// golangci-lint run` to see all tags and checks.
	"disabled-tags"?: [...#."gocritic-tags"]

	// Settings passed to gocritic. Properties must be valid and
	// enabled check names.
	settings?: close({
		captLocal?: close({
			paramsOnly?: bool
		})
		commentedOutCode?: close({
			minLength?: number
		})
		elseif?: close({
			skipBalanced?: bool
		})
		hugeParam?: close({
			sizeThreshold?: number
		})
		ifElseChain?: close({
			minThreshold?: number
		})
		nestingReduce?: close({
			bodyWidth?: number
		})
		rangeExprCopy?: close({
			sizeThreshold?: number
			skipTestFuncs?: bool
		})
		rangeValCopy?: close({
			sizeThreshold?: number
			skipTestFuncs?: bool
		})
		ruleguard?: close({
			debug?:   string
			enable?:  string
			disable?: string
			failOn?:  string
			rules?:   string
		})
		tooManyResultsChecker?: close({
			maxResults?: number
		})
		truncateCmp?: close({
			skipArchDependent?: bool
		})
		underef?: close({
			skipRecvDeref?: bool
		})
		unnamedResult?: close({
			checkExported?: bool
		})
	})
	"disable-all"?: bool
	"enable-all"?:  bool
})

_#defs: "/definitions/settings/definitions/gocycloSettings": close({
	// Minimum code complexity to report (we recommend 10-20).
	"min-complexity"?: int
})

_#defs: "/definitions/settings/definitions/godotSettings": close({
	// Comments to be checked.
	scope?: "declarations" | "toplevel" | "all" | "noinline"

	// List of regexps for excluding particular comment lines from
	// check.
	exclude?: [...string]

	// Check that each sentence ends with a period.
	period?: bool

	// Check that each sentence starts with a capital letter.
	capital?: bool

	// DEPRECATED: Check all top-level comments, not only
	// declarations.
	"check-all"?: bool
})

_#defs: "/definitions/settings/definitions/godoxSettings": close({
	// Report any comments starting with one of these keywords. This
	// is useful for TODO or FIXME comments that might be left in the
	// code accidentally and should be resolved before merging.
	keywords?: [...string]
})

_#defs: "/definitions/settings/definitions/gofmtSettings": close({
	// Simplify code.
	simplify?: bool

	// Apply the rewrite rules to the source before reformatting.
	"rewrite-rules"?: [...close({
		pattern?:     string
		replacement?: string
	})]
})

_#defs: "/definitions/settings/definitions/gofumptSettings": close({
	// Choose whether or not to use the extra rules that are disabled
	// by default.
	"extra-rules"?: bool

	// Module path which contains the source code being formatted.
	"module-path"?: string
})

_#defs: "/definitions/settings/definitions/goheaderSettings": matchN(1, [{
	template!: _
	...
}, {
	"template-path"!: _
	...
}]) & close({
	values?: close({
		// Constants to use in the template.
		const?: close({
			{[=~"^.+$"]: string}
		})

		// Regular expressions to use in your template.
		regexp?: close({
			{[=~"^.+$"]: string}
		})
	})

	// Template to put on top of every file.
	template?: string

	// Path to the file containing the template source.
	"template-path"?: string
})

_#defs: "/definitions/settings/definitions/goimportsSettings": close({
	// Put imports beginning with prefix after 3rd-party packages. It
	// is a list of prefixes.
	"local-prefixes"?: [...string]
})

_#defs: "/definitions/settings/definitions/golinesSettings": close({
	"max-len"?:          int
	"tab-len"?:          int
	"shorten-comments"?: bool
	"reformat-tags"?:    bool
	"chain-split-dots"?: bool
})

_#defs: "/definitions/settings/definitions/gomoddirectivesSettings": close({
	// Allow local `replace` directives.
	"replace-local"?: bool

	// List of allowed `replace` directives.
	"replace-allow-list"?: [...string]

	// Allow to not explain why the version has been retracted in the
	// `retract` directives.
	"retract-allow-no-explanation"?: bool

	// Forbid the use of the `exclude` directives.
	"exclude-forbidden"?: bool

	// Forbid the use of the `ignore` directives. (>= go1.25)
	"ignore-forbidden"?: bool

	// Forbid the use of the `toolchain` directive.
	"toolchain-forbidden"?: bool

	// Defines a pattern to validate `toolchain` directive.
	"toolchain-pattern"?: string

	// Forbid the use of the `tool` directives.
	"tool-forbidden"?: bool

	// Forbid the use of the `godebug` directive.
	"go-debug-forbidden"?: bool

	// Defines a pattern to validate `go` minimum version directive.
	"go-version-pattern"?: string
})

_#defs: "/definitions/settings/definitions/gomodguardSettings": close({
	allowed?: close({
		// List of allowed modules.
		modules?: [...string]

		// List of allowed module domains.
		domains?: [...string]
	})
	blocked?: close({
		// List of blocked modules.
		modules?: [...close({
			{[=~"^.+$"]: close({
				// Recommended modules that should be used instead.
				recommendations?: [...string]

				// Reason why the recommended module should be used.
				reason?: string
			})
			}
		})]

		// List of blocked module version constraints.
		versions?: [...{
			{[=~"^.*$"]: close({
				// Version constraint.
				version?: string

				// Reason why the version constraint exists.
				reason!: string
			})
			}
			...
		}]

		// Raise lint issues if loading local path with replace directive
		"local-replace-directives"?: bool
	})
})

_#defs: "/definitions/settings/definitions/gosecSettings": close({
	// To select a subset of rules to run
	includes?: [...#."gosec-rules"]

	// To specify a set of rules to explicitly exclude
	excludes?: [...#."gosec-rules"]

	// Filter out the issues with a lower severity than the given
	// value
	severity?: "low" | "medium" | "high"

	// Filter out the issues with a lower confidence than the given
	// value
	confidence?: "low" | "medium" | "high"

	// To specify the configuration of rules
	config?: {
		...
	}

	// Concurrency value
	concurrency?: int
})

_#defs: "/definitions/settings/definitions/gosmopolitanSettings": close({
	// Allow and ignore `time.Local` usages.
	"allow-time-local"?: bool

	// List of fully qualified names in the `full/pkg/path.name` form,
	// to act as "i18n escape hatches".
	"escape-hatches"?: [...string]

	// List of Unicode scripts to watch for any usage in string
	// literals.
	"watch-for-scripts"?: [...string]
})

_#defs: "/definitions/settings/definitions/govetSettings": close({
	// Settings per analyzer. Map of analyzer name to specific
	// settings.
	// Run `go tool vet help` to find out more.
	settings?: {
		[#."govet-analyzers" & string]: _
	} & {
		{[=~"^.*$"]: {
			...
		}}
		...
	}

	// Enable analyzers by name.
	enable?: [...#."govet-analyzers"]

	// Disable analyzers by name.
	disable?: [...#."govet-analyzers"]

	// Enable all analyzers.
	"enable-all"?: bool

	// Disable all analyzers.
	"disable-all"?: bool
})

_#defs: "/definitions/settings/definitions/grouperSettings": close({
	"const-require-single-const"?:   bool
	"const-require-grouping"?:       bool
	"import-require-single-import"?: bool
	"import-require-grouping"?:      bool
	"type-require-single-type"?:     bool
	"type-require-grouping"?:        bool
	"var-require-single-var"?:       bool
	"var-require-grouping"?:         bool
})

_#defs: "/definitions/settings/definitions/ifaceSettings": close({
	// Enable analyzers by name.
	enable?: [...#."iface-analyzers"]
	settings?: close({
		unused?: close({
			exclude?: [...string]
		})
	})
})

_#defs: "/definitions/settings/definitions/importasSettings": close({
	// Do not allow unaliased imports of aliased packages.
	"no-unaliased"?: bool

	// Do not allow non-required aliases.
	"no-extra-aliases"?: bool

	// List of aliases
	alias?: [...close({
		// Package path e.g.
		// knative.dev/serving/pkg/apis/autoscaling/v1alpha1
		pkg!: string

		// Package alias e.g. autoscalingv1alpha1
		alias!: string
	})]
})

_#defs: "/definitions/settings/definitions/inamedparamSettings": close({
	// Skips check for interface methods with only a single parameter.
	"skip-single-param"?: bool
})

_#defs: "/definitions/settings/definitions/interfacebloatSettings": close({
	// The maximum number of methods allowed for an interface.
	max?: int
})

// Use either `reject` or `allow` properties for interfaces
// matching.
_#defs: "/definitions/settings/definitions/ireturnSettings": matchN(>=1, [matchN(0, [null | bool | number | string | [...] | {
	allow?: "reject"
	...
}]) & {
	allow!: _
	...
}, {
	reject!: _
	...
}]) & close({
	allow?: [...matchN(>=1, [string, "anon" | "error" | "empty" | "stdlib"])]
	reject?: [...matchN(>=1, [string, "anon" | "error" | "empty" | "stdlib"])]
})

_#defs: "/definitions/settings/definitions/lllSettings": close({
	// Width of "\t" in spaces.
	"tab-width"?: int & >=0

	// Maximum allowed line length, lines longer will be reported.
	"line-length"?: int & >=1
})

_#defs: "/definitions/settings/definitions/loggercheckSettings": close({
	// Allow check for the github.com/go-kit/log library.
	kitlog?: bool

	// Allow check for the k8s.io/klog/v2 library.
	klog?: bool

	// Allow check for the github.com/go-logr/logr library.
	logr?: bool

	// Allow check for the log/slog library.
	slog?: bool

	// Allow check for the "sugar logger" from go.uber.org/zap
	// library.
	zap?: bool

	// Require all logging keys to be inlined constant strings.
	"require-string-key"?: bool

	// Require printf-like format specifier (%s, %d for example) not
	// present.
	"no-printf-like"?: bool

	// List of custom rules to check against, where each rule is a
	// single logger pattern, useful for wrapped loggers.
	rules?: [...string]
})

// Maintainability index
// https://docs.microsoft.com/en-us/visualstudio/code-quality/code-metrics-maintainability-index-range-and-meaning?view=vs-2022
_#defs: "/definitions/settings/definitions/maintidxSettings": close({
	// Minimum accatpable maintainability index level (see
	// https://docs.microsoft.com/en-us/visualstudio/code-quality/code-metrics-maintainability-index-range-and-meaning?view=vs-2022)
	under?: number
})

_#defs: "/definitions/settings/definitions/makezeroSettings": close({
	// Allow only slices initialized with a length of zero.
	always?: bool
})

// Correct spellings using locale preferences for US or UK.
// Default is to use a neutral variety of English.
_#defs: "/definitions/settings/definitions/misspellSettings": close({
	locale?: "US" | "UK"

	// List of rules to ignore.
	"ignore-rules"?: [...string]

	// Mode of the analysis.
	mode?: "restricted" | "" | "default"

	// Extra word corrections.
	"extra-words"?: [...close({
		correction?: string
		typo?:       string
	})]
})

_#defs: "/definitions/settings/definitions/mndSettings": close({
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
})

_#defs: "/definitions/settings/definitions/musttagSettings": close({
	functions?: [...close({
		name?:      string
		tag?:       string
		"arg-pos"?: int
	})]
})

_#defs: "/definitions/settings/definitions/nakedretSettings": close({
	// Report if a function has more lines of code than this value and
	// it has naked returns.
	"max-func-lines"?: int & >=0
})

_#defs: "/definitions/settings/definitions/nestifSettings": close({
	// Minimum complexity of "if" statements to report.
	"min-complexity"?: int
})

_#defs: "/definitions/settings/definitions/nilnilSettings": close({
	// To check functions with only two return values.
	"only-two"?: bool

	// In addition, detect opposite situation (simultaneous return of
	// non-nil error and valid value).
	"detect-opposite"?: bool

	// List of return types to check.
	"checked-types"?: [..."chan" | "func" | "iface" | "map" | "ptr" | "uintptr" | "unsafeptr"]
})

_#defs: "/definitions/settings/definitions/nlreturnSettings": close({
	// set block size that is still ok
	"block-size"?: >=0
})

_#defs: "/definitions/settings/definitions/nolintlintSettings": close({
	// Enable to ensure that nolint directives are all used.
	"allow-unused"?: bool

	// Exclude these linters from requiring an explanation.
	"allow-no-explanation"?: [...#."linter-names"]

	// Enable to require an explanation of nonzero length after each
	// nolint directive.
	"require-explanation"?: bool

	// Enable to require nolint directives to mention the specific
	// linter being suppressed.
	"require-specific"?: bool
})

_#defs: "/definitions/settings/definitions/nonamedreturnsSettings": close({
	// Report named error if it is assigned inside defer.
	"report-error-in-defer"?: bool
})

_#defs: "/definitions/settings/definitions/paralleltestSettings": close({
	// Ignore missing calls to `t.Parallel()` and only report
	// incorrect uses of it.
	"ignore-missing"?: bool

	// Ignore missing calls to `t.Parallel()` in subtests. Top-level
	// tests are still required to have `t.Parallel`, but subtests
	// are allowed to skip it.
	"ignore-missing-subtests"?: bool
})

_#defs: "/definitions/settings/definitions/perfsprintSettings": close({
	// Enable/disable optimization of integer formatting.
	"integer-format"?: bool

	// Optimizes even if it requires an int or uint type cast.
	"int-conversion"?: bool

	// Enable/disable optimization of error formatting.
	"error-format"?: bool

	// Optimizes into `err.Error()` even if it is only equivalent for
	// non-nil errors.
	"err-error"?: bool

	// Optimizes `fmt.Errorf`.
	errorf?: bool

	// Enable/disable optimization of string formatting.
	"string-format"?: bool

	// Optimizes `fmt.Sprintf` with only one argument.
	sprintf1?: bool

	// Optimizes into strings concatenation.
	strconcat?: bool

	// Enable/disable optimization of bool formatting.
	"bool-format"?: bool

	// Enable/disable optimization of hex formatting.
	"hex-format"?: bool
})

// We do not recommend using this linter before doing performance
// profiling.
// For most programs usage of `prealloc` will be premature
// optimization.
_#defs: "/definitions/settings/definitions/preallocSettings": close({
	// Report preallocation suggestions only on simple loops that have
	// no returns/breaks/continues/gotos in them.
	simple?: bool

	// Report preallocation suggestions on range loops.
	"range-loops"?: bool

	// Report preallocation suggestions on for loops.
	"for-loops"?: bool
})

_#defs: "/definitions/settings/definitions/predeclaredSettings": close({
	// List of predeclared identifiers to not report on.
	ignore?: [...string]

	// Include method names and field names in checks.
	"qualified-name"?: bool
})

_#defs: "/definitions/settings/definitions/promlinterSettings": close({
	strict?: _
	"disabled-linters"?: [..."Help" | "MetricUnits" | "Counter" | "HistogramSummaryReserved" | "MetricTypeInName" | "ReservedChars" | "CamelCase" | "UnitAbbreviations"]
})

_#defs: "/definitions/settings/definitions/protogetterSettings": close({
	"skip-generated-by"?: [...string]
	"skip-files"?: [...string]

	// Skip any generated files from the checking.
	"skip-any-generated"?: bool

	// Skip first argument of append function.
	"replace-first-arg-in-append"?: bool
})

_#defs: "/definitions/settings/definitions/reassignSettings": close({
	patterns?: [...string]
})

_#defs: "/definitions/settings/definitions/recvcheckSettings": close({
	// Disables the built-in method exclusions.
	"disable-builtin"?: bool

	// User-defined method exclusions.
	exclusions?: [...string]
})

_#defs: "/definitions/settings/definitions/reviveSettings": close({
	"max-open-files"?:   int
	confidence?:         number
	severity?:           "warning" | "error"
	"enable-all-rules"?: bool
	directives?: [...close({
		name?:     "specify-disable-reason"
		severity?: "warning" | "error"
		exclude?: [...string]
		arguments?: [...]
	})]
	rules?: [...close({
		name!:     #."revive-rules"
		disabled?: bool
		severity?: "warning" | "error"
		exclude?: [...string]
		arguments?: [...]
	})]
})

_#defs: "/definitions/settings/definitions/rowserrcheckSettings": close({
	packages?: [...string]
})

_#defs: "/definitions/settings/definitions/sloglintSettings": close({
	// Enforce using key-value pairs only (incompatible with
	// attr-only).
	"kv-only"?: bool

	// Enforce not using global loggers.
	"no-global"?: "" | "all" | "default"

	// Enforce not mixing key-value pairs and attributes.
	"no-mixed-args"?: bool

	// Enforce using methods that accept a context.
	context?: "" | "all" | "scope"

	// Enforce using static values for log messages.
	"static-msg"?: bool

	// Enforce message style.
	"msg-style"?: "" | "lowercased" | "capitalized"

	// Enforce a single key naming convention.
	"key-naming-case"?: "snake" | "kebab" | "camel" | "pascal"

	// Enforce using attributes only (incompatible with kv-only).
	"attr-only"?: bool

	// Enforce using constants instead of raw keys.
	"no-raw-keys"?: bool

	// Enforce not using specific keys.
	"forbidden-keys"?: [...string]

	// Enforce putting arguments on separate lines.
	"args-on-sep-lines"?: bool
})

_#defs: "/definitions/settings/definitions/spancheckSettings": close({
	// Checks to enable.
	checks?: [..."end" | "record-error" | "set-status"]

	// A list of regexes for function signatures that silence
	// `record-error` and `set-status` reports if found in the call
	// path to a returned error.
	"ignore-check-signatures"?: [...string]

	// A list of regexes for additional function signatures that
	// create spans.
	"extra-start-span-signatures"?: [...string]
})

_#defs: "/definitions/settings/definitions/staticcheckSettings": close({
	checks?: [...matchN(>=1, [#."staticcheck-checks", string])]

	// By default, ST1001 forbids all uses of dot imports in non-test
	// packages. This setting allows setting a whitelist of import
	// paths that can be dot-imported anywhere.
	"dot-import-whitelist"?: [...string]

	// ST1013 recommends using constants from the net/http package
	// instead of hard-coding numeric HTTP status codes. This setting
	// specifies a list of numeric status codes that this check does
	// not complain about.
	"http-status-code-whitelist"?: [..."100" | "101" | "102" | "103" | "200" | "201" | "202" | "203" | "204" | "205" | "206" | "207" | "208" | "226" | "300" | "301" | "302" | "303" | "304" | "305" | "306" | "307" | "308" | "400" | "401" | "402" | "403" | "404" | "405" | "406" | "407" | "408" | "409" | "410" | "411" | "412" | "413" | "414" | "415" | "416" | "417" | "418" | "421" | "422" | "423" | "424" | "425" | "426" | "428" | "429" | "431" | "451" | "500" | "501" | "502" | "503" | "504" | "505" | "506" | "507" | "508" | "510" | "511"]

	// ST1003 check, among other things, for the correct
	// capitalization of initialisms. The set of known initialisms
	// can be configured with this option.
	initialisms?: [...string]
})

_#defs: "/definitions/settings/definitions/tagalignSettings": close({
	// Align and sort can be used together or separately.
	align?: bool

	// Whether enable tags sort.
	sort?: bool

	// Specify the order of tags, the other tags will be sorted by
	// name.
	order?: [...string]

	// Whether enable strict style.
	strict?: bool
})

_#defs: "/definitions/settings/definitions/tagliatelleSettings": close({
	case?: close({
		// Use the struct field name to check the name of the struct tag.
		"use-field-name"?: bool

		// The field names to ignore.
		"ignored-fields"?: [...string]
		rules?: {
			{[=~"^.+$"]: #."tagliatelle-cases"}
			...
		}

		// Defines the association between tag name and case.
		"extended-rules"?: {
			{[=~"^.+$"]: close({
				case!:                #."tagliatelle-cases"
				"extra-initialisms"?: bool
				"initialism-overrides"?: {
					{[=~"^.+$"]: bool}
					...
				}
			})
			}
			...
		}

		// Overrides the default/root configuration.
		overrides?: [...close({
			// A package path.
			pkg!: string

			// Use the struct field name to check the name of the struct tag.
			"use-field-name"?: bool

			// The field names to ignore.
			"ignored-fields"?: [...string]

			// Ignore the package (takes precedence over all other
			// configurations).
			ignore?: bool
			rules?: {
				{[=~"^.+$"]: #."tagliatelle-cases"}
				...
			}

			// Defines the association between tag name and case.
			"extended-rules"?: {
				{[=~"^.+$"]: close({
					case!:                #."tagliatelle-cases"
					"extra-initialisms"?: bool
					"initialism-overrides"?: {
						{[=~"^.+$"]: bool}
						...
					}
				})
				}
				...
			}
		})]
	})
})

_#defs: "/definitions/settings/definitions/testifylintSettings": close({
	// Enable all checkers.
	"enable-all"?: bool

	// Disable all checkers.
	"disable-all"?: bool

	// Enable specific checkers.
	enable?: [..."blank-import" | "bool-compare" | "compares" | "contains" | "empty" | "encoded-compare" | "equal-values" | "error-is-as" | "error-nil" | "expected-actual" | "float-compare" | "formatter" | "go-require" | "len" | "negative-positive" | "nil-compare" | "regexp" | "require-error" | "suite-broken-parallel" | "suite-dont-use-pkg" | "suite-extra-assert-call" | "suite-method-signature" | "suite-subtest-run" | "suite-thelper" | "useless-assert"]

	// Disable specific checkers.
	disable?: [..."blank-import" | "bool-compare" | "compares" | "contains" | "empty" | "encoded-compare" | "equal-values" | "error-is-as" | "error-nil" | "expected-actual" | "float-compare" | "formatter" | "go-require" | "len" | "negative-positive" | "nil-compare" | "regexp" | "require-error" | "suite-broken-parallel" | "suite-dont-use-pkg" | "suite-extra-assert-call" | "suite-method-signature" | "suite-subtest-run" | "suite-thelper" | "useless-assert"]
	"bool-compare"?: close({
		// To ignore user defined types (over builtin bool).
		"ignore-custom-types"?: bool
	})
	"expected-actual"?: close({
		// Regexp for expected variable name.
		pattern?: string
	})
	formatter?: close({
		// To enable go vet's printf checks.
		"check-format-string"?: bool

		// To require f-assertions (e.g. assert.Equalf) if format string
		// is used, even if there are no variable-length variables.
		"require-f-funcs"?: bool

		// To require that the first element of msgAndArgs (msg) has a
		// string type.
		"require-string-msg"?: bool
	})
	"go-require"?: close({
		// To ignore HTTP handlers (like http.HandlerFunc).
		"ignore-http-handlers"?: bool
	})
	"require-error"?: close({
		// Regexp for assertions to analyze. If defined, then only matched
		// error assertions will be reported.
		"fn-pattern"?: string
	})
	"suite-extra-assert-call"?: close({
		// To require or remove extra Assert() call?
		mode?: "remove" | "require"
	})
})

_#defs: "/definitions/settings/definitions/testpackageSettings": close({
	// Files with names matching this regular expression are skipped.
	"skip-regexp"?: string

	// List of packages that don't end with _test that tests are
	// allowed to be in.
	"allow-packages"?: list.UniqueItems() & [...string]
})

_#defs: "/definitions/settings/definitions/thelperSettings": close({
	test?: close({
		// Check if `t.Helper()` begins helper function.
		begin?: bool

		// Check if *testing.T is first param of helper function.
		first?: bool

		// Check if *testing.T param has t name.
		name?: bool
	})
	benchmark?: close({
		// Check if `b.Helper()` begins helper function.
		begin?: bool

		// Check if *testing.B is first param of helper function.
		first?: bool

		// Check if *testing.B param has b name.
		name?: bool
	})
	tb?: close({
		// Check if `tb.Helper()` begins helper function.
		begin?: bool

		// Check if *testing.TB is first param of helper function.
		first?: bool

		// Check if *testing.TB param has tb name.
		name?: bool
	})
	fuzz?: close({
		// Check if `f.Helper()` begins helper function.
		begin?: bool

		// Check if *testing.F is first param of helper function.
		first?: bool

		// Check if *testing.F param has f name.
		name?: bool
	})
})

_#defs: "/definitions/settings/definitions/unconvertSettings": close({
	"fast-math"?: bool
	safe?:        bool
})

_#defs: "/definitions/settings/definitions/unparamSettings": close({
	// Inspect exported functions. Set to true if no external
	// program/library imports your code.
	//
	// WARNING: if you enable this setting, unparam will report a lot
	// of false-positives in text editors:
	// if it's called for subdir of a project it can't find external
	// interfaces. All text editor integrations
	// with golangci-lint call it on a directory with the changed
	// file.
	"check-exported"?: bool
})

_#defs: "/definitions/settings/definitions/unusedSettings": close({
	"field-writes-are-uses"?:     bool
	"post-statements-are-reads"?: bool
	"exported-fields-are-used"?:  bool
	"parameters-are-used"?:       bool
	"local-variables-are-used"?:  bool
	"generated-is-used"?:         bool
})

_#defs: "/definitions/settings/definitions/usestdlibvarsSettings": close({
	// Suggest the use of http.MethodXX.
	"http-method"?: bool

	// Suggest the use of http.StatusXX.
	"http-status-code"?: bool

	// Suggest the use of time.Weekday.String().
	"time-weekday"?: bool

	// Suggest the use of time.Month.String().
	"time-month"?: bool

	// Suggest the use of time.Layout.
	"time-layout"?: bool

	// Suggest the use of time.Month in time.Date.
	"time-date-month"?: bool

	// Suggest the use of crypto.Hash.String().
	"crypto-hash"?: bool

	// Suggest the use of rpc.DefaultXXPath.
	"default-rpc-path"?: bool

	// Suggest the use of sql.LevelXX.String().
	"sql-isolation-level"?: bool

	// Suggest the use of tls.SignatureScheme.String().
	"tls-signature-scheme"?: bool

	// Suggest the use of constant.Kind.String().
	"constant-kind"?: bool
})

_#defs: "/definitions/settings/definitions/usetestingSettings": close({
	"context-background"?: bool
	"context-todo"?:       bool
	"os-chdir"?:           bool
	"os-mkdir-temp"?:      bool
	"os-setenv"?:          bool
	"os-create-temp"?:     bool
	"os-temp-dir"?:        bool
})

_#defs: "/definitions/settings/definitions/varnamelenSettings": close({
	// Variables used in at most this N-many lines will be ignored.
	"max-distance"?: int

	// The minimum length of a variable's name that is considered
	// `long`.
	"min-name-length"?: int

	// Check method receiver names.
	"check-receiver"?: bool

	// Check named return values.
	"check-return"?: bool

	// Check type parameters.
	"check-type-param"?: bool

	// Ignore `ok` variables that hold the bool return value of a type
	// assertion
	"ignore-type-assert-ok"?: bool

	// Ignore `ok` variables that hold the bool return value of a map
	// index.
	"ignore-map-index-ok"?: bool

	// Ignore `ok` variables that hold the bool return value of a
	// channel receive.
	"ignore-chan-recv-ok"?: bool

	// Optional list of variable names that should be ignored
	// completely.
	"ignore-names"?: [...string]

	// Optional list of variable declarations that should be ignored
	// completely.
	"ignore-decls"?: [...string]
})

_#defs: "/definitions/settings/definitions/whitespaceSettings": close({
	// Enforces newlines (or comments) after every multi-line if
	// statement
	"multi-if"?: bool

	// Enforces newlines (or comments) after every multi-line function
	// signature
	"multi-func"?: bool
})

_#defs: "/definitions/settings/definitions/wrapcheckSettings": close({
	// An array of strings specifying additional substrings of
	// signatures to ignore.
	"extra-ignore-sigs"?: [...string]

	// An array of strings which specify substrings of signatures to
	// ignore.
	"ignore-sigs"?: [...string]

	// An array of strings which specify regular expressions of
	// signatures to ignore.
	"ignore-sig-regexps"?: [...string]

	// An array of glob patterns which, if any match the package of
	// the function returning the error, will skip wrapcheck analysis
	// for this error.
	"ignore-package-globs"?: [...string]

	// An array of glob patterns which, if matched to an underlying
	// interface name, will ignore unwrapped errors returned from a
	// function whose call is defined on the given interface.
	"ignore-interface-regexps"?: [...string]

	// Determines whether wrapcheck should report errors returned from
	// inside the package.
	"report-internal-errors"?: bool
})

_#defs: "/definitions/settings/definitions/wslSettings": close({
	// Controls if you may cuddle assignments and anything without
	// needing an empty line between them.
	"allow-assign-and-anything"?: bool

	// Allow calls and assignments to be cuddled as long as the lines
	// have any matching variables, fields or types.
	"allow-assign-and-call"?: bool

	// Allow declarations (var) to be cuddled.
	"allow-cuddle-declarations"?: bool

	// A list of call idents that everything can be cuddled with.
	"allow-cuddle-with-calls"?: [...string]

	// AllowCuddleWithRHS is a list of right hand side variables that
	// is allowed to be cuddled with anything.
	"allow-cuddle-with-rhs"?: [...string]

	// Allow cuddling with any block as long as the variable is used
	// somewhere in the block
	"allow-cuddle-used-in-block"?: bool

	// Allow multiline assignments to be cuddled.
	"allow-multiline-assign"?: bool

	// Allow leading comments to be separated with empty lines.
	"allow-separated-leading-comment"?: bool

	// Allow trailing comments in ending of blocks.
	"allow-trailing-comment"?: bool

	// When force-err-cuddling is enabled this is a list of names used
	// for error variables to check for in the conditional.
	"error-variable-names"?: [...string]

	// Force newlines in end of case at this limit (0 = never).
	"force-case-trailing-whitespace"?: int & >=0

	// Causes an error when an If statement that checks an error
	// variable doesn't cuddle with the assignment of that variable.
	"force-err-cuddling"?: bool

	// Causes an error if a short declaration (:=) cuddles with
	// anything other than another short declaration.
	"force-short-decl-cuddling"?: bool

	// If true, append is only allowed to be cuddled if appending
	// value is matching variables, fields or types on line above.
	"strict-append"?: bool
})

_#defs: "/definitions/settings/definitions/wslSettingsV5": close({
	"allow-first-in-block"?: bool
	"allow-whole-block"?:    bool
	"branch-max-lines"?:     int
	"case-max-lines"?:       int
	default?:                "all" | "none" | "default" | ""
	enable?: [...#."wsl-checks"]
	disable?: [...#."wsl-checks"]
})
