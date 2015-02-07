# xmp.rb
=begin
== NAME
((*xmp*)) - example printer

== SYNOPSIS

  require "xmp"

  Kernel::xmp string [, fmt [, sep]]
  xmp string [, fmt [, sep]]

== DESCRIPTION

((*xmp*)) is an example printer, which is helpful to show example
code.  The function (({xmp})) evaluates the first argument
((|string|)) then prints the ((|string|)) result value.  If
(({false})) or (({nil})) is given as second argument ((|fmt|)),
(({xmp})) doesn't print the result.  

The second argument ((|fmt|)) specifies the report format. In format
string ((|fmt|)), special patterns "%l" and "%r" are available.  "%l"s
are replaced by the line and "%r" by the result.  

The third argument ((|sep|)) specifies the report separator for the 
multi-line output.  This string ((|sep|)) is put between the output 
lines unless ((|fmt|)) is false. 

Unless (({false})) is given as the second argument, (({xmp})) can't
treat a statement which consist of more than one line.  

== CONSTANT
 
:XMP_VERSION
  (({XMP_VERSION})) is version string which stand for the last modification
  date (YYYY-MM-DD). 

:XMP_DEFAULT_OPTION
  (({XMP_DEFAULT_OPTION})) is default option.  (({xmp(arg)})) is intepreted
  as (({xmp(arg, *XMP_DEFAULT_OPTION)})).

== SIMPLE EXAMPLE

=== EXAMPLE 1

To show what `(({nil.to_i}))' returns

  xmp "nil.to_i"

That report as follows (In this section, A vertical bar `(('|'))' at
beginnig of a line indicates output):
  | nil.to_i
  |    #=> 0

=== EXAMPLE 2

To show each lines 

  xmp <<-EOS
    a = "The moon Fly"
    b = [a.split, "TO", "Me"]
    b = b.flatten
    b.sort!
    b.join(" ").capitalize
  EOS

The result:
  |  a = "The moon Fly"
  |    #=> "The moon Fly"
  |  b = [a.split, "TO", "Me"]
  |    #=> [["The", "moon", "Fly"], "TO", "Me"]
  |  b = b.flatten
  |    #=> ["The", "moon", "Fly", "TO", "Me"]
  |  b.sort!
  |    #=> ["Fly", "Me", "TO", "The", "moon"]
  |  b.join(" ").capitalize
  |    #=> "Fly me to the moon"

=== EXAMPLE 3

To show how attr works

  xmp <<-EOS, false
    class Foo
      attr :a, true
    end

  EOS

  xmp <<-EOS
    foo = Foo.new
    foo.a
    foo.a = 10
    foo.b
    foo.a
  end

The result:

  |  class Foo
  |    attr :a, true
  |  end
  |
  |  foo = Foo.new
  |    #=> #<Foo:0x80e6690>
  |  foo.a
  |    #=> nil
  |  foo.a = 10
  |    #=> 10
  |  foo.b
  |    #!! undefined method `b' for #<Foo:0x80e1af0>
  |  foo.a
  |    #=> 10

== TIPS

(({xmp})) puts ``(({#=> }))'' to each values.  It is covenient when one 
includes (({xmp}))'s output to an email message by directly cut & paste
because such message can be cut & paste again to execute by a reader. 

Combinating with (({if __FILE__ == $0})) technic, (({xmp})) is useful to
show how to use user's library.  For example, one can put some code at
the end of foo.rb to show usage as follows:

  if __FILE__ == $0
    require "xmp"

    xmp <<-EOS, false
      class Bar
        ...
      end

    EOS

    xmp <<-EOS
      bar = BAR.new
      ...
    EOS
  end

== SEE ALSO

Irb - interactive ruby (written by Keiju Ishitsuka)

== BUG

(({Xmp}))'s report follows the outout of the first argument ((|string|)) to
the standard output or the standard error. 

== HISTORY

 07 Feb 00: format customizing and excepcion reporting (gotoken@notwork.org)
 03 Jan 00: documentation (gotoken@notwork.org)

== URL

See Ruby Application Archive ((<URL:http://www.ruby-lang.org/en/raa.html#xmp>))
for information about the latest version. 

== AUTHOR

Gotoken <gotoken@notwork.org>

=end

module Kernel
  XMP_VERSION = "2000-02-07"
  XMP_DEFAULT_OPTION = ["%l\n    #%r\n", "\n    #   "]

  def xmpsec(*a) puts *a; end

  def xmp(arg, fmt = XMP_DEFAULT_OPTION[0], sep=XMP_DEFAULT_OPTION[1])
    if fmt
      fmt = fmt.to_s
      eval("___sep___ = #{sep.inspect}; ___res___ = []", TOPLEVEL_BINDING)
      eval(arg.gsub(/^(.*)\n?/){
	     %Q|
             begin
	       ___res___ << "=> " + (#{$1}).inspect.gsub(/\n^/, ___sep___);
             rescue
               ___res___ << "!! " + $!;
             end|}, TOPLEVEL_BINDING)
      arg.split(/\n/).each_with_index{|l,i|
	(puts "\n" ; next) if l =~ /^$/
	res = fmt.gsub(/%l/, l)
	res = res.gsub(/%r/, eval("___res___", TOPLEVEL_BINDING)[i])
	res
      }
    else
      print arg; eval(arg, TOPLEVEL_BINDING)
    end
  end
  alias __xmp__ xmp
end

if __FILE__ == $0

  puts "## EXAMPLE 1"
  xmp "nil.to_i"

  puts ""
  puts "## EXAMPLE 2"
  xmp <<-EOS
  a = "The moon Fly"
  b = [a.split, "TO", "Me"]
  b = b.flatten
  b.sort!
  b.join(" ").capitalize
  EOS

  puts ""
  puts "## EXAMPLE 3"
  xmp <<-EOS, false
  class Foo
    attr :a, true
  end

  EOS

  xmp <<-EOS
  foo = Foo.new
  foo.a
  foo.a = 10
  foo.b
  foo.a
  EOS
end
