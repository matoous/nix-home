{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: 
let
  username = "matousdzivjak";
  homeDir = "/Users/${username}";
in 
{
  imports = [
    ./git/default.nix
    ./fish/default.nix
    ./starship/default.nix
    ./helix/default.nix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";


  # Search for home-manager options here:
  # https://mipmip.github.io/home-manager-option-search/
  nixpkgs = {
    overlays = [
      # Add overlays defined in the flake outputs, from the overlay/ and pkgs/ dirs.
      outputs.overlays.additions
    ];
    config = {
      # Allow closed source / unfree packages.
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = username;
    homeDirectory = homeDir;
    # Environment variables to always set at login.
    # sessionVariables = {
    #   KUBECONFIG = "${homeDir}/.kube/config:${homeDir}/.kube/classic.yaml:${homeDir}/.kube/fleet.yaml";
    # };
  };

  editorconfig = {
    enable = true;
  };

  programs = {
    home-manager.enable = true;
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    awscli = {
      enable = true;
    };
    k9s = {
      enable = true;
    };
    thefuck = {
      enable = true;
      enableFishIntegration = true;
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
    ripgrep = {
      enable = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
    };
    jq = {
      enable = true;
    };
    pandoc = {
      enable = true;
    };
  };

  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # Nix language server
    pkgs.nil

    # Shell tools
    pkgs.ripgrep
    pkgs.ack

    # Work
    pkgs.argocd
    pkgs.kubernetes-helm

    # Docker
    pkgs.dive

    # AWS/Kubernetes-related packages
    pkgs.kubectl
    pkgs.kubectl-images # Show container images used in the cluster
    pkgs.kubectl-gadget # A collection of gadgets for troubleshooting Kubernetes application using eBPF
    pkgs.kubectl-view-secret # Kubernetes CLI plugin to decode Kubernetes secrets
    pkgs.kubie
    pkgs.krew
    pkgs.kind
    pkgs.aws-vault # A vault for securely storing and accessing AWS credentials in development environments

    pkgs.act

    # TODO: find how to install some docker compatible CLI interface for building images which is the same as macOS.
    # pkgs.podman
    # pkgs.docker
    # pkgs.docker-compose
    # pkgs.docker-machine-kvm2
    # pkgs.docker-machine
    # pkgs.nerdctl

    pkgs.nodejs
    pkgs.python3
    pkgs.rustup
    pkgs.rustc
    pkgs.deno

    # Font
    pkgs.fira-code-nerdfont
    # It is sometimes useful to fine-tune packages, for example, by applying
    # overrides. You can do that directly here, just don't forget the
    # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # fonts?
    (
      pkgs.nerdfonts.override {
        fonts = [
          "FantasqueSansMono"
          "FiraMono"
          "Inconsolata"
          "InconsolataGo"
          "JetBrainsMono"
          "Meslo"
        ];
      }
    )

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # ".kube/classic.yaml".source = kube/classic.yaml;
    # ".kube/fleet.yaml".source = kube/fleet.yaml;
    # ".aws/config".source = aws/config.ini;
  };
}
