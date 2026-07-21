# typed: strict
# frozen_string_literal: true

# Installs the vbear coding-agent configuration CLI.
class Vbear < Formula
  desc "Versioned control plane and local client for coding-agent harnesses"
  homepage "https://github.com/griffinclark/homebrew-tap"
  url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-source-0.1.4/vbear_0.1.4_source.tar.gz"
  sha256 "8fb856f85dfe046b722f362cd516afe3bc9381884a56339eecfd42f3d1072986"
  license "MIT"

  bottle do
    root_url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-0.1.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "94f16b5d9e264ae65b0d12c9d8c6c68402a31b53ae7dd992c8032442a907bd6f"
    sha256 cellar: :any,                 x86_64_linux: "d50964ff19ce52fb500d943e9c4f3666065f9c36857cd3ffadf4843dd955d9af"
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
