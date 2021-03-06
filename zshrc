# {{{ pre requirements
# Test for an interactive shell. There is no need to set anything past this
# point for scp and rcp, and it is important to refrain from outputting anything
# in those cases.

# Shell is non-interactive. Be done now
[[ $- != *i* ]] && return

# load /etc/profile.d files
[[ -r ~/.shell/load-profile ]] && source ~/.shell/load-profile
#}}}

# {{{ Add Plugin
[[ -r ~/.fzf.zsh ]]                   && source ~/.fzf.zsh
[[ -r ~/.sdkman/bin/sdkman-init.sh ]] && source ~/.sdkman/bin/sdkman-init.sh
[[ -r ~/.zsh/bundle.zsh ]]            && source ~/.zsh/bundle.zsh
#}}}

# {{{ Parameters Used By The Shell
###############################################################################
# cdpath <S> <Z> (CDPATH <S>)
# An array (colon-separated list) of directories specifying the search path for
# the cd command.
export CDPATH=".:~"

# DIRSTACKSIZE
# The maximum size of the directory stack. If the stack gets larger than this,
# it will be truncated automatically. This is useful with the AUTO_PUSHD option.
export DIRSTACKSIZE="32"

# FCEDIT
# The default editor for the fc builtin.
if [[ -x /usr/bin/vim ]]; then
    export FCEDIT="vim"
elif [[ -x /usr/bin/vi ]]; then
    export FCEDIT="vi"
fi

# HISTFILE
# The file to save the history in when an interactive shell exits. If unset, the
# history is not saved.
export HISTFILE=~/.cache/zsh/history

# HISTSIZE <S>
# The maximum number of events stored in the internal history list. If you use
# the HIST_EXPIRE_DUPS_FIRST option, setting this value larger than the SAVEHIST
# size will give you the difference as a cushion for saving duplicated history
# events.
export HISTSIZE="10000"

# LINES <S>
# The number of lines for this terminal session. Used for printing select lists
# and for the line editor.
export LINES="200"

# LISTMAX
# In the line editor, the number of matches to list without asking first. If the
# value is negative, the list will be shown if it spans at most as many lines as
# given by the absolute value. If set to zero, the shell asks only if the top of
# the listing would scroll off the screen.
export LISTMAX="200"

# LOGCHECK
# The interval in seconds between checks for login/logout activity using the
# watch parameter.
unset LOGCHECK

# MAIL
# If this parameter is set and mailpath is not set, the shell looks for mail in
# the specified file.
unset MAIL

# MAILCHECK
# The interval in seconds between checks for new mail.
unset MAILCHECK

# mailpath <S> <Z> (MAILPATH <S>)
# An array (colon-separated list) of filenames to check for new mail. Each
# filename can be followed by a `?' and a message that will be printed. The
# message will undergo parameter expansion, command substitution and arithmetic
# expansion with the variable $_ defined as the name of the file that has
# changed. The default message is `You have new mail'. If an element is a
# directory instead of a file the shell will recursively check every file in
# every subdirectory of the element.
unset MAILPATH

# path <S> <Z> (PATH <S>)
# An array (colon-separated list) of directories to search for commands. When
# this parameter is set, each directory is scanned and all files found are put
# in a hash table.
typeset -U path

[[ -d /sbin ]]           && path=(/sbin $path)
[[ -d /usr/sbin ]]       && path=(/usr/sbin $path)
[[ -d /usr/local/sbin ]] && path=(/usr/local/sbin $path)
[[ -d /bin ]]            && path=(/bin $path)
[[ -d /usr/bin ]]        && path=(/usr/bin $path)
[[ -d /usr/local/bin ]]  && path=(/usr/local/bin $path)

# set PATH so it includes user's private bin if it exists
[[ -d ~/.dotfiles/bin ]]           && path=(~/.dotfiles/bin $path)
[[ -d ~/.local/bin ]]              && path=(~/.local/bin $path)
[[ -d ~/.local/share/umake/bin ]]  && path=(~/.local/share/umake/bin $path)
[[ -d ~/.rvm/bin ]]                && path=(~/.rvm/bin $path)
[[ -d ~/.rvm/rubies/default/bin ]] && path=(~/.rvm/rubies/default/bin $path)
[[ -d ~/git/bin ]]                 && path=(~/git/bin $path)

