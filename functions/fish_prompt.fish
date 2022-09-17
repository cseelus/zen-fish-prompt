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
  set --local is_git_repository (command git rev-parse --is-inside-work-tree 2>/dev/null)

  if test -n "$is_git_repository"
    echo (command git symbolic-ref --short HEAD 2>/dev/null;
        or command git name-rev --name-only HEAD 2>/dev/null)
  end
end

function _git_status_symbol
  set --local is_git_repository (command git rev-parse --is-inside-work-tree 2>/dev/null)

  if test -n "$is_git_repository"
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
end

# Change VIM mode indicator
function fish_mode_prompt
  switch $fish_bind_mode
    case default
      set_color --bold blue
      echo 'ɴᴏʀᴍᴀʟ'
    case insert
      set_color --bold green
      echo ' '
    case replace_one
      set_color --bold red
      echo 'ʀᴇᴘʟᴀᴄᴇ'
    case visual
      set_color --bold yellow
      echo 'ᴠɪsᴜᴀʟ'
    case '*'
      set_color --bold red
      echo 'ˀˀˀ'
  end
  set_color normal
end
