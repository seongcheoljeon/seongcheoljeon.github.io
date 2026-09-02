# frozen_string_literal: true

# Jekyll plugin: copy non-markdown assets (images, etc.) from _posts/ into _site/posts/
# - Only copies files that are new or modified (mtime comparison)
# - Removes files from _site/posts/ that no longer exist in _posts/
#
# front matter example:
#   media_subpath: "/posts/graphics/sfml/breakout_game"
#
# NOTE: COPY_EXTENSIONS 는 _config.yml 의 exclude 목록(_posts/**/*.png ...)과
#       짝을 이룬다. 한쪽에만 확장자를 추가하면 파일이 조용히 사라지므로,
#       목록에 없는 확장자는 아래에서 경고를 남긴다.

require "fileutils"

module CopyPostAssets
  COPY_EXTENSIONS = %w[.png .jpg .jpeg .gif .webp .svg .avif .bmp .tiff .tif .ico .mp4 .webm .mov .pdf].freeze
  MARKDOWN_EXTENSIONS = %w[.md .markdown].freeze
end

Jekyll::Hooks.register :site, :post_write do |site|
  posts_src = File.join(site.source, "_posts")
  posts_dst = File.join(site.dest,   "posts")

  # ── 1. _posts/ → _site/posts/ : 신규/변경 파일만 복사 ──────────────────
  Dir.glob(File.join(posts_src, "**", "*")).each do |src|
    next if File.directory?(src)

    ext = File.extname(src).downcase
    unless CopyPostAssets::COPY_EXTENSIONS.include?(ext)
      # 마크다운은 Jekyll 이 처리하므로 정상. 그 외 확장자는 무음 소실 방지용 경고.
      unless CopyPostAssets::MARKDOWN_EXTENSIONS.include?(ext)
        Jekyll.logger.warn "copy_post_assets:",
                           "skipped #{src.sub(site.source + File::SEPARATOR, '')} " \
                           "(extension #{ext.inspect} not in COPY_EXTENSIONS)"
      end
      next
    end

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
  # (훅 블록은 Proc 이므로 return 은 LocalJumpError — next 를 써야 한다)
  next unless File.directory?(posts_dst)

  Dir.glob(File.join(posts_dst, "**", "*")).each do |dst|
    next if File.directory?(dst)
    next unless CopyPostAssets::COPY_EXTENSIONS.include?(File.extname(dst).downcase)  # 미디어만

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
