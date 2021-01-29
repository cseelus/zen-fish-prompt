# name: zen
# by Chris Seelus (@cseelus) <cseelus@gmail.com>
# License: public domain

function fish_prompt
  set -l blue (set_color blue)
  set -l cyan (set_color cyan)
  set -l green (set_color green)
  set -l yellow (set_color yellow)
  set -l normal (set_color normal)

  # working dir
  set -l working_dir (set_color --bold)(pwd | sed "s:^$HOME:~:")(set_color normal)
  # git info
  set -l git_info (_git_branch_name)(_git_status_symbol)

  # Add colors, spacer and powerline chars to git_info
  if test -n "$git_info"
    set -l dirty (command git diff --no-ext-diff --quiet --exit-code; or echo -n '*')
    if [ "$dirty" ]
      set git_info " · $yellow  $git_info"
    else
      set git_info " · $green  $git_info"
    end
  end

  # Add a newline before new prompts
  echo -e ''
  # hostname + working_dir + git_info
  echo (_remote_hostname) $working_dir$normal $git_info$normal
  # Promt char
  echo -e -n -s 'ϟ '
end


function _remote_hostname
  if test -n "$SSH_CONNECTION"
    echo (whoami)@(hostname)
  end
end

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _git_status_symbol
  set -l git_status (git status --porcelain ^/dev/null)

  if test -n "$git_status"
    # Is there anyway to preserve newlines so we can reuse $git_status?
    if git status --porcelain ^/dev/null | grep '^.[^ ]' >/dev/null
      echo ' ±' # dirty
    else
      echo ' ✓' # all staged
    end
  else
    echo    '' # clean
  end
end

