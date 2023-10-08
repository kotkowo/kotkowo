[
  "lib/kotkowo_web/endpoint.ex",
  "lib/kotkowo/mailer.ex",
  "lib/kotkowo/repo.ex",
  # lib/kotkowo/gallery_image.ex: Illegal map type t() on line 0
  # seems to be an issue with Elixir's URI module:
  # ** (RuntimeError) Unrecognized ignore line: 
  # {"lib/kotkowo/gallery_image.ex", {:illegal_map_type, {:user_type, [file: ~c"Elixir.URI.erl", location: 0], :t, []}}}
  {"lib/kotkowo/gallery_image.ex", :illegal_map_type}
]
