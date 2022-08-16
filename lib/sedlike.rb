def sed(file, pattern, replacement)
  File.open(file, "r") do |f_in|
    buf = f_in.read
    buf.gsub!(pattern, replacement)
    File.open(file, "w") do |f_out|
      f_out.write(buf)
    end
  end
end

sed(*ARGV)