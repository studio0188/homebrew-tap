class StampEnv < Formula
  desc "프리셋 기반 폴더/파일 구조를 심링크로 배포하는 CLI 도구"
  homepage "https://github.com/studio0188/stamp-env"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/studio0188/stamp-env/releases/download/v0.1.0/stamp-env-aarch64-apple-darwin.tar.xz"
      sha256 "390a0a05f78710f35c49c20439d441e1efa6e4c9eb1c6ecaf896debb7a334479"
    end
    if Hardware::CPU.intel?
      url "https://github.com/studio0188/stamp-env/releases/download/v0.1.0/stamp-env-x86_64-apple-darwin.tar.xz"
      sha256 "71ca5c2d1f971252971049a76f1f23fe19edd035c9a2e81de7e3c191fbd8660e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/studio0188/stamp-env/releases/download/v0.1.0/stamp-env-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "43ae1aadd4bb95b352943a39f0f54d25e6281d88b20bc542f8bb3adadaffa54f"
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
    bin.install "stamp" if OS.mac? && Hardware::CPU.arm?
    bin.install "stamp" if OS.mac? && Hardware::CPU.intel?
    bin.install "stamp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
