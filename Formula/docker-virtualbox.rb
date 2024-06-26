require 'formula'

class DockerVirtualbox < Formula
  url "https://github.com/sergeycherepanov/homebrew-docker-virtualbox.git", :using => :git
  version "0.0.7"
  revision 1

  depends_on 'coreutils'
  depends_on 'curl'
  depends_on 'jq'
  depends_on 'terminal-notifier'
  depends_on 'docker'
  depends_on 'docker-compose'
  depends_on 'docker-credential-helper'
  depends_on 'docker-machine'
  depends_on 'docker-machine-nfs-generic'

  keg_only "this package may conflict with official docker client"

  resource "gobetween" do
    url "https://github.com/yyyar/gobetween/releases/download/0.8.0/gobetween_0.8.0_darwin_amd64.zip"
    sha256 "15efec9cef9dc01c4e195042df62def95f189090e470678d5b6f024afa71e1b0"
  end

  def install
    resource("gobetween").stage do
      bin.install "gobetween"
    end
    (buildpath/"gobetween.toml").write <<~EOS
      [api]
      enabled = true
      bind = "127.0.0.1:8181"
    EOS
    (etc/"docker-virtualbox").mkpath
    etc.install "gobetween.toml" => 'docker-virtualbox/gobetween.toml'

    bin.install "bin/docker"
    bin.install "bin/docker-compose"
    bin.install "bin/docker-machine-init"
    prefix.install "assets/djocker.png"
  end

  service do
    run opt_bin/"docker-machine-init"
    keep_alive true
    working_dir "/tmp"    
  end
  
  def caveats
      s = <<~EOS
        Docker Virtualbox was installed

        Please don't forget to configure your PATH variable
      EOS
      s
    end
end
