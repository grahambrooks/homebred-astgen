class Astgen < Formula
  desc "The astgen application"
  homepage "https://github.com/grahambrooks/astgen"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/grahambrooks/astgen/releases/download/0.7.0/astgen-aarch64-apple-darwin.tar.xz"
      sha256 "751787da331d6211a206b7888f591886aa45123c163fc667210db66c1ce90ee9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/grahambrooks/astgen/releases/download/0.7.0/astgen-x86_64-apple-darwin.tar.xz"
      sha256 "d1f0100c0591ddeeb70849d1705f0b69b8312b121d4eb5a4f011d9704ea164f0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/grahambrooks/astgen/releases/download/0.7.0/astgen-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "7e87eede4ca56cffdefaae0d6758329aaa85b33a99f2acd5aaf56ea2836feed0"
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
