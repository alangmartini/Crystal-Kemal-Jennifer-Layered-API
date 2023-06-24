require "file"

def count_lines_in_directory(dir)
  total_lines = 0
  Dir.glob("#{dir}/**/*") do |file|
    if File.file?(file)
      File.open(file) do |f|
        total_lines += f.each_line.count { true }
      end
    end
  end
  total_lines
end

src_lines = count_lines_in_directory("src")
spec_lines = count_lines_in_directory("spec")

puts "Total lines in src: #{src_lines}"
puts "Total lines in spec: #{spec_lines}"
