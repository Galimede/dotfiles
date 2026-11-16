{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    private-fonts = {
      url = "git+ssh://git@github.com/Galimede/private-fonts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Not following our nixpkgs here: hunk's transitive bun2nix input uses
    # flake-parts across all systems (incl. x86_64-darwin), which our pinned
    # nixpkgs-unstable revision has dropped support for. Its own locked
    # nixpkgs avoids that break.
    hunk.url = "github:modem-dev/hunk";
  };

  outputs = { nixpkgs, home-manager, nixgl, zen-browser, nur, private-fonts, hunk, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
        "onepassword-password-manager"
      ];
      overlays = [
        nur.overlays.default
        nixgl.overlays.default
        # nixGL still calls pcregrep in its checkPhase, but pcre was removed
        # from nixpkgs. Shim it with pcre2grep (same flags for this use).
        # Drop once nix-community/nixGL#227 is merged.
        (final: prev: {
          pcre = final.runCommand "pcregrep-shim" { } ''
            mkdir -p $out/bin
            ln -s ${final.pcre2.bin}/bin/pcre2grep $out/bin/pcregrep
          '';
        })
        (final: prev: let
          # Create a symlink of electron named "obsidian" so the CLI
          # process name check (electron !== obsidian) passes.
          electronAsObsidian = prev.runCommand "electron-as-obsidian" {} ''
            mkdir -p $out/bin
            ln -s ${prev.electron}/bin/electron $out/bin/obsidian
          '';
        in {
          obsidian = prev.obsidian.overrideAttrs (old: {
            installPhase = builtins.replaceStrings
              [ "${prev.electron}/bin/electron" ]
              [ "${electronAsObsidian}/bin/obsidian" ]
              old.installPhase;
          });
        })
      ];
    };
  in {
    homeConfigurations."mdegand" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit zen-browser private-fonts hunk; };
      modules = [ ./home.nix ];
    };

  };
}        
