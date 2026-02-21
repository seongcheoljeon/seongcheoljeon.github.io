# frozen_string_literal: true

# Jekyll plugin: copy non-markdown assets (images, etc.) from _posts/ into _site/posts/
# - Only copies files that are new or modified (mtime comparison)
# - Removes files from _site/posts/ that no longer exist in _posts/
#
# front matter example:
#   media_subpath: "/posts/graphics/sfml/breakout_game"

require "fileutils"

Jekyll::Hooks.register :site, :post_write do |site|
  COPY_EXTENSIONS = %w[.png .jpg .jpeg .gif .webp .svg .avif .bmp .tiff .tif .ico .mp4 .webm .mov .pdf].freeze unless defined?(COPY_EXTENSIONS)
  posts_src = File.join(site.source, "_posts")
  posts_dst = File.join(site.dest,   "posts")

  # ── 1. _posts/ → _site/posts/ : 신규/변경 파일만 복사 ──────────────────
  Dir.glob(File.join(posts_src, "**", "*")).each do |src|
    next if File.directory?(src)
    next unless COPY_EXTENSIONS.include?(File.extname(src).downcase)

    relative = src.sub(posts_src + File::SEPARATOR, "")
    dst = File.join(posts_dst, relative)

    # 목적지 파일이 없거나 소스가 더 새것일 때만 복사
    if !File.exist?(dst) || File.mtime(src) > File.mtime(dst)
      FileUtils.mkdir_p(File.dirname(dst))
      FileUtils.cp(src, dst)
    end
  end

  # ── 2. _site/posts/ 에 있지만 _posts/ 에 없는 미디어 파일 삭제 (찌꺼기 정리) ──
  # 주의: Jekyll 이 생성한 HTML 등은 건드리지 않고 미디어 파일만 정리한다.
  return unless File.directory?(posts_dst)

  Dir.glob(File.join(posts_dst, "**", "*")).each do |dst|
    next if File.directory?(dst)
    next unless COPY_EXTENSIONS.include?(File.extname(dst).downcase)  # 미디어만

    relative = dst.sub(posts_dst + File::SEPARATOR, "")
    src = File.join(posts_src, relative)

    unless File.exist?(src)
      File.delete(dst)
      # 빈 디렉토리 정리
      dir = File.dirname(dst)
      while dir != posts_dst && Dir.empty?(dir)
        Dir.rmdir(dir)
        dir = File.dirname(dir)
      end
    end
  end
end
