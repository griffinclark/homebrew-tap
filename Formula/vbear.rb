# typed: strict
# frozen_string_literal: true

# Installs the vbear coding-agent configuration CLI.
class Vbear < Formula
  desc "Versioned control plane and local client for coding-agent harnesses"
  homepage "https://github.com/griffinclark/homebrew-tap"
  url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-source-0.1.3/vbear_0.1.3_source.tar.gz"
  sha256 "eb41972afada668091a21da80447186e7f8a935ffc408eaf275fdee2c5ea3bc9"
  license "MIT"

  bottle do
    root_url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-0.1.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "d8a12d5b127bcae53ebe5fc165aec17a6441ff3bee4e0bff9c0f7e7c798706c4"
    sha256 cellar: :any,                 x86_64_linux: "871ada3734f9b40a70243842309483debcad04a1d986d75a8773bae4f6003e36"
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
