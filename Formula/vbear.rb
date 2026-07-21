# typed: strict
# frozen_string_literal: true

# Installs the vbear coding-agent configuration CLI.
class Vbear < Formula
  desc "Versioned control plane and local client for coding-agent harnesses"
  homepage "https://github.com/griffinclark/homebrew-tap"
  url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-source-0.1.0/vbear_0.1.0_source.tar.gz"
  sha256 "5bf35f905385571061cce13a65aa6ae9affee9a7a35cf0c9f800215c6d0b1d63"
  license "MIT"

  bottle do
    root_url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-0.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "4119f2b54ed9cca0bba3c104dca948db1b7d24605aab02cfa8f86a259d349563"
    sha256 cellar: :any,                 x86_64_linux: "e76eb3c9d467b69f08ac889412ccf440e6df1ef8a0a1a398c2ee60811cd120da"
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
