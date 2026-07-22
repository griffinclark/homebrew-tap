# typed: strict
# frozen_string_literal: true

# Installs the vbear coding-agent configuration CLI.
class Vbear < Formula
  desc "Versioned control plane and local client for coding-agent harnesses"
  homepage "https://github.com/griffinclark/homebrew-tap"
  url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-source-0.1.6/vbear_0.1.6_source.tar.gz"
  sha256 "7ffe5284d788310246d958464082ff34c94323986aefe37bb012089727ec7d21"
  license "MIT"

  bottle do
    root_url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-0.1.6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "b6798c79701269a23b60b52984acbfcce1b562d066256a8c34630ade5a5aac47"
    sha256 cellar: :any_skip_relocation, sequoia:      "401996da183a8578383447e68bfb7b6749adb2a90f41ebb1230c4ee32be6b269"
    sha256 cellar: :any,                 x86_64_linux: "234502b1fe950f5a60f86730b8e4ecdc063a20178e6d57537377161e0bddd217"
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
