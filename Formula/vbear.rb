# typed: strict
# frozen_string_literal: true

# Installs the vbear coding-agent configuration CLI.
class Vbear < Formula
  desc "Versioned control plane and local client for coding-agent harnesses"
  homepage "https://github.com/griffinclark/homebrew-tap"
  url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-source-0.1.11/vbear_0.1.11_source.tar.gz"
  sha256 "bad749e8138f96028bb7f20f5040b28953a3126e1517a4e6e74d26de9e5aca90"
  license "MIT"

  bottle do
    root_url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-0.1.11"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "0444ed77d3ae993ec7809fa1b112957ef9b62dc2b90b9db740f669e204dccee0"
    sha256 cellar: :any_skip_relocation, sequoia:      "4b1363c563dce83a64032b1fa8ebc6a557ec761d59a68497c388d89999cc0102"
    sha256 cellar: :any,                 x86_64_linux: "78374f69e0f42b48b9d96103b6279b027e9c8e3198e77c8ff4faee012c116084"
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
