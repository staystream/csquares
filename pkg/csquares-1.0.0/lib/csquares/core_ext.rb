module Enumerable
  
  # http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/6663
  
  def interleave(enum2)
    e1, e2, res = to_a.reverse, enum2.to_a.reverse, []
    res.push e1.pop, e2.pop until e1.empty? or e2.empty?
    res + (e1 + e2) .reverse
  end
end

class Array
  
  # http://blog.jayfields.com/2007/09/ruby-arraychunk.html

  def chunk(number_of_chunks)
    chunks = Array.new(number_of_chunks) { [] }
    count = 0
    self.each do |e|
      chunks[count] << e 
      count = (count < number_of_chunks-1) ? count + 1 : 0
    end
    chunks
  end
  
  def chunk_into(max_size_of_array)
    chunks = [[]]
    self.each do |e|
      chunks << [] unless chunks.last.length < max_size_of_array
      chunks.last << e
    end
    chunks
  end
end
