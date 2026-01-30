class StampEnv < Formula
  desc "A CLI tool for deploying preset-based folder/file structures via symlinks"
  homepage "https://github.com/studio0188/stamp-env"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/studio0188/stamp-env/releases/download/v0.3.0/stamp-env-aarch64-apple-darwin.tar.xz"
      sha256 "12da0692884400e16d57e20562f34a23d7c20cf3746a0c584d5f461f41ade556"
    end
    if Hardware::CPU.intel?
      url "https://github.com/studio0188/stamp-env/releases/download/v0.3.0/stamp-env-x86_64-apple-darwin.tar.xz"
      sha256 "21f0b7e7593511049a3f88a962bf56c3a0c994a0a2ca1d8458e80b7191733314"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/studio0188/stamp-env/releases/download/v0.3.0/stamp-env-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8aca7ad34d084b78400925965e031c05507c6121de5c18bc20ab2bd75dea0482"
    end
    if Hardware::CPU.intel?
      url "https://github.com/studio0188/stamp-env/releases/download/v0.3.0/stamp-env-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "01c0ac755ee1aeed54d545de0c6788d5c3fdd50e4b213a6f16eb61bfadfc0a05"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "stampenv" if OS.linux? && Hardware::CPU.arm?
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
