class Ballerina < Formula
  desc "A Programming Language for Network Distributed Applications"
  homepage "https://v1-0.ballerina.io"
  url "https://product-dist.ballerina.io/downloads/1.0.5/jballerina-1.0.5.zip"
  sha256 "75254fb25a41fc11e5ee6feef0ed76357e42ed3071656c52dc1501f1b5db8ab4"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    # Remove Windows files
    rm Dir["bin/*.bat"]

    chmod 0755, "bin/ballerina"

    inreplace ["bin/ballerina"] do |s|
      s.gsub! /^BALLERINA_HOME=.*$/, "BALLERINA_HOME=#{libexec}"
      s.gsub! /\r?/, ""
    end

    bin.install "bin/ballerina"
    libexec.install Dir["*"]
    # Add symlinks for the Language Server
    prefix.install_symlink libexec/"bre"
    prefix.install_symlink libexec/"lib"
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    (testpath/"helloWorld.bal").write <<~EOS
      import ballerina/io;
      public function main() {
        io:println("Hello, World!");
      }
    EOS
    output = shell_output("#{bin}/ballerina run helloWorld.bal")
    assert_equal "Hello, World!", output.chomp
  end
end
