# VCS
YS_VCS_PROMPT_PREFIX1=" %{$fg[white]%}on%{$reset_color%} "
YS_VCS_PROMPT_PREFIX2=":%{$fg[yellow]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}"
YS_VCS_PROMPT_DIRTY=" %{$fg[red]%}o "
YS_VCS_PROMPT_CLEAN=" %{$fg[green]%}✔ "

# Git info
local git_info='$(git_prompt)'
ZSH_THEME_GIT_PROMPT_PREFIX="git${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# Git status.
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%} ✚ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%} -%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%} ●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[blue]%} ❯%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[cyan]%} ═%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[magenta]%} *%{$reset_color%}"

function git_prompt {
    if [[ -n $(git rev-parse --is-inside-work-tree 2>/dev/null) ]]; then
        local mode
        if [[ -e "$(git rev-parse --git-dir 2>/dev/null)/MERGE_HEAD" ]]; then
          mode="%{$fg_bold[red]%}>M<%{$reset_color%} "
        fi
        local git_status="$(git_prompt_status)"
        if [[ -n $git_status ]]; then
            git_status="[$git_status%{$reset_color%} ] "
        fi
        local git_prompt=" ( $(git_prompt_info)$mode$git_status)"
        echo $git_prompt
    fi
}

# HG info
local hg_info='$(ys_hg_prompt_info)'
ys_hg_prompt_info() {
  # make sure this is a hg dir
  if [ -d '.hg' ]; then
    echo -n "${YS_VCS_PROMPT_PREFIX1}hg${YS_VCS_PROMPT_PREFIX2}"
    echo -n $(hg branch 2>/dev/null)
    if [ -n "$(hg status 2>/dev/null)" ]; then
      echo -n "$YS_VCS_PROMPT_DIRTY"
    else
      echo -n "$YS_VCS_PROMPT_CLEAN"
    fi
    echo -n "$YS_VCS_PROMPT_SUFFIX"
  fi
}

bureau_precmd () {
  print -rP "$precmd"
}

local exit_code="%(?,,C:%{$fg[red]%}%?%{$reset_color%})"

PROMPT="
%{$terminfo[bold]$fg_bold[magenta]%}%~%{$reset_color%}\
${hg_info}\
${git_info}\
\
%{$fg[white]%}   [%*]   $exit_code
%{$terminfo[bold]$fg[red]%}❯ %{$reset_color%}"
