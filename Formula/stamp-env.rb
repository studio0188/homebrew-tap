class StampEnv < Formula
  desc "A CLI tool for deploying preset-based folder/file structures via symlinks"
  homepage "https://github.com/studio0188/stamp-env"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/studio0188/stamp-env/releases/download/v0.1.1/stamp-env-aarch64-apple-darwin.tar.xz"
      sha256 "d1e4ee10abc26c92aa7643f2e38abf2f1d01ffc1cccec707d404d48ffd634b40"
    end
    if Hardware::CPU.intel?
      url "https://github.com/studio0188/stamp-env/releases/download/v0.1.1/stamp-env-x86_64-apple-darwin.tar.xz"
      sha256 "10c38672a2c51c57441af5655c64877d6ef1f1bbb7099251a95b99d1762f62f3"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/studio0188/stamp-env/releases/download/v0.1.1/stamp-env-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "847121946bb6fe2a2317b42f4f09acea9999a8abfd4fc3c0beb9a82a360bbe9a"
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
