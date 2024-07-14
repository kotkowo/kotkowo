{
  description = "Kotkowo";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.fenix.url = "github:nix-community/fenix/monthly";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    fenix,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      erlangPackages = pkgs.beamPackages;
      node2nix = pkgs.nodePackages.node2nix;
      elixir = erlangPackages.elixir;
      erlang = erlangPackages.erlang;
      nodejs = pkgs.nodejs_20;
      elixir-ls = erlangPackages.elixir_ls;
    in {
      packages = let
        version = "0.3.4";
        src = ./.;
        fetchNpmDeps = {
          pname,
          version,
          src,
          hash,
          postBuild ? "",
        }: let
          inherit (pkgs) stdenv buildPackages fetchNpmDeps;
          npmHooks = buildPackages.npmHooks.override {inherit nodejs;};
        in
          stdenv.mkDerivation {
            name = "${pname}-${version}";
            inherit src;
            npmDeps = fetchNpmDeps {
              name = "${pname}-cache-${version}";
              inherit src hash;
            };
            nativeBuildInputs = [nodejs npmHooks.npmConfigHook];
            postBuild = postBuild;
            installPhase = ''
              mkdir -p "$out"
              cp -r package.json package-lock.json node_modules "$out"
            '';
          };
      in
        flake-utils.lib.flattenTree rec {
          kotkowo-elixir-deps = erlangPackages.fetchMixDeps {
            inherit version src;
            pname = "kotkowo-elixir-deps";
            sha256 = "sha256-Cuw0nrenawsiU+Cqxd5a56+eq2N4LtCHF8KlSgcKe2Q=";
          };
          kotkowo-fe-deps = let
            mixDeps = self.packages.${system}.kotkowo-elixir-deps;
          in
            fetchNpmDeps {
              pname = "kotkowo-fe-deps";
              inherit version;
              src = "${src}/assets";
              hash = "sha256-YF5loRscJRiSsxwSNG2mnePvWDrpOJTo9ONDqexOFmU=";
              postBuild = ''
                # fix broken local packages
                local_packages=(
                  "phoenix"
                  "phoenix_html"
                  "phoenix_live_view"
                )
                for package in ''${local_packages[@]}; do
                  path=node_modules/$package
                  if [[ -L $path ]]; then
                    echo "fixing local package - $package"
                    rm node_modules/$package
                    cp -r ${mixDeps}/$package node_modules/
                  fi
                done
              '';
            };

          kotkowo-client = let
            toolchain = fenix.packages.${system}.minimal.toolchain;
          in
            (pkgs.makeRustPlatform {
              cargo = toolchain;
              rustc = toolchain;
            })
            .buildRustPackage {
              pname = "kotkowo-client";
              version = "0.1.0";
              src = ./native/client;
              # nativeBuildInputs = [pkgs.openssl.dev pkgs.pkg-config];
              buildInputs = [pkgs.openssl.dev pkgs.pkg-config];
              nativeBuildInputs = [pkgs.pkg-config];
              #buildPhase = ''
              #  export PKG_CONFIG_PATH=${pkgs.openssl.dev}/lib/pkgconfig
              #  export OPENSSL_LIB_DIR=${pkgs.openssl.dev}/lib
              #  # export OPENSSL_INCLUDE_DIR=${pkgs.openssl.dev}/include
              #  export OPENSSL_STATIC=yes

              #  export HOME=$(pwd)
              #'';
              #installPhase = ''
              #  ls target/release
              #  exit 1
              #'';
              cargoLock = {
                lockFile = ./native/client/Cargo.lock;
                outputHashes = {
                  "kotkowo-client-0.2.3" = "sha256-eT/Jj3AXj2jZRcdIwJ6kRU5L4W6DfRUkLEuCxZtjqGk=";
                };
              };
            };

          kotkowo-fe = let
            deps = self.packages.${system}.kotkowo-fe-deps;
            mixDeps = self.packages.${system}.kotkowo-elixir-deps;
          in
            pkgs.stdenvNoCC.mkDerivation {
              pname = "kotkowo-fe";
              nativeBuildInputs = [nodejs];
              inherit version src;
              configurePhase = ''
                export NODE_ENV=production
                export TAILWIND_DISABLE_TOUCH=true
              '';

              buildPhase = ''
                cp -r . $TEMPDIR/kotkowo_web
                ln -s ${deps}/node_modules $TEMPDIR/kotkowo_web/assets
              '';

              installPhase = ''
                cp --no-preserve=mode,ownership,timestamps -r $TEMPDIR/kotkowo_web/priv/static $out/
              '';
              sha256 = "sha256-r/3h0xLXW4B4nVDnt04L/ERy7lNAatoKlSxKxDHrl78=";
            };
          kotkowo = let
            kotkowo-fe = self.packages.${system}.kotkowo-fe;
            mixFodDeps = self.packages.${system}.kotkowo-elixir-deps;
            throwSystem =
              throw "tailwindcss has not been packaged for ${system} yet.";
            tailwindPlatform =
              {
                aarch64-darwin = "macos-arm64";
                aarch64-linux = "linux-arm64";
                armv7l-linux = "linux-armv7";
                x86_64-darwin = "macos-x64";
                x86_64-linux = "linux-x64";
              }
              .${system}
              or throwSystem;

            tailwindHash =
              {
                aarch64-darwin = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
                aarch64-linux = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
                armv7l-linux = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
                x86_64-darwin = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
                x86_64-linux = "sha256-+3egrFc2pVWc9j37wJTWrXhXMYgVrlLZpujoYCpN8zc=";
              }
              .${system}
              or throwSystem;
            tailwindcss = pkgs.tailwindcss.overrideAttrs (prev: rec {
              version = "3.1.8";
              src = pkgs.fetchurl {
                url = "https://github.com/tailwindlabs/tailwindcss/releases/download/v${version}/tailwindcss-${tailwindPlatform}";
                hash = tailwindHash;
              };
            });

            deps = self.packages.${system}.kotkowo-fe-deps;
          in
            erlangPackages.mixRelease {
              inherit version src mixFodDeps;
              pname = "kotkowo";
              nativeBuildInputs = [fenix.packages.${system}.default.toolchain];
              buildInputs = [pkgs.openssl.dev];
              preInstall = ''
                ln -s ${deps}/node_modules assets/node_modules

                cp --no-preserve=mode,ownership,timestamps -R ${kotkowo-client}/lib ./priv/native
                cp --no-preserve=mode,ownership,timestamps -R ${kotkowo-fe} ./priv/static/
                cd assets
                ${tailwindcss}/bin/tailwindcss --minify --config=tailwind.config.cjs --input=css/app.css --output=../priv/static/assets/app.css
                cd ..
                ${elixir}/bin/mix phx.digest
              '';

              buildPhase = ''
                # this line removes a bug where value of $HOME is set to a non-writable /homeless-shelter dir
                export HOME=$(pwd)
              '';
            };
          default = kotkowo;
        };
    })
    // {
      nixosModules.kotkowo = {
        config,
        lib,
        pkgs,
        ...
      }: let
        cfg = config.services.kotkowo-web;
        system = config.nixpkgs.system;
        kotkowo = self.packages.${system}.default;
      in {
        options = {
          services.kotkowo-web = {
            enable = lib.mkEnableOption "kotkowo-web";
            port = lib.mkOption {
              type = lib.types.int;
              default = 4000;
              description = "Port to listen on, 4000 by default";
            };
            poolSize = lib.mkOption {
              type = lib.types.int;
              default = 10;
              description = "Connection pool size, 10 by default";
            };
            secretKeyBaseFile = lib.mkOption {
              type = lib.types.path;
              description = "A file contianing the Phoenix Secret Key Base. This should be secret, and not kept in the nix store";
            };
            dataDir = lib.mkOption {
              type = lib.types.path;
              default = "/var/lib/kotkowo-web";
              description = "The directory to write data to";
            };
            databaseUrlFile = lib.mkOption {
              type = lib.types.path;
              description = "A file containing the URL to use to connect to the database";
            };
            user = lib.mkOption {
              type = lib.types.str;
              default = "kotkowo-web";
              description = "The user to run as";
            };
            group = lib.mkOption {
              type = lib.types.str;
              default = "kotkowo-web";
              description = "The group the user is in";
            };
            host = lib.mkOption {
              type = lib.types.str;
              description = "The host to configure the router generation from";
            };
            #gem = {
            #  md2gemini = {
            #    pkg = lib.mkOption {
            #      type = lib.types.str;
            #      default = "${pkgs.md2gemini}/bin/md2gemini";
            #    };
            #    args = lib.mkOption {
            #      type = lib.types.listOf lib.types.str;
            #      default = ["--links" "copy" "--plain"];
            #    };
            #  };
            #  cert = lib.mkOption {type = lib.types.path;};
            #  key = lib.mkOption {type = lib.types.path;};
            #};
          };
        };
        config = lib.mkIf cfg.enable {
          assertions = lib.mkIf cfg.enable [
            {
              assertion = cfg.secretKeyBaseFile != "";
              message = "A base key file is necessary";
            }
          ];

          environment.systemPackages = lib.optional cfg.enable kotkowo;

          users.users = lib.optionalAttrs (cfg.user == "kotkowo-web") {
            kotkowo-web = {
              isSystemUser = true;
              group = cfg.group;
              home = cfg.dataDir;
              createHome = true;
            };
          };

          users.groups = lib.optionalAttrs (cfg.group == "kotkowo-web") {
            kotkowo-web = {};
          };

          systemd.services = {
            kotkowo-web-setup = lib.mkIf cfg.enable {
              description = "Create and Migrate Kotkowo Web Database";
              wantedBy = ["multi-user.target"];
              script = ''
                if [ ! -f "$RELEASE_COOKIE" ]
                then
                   echo "Creating cookie file"
                   dd if=/dev/urandom bs=1 count=16 | ${pkgs.hexdump}/bin/hexdump -e '16/1 "%02x"' > "$RELEASE_COOKIE"
                fi
                ${kotkowo}/bin/kotkowo eval "Kotkowo.Release.migrate"
              '';
              serviceConfig = {
                Type = "oneshot";
                User = cfg.user;
                Group = cfg.group;
              };
              environment = {
                RELEASE_TMP = cfg.dataDir;
                TZ_DATA_DIR = cfg.dataDir;
                SECRET_KEY_BASE_FILE = cfg.secretKeyBaseFile;
                DATABASE_URL_FILE = cfg.databaseUrlFile;
                HOSTNAME = cfg.host;
                #HOME_GEMINI_CERT = cfg.gem.cert;
                #HOME_GEMINI_KEY = cfg.gem.key;
                #HOME_GEMINI_CONVERTER = cfg.gem.md2gemini.pkg;
                #HOME_GEMINI_CONVERTER_ARGS =
                #  pkgs.lib.concatStringsSep " " cfg.gem.md2gemini.args;
                RELEASE_COOKIE = "${cfg.dataDir}/.cookie";
              };
            };

            kotkowo-web = lib.mkIf cfg.enable {
              description = "kotkowo web";
              wantedBy = ["multi-user.target"];
              after = ["network.target" "kotkowo-web-setup.service"];
              wants = ["kotkowo-web-setup.service"];
              script = ''
                ${kotkowo}/bin/kotkowo start
              '';
              serviceConfig = {
                User = cfg.user;
                Group = cfg.group;
              };
              environment = {
                RELEASE_TMP = cfg.dataDir;
                TZ_DATA_DIR = cfg.dataDir;
                POOL_SIZE = builtins.toString cfg.poolSize;
                SECRET_KEY_BASE_FILE = cfg.secretKeyBaseFile;
                PORT = builtins.toString cfg.port;
                DATABASE_URL_FILE = cfg.databaseUrlFile;
                HOSTNAME = cfg.host;
                #HOME_GEMINI_CERT = cfg.gem.cert;
                #HOME_GEMINI_KEY = cfg.gem.key;
                #HOME_GEMINI_CONVERTER = cfg.gem.md2gemini.pkg;
                #HOME_GEMINI_CONVERTER_ARGS =
                #  pkgs.lib.concatStringsSep " " cfg.gem.md2gemini.args;
                RELEASE_COOKIE = "${cfg.dataDir}/.cookie";
              };
            };
          };
        };
      };
      nixosModule = self.nixosModules.kotkowo;
    };
}
