class Astgen < Formula
  desc "The astgen application"
  homepage "https://github.com/grahambrooks/astgen"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/grahambrooks/astgen/releases/download/0.8.0/astgen-aarch64-apple-darwin.tar.xz"
      sha256 "733e056b6c69ff2e1113b45297c0b2a1f4b8a77eeefd170a5ddc34cb0a06c7cf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/grahambrooks/astgen/releases/download/0.8.0/astgen-x86_64-apple-darwin.tar.xz"
      sha256 "937edf3ff1ac168509a39a640694e52125e2916b27478dbbe758f42998494c7b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/grahambrooks/astgen/releases/download/0.8.0/astgen-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0ff2487e5c289eb86165f5d4237852123f1ce153c8b5c2e5265848b7d7271deb"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
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
    bin.install "astgen" if OS.mac? && Hardware::CPU.arm?
    bin.install "astgen" if OS.mac? && Hardware::CPU.intel?
    bin.install "astgen" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
