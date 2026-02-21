# frozen_string_literal: true

# Automatically sets media_subpath for each post based on its file location.
#
# _posts/graphics/sfml/breakout_game/2026-02-21-breakout-game.md
# → media_subpath: "/posts/graphics/sfml/breakout_game"
#
# If media_subpath is already explicitly set in front matter, it is NOT overridden.

Jekyll::Hooks.register :posts, :pre_render do |post|
  next if post.data["media_subpath"]

  # Windows/Unix 경로 모두 정규화 (\ → /)
  posts_src = File.join(post.site.source, "_posts").gsub("\\", "/").chomp("/") + "/"
  post_dir  = File.dirname(post.path).gsub("\\", "/")
  relative  = post_dir.sub(posts_src, "")

  # _posts/ 바로 아래 포스트면 subpath 불필요
  next if relative.empty? || relative == "."

  post.data["media_subpath"] = "/posts/#{relative}"
end
