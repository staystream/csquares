class CSquare

  attr_reader :lat, :lng, :code, :digits, :radius, :degrees

  METERS = {0.0001 => 11, 0.0005 => 55, 0.001 => 110, 0.005 => 550, 
            0.01 => 1100, 0.05 => 5500, 0.1 => 11000, 0.5 => 55000,
            1 => 110000, 5 => 550000, 10 => 1100000}

  KM = {1 => 0.01, 5 => 0.05, 10 => 0.1, 50 => 0.5, 100 => 1, 500 => 5, 1000 => 1}
 
  def initialize(lat, lng=nil)
    return decode lat unless lng
    @lat, @lng = lat.to_f,lng.to_f
    digits = pad_and_interleave.insert(0,global_quadrant)
    chunks = chunk_up(digits)
    chunks[1..-1].each {|it| it.insert(0,intermediate_quadrant(it))}
    @code = delimit(chunks)
    @digits = chunks.join.split("").map {|it| it.to_i}
  end

  def sq(i=0.1, int=false)
    n = 6 + (3 * Math.log10(i).abs).ceil
    it = case i
      when 10 then @digits[0..3]
      when 5 then @digits[0..4]
      when 1 then @digits[0..6]
      else @digits[0..n]
    end
    result = delimit [it[0..3],*it[4..-1].chunk_into(3)]
    int ? result.gsub(/:/){}.to_i : result
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
        it[0] = it.first[0,2],it.first[2,2]
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

  def decode(it)
    i = it.to_s.gsub(/\D/){}
    n = case i.size
    when 5, 6
      [500, 5]
    when 7
      [100, 7]
    when 8, 9
      [50, 8]
    when 10
      [10, 10]
    when 11, 12
      [5, 11]
    when 13
      [1, 13]
    else
      [1, 14]
    end
    @radius = n.first
    @degrees = KM[@radius]
    @code = i[0,n.last]
    a = i.split("")
    return false if a.size < 7
    b, c = a[0..3], a[4..-1].chunk_into(3)
    lat = [b[1], c.map {|it| it[1]}]
    lng = [b[2..3], c.map {|it| it[2]}].flatten.compact
    lng.delete_at(0) if lng.first == "0"
    if c.last.size < 3
      case c.last.first
      when '4'
        lat << 5
        lng << 5
      when '3'
        lat << 5
      when '2'
        lng << 5
      end
    end
    @lat, @lng = [lat, lng].map {|it| it.join.insert(2,'.').to_f}
    gq = a.first.to_i
    if @lat >= 0
      @lng *= -1 if gq == 7
    else
      @lng *= -1 if gq == 5
    end
 
  end
end