export PATH

# REPORTTIME
# If nonnegative, commands whose combined user and system execution times
# (measured in seconds) are greater than this value have timing statistics
# printed for them.
export REPORTTIME="300"

# RPROMPT <S>
# RPS1 <S>
# This prompt is displayed on the right-hand side of the screen when the primary
# prompt is being displayed on the left. This does not work if the SINGLELINEZLE
# option is set. It is expanded in the same way as PS1.
export RPROMPT

# SAVEHIST
# The maximum number of history events to save in the history file.
export SAVEHIST="10000"

# TERM <S>
# The type of terminal in use. This is used when looking up termcap sequences.
# An assignment to TERM causes zsh to re-initialize the terminal, even if the
# value does not change (e.g., `TERM=${TERM}'). It is necessary to make such an
# assignment upon any change to the terminal definition database or terminal
# type in order for the new settings to take effect.
case "${TERM}" in
    xterm*)
        export TERM=xterm-256color
        ;;
esac

# watch <S> <Z> (WATCH <S>)
# An array (colon-separated list) of login/logout events to report. If it
# contains the single word `all', then all login/logout events are reported. If
# it contains the single word `notme', then all events are reported as with
# `all' except ${USERNAME}. An entry in this list may consist of a username, an
# `@' followed by a remote hostname, and a `%' followed by a line (tty). Any or
# all of these components may be present in an entry; if a login/logout event
# matches all of them, it is reported.
watch=(notme root)
#}}}

# {{{ Description of Options
###############################################################################
# {{{ Changing Directories
################################################################################
# {{{ AUTO_CD (-J)
# If a command is issued that can"t be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt auto_cd
#}}}

# {{{ AUTO_PUSHD (-N)
# Make cd push the old directory onto the directory stack.
setopt auto_pushd
#}}}

# {{{ CDABLE_VARS (-T)
# If the argument to a cd command (or an implied cd with the AUTO_CD option set)
# is not a directory, and does not begin with a slash, try to expand the
# expression as if it were preceded by a "~" (see the section "Filename
# Expansion").
setopt cdable_vars
#}}}

# {{{ PUSHD_IGNORE_DUPS
# Don"t push multiple copies of the same directory onto the directory stack.
setopt pushd_ignore_dups
#}}}

# {{{ Completion
################################################################################
# {{{ LIST_BEEP <D>
# Beep on an ambiguous completion. More accurately, this forces the completion
# widgets to return status 1 on an ambiguous completion, which causes the shell
# to beep if the option BEEP is also set; this may be modified if completion is
# called from a user-defined widget.
setopt no_list_beep
#}}}

# {{{ LIST_PACKED
# Try to make the completion list smaller (occupying less lines) by printing the
# matches in columns with different widths.
setopt list_packed
#}}}
#}}}

# {{{ Expansion and Globbing
################################################################################
# {{{ CASE_GLOB <D>
# Make globbing (filename generation) sensitive to case. Note that other uses of
# patterns are always sensitive to case. If the option is unset, the presence of
# any character which is special to filename generation will cause
# case-insensitive matching. For example, cvs(/) can match the directory CVS
# owing to the presence of the globbing flag (unless the option BARE_GLOB_QUAL
# is unset).
setopt no_case_glob
#}}}

# {{{ EXTENDED_GLOB
# Treat the "#", "~" and "^" characters as part of patterns for filename
# generation, etc. (An initial unquoted "~" always produces named directory
# expansion.)
setopt extended_glob
#}}}

# {{{ MARK_DIRS (-, ksh: -X)
# Append a trailing "/" to all directory names resulting from filename
# generation (globbing).
setopt mark_dirs
#}}}

