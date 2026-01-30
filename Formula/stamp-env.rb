class StampEnv < Formula
  desc "A CLI tool for deploying preset-based folder/file structures via symlinks"
  homepage "https://github.com/studio0188/stamp-env"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/studio0188/stamp-env/releases/download/v0.2.0/stamp-env-aarch64-apple-darwin.tar.xz"
      sha256 "5c8a502224ce6446912f38485e46d2d6fa210f0e3d676f78ccef8eec41d02e82"
    end
    if Hardware::CPU.intel?
      url "https://github.com/studio0188/stamp-env/releases/download/v0.2.0/stamp-env-x86_64-apple-darwin.tar.xz"
      sha256 "3e8df4644371eb1a6ce820ca90cb72ab5754553d4ba94f01df3e8194849d10f4"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/studio0188/stamp-env/releases/download/v0.2.0/stamp-env-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "34be1b2d8cb451e5abce4559e324319109cea0c0afc163d679a424af7086613b"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "stampenv" if OS.mac? && Hardware::CPU.arm?
    bin.install "stampenv" if OS.mac? && Hardware::CPU.intel?
    bin.install "stampenv" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
