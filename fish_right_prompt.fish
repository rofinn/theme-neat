function fish_right_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l red (set_color -o red)
  set -l normal (set_color normal)
  set -l white (set_color white)

  echo -n -s $white (date "+%H:%M:%S")

  if test $last_status -ne 0
    set_color red
    printf ' %d' $last_status
    set_color normal
  end
end
