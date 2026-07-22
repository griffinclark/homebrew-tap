# typed: strict
# frozen_string_literal: true

# Installs the vbear coding-agent configuration CLI.
class Vbear < Formula
  desc "Versioned control plane and local client for coding-agent harnesses"
  homepage "https://github.com/griffinclark/homebrew-tap"
  url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-source-0.1.8/vbear_0.1.8_source.tar.gz"
  sha256 "f0a5a7e416a14d8a8a1b3a04f9651c5764ad8ea61690999184f943f655566881"
  license "MIT"

  bottle do
    root_url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-0.1.8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "c85f171df38465ea6b0de31174d774e313abbc8a26846d7f25a7d0e48a6701b5"
    sha256 cellar: :any_skip_relocation, sequoia:      "14354a61b0bff3e77aedd0de199f09c1f4553e31c3f53dbe2cf05fe929f08b61"
    sha256 cellar: :any,                 x86_64_linux: "39e6da5078dc9eeb21acdda929c155ac98da596488ab6bc55faa5bc159900a30"
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
