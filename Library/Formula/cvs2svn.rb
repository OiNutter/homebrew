require 'formula'

class PythonWithGdbm < Requirement
  fatal true

  def message; <<-EOS.undent
    The Python being used does not include gdbm support,
    but it is required to build this formula:

      #{which 'python'}

    Homebrew's Python includes gdbm support.
    EOS
  end

  def satisfied?
    quiet_system "python", "-c", "import gdbm"
  end
end

class Cvs2svn < Formula
  homepage 'http://cvs2svn.tigris.org/'
  url 'http://trac.macports.org/export/70472/distfiles/cvs2svn/cvs2svn-2.3.0.tar.gz'
  sha1 '545237805ddb241054ba40b105b9c29b705539b8'

  depends_on PythonWithGdbm.new

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
    system "make man"
    man1.install gzip('cvs2svn.1', 'cvs2git.1', 'cvs2bzr.1')
    prefix.install %w[ BUGS COMMITTERS HACKING
      cvs2bzr-example.options cvs2git-example.options cvs2hg-example.options
      cvs2svn-example.options contrib ]

    doc.install Dir['{doc,www}/*']
  end

  def caveats; <<-EOS.undent
    NOTE: man pages have been installed, but for better documentation see:
      #{HOMEBREW_PREFIX}/share/doc/cvs2svn/cvs2svn.html
    or http://cvs2svn.tigris.org/cvs2svn.html.

    Contrib scripts and example options files are installed in:
      #{opt_prefix}
    EOS
  end
end
