[
  import_deps: [:phoenix],
  subdirectories: ["priv/*/migrations"],
  plugins: [Styler, Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"]
]
