# typed: strict
# frozen_string_literal: true

# Installs the vbear coding-agent configuration CLI.
class Vbear < Formula
  desc "Versioned control plane and local client for coding-agent harnesses"
  homepage "https://github.com/griffinclark/homebrew-tap"
  url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-source-0.1.13/vbear_0.1.13_source.tar.gz"
  sha256 "d1e29b57482d2a13f24c2882941b1d0a5036e932587a5f01f8997edea166dc65"
  license "MIT"

  bottle do
    root_url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-0.1.13"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "25e7a87957f058bd1eaaf0e0636e066abe374d5a21fbcbc6558818f469299b77"
    sha256 cellar: :any_skip_relocation, sequoia:      "69d523ceef74b45c395711fbf891d93441089d1a538e59247a3650fc8fd2992a"
    sha256 cellar: :any,                 x86_64_linux: "2e20cf887a879c0c71077afe6d6f3137aae6e4233c880341eba48af634644535"
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