# {{{ MULTIBYTE <C> <K> <Z>
# Respect multibyte characters when found in strings. When this option is set,
# strings are examined using the system library to determine how many bytes form
# a character, depending on the current locale. This affects the way characters
# are counted in pattern matching, parameter values and various delimiters.
#
# The option is on by default if the shell was compiled with MULTIBYTE_SUPPORT
# except in sh emulation; otherwise it is off by default and has no effect if
# turned on. The mode is off in sh emulation for compatibility but for
# interative use may need to be turned on if the terminal interprets multibyte
# characters.
#
# If the option is off a single byte is always treated as a single character.
# This setting is designed purely for examining strings known to contain raw
# bytes or other values that may not be characters in the current locale. It is
# not necessary to unset the option merely because the character set for the
# current locale does not contain multibyte characters.
#
# The option does not affect the shell"s editor, which always uses the locale to
# determine multibyte characters. This is because the character set displayed by
# the terminal emulator is independent of shell settings.
setopt no_multibyte
#}}}

# {{{ NOMATCH (+) <C> <Z>
# If a pattern for filename generation has no matches, print an error, instead
# of leaving it unchanged in the argument list. This also applies to file
# expansion of an initial "~" or "=".
setopt nonomatch
#}}}
#}}}

# {{{ History
################################################################################
# {{{ APPEND_HISTORY <D>
# If this is set, zsh sessions will append their history list to the history
# file, rather than replace it. Thus, multiple parallel zsh sessions will all
# have the new entries from their history lists added to the history file, in
# the order that they exit. The file will still be periodically re-written to
# trim it when the number of lines grows 20% beyond the value specified by
# ${SAVEHIST} (see also the HIST_SAVE_BY_COPY option).
setopt append_history
#}}}

# {{{ HIST_BEEP <D>
# Beep when an attempt is made to access a history entry which isn"t there.
setopt no_hist_beep
#}}}

# {{{ HIST_EXPIRE_DUPS_FIRST
# If the internal history needs to be trimmed to add the current command line,
# setting this option will cause the oldest history event that has a duplicate
# to be lost before losing a unique event from the list. You should be sure to
# set the value of HISTSIZE to a larger number than SAVEHIST in order to give
# you some room for the duplicated events, otherwise this option will behave
# just like HIST_IGNORE_ALL_DUPS once the history fills up with unique events.
setopt hist_expire_dups_first
#}}}

# {{{ HIST_FIND_NO_DUPS
# When searching for history entries in the line editor, do not display
# duplicates of a line previously found, even if the duplicates are not
# contiguous.
setopt hist_find_no_dups
#}}}

# {{{ HIST_IGNORE_ALL_DUPS
# If a new command line being added to the history list duplicates an older one,
# the older command is removed from the list (even if it is not the previous
# event).
setopt hist_ignore_all_dups
#}}}

# {{{ HIST_IGNORE_DUPS (-h)
# Do not enter command lines into the history list if they are duplicates of the
# previous event.
setopt hist_ignore_dups
#}}}

# {{{ HIST_IGNORE_SPACE (-g)
# Remove command lines from the history list when the first character on the
# line is a space, or when one of the expanded aliases contains a leading space.
# Note that the command lingers in the internal history until the next command
# is entered before it vanishes, allowing you to briefly reuse or edit the line.
# If you want to make it vanish right away without entering another command,
# type a space and press return.
setopt hist_ignore_space
#}}}

# {{{ HIST_NO_FUNCTIONS
# Remove function definitions from the history list. Note that the function
# lingers in the internal history until the next command is entered before it
# vanishes, allowing you to briefly reuse or edit the definition.
setopt hist_no_functions
#}}}

# {{{ HIST_NO_STORE
# Remove the history (fc -l) command from the history list when invoked. Note
# that the command lingers in the internal history until the next command is
# entered before it vanishes, allowing you to briefly reuse or edit the line.
setopt hist_no_store
#}}}

# {{{ HIST_REDUCE_BLANKS
# Remove superfluous blanks from each command line being added to the history
# list.
setopt hist_reduce_blanks
#}}}

# {{{ HIST_SAVE_BY_COPY <D>
# When the history file is re-written, we normally write out a copy of the file
# named ${HISTFILE}.new and then rename it over the old one. However, if this
# option is unset, we instead truncate the old history file and write out the
# new version in-place. If one of the history-appending options is enabled, this
# option only has an effect when the enlarged history file needs to be
# re-written to trim it down to size. Disable this only if you have special
# needs, as doing so makes it possible to lose history entries if zsh gets
# interrupted during the save.
#
# When writing out a copy of the history file, zsh preserves the old file"s
# permissions and group information, but will refuse to write out a new file if
# it would change the history file"s owner.
setopt hist_save_by_copy
#}}}

