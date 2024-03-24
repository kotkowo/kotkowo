{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs = {nixpkgs.follows = "nixpkgs";};

    next-ls.url = "github:elixir-tools/next-ls";
  };

  nixConfig = {
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "elixir-tools.cachix.org-1:GfK9E139Ysi+YWeS1oNN9OaTfQjqpLwlBaz+/73tBjU="
    ];
    extra-substituters = [
      "https://devenv.cachix.org"
      "https://elixir-tools.cachix.org"
    ];
  };

  outputs = {
    self,
    nixpkgs,
    devenv,
    next-ls,
    ...
  } @ inputs: let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    erlang = pkgs.beam.packages.erlangR26;
    elixir = erlang.elixir_1_16;
    node = pkgs.nodejs_20;
    elixir-ls = (erlang.elixir-ls.override {elixir = elixir;}).overrideAttrs (prev: {
      version = "master";
      src = pkgs.fetchFromGitHub {
        owner = "elixir-lsp";
        repo = "elixir-ls";
        rev = "06178f5cc5babad9522ba1dc67046ffc48a0d6ed";
        hash = "sha256-8tFQ68gxlHjzCfgdB5QFaxMoelN5Ht4XmqtuM8Fwg2E=";
        fetchSubmodules = true;
      };
      buildPhase = ''
        runHook preBuild
        mix do compile --no-deps-check, elixir_ls.release2
        runHook postBuild
      '';
    });
  in {
    devShell.x86_64-linux = devenv.lib.mkShell {
      inherit inputs pkgs;
      modules = [
        ({
          pkgs,
          config,
          ...
        }: {
          env.LANG = "en_US.UTF-8";
          env.ERL_AFLAGS = "-kernel shell_history enabled";

          enterShell = ''
            export MIX_HOME=$PWD/.nix-mix
            export HEX_HOME=$PWD/.nix-hex
            export PATH=$MIX_HOME/bin:$PATH
            export PATH=$HEX_HOME/bin:$PATH
            export PATH=$PATH:$(pwd)/_build/pip_packages/bin

            export $(${pkgs.gnugrep}/bin/grep -v '^#' .env | ${pkgs.findutils}/bin/xargs -0)
          '';

          scripts.refresh_schema.exec = "graphql-client introspect-schema http://localhost:1337/graphql --output $DEVENV_ROOT/native/strapiclient/src/query/schema.json";

          packages = with pkgs;
            [
              docker
              node
              nodePackages."@tailwindcss/language-server"
              nodePackages.vscode-html-languageserver-bin
              elixir-ls
              # next-ls.packages.x86_64-linux.default
              openssl
              graphql-client
            ]
            ++ lib.optionals pkgs.stdenv.isLinux (with pkgs; [inotify-tools]);

          languages.elixir = {
            enable = true;
            package = elixir;
          };

          languages.rust = {
            enable = true;
            toolchain.rust-analyzer = pkgs.rust-analyzer;
            channel = "nightly";
          };
        })
      ];
    };
  };
}
