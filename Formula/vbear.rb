# typed: strict
# frozen_string_literal: true

# Installs the vbear coding-agent configuration CLI.
class Vbear < Formula
  desc "Versioned control plane and local client for coding-agent harnesses"
  homepage "https://github.com/griffinclark/homebrew-tap"
  url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-source-0.1.12/vbear_0.1.12_source.tar.gz"
  sha256 "77b5b4d36dfb74016e2bbc75f77fc7e4734e1694969989884d601ba0b500532c"
  license "MIT"

  bottle do
    root_url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-0.1.12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "d3152f59e61acb9efa3c742a1356de574721bf736d619ab4ed2f403db86455bc"
    sha256 cellar: :any_skip_relocation, sequoia:      "69d37666811d047bdc80ed61ef0d4e330dd815cbc719efc1e5ac98ddac64c732"
    sha256 cellar: :any,                 x86_64_linux: "1f246b608dfe931089aa9faa0863b8991510003185d5bf8877def67c009b17d1"
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
