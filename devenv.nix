{ pkgs, ... }:


let
  erlang = pkgs.beam.packages.erlangR25;
in
{
  env.LANG="en_US.UTF-8";
  env.ERL_AFLAGS="-kernel shell_history enabled";

  enterShell = ''
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$MIX_HOME/bin:$PATH
    export PATH=$HEX_HOME/bin:$PATH
    export PATH=$PATH:$(pwd)/_build/pip_packages/bin
  '';

  packages = with pkgs; [
    elixir_ls
  ] ++ lib.optionals pkgs.stdenv.isLinux (with pkgs; [ inotify-tools ]);

  languages.elixir = {
    enable = true;
    package = erlang.elixir_1_14;
  };

  languages.javascript.enable = true;

  services.postgres = {
    enable = true;
    initialDatabases = [
      { name = "kotkowo_dev"; }
    ];
    initialScript = ''
      CREATE ROLE postgres WITH LOGIN SUPERUSER PASSWORD 'postgres';
    '';
  };
}
