{ lib, pkgs, pkgs-unstable }: let
  isKakFile = name: type: type == "regular" && lib.hasSuffix ".kak" name;
  isDir     = name: type: type == "directory";
  allKakFiles = (dir:
    let fullPath = p: "${dir}/${p}";
        files = builtins.readDir dir;
        subdirs  = lib.concatMap (p: allKakFiles (fullPath p)) (lib.attrNames (lib.filterAttrs isDir files));
        subfiles = builtins.map fullPath (lib.attrNames (lib.filterAttrs isKakFile files));
    # This makes sure the most shallow files are loaded first
    in (subfiles ++ subdirs)
  );
  kakImport = name: ''source "${name}"'';
  allKakImports = dir: builtins.concatStringsSep "\n" (map kakImport (allKakFiles dir));

in
''
  ${allKakImports pkgs.kak-fzf}

  # eval %sh{kak-lsp --kakoune -s $kak_session}
  # hook global WinSetOption filetype=(haskell) %{
  #   lsp-enable-window
  # }

  # Custom mercury mode, lets roll
  source /home/manky/repos/adventofcode/mercury.kak

  hook global InsertChar k %{ try %{
    exec -draft hH <a-k>jk<ret> d
    exec <esc>
  }}

  map global normal = '|${pkgs-unstable.fmt}/bin/fmt -w $kak_opt_autowrap_column<ret>'

  hook global BufCreate .*[.](hsc) %{
      set-option buffer filetype haskell
  }

  hook global WinSetOption filetype=haskell %{
    # HLinty goodness
    set-option window lintcmd 'hlint'
    lint-enable

    # Hasktaggy goodness
    set-option window ctagscmd "hasktags -x -c -R"

    hook window BufWritePost %val{buffile} %{
      lint
    }
  }

  hook global KakBegin .* %{
      evaluate-commands %sh{
          path="$PWD"
          while [ "$path" != "$HOME" ] && [ "$path" != "/" ]; do
              if [ -e "./tags" ]; then
                  printf "%s\n" "set-option -add current ctagsfiles %{$path/tags}"
                  break
              else
                  cd ..
                  path="$PWD"
              fi
          done
      }
  }

  define-command mkdir %{ nop %sh{ mkdir -p $(dirname $kak_buffile) } }
  set-option global grepcmd 'ag --column'
  add-highlighter global/ show-matching

  def suspend-and-resume \
      -params 1..2 \
      -docstring 'suspend-and-resume <cli command> [<kak command after resume>]: backgrounds current kakoune client and runs specified cli command.  Upon exit of command the optional kak command is executed.' \
      %{ evaluate-commands %sh{

      # Note we are adding '&& fg' which resumes the kakoune client process after the cli command exits
      cli_cmd="$1 && fg"
      post_resume_cmd="$2"

      # automation is different platform to platform
      platform=$(uname -s)
      case $platform in
          Darwin)
              automate_cmd="sleep 0.01; osascript -e 'tell application \"System Events\" to keystroke \"$cli_cmd\\n\" '"
              kill_cmd="/bin/kill"
              break
              ;;
          Linux)
              automate_cmd="sleep 0.2; xdotool type '$cli_cmd'; xdotool key Return"
              kill_cmd="/usr/bin/kill"
              break
              ;;
      esac

      # Uses platforms automation to schedule the typing of our cli command
      nohup sh -c "$automate_cmd"  > /dev/null 2>&1 &
      # Send kakoune client to the background
      $kill_cmd -SIGTSTP $kak_client_pid

      # ...At this point the kakoune client is paused until the " && fg " gets run in the $automate_cmd

      # Upon resume, run the kak command is specified
      if [ ! -z "$post_resume_cmd" ]; then
          echo "$post_resume_cmd"
      fi
  }}
''