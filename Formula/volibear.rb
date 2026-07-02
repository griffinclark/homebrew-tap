class Volibear < Formula
  desc "Local-first web manager for repo-scoped coding-agent harnesses"
  homepage "https://www.npmjs.com/package/volibear"
  url "https://registry.npmjs.org/volibear/-/volibear-0.1.0.tgz"
  sha256 "c1233c73b9e381384164887a24cf5b70f97898bf4f00edd5bef063edcd8226ad"
  license "MIT"

  depends_on "node"
  depends_on "python@3.14"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/volibear --version")

    system bin/"volibear", "init", "--root", testpath
    assert_path_exists testpath/".harness/schema.sql"
    assert_path_exists testpath/".harness/scripts/file_bug.py"
  end
end
