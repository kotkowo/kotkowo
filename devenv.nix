{ pkgs, lib, config, inputs, ... }:
{
  packages = with pkgs; [
    erlang_26
    nodejs_20
    elixir_1_16
    elixir_ls
    docker
    openssl
    graphql-client
    nodePackages."@tailwindcss/language-server"
    nodePackages.vscode-html-languageserver-bin
  ] ++ lib.optionals pkgs.stdenv.isLinux (with pkgs; [inotify-tools]);

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


  languages.elixir = {
    enable = true;
  };

  languages.rust = {
    enable = true;
    toolchain.rust-analyzer = pkgs.rust-analyzer;
    channel = "nightly";
  };
}
