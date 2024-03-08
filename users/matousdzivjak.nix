{ inputs
, outputs
, lib
, config
, pkgs
, unstable
, bleeding-edge
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

  xdg.enable = true;

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
    pandoc = {
      enable = true;
    };
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    ssh = {
      enable = true;
    };
  };

  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.moreutils

    # Fast flake downloads
    pkgs.cachix

    # To flex with the setup
    pkgs.neofetch

    # HTTP, httpie is the main driver
    pkgs.httpie
    # curl and wget for scipts and tools that use them
    pkgs.wget
    pkgs.curl

    # curl, but for gRPC
    pkgs.grpcurl

    # Alternative to find
    pkgs.fd

    # Alternative to cat, file pager
    pkgs.bat

    # Alternative to ls, used to be exa but that became unmaintained
    pkgs.eza

    # Alternative to dig, for DNS
    pkgs.dog

    # JSON mangling in terminal
    pkgs.jq

    # Workspace search and replace
    pkgs.fastmod
    # Another search and replace tool
    pkgs.amber

    # Cloc with extras, count lines and more
    pkgs.scc

    # ast-grep, AST tree based search/replace tool
    # https://github.com/ast-grep/ast-grep
    pkgs.ast-grep

    # Session recording
    pkgs.asciinema

    # For when I make a mistake
    # pkgs.trashy # TODO: doesn't work on m1

    # Shell tools
    pkgs.ack
    pkgs.difftastic
    pkgs.loc
    pkgs.tanka
    pkgs.yarn
    pkgs.yq

    # Typos! Everyone makes them
    # https://github.com/crate-ci/typos
    pkgs.typos

    # Colorful top
    pkgs.btop

    # Get wifi password from command line
    pkgs.wifi-password

    # Workspace search
    pkgs.ripgrep

    # File info
    pkgs.file

    # Run github action locally
    pkgs.act

    # Fly.io, used for wiki
    pkgs.flyctl

    # dzx.cz
    pkgs.hugo

    # Linux virtual machines
    pkgs.lima-bin

    # Container runtime on MacOS
    pkgs.colima

    pkgs.gh
    pkgs.imagemagick
    pkgs.pgcli
    pkgs.pinentry_mac
    pkgs.yubikey-manager

    # auto-squash on steroids
    # https://github.com/tummychow/git-absorb
    pkgs.git-absorb

    # Work
    pkgs.argocd
    pkgs.aws-iam-authenticator
    pkgs.conftest
    pkgs.kubernetes-helm

    # Docker
    pkgs.docker-buildx
    pkgs.docker-compose
    pkgs.dive

    # AWS/Kubernetes-related packages
    pkgs.aws-vault # A vault for securely storing and accessing AWS credentials in development environments
    pkgs.kind
    pkgs.kubectl
    pkgs.kubectl-gadget # A collection of gadgets for troubleshooting Kubernetes application using eBPF
    pkgs.kubectl-images # Show container images used in the cluster
    pkgs.kubectl-view-secret # Kubernetes CLI plugin to decode Kubernetes secrets
    pkgs.kubectx
    pkgs.kubie
    pkgs.kustomize

    # TODO: find how to install some docker compatible CLI interface for building images which is the same as macOS.
    # pkgs.podman
    # pkgs.docker
    # pkgs.docker-compose
    # pkgs.docker-machine-kvm2
    # pkgs.docker-machine
    # pkgs.nerdctl

    # Languages
    pkgs.nodejs
    pkgs.python3
    pkgs.rustup
    pkgs.rustc
    pkgs.deno
    pkgs.elixir
    # pkgs.go

    # pkgs.cargo # TODO: enable, currently conflicts

    # Go for embed and wasm
    pkgs.tinygo

    # Language servers
    pkgs.nil

    # Compression
    pkgs.zstd
    pkgs.lz4
    pkgs.zx

    # Fonts
    pkgs.jetbrains-mono

    # Apps
    pkgs.spotify
    pkgs._1password
    # pkgs._1password-gui # TODO: for some reason doesn't work, old version?

    # Flash OS images to SD cards
    # pkgs.etcher # TODO: not available on MacOS

    # Media player for MacOS
    pkgs.iina

    # Work work work
    pkgs.slack
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # ".kube/classic.yaml".source = kube/classic.yaml;
    # ".kube/fleet.yaml".source = kube/fleet.yaml;
    # ".aws/config".source = aws/config.ini;
  };
}
