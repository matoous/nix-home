{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Matouš Dzivjak";
    userEmail = "matousdzivjak@gmail.com";
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqFBIN8LPA9MTCLv/cZbS/CGGSM2S8FYaq1HJzZy8Rv";
      signByDefault = true;
    };
    aliases = {
      aliases = "!git config --get-regexp alias | sed -re 's/alias\\.(\\S*)\\s(.*)$/\\1 = \\2/g'";
      w = "switch hist = log --pretty=format:'%h %ad | %s%d %an' --graph --date=short = {";
      type = "cat-file -t";
      dump = "cat-file -p";
      c = "commit";
      f = "fetch";
      b = "branch";
      s = "status";
      p = "pull";
      d = "diff";
      lo = "log --oneline -n 10";
      lg = "log --graph --date=relative --pretty=tformat:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%an %ad)%Creset'";
      unstage = "reset HEAD";
      pushf = "push --force-with-lease";
      cane = "commit --amend --no-edit";
      reword = "commit --amend";
      uncommit = "reset --soft HEAD~1";
      untrack = "rm --cache --  ";
      cmt = "!git add . && git commit --amend && git push --force-with-lease";
    };
    extraConfig = {
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
      core = {
        editor = "hx";
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
        excludesfile = "~/.config/git/.gitignore_global";
        fsmonitor = true;
      };
      apply = {
        whitespace = "fix";
      };
      color = {
        ui = "auto";
      };
      credential = {
        helper = "osxkeychain";
      };
      diff = {
        mnemonicPrefix = "true";
        renames = "true";
        submodule = "log";
        colorMoved = "default";
      };
      fetch = {
        prune = true;
      };
      filter = {
        lfs = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };
      http = {
        cookiefile = "$HOME/.gitcookies";
      };
      init = {
        defaultBranch = "main";
      };
      interactive = {
        diffFilter = "difft";
      };
      log = {
        abbrevCommit = true;
        follow = true;
      };
      pull = {
        rebase = true;
        autostash = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      rebase = {
        autoStash = true;
        updateRefs = true;
      };
      push = {
        default = "current";
        autoSetupRemote = true;
        followTags = true;
      };
      tag = {
        forceSignAnnotated = true;
      };
      gpg = {
        format = "ssh";
      };
      gpg."ssh".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };
  };

  xdg.configFile."git/.gitignore_global".source = ./.gitignore_global;
}
