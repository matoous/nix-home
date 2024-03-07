{ pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      scan_timeout = 10;
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$localip"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_status"
        "$sudo"
        "$jobs"
        "$battery"
        "$status"
        "$character"
      ];      

      git_branch = {
        format = "\\[[$branch]($style)\\]";
      };

      git_commit = {
        only_detached = false;
        format = "\\[[$hash]($style)\\]";
      };

      git_status = {
        format = "\\[([$all_status$ahead_behind]($style))\\]";
      };

      sudo = {
        format = "\\[as $symbol\\]";
      };

      username = {
        format = "\\[[$user]($style)\\]";
      };

      directory = {
        format = "[$path](bold white)[$read_only]($read_only_style)";
      };

      character = {
        success_symbol = "[](bold yellow)";
        error_symbol = "[!](bold red)";
      };
    };
  };
}
