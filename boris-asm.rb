#!/usr/bin/env ruby

class Boris
  instructions = %w[nop push dup drop swap add print halt]

  instructions.each_with_index do |instruction, i|
    define_method(instruction) do |*args|
      # http://www.ruby-doc.org/core-2.0/Array.html#method-i-pack
      # instruction is a uint8_t
      instruction_bytecode = [i].pack("C")

      # each argument is a uint32_t
      args_bytecode = args.map{|x| [x].pack("L") }

      Kernel.print(*instruction_bytecode, *args_bytecode)
    end
  end

  # Simple label/call implementation until scott documents how it will work.
  def label(name, &block)
    instance_variable_set("@#{name}", block)
  end

  def call(block)
    block.yield
  end



  def generate_bytecode(code)
    # I am sorry beyond words.
    eval code
  end
end

# Run this if used as an executable, but not if used as a library.
if __FILE__ == $0
  if ARGV.length == 0
    puts "Usage: #$0 <file>"
  else
    Boris.new.generate_bytecode(ARGF.read)
  end
end
