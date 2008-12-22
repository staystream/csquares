class Csquare

  attr_reader :lat, :lng, :code, :digits

  def initialize(lat,lng)
    @lat, @lng = lat.to_f,lng.to_f
    digits = pad_and_interleave.insert(0,global_quadrant)
    chunks = chunk_up(digits)
    chunks[1..-1].each {|it| it.insert(0,intermediate_quadrant(it))}
    @code = delimit(chunks)
    @digits = chunks.join.split("").map {|it| it.to_i}
  end

  def sq(i=0.1)
    n = 6 + (3 * Math.log10(i).abs).ceil
    sq = case i
      when 10 then @digits[0..3]
      when 5 then @digits[0..4]
      when 1 then @digits[0..6]
      else @digits[0..n]
    end
    delimit [sq[0..3],*sq[4..-1].chunk_into(3)]
  end

  private

  def global_quadrant
    if lat >= 0
      lng >= 0 ? 1 : 7
    else
		  lng >= 0 ? 3 : 5
    end
  end

  def intermediate_quadrant(q)
    a = (0..4).include?(q.first)
    b = (0..4).include?(q.last)
    if a && b then 1
    elsif a && !b then 2
    elsif !a && b then 3
    else 4 end
  end

  def pad_and_interleave
    a,b = [lat,lng].map {|it| it.to_f.abs.to_s.split(".")}
    [a,b].each_with_index do |it,i| 
      it.first.insert(0,"0") while it.first.size <= i+1
      if i == 1
        it[0] = it.first[0,2],it.first[2,2] if i == 1
      else
        it[0] = it.first.split("")
      end
      it[1] = it.last.split("")
      it.flatten!
    end
    a.interleave(b).join.split("").map {|it| it.to_i}
  end

  def chunk_up(digits)
    chunks = digits.chunk_into(2)
    chunks = [[chunks.first,chunks[1]].flatten,*chunks[2..-1]]
  end

  def delimit(chunks)
    chunks.map {|it| it.join("")}.join(":").sub(/:$/){}
  end
end
