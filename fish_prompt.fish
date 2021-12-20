# name: neat
# description: Based off edan provides a simple yet information rich prompt
# left prompt:
# * Virtualenv/playground name (if applicable, see https://github.com/adambrenecki/virtualfish)
# * Current directory name
# * Git branch and dirty state (if inside a git repo)
# right prompt:
# * time from last cmd
# * return code from last cmd

function _git_branch_name
  echo (command git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _user_host
  if [ (id -u) = "0" ];
    echo -n (set_color -o red)
  else
    echo -n (set_color -o blue)
  end
  echo -n (hostname|cut -d . -f 1)@$USER (set color normal)
end

function fish_prompt
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)
  set -l white (set_color white)
  set -l purple (set_color purple)

  set -l cwd $cyan(basename (prompt_pwd))

  # output the prompt, left to right

  # Add a newline before prompts
  echo -e ""

  # Display [venvname] if in a virtualenv
  if set -q VIRTUAL_ENV
    echo -n -s $blue '[' (basename "$VIRTUAL_ENV") ']' $normal ' '
  end

  # Display [playgroundname] if in a playground
  if set -q PLAYGROUND_ENV
    echo -n -s $purple '[' (basename "$PLAYGROUND_ENV") ']' $normal ' '
  end

  # Display [user & host] when on remote host
  if [ "$NEAT_HOST_TYPE" = "remote" ]
    _user_host; echo -n ': '
  end

  # Display the current directory name
  echo -n -s $cyan (prompt_pwd) $normal


  # Show git branch and dirty state
  if [ (_git_branch_name) ]
    set -l git_branch '(' (_git_branch_name) ')'

    if [ (_is_git_dirty) ]
      set git_info $red $git_branch " ★ "
    else
      set git_info $green $git_branch
    end
    echo -n -s ' ' $git_info $normal
  end

  # Terminate with a nice prompt char
  echo -n -s $cyan ' > ' $normal

end
