# typed: strict
# frozen_string_literal: true

# Installs the vbear coding-agent configuration CLI.
class Vbear < Formula
  desc "Versioned control plane and local client for coding-agent harnesses"
  homepage "https://github.com/griffinclark/homebrew-tap"
  url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-source-0.1.9/vbear_0.1.9_source.tar.gz"
  sha256 "14315f9c9c361bf29ef57b15eb6fc0bcfbcf29c13e8760816285720af993f92a"
  license "MIT"

  bottle do
    root_url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-0.1.9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "aa42af35bde6fbaab9ec45492a21da2c6048f9914046af261772ebf82e470f1c"
    sha256 cellar: :any_skip_relocation, sequoia:      "e61fea24583eec4525f60df076449153e964a08ec48cef314d62af07bc1a65eb"
    sha256 cellar: :any,                 x86_64_linux: "7f49c28c994b013a76b258c37848a854e66ab04f78cc75fb88352a599243f458"
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
