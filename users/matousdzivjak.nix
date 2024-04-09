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
    pkgs.wezterm
    pkgs.moreutils

    pkgs.zstd
    pkgs.lz4
    pkgs.zx
    pkgs.cachix # Fast flake downloads
    pkgs.neofetch # To flex with the setup
    pkgs.httpie
    pkgs.wget
    pkgs.curl
    pkgs.grpcurl # curl, but for gRPC
    pkgs.fd # Alternative to find
    pkgs.bat # Alternative to cat, file pager
    pkgs.eza # Alternative to ls, used to be exa but that became unmaintained
    pkgs.dog # Alternative to dig, for DNS
    pkgs.jq # JSON mangling in terminal
    pkgs.ack
    pkgs.difftastic
    pkgs.typos # Typos! Everyone makes them (https://github.com/crate-ci/typos)
    pkgs.btop # Colorful top
    pkgs.wifi-password # Get wifi password from command line
    pkgs.file # File info
    pkgs.imagemagick # Image mangling
    pkgs.hugo

    # Search
    pkgs.fastmod # Workspace search and replace
    pkgs.amber # Another search and replace tool
    pkgs.ast-grep # ast-grep, AST tree based search/replace tool (https://github.com/ast-grep/ast-grep)
    pkgs.ripgrep # Workspace search

    pkgs.loc
    pkgs.scc # Cloc with extras, count lines and more
    pkgs.act # Run github action locally
    pkgs.gh
    pkgs.pgcli
    pkgs.pinentry_mac
    pkgs.yubikey-manager
    pkgs.git-absorb # auto-squash on steroids (https://github.com/tummychow/git-absorb)
    pkgs.asciinema # Session recording
    # pkgs.charm-freeze # Nice images of code # NOTE: not yet available, see https://github.com/NixOS/nixpkgs/pull/299189   
    pkgs.flyctl # Used for Wiki

    # Languages
    pkgs.python3
    pkgs.nodejs_20
    pkgs.yarn
    pkgs.tanka
    # pkgs.go
    # pkgs.cargo
    # pkgs.rustc
    # pkgs.rustfmt
    # pkgs.cargo-binutils
    pkgs.tinygo # Go for embed and wasm

    # Language servers
    pkgs.nil
    pkgs.yaml-language-server

    # Fonts
    pkgs.jetbrains-mono

    # Apps
    pkgs.spotify
    pkgs._1password
    pkgs.iina # Media player for MacOS
    pkgs.slack

    # pkgs._1password-gui # TODO: for some reason doesn't work, old version?
    # pkgs.etcher # Flash OS images to SD cards # TODO: not available on MacOS
    # pkgs.anki # TODO: currently broken
    # pkgs.trashy # For when I make a mistake # TODO: doesn't work on m1

    # Embed dev
    pkgs.minicom # Modem control and terminal emulation program
    pkgs.openocd # Playing with hubris
    pkgs.ninja # Small build system with a focus on speed
    pkgs.gperf
    # pkgs.cmake
    # pkgs.ccache
    pkgs.dtc # Device Tree Compiler

    # Docker
    pkgs.lima-bin # Linux virtual machines
    pkgs.colima # Container runtime on MacOS
    pkgs.docker-buildx
    pkgs.docker-compose
    pkgs.dive
    # pkgs.docker
    # pkgs.docker-compose
    # pkgs.docker-machine-kvm2
    # pkgs.docker-machine

    # Work
    pkgs.argocd
    pkgs.aws-iam-authenticator
    pkgs.conftest
    pkgs.kubernetes-helm
    pkgs.aws-vault # A vault for securely storing and accessing AWS credentials in development environments
    pkgs.kind
    pkgs.kubectl
    pkgs.kubectl-gadget # A collection of gadgets for troubleshooting Kubernetes application using eBPF
    pkgs.kubectl-images # Show container images used in the cluster
    pkgs.kubectl-view-secret # Kubernetes CLI plugin to decode Kubernetes secrets
    pkgs.kubectx
    pkgs.kubie
    pkgs.kustomize
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # ".kube/classic.yaml".source = kube/classic.yaml;
    # ".kube/fleet.yaml".source = kube/fleet.yaml;
    # ".aws/config".source = aws/config.ini;
  };
}
