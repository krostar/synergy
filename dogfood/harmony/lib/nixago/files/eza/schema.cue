filekinds?: {
	normal?:       _#Style
	directory?:    _#Style
	symlink?:      _#Style
	pipe?:         _#Style
	block_device?: _#Style
	char_device?:  _#Style
	socket?:       _#Style
	special?:      _#Style
	executable?:   _#Style
	mount_point?:  _#Style
}

perms?: {
	user_read?:            _#Style
	user_write?:           _#Style
	user_executable_file?: _#Style
	user_execute_other?:   _#Style
	group_read?:           _#Style
	group_write?:          _#Style
	group_execute?:        _#Style
	other_read?:           _#Style
	other_write?:          _#Style
	other_execute?:        _#Style
	special_user_file?:    _#Style
	special_other?:        _#Style
	attribute?:            _#Style
}

size?: {
	major?:       _#Style
	minor?:       _#Style
	number_byte?: _#Style
	number_kilo?: _#Style
	number_mega?: _#Style
	number_giga?: _#Style
	number_huge?: _#Style
	unit_byte?:   _#Style
	unit_kilo?:   _#Style
	unit_mega?:   _#Style
	unit_giga?:   _#Style
	unit_huge?:   _#Style
}

users?: {
	user_you?:    _#Style
	user_root?:   _#Style
	user_other?:  _#Style
	group_yours?: _#Style
	group_other?: _#Style
	group_root?:  _#Style
}

links?: {
	normal?:          _#Style
	multi_link_file?: _#Style
}

git?: {
	new?:        _#Style
	modified?:   _#Style
	deleted?:    _#Style
	renamed?:    _#Style
	ignored?:    _#Style
	conflicted?: _#Style
}

git_repo?: {
	branch_main?:  _#Style
	branch_other?: _#Style
	git_clean?:    _#Style
	git_dirty?:    _#Style
}

security_context?: {
	none?: _#Style
	selinux?: {
		colon?: _#Style
		user?:  _#Style
		role?:  _#Style
		typ?:   _#Style
		range?: _#Style
	}
}

file_type?: {
	image?:      _#Style
	video?:      _#Style
	music?:      _#Style
	crypto?:     _#Style
	document?:   _#Style
	compressed?: _#Style
	temp?:       _#Style
	compiled?:   _#Style
	build?:      _#Style
	source?:     _#Style
}

punctuation?:         _#Style
date?:                _#Style
inode?:               _#Style
blocks?:              _#Style
header?:              _#Style
octal?:               _#Style
flags?:               _#Style
control_char?:        _#Style
broken_symlink?:      _#Style
broken_path_overlay?: _#Style
filenames?:           _#FileIconStyle
extensions?:          _#FileIconStyle

_#Style: {
	foreground?:        string | null
	background?:        string | null
	is_bold?:           bool
	is_dimmed?:         bool
	is_italic?:         bool
	is_underline?:      bool
	is_blink?:          bool
	is_reverse?:        bool
	is_hidden?:         bool
	is_strikethrough?:  bool
	prefix_with_reset?: bool
}

_#FileIconStyle: {
	[string]: {
		filename?: _#Style
		icon?: {
			glyph?: string
			style?: _#Style
		}
	}
}