# {{{ HIST_SAVE_NO_DUPS
# When writing out the history file, older commands that duplicate newer ones
# are omitted.
setopt hist_save_no_dups
#}}}

# {{{ HIST_VERIFY
# Whenever the user enters a line with history expansion, don't execute the line
# directly; instead, perform history expansion and reload the line into the
# editing buffer.
setopt hist_verify
#}}}
#}}}

# {{{ Input/Output
################################################################################
# {{{ CORRECT (-)
# Try to correct the spelling of commands. Note that, when the HASH_LIST_ALL
# option is not set or when some directories in the path are not readable, this
# may falsely report spelling errors the first time some commands are used.
setopt correct
#}}}

# {{{ MAIL_WARNING (-U)
# Print a warning message if a mail file has been accessed since the shell last
# checked.
setopt no_mail_warning
#}}}

# {{{ SHORT_LOOPS <C> <Z>
# Allow the short forms of for, repeat, select, if, and function constructs.
setopt short_loops
#}}}
#}}}

# {{{ Job Control
################################################################################
# {{{ AUTO_CONTINUE
# With this option set, stopped jobs that are removed from the job table with
# the disown builtin command are automatically sent a CONT signal to make them
# running.
setopt auto_continue
#}}}

# {{{ CHECK_JOBS <Z>
# Report the status of background and suspended jobs before exiting a shell with
# job control; a second attempt to exit the shell will succeed. NO_CHECK_JOBS is
# best used only in combination with NO_HUP, else such jobs will be killed
# automatically.
#
# The check is omitted if the commands run from the previous command line
# included a "jobs" command, since it is assumed the user is aware that there
# are background or suspended jobs. A "jobs" command run from one of the hook
# functions defined in the section SPECIAL FUNCTIONS in zshmisc(1) is not
# counted for this purpose.
setopt no_check_jobs
#}}}

# {{{ LONG_LIST_JOBS (-R)
# List jobs in the long format by default.
setopt long_list_jobs
#}}}

# {{{ MONITOR (-m, ksh: -m)
# Allow job control. Set by default in interactive shells.
setopt monitor
#}}}

# {{{ NOTIFY (-, ksh: -b) <Z>
# Report the status of background jobs immediately, rather than waiting until
# just before printing a prompt.
setopt notify
#}}}
#}}}

# {{{ Scripts and Functions
################################################################################
# {{{ MULTIOS <Z>
# Perform implicit tees or cats when multiple redirections are attempted (see
# the section "Redirection").
setopt multios
#}}}
#}}}

# {{{ Shell Emulation
################################################################################
# {{{ POSIX_BUILTINS <K> <S>
# When this option is set the command builtin can be used to execute shell
# builtin commands. Parameter assignments specified before shell functions and
# special builtins are kept after the command completes unless the special
# builtin is prefixed with the command builtin. Special builtins are ., :,
# break, continue, declare, eval, exit, export, integer, local, readonly,
# return, set, shift, source, times, trap and unset.
setopt posix_builtins
#}}}
#}}}

# {{{ Zle
################################################################################
# {{{ BEEP (+B) <D>
# Beep on error in ZLE.
setopt nobeep
#}}}

# {{{ EMACS
# If ZLE is loaded, turning on this option has the equivalent effect of "bindkey
# -e". In addition, the VI option is unset. Turning it off has no effect. The
# option setting is not guaranteed to reflect the current keymap. This option is
# provided for compatibility; bindkey is the recommended interface.
setopt no_emacs
#}}}

# {{{ VI
# If ZLE is loaded, turning on this option has the equivalent effect of "bindkey
# -v". In addition, the EMACS option is unset. Turning it off has no effect. The
# option setting is not guaranteed to reflect the current keymap. This option is
# provided for compatibility; bindkey is the recommended interface.
setopt vi
#}}}

