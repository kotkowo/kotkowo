{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    devenv.url = "github:cachix/devenv";
    fenix.url = "github:nix-community/fenix";
    fenix.inputs = {nixpkgs.follows = "nixpkgs";};
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = {
    self,
    nixpkgs,
    devenv,
    ...
  } @ inputs: let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    erlang = pkgs.beam.packages.erlangR26;
    elixir = erlang.elixir_1_15;
    node = pkgs.nodejs_20;
    elixir-ls = erlang.elixir-ls.override {elixir = elixir;};
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
              elixir_ls
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
