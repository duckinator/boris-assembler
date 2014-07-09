#!/usr/bin/env ruby

class Boris
  instructions = %w[nop push dup drop swap add print halt]

  instructions.each_with_index do |instruction, i|
    define_method(instruction) do |*args|
      # http://www.ruby-doc.org/core-2.0/Array.html#method-i-pack
      # Instructions = uint8_t; arguments = uint32_t
      Kernel.print [i].pack("C")
      args.map{|x| Kernel.print [x].pack("L") }
    end
  end

  #def label(name)
  # TODO: how's this gonna work?
  #end

  # Simple label/call implementation until scott documents how it will work.

  def label(name, &block)
    instance_variable_set("@#{name}", block)
  end

  def call(block)
    block.yield
  end



  def initialize(file)
    # I'm so sorry.
    eval open(file).read
  end
end

# Run this if used as an executable, but not if used as a library.
if __FILE__ == $0
  if ARGV.length == 0
    puts "Usage: #$0 <file>"
  else
    Boris.new(ARGV[0])
  end
end
