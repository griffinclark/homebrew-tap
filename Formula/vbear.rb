# typed: strict
# frozen_string_literal: true

# Installs the vbear coding-agent configuration CLI.
class Vbear < Formula
  desc "Versioned control plane and local client for coding-agent harnesses"
  homepage "https://github.com/griffinclark/homebrew-tap"
  url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-source-0.1.7/vbear_0.1.7_source.tar.gz"
  sha256 "dd8583019ffb2d76c720ebc6388a13703c0f9d857fb95a40dc53a29372bf0431"
  license "MIT"

  bottle do
    root_url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-0.1.7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "ff4d9aedb2e70dbab6f35d86f0debd4a1b6cc95364b4c7de1e1890fdc40bd3bf"
    sha256 cellar: :any_skip_relocation, sequoia:      "095ba859046dffcc3d53d7b3a00446a125c9d76ddfd731d01b6041c266bc6e18"
    sha256 cellar: :any,                 x86_64_linux: "f2815e123e6339599a955404160fafd1a8314d250218000e2b197a5bff70c00b"
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
