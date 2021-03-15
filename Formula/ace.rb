class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-7_0_1/ACE-7.0.1.tar.bz2"
  sha256 "e671f96b4b4139c19f034ede7a1f448c7d2f813de04d15981d7a1e3be4054234"
  license "DOC"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/ACE(?:%2B[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "8d5842334724e12e37e34afb93c42a14f1baa9bc49d2643c573b201534e72a30"
    sha256 cellar: :any, catalina: "72e9b7ecba3c88f74b8d0e4f4b1cce66cc80614f56bbd2941fc0a2aab97f6c7e"
    sha256 cellar: :any, mojave:   "2635c73c42b1d550183a9dd7f4e26037287c0d4e75664bbb12f04395003ee8aa"
  end

  def install
    ln_sf "config-macosx.h", "ace/config.h"
    ln_sf "platform_macosx.GNU", "include/makeinclude/platform_macros.GNU"

    # Set up the environment the way ACE expects during build.
    ENV.cxx11
    ENV["ACE_ROOT"] = buildpath
    ENV["DYLD_LIBRARY_PATH"] = "#{buildpath}/lib"

    # Done! We go ahead and build.
    system "make", "-C", "ace", "-f", "GNUmakefile.ACE",
                   "INSTALL_PREFIX=#{prefix}",
                   "LDFLAGS=",
                   "DESTDIR=",
                   "INST_DIR=/ace",
                   "debug=0",
                   "shared_libs=1",
                   "static_libs=0",
                   "install"

    system "make", "-C", "examples"
    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}/examples/Log_Msg/.", testpath
    system "./test_callback"
  end
end
