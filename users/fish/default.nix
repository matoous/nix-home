{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
    functions = {
      update = {
        description = "Update binaries";
        body =
          ''
            brew update; and brew upgrade
            gup update
            npm update -g
            rustup update  
            cargo install-update -a
          '';
      };

      falias = {
        description = "Find aliases";
        body =
          ''
            set CMD (alias | string split \n; functions | grep "()" | cut -d ' ' -f1 | grep -v "^_ " | string split \n | fzf | cut -d '=' -f1)
            eval $CMD
          '';
      };

      gtake = {
        description = "Git take. Clone and CD into GitHub repo my org/name.";
        body =
          ''
            echo $argv[1]
            git clone "https://github.com/$argv[1]" "$HOME/code/github.com/$argv[1]"
            echo "https://github.com/$argv[1]" >> "$HOME/code/repositories.txt"
            cd "$HOME/code/github.com/$argv[1]"
          '';
      };

      take = {
        description = "Take directory or GitHub repo";
        body =
          ''
            if string match -rq 'git@github.com:*' $argv[1]
                set repo (echo $argv[1] | sed 's/^git@github.com:/https:\/\/github.com\//' | sed 's/.git$//')
                set dirname (basename $repo)
                git clone $repo
                cd $dirname
            else
                mkdir -p $argv[1]; and cd $argv[1]
            end
          '';
      };

      fkill = {
        description = "Find and kill a process";
        body =
          ''
            # Directly use ps command because it is often aliased to a different command entirely
            # or with options that dirty the search results and preview output
            set -f ps_cmd (command -v ps || echo "ps")
            # use all caps to be consistent with ps default format
            # snake_case because ps doesn't seem to allow spaces in the field names
            set -f ps_preview_fmt (string join ',' 'pid' 'ppid=PARENT' 'user' '%cpu' 'rss=RSS_IN_KB' 'start=START_TIME' 'command')
            set -f processes_selected (
                $ps_cmd -A -opid,command | \
                fzf --multi \
                    --prompt="Processes> " \
                    --query (commandline --current-token) \
                    --ansi \
                    # first line outputted by ps is a header, so we need to mark it as so
                    --header-lines=1 \
                    # ps uses exit code 1 if the process was not found, in which case show an message explaining so
                    --preview="$ps_cmd -o '$ps_preview_fmt' -p {1} || echo 'Cannot preview {1} because it exited.'" \
                    --preview-window="bottom:4:wrap" \
                    $fzf_processes_opts
            )
  
            set pid (echo $processes_selected | awk '{print $1}')
            if [ "x$pid" != "x" ]
                echo $pid | xargs kill -$argv
            end
          '';
      };

      glog = {
        description = "Search the output of git log and preview commits. Replace the current token with the selected commit hash.";
        body =
          ''
            if not git rev-parse --git-dir >/dev/null 2>&1
                echo 'glog: Not in a git repository.' >&2
            else
                if not set --query fzf_git_log_format
                    # %h gives you the abbreviated commit hash, which is useful for saving screen space, but we will have to expand it later below
                    set -f fzf_git_log_format '%C(bold blue)%h%C(reset) - %C(cyan)%ad%C(reset) %C(yellow)%d%C(reset) %C(normal)%s%C(reset)  %C(dim normal)[%an]%C(reset)'
                end

                set -f preview_cmd 'git show --color=always --stat --patch {1}'
                if set --query fzf_diff_highlighter
                    set preview_cmd "$preview_cmd | $fzf_diff_highlighter"
                end

                set -f selected_log_lines (
                    git log --no-show-signature --color=always --format=format:$fzf_git_log_format --date=short | \
                    fzf --ansi \
                        --multi \
                        --scheme=history \
                        --prompt="Git Log> " \
                        --preview=$preview_cmd \
                        --query=(commandline --current-token) \
                        $fzf_git_log_opts
                )
                if test $status -eq 0
                    for line in $selected_log_lines
                        set -f abbreviated_commit_hash (string split --field 1 " " $line)
                        set -f full_commit_hash (git rev-parse $abbreviated_commit_hash)
                        set -f --append commit_hashes $full_commit_hash
                    end
                    commandline --current-token --replace (string join ' ' $commit_hashes)
                end
            end

            commandline --function repaint
          '';
      };
    };
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "cat" = "bat";
      "cope" = "gh copilot explain";
      "copg" = "gh copilot suggest -t git";
      "copgh" = "gh copilot suggest -t gh";
      "cops" = "gh copilot suggest -t shell";
      "cpu" = "htop -s PERCENT_CPU";
      "dk" = "docker";
      "dkc" = "docker compose";
      "e" = "exit";
      "g" = "git";
      "grep" = "ack";
      "ip" = "dig +short myip.opendns.com @resolver1.opendns.com";
      "jsonnet" = "jrsonnet";
      "k" = "kubectl";
      "ll" = "eza --long --sort=age --git --time=modified --time-style=iso";
      "ls" = "eza --all --group-directories-first --level=2";
      "lsa" = "eza --all --group-directories-first --level=2";
      "mem" = "htop -s PERCENT_MEM";
      "mx" = "chmod +x";
      "p" = "python3";
      "pb" = "pbcopy";
      "rm" = "trash";
      "screen" = "neofetch";
      "sizeof" = "du -sh";
      "sz" = "source ~/.config/fish/config.fish";
      "tf" = "terraform";
      "top" = "htop";
      "wifi" = "wifi-password -q";
    };
    shellInit = ''
      set -gx LANG en_US.UTF-8
      set -gx LC_CTYPE en_US.UTF-8
      set -gx CDPATH ".:~:~/code"

      # Editor
      set -gx EDITOR hx

      # Homebrew config
      fish_add_path --append /opt/homebrew/bin
      set -gx HOMEBREW_NO_EMOJI 1
      set -gx HOMEBREW_NO_ANALYTICS 1
      set -gx HOMEBREW_CASK_OPTS --require-sha

      # FZF
      set --export FZF_DEFAULT_OPTS '--cycle --layout=reverse --preview-window=wrap --marker="*" --bind=tab:down,btab:up'

      # GPG
      set -gx GPG_TTY $(tty)

      # Rust
      fish_add_path --append "$HOME/.cargo/bin"

      # Golang
      set -gx GOPRIVATE github.com/sumup
      fish_add_path --append "$HOME/go/bin"

      set -gx LDFLAGS "-L/opt/homebrew/opt/llvm/lib, -L/opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++"
      set -gx CPPFLAGS "-I/opt/homebrew/opt/llvm/include"
    '';
  };
}
