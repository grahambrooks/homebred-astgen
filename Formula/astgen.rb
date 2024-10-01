class Astgen < Formula
  desc "The astgen application"
  homepage "https://github.com/grahambrooks/astgen"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/grahambrooks/astgen/releases/download/0.7.1/astgen-aarch64-apple-darwin.tar.xz"
      sha256 "0bb684fa19b40b6504ec04d65f4fb76483ded63dbeab75a380721248948f82a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/grahambrooks/astgen/releases/download/0.7.1/astgen-x86_64-apple-darwin.tar.xz"
      sha256 "ef68340fdf923bbad322eb041b949e8bd572733a75f93a27f89a9cd81c7c9d29"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/grahambrooks/astgen/releases/download/0.7.1/astgen-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "493ac80a7ea6a416aaf1b822bef31c4d9f9736dc0e23921158ea3855e0f68b0e"
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