# {{{ PromptSubst
setopt promptsubst
#}}}
#}}}
#}}}

# {{{ Hashes
################################################################################
# hash [ -Ldfmrv ] [ name[=value] ] ...
#
# hash can be used to directly modify the contents of the command hash table,
# and the named directory hash table. Normally one would modify these tables by
# modifying one's PATH (for the command hash table) or by creating appropriate
# shell parameters (for the named directory hash table). The choice of hash
# table to work on is determined by the -d option; without the option the
# command hash table is used, and with the option the named directory hash table
# is used.
#
# Given no arguments, and neither the -r or -f options, the selected hash table
# will be listed in full.
#
# The -r option causes the selected hash table to be emptied. It will be
# subsequently rebuilt in the normal fashion. The -f option causes the selected
# hash table to be fully rebuilt immediately. For the command hash table this
# hashes all the absolute directories in the PATH, and for the named directory
# hash table this adds all users' home directories. These two options cannot be
# used with any arguments.
#
# The -m option causes the arguments to be taken as patterns (which should be
# quoted) and the elements of the hash table matching those patterns are
# printed. This is the only way to display a limited selection of hash table
# elements.
#
# For each name with a corresponding value, put `name' in the selected hash
# table, associating it with the pathname `value'. In the command hash table,
# this means that whenever `name' is used as a command argument, the shell will
# try to execute the file given by `value'. In the named directory hash table,
# this means that `value' may be referred to as `~name'.
#
# For each name with no corresponding value, attempt to add name to the hash
# table, checking what the appropriate value is in the normal manner for that
# hash table. If an appropriate value can't be found, then the hash table will
# be unchanged.
#
# The -v option causes hash table entries to be listed as they are added by
# explicit specification. If has no effect if used with -f.
#
# If the -L flag is present, then each hash table entry is printed in the form
# of a call to hash.
if [[ -d ~/git ]]; then
    for i in ~/git/*(/); do
        hash -d "repo$(basename ${i})"="${i}"
    done
fi
#}}}

# {{{ Aliases
################################################################################
# alias [ {+|-}gmrsL ] [ name[=value] ... ]
# For each name with a corresponding value, define an alias with that value. A
# trailing space in value causes the next word to be checked for alias
# expansion. If the -g flag is present, define a global alias; global aliases
# are expanded even if they do not occur in command position.
#
# If the -s flags is present, define a suffix alias: if the command word on a
# command line is in the form `text.name', where text is any non-empty string,
# it is replaced by the text `value text.name'. Note that name is treated as a
# literal string, not a pattern. A trailing space in value is not special in
# this case. For example,
#
#   alias -s ps=gv
#
# will cause the command `*.ps' to be expanded to `gv *.ps'. As alias expansion
# is carried out earlier than globbing, the `*.ps' will then be expanded. Suffix
# aliases constitute a different name space from other aliases (so in the above
# example it is still possible to create an alias for the command ps) and the
# two sets are never listed together.
#
# For each name with no value, print the value of name, if any. With no
# arguments, print all currently defined aliases other than suffix aliases. If
# the -m flag is given the arguments are taken as patterns (they should be
# quoted to preserve them from being interpreted as glob patterns), and the
# aliases matching these patterns are printed. When printing aliases and one of
# the -g, -r or -s flags is present, restrict the printing to global, regular or
# suffix aliases, respectively; a regular alias is one which is neither a global
# nor a suffix alias. Using `+' instead of `-', or ending the option list with a
# single `+', prevents the values of the aliases from being printed.
#
# If the -L flag is present, then print each alias in a manner suitable for
# putting in a startup script. The exit status is nonzero if a name (with no
# value) is given for which no alias has been defined.

# Global aliases
alias -g G='|& egrep --ignore-case'
alias -g N='&> /dev/null'

# remap the buildin commads
alias which='whence -vas'
alias where='whence -cas'

# search an specific alias
alias aliasgrep='alias G'

# no spell correction for cp, mv, rm, mkdir, rmdir and adding default options
alias cp='nocorrect cp -v'
alias mv='nocorrect mv -v'
alias ln='nocorrect ln -v'
alias mkdir='nocorrect mkdir -v'
#}}}

# {{{ Functions
# Executed before each prompt. Note that precommand functions are not reexecuted
# simply because the command line is redrawn, as happens, for example, when a
# notification about an exiting job is displayed.
function precmd() {
    vcs_info prompt
    if [[ -n ${vcs_info_msg_0_} ]]; then
        RPROMPT="${vcs_info_msg_0_} "
    else
        RPROMPT=""
    fi
}
#}}}

# {{{ ulimit
###############################################################################
# ulimit [ -SHacdflmnpstv [ limit ] ... ]
# Set or display resource limits of the shell and the processes started by the
# shell. The value of limit can be a number in the unit specified below or the
# value `unlimited'. By default, only soft limits are manipulated. If the -H
# flag is given use hard limits instead of soft limits. If the -S flag is given
# together with the -H flag set both hard and soft limits. If no options are
# used, the file size limit (-f) is assumed. If limit is omitted the current
# value of the specified resources are printed. When more than one resource
# values are printed the limit name and unit is printed before each value.
#   -a
#       Lists all of the current resource limits.
#   -c
#       512-byte blocks on the size of core dumps.
#   -d
#       K-bytes on the size of the data segment.
#   -f
#       512-byte blocks on the size of files written.
#   -l
#       K-bytes on the size of locked-in memory.
#   -m
#       K-bytes on the size of physical memory.
#   -n
#       open file descriptors.
#   -s
#       K-bytes on the size of the stack.
#   -t
#       CPU seconds to be used.
#   -u
#       processes available to the user.
#   -v
#       K-bytes on the size of virtual memory. On some systems this refers to
#       the limit called `address space'.
unlimit

limit stack 8192
limit core 0
limit -s
#}}}

# {{{ umask
###############################################################################
# umask [ -S ] [ mask ]
# The umask is set to mask. mask can be either an octal number or a symbolic
# value as described in man page chmod(1). If mask is omitted, the current value
# is printed. The -S option causes the mask to be printed as a symbolic value.
# Otherwise, the mask is printed as an octal number. Note that in the symbolic
# form the permissions you specify are those which are to be allowed (not
# denied) to the users specified.
umask 0077

# vcs_info
# In a lot of cases, it is nice to automatically retrieve information from
# version control systems (VCSs), such as subversion, CVS or git, to be able to
# provide it to the user; possibly in the user's prompt. So that you can
# instantly tell on which branch you are currently on, for example
autoload -Uz vcs_info

zstyle ':vcs_info:*:prompt:*' actionformats "(${BOLD_BLACK}%s${NO_COLOR}) [${BOLD_YELLOW}%a${NO_COLOR}]"
zstyle ':vcs_info:*:prompt:*' branchformat "${BOLD_GREEN}%r${NO_COLOR}"
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' formats "%u%c${NO_COLOR} (${BOLD_BLACK}%s${NO_COLOR}) ${MAGENTA}%8.8i${NO_COLOR}"
zstyle ':vcs_info:*:prompt:*' get-revision true
zstyle ':vcs_info:*:prompt:*' stagedstr "${BOLD_GREEN}*"
zstyle ':vcs_info:*:prompt:*' unstagedstr "${BOLD_YELLOW}!"
#}}}
#}}}

# # {{{ ZSh Modules
# THE ZSH/TERMCAP MODULE
# The zsh/termcap module makes available one builtin command:
#
# echotc cap [ arg ... ]
#   Output the termcap value corresponding to the capability cap, with optional
#   arguments.
#
# The zsh/termcap module makes available one parameter:
# termcap
#   An associative array that maps termcap capability codes to their values.
autoload -Uz zsh/termcap
#}}}

# {{{ Load Resources
# load none ZSH components and/or configurations for all shells but jump to HOME
# before
if [[ -d ~/.shell ]]; then
    for sh in ~/.shell/*.sh(.); do
        [[ -r "${sh}" ]] && source "${sh}" || true
    done
fi

for sh in ~/.zsh/local/*.sh(.); do
    [[ -r "${sh}" ]] && source "${sh}" || true
done
unset sh
#}}}

# vim: filetype=zsh textwidth=80 foldmethod=marker
