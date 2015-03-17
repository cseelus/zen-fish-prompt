# name: clearance
# ---------------
# Based on idan. Display the following bits on the left:
# - Virtualenv name (if applicable, see https://github.com/adambrenecki/virtualfish)
# - Current directory name
# - Git branch and dirty state (if inside a git repo)

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _remote_hostname
  if test -n "$SSH_CONNECTION"
    echo (whoami)@(hostname)
  end
end

function fish_prompt
  set -l turquoise (set_color green)
  set -l cobalt (set_color blue)
  set -l purple (set_color cyan)
  set -l cloud (set_color white)
  set -l sap (set_color yellow)

  set -l cwd $cobalt(pwd | sed "s:^$HOME:~:")

  # Output the prompt, left to right

  # Add a newline before new prompts
  echo -e ''

  # Display [venvname] if in a virtualenv
  if set -q VIRTUAL_ENV
      echo -n -s (set_color -b turquoise black) '[' (basename "$VIRTUAL_ENV") ']' $cloud ' '
  end

  # Print remote hostname
  if [ (_remote_hostname) ]
    echo -n $cobalt (_remote_hostname)$cloud '· '
  end

  # Print pwd or full path
  echo -n -s $cwd (set_color normal) $cloud

  # Show git branch and status
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)

    if [ (_git_is_dirty) ]
      set git_info '(' $sap $git_branch "±" $cloud ')'
    else
      set git_info '(' $turquoise $git_branch $cloud ')'
    end
    echo -n -s ' · ' $git_info $cloud
  end

  # Terminate with a nice prompt char
  echo -e ''
  echo -e -n -s '⟩ ' $cloud
end

# set fish_color_autosuggestion black
set fish_color_normal white
set fish_color_command green
set fish_color_param magenta
set fish_color_quote purple
# fish_color_redirection, the color for IO redirections
# fish_color_end, the color for process separators like ';' and '&'
# fish_color_error, the color used to highlight potential errors
# fish_color_comment, the color used for code comments
# fish_color_match, the color used to highlight matching parenthesis
# fish_color_search_match, the color used to highlight history search matches
# fish_color_operator, the color for parameter expansion operators like '*' and '~'
# fish_color_escape, the color used to highlight character escapes like '\n' and '\x70'
# fish_color_cwd, the color used for the current working directory in the default prompt
