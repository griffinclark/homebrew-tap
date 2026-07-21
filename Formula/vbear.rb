# typed: strict
# frozen_string_literal: true

# Installs the vbear coding-agent configuration CLI.
class Vbear < Formula
  desc "Versioned control plane and local client for coding-agent harnesses"
  homepage "https://github.com/griffinclark/homebrew-tap"
  url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-source-0.1.2/vbear_0.1.2_source.tar.gz"
  sha256 "fef766a5e74b673be467638f17b596c6ec02a8edaa414f22bdd229709e444a95"
  license "MIT"

  bottle do
    root_url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-0.1.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "39abada339f57185b8ab6f96b1d6de70a201d6ecac2e17d81f8c19776ae84b0e"
    sha256 cellar: :any,                 x86_64_linux: "fa2a5e79fcb7fc3250d560437c1926e79ebae365fa71b769fd47e3d091eacb44"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libsecret"
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/vbear"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vbear version")

    (testpath/"AGENTS.md").write "# Homebrew package test\n"
    output = shell_output("#{bin}/vbear --json scan")
    assert_match '"mutated":false', output
    assert_match '"source_uri":"source://workspace/AGENTS.md"', output
  end
end
