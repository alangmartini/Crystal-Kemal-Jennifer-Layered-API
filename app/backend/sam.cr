require "./config/*" # here load jennifer and all required configurations
require "sam"
require "./migrations/*"
load_dependencies "jennifer"

desc "Run the tests"
task "spec" do
  ENV["APP_ENV"] = "test"
  ENV["KEMAL_ENV"]= "test"
  system "crystal spec"
end

desc "Drop test database and re setup"
task "setup_test" do
  ENV["APP_ENV"] = "test"
  system "crystal sam.cr db:drop"
  system "crystal sam.cr db:setup"
end

Sam.help