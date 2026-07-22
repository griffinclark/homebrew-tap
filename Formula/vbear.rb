# typed: strict
# frozen_string_literal: true

# Installs the vbear coding-agent configuration CLI.
class Vbear < Formula
  desc "Versioned control plane and local client for coding-agent harnesses"
  homepage "https://github.com/griffinclark/homebrew-tap"
  url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-source-0.1.10/vbear_0.1.10_source.tar.gz"
  sha256 "cddb9e92289f97353a4f9e93f46c81d895cb18d0d47cd47e8361462faabf2584"
  license "MIT"

  bottle do
    root_url "https://github.com/griffinclark/homebrew-tap/releases/download/vbear-0.1.10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "7876c5edbe8a1cbc8c6eb17085c33fce502a1b97b0b5fe9dad1dd18159fca6b3"
    sha256 cellar: :any_skip_relocation, sequoia:      "499d1c757e92386724cf8f9622f1b19f3b6496562f3e2839a679b83684ccab52"
    sha256 cellar: :any,                 x86_64_linux: "6215b88f67c99767f8ac4b9a5daebf9ae73a887f70d867d4a80ba4f79efe4407"
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
