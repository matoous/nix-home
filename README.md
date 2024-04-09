# nix-configs

## Get started

Clone and:

```sh
ln -s ~/code/github.com/matoous/nix-home ~/.config/home-manager
```

Home manager can't set default user shell. After install one needs to manually add fish shell to `echo '/Users/matousdzivjak/.nix-profile/bin/fish' >> /etc/shells` and then update the current users default shell using `chsh -s /Users/matousdzivjak/.nix-profile/bin/fish`.

- [home-manager](https://github.com/nix-community/home-manager)
  - [Home manager options](https://mipmip.github.io/home-manager-option-search/)

### SSH

Add key to keychain on MacOS:

```sh
ssh-add --apple-use-keychain ~/.ssh/[your-private-key]
```

## Reading

- [Using Nix on macOS](https://checkoway.net/musings/nix/) by Stephen Checkoway
- [Some notes on using nix](https://jvns.ca/blog/2023/02/28/some-notes-on-using-nix/) by Julia Evans
- [Some notes on nix flakes](https://jvns.ca/blog/2023/11/11/notes-on-nix-flakes/) by Julia Evans
- [Some notes on NixOS](https://jvns.ca/blog/2024/01/01/some-notes-on-nixos/) by Julia Evans
- [Using Nix to install Go tools for VS Code](https://mgdm.net/weblog/vscode-nix-go-tools/) by Michael Maclean
- [Nix MacOS Setup](https://davi.sh/til/nix/nix-macos-setup/)
- [Setting up a development environment with Nix and Home Manager](https://www.rousette.org.uk/archives/setting-up-a-development-environment-with-nix-and-home-manager/)
- [Tutorial: Getting started with Home Manager for Nix](https://ghedam.at/24353/tutorial-getting-started-with-home-manager-for-nix)
- [Declarative macOS Configuration Using nix-darwin And home-manager](https://xyno.space/post/nix-darwin-introduction)

## Transforming your existing config files

- [yaml2nix](https://github.com/euank/yaml2nix)
