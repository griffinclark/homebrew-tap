# typed: strict
# frozen_string_literal: true

# Installs the vbear coding-agent configuration CLI.
class Vbear < Formula
  desc "Versioned control plane and local client for coding-agent harnesses"
  homepage "https://github.com/griffinclark/homebrew-tap"
  url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-source-0.1.5/vbear_0.1.5_source.tar.gz"
  sha256 "3b54d7c3ed191516455065d6fdf1db4d962882bed328e9bcc001fbb5a5829cb0"
  license "MIT"

  bottle do
    root_url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-0.1.5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "2ae20533e85248520a8103e1d96e2e0e3f155bec87920787816defc0ed8c6854"
    sha256 cellar: :any,                 x86_64_linux: "dc4cb6286547d6dec9140d827af03d58d91bceba33f0592929b5870929413ad7"
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
