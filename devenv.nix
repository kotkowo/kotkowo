{pkgs, ...}: let
  erlang = pkgs.beam.packages.erlangR26;
  elixir = erlang.elixir_1_15;
  node = pkgs.nodejs_20;
  elixir-ls = erlang.elixir-ls.override {elixir = elixir;};
in {
  env.LANG = "en_US.UTF-8";
  env.ERL_AFLAGS = "-kernel shell_history enabled";
  dotenv.enable = true;

  enterShell = ''
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$MIX_HOME/bin:$PATH
    export PATH=$HEX_HOME/bin:$PATH
    export PATH=$PATH:$(pwd)/_build/pip_packages/bin
  '';

  scripts.refresh_schema.exec = "graphql-client introspect-schema http://localhost:1337/graphql --output $DEVENV_ROOT/native/strapiclient/src/query/schema.json";

  packages = with pkgs;
    [
      docker
      node
      elixir_ls
      openssl
      graphql-client
    ]
    ++ lib.optionals pkgs.stdenv.isLinux (with pkgs; [inotify-tools]);

  languages.elixir = {
    enable = true;
    package = elixir;
  };

  languages.javascript.enable = true;
  languages.rust = {
    enable = true;
    channel = "nightly";
  };
}
