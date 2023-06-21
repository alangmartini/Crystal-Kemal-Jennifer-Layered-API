require "kemal"
require "../config/config.cr"
require "./routes/travels.route.cr"

include TravelPlansRoute

get "/" do |env|
  env.response.status_code = 200
end
# Create, migrate and populate the database. This is done here
# instead of inside Dockerfile because it needs
# the mysql service to be created and running.
Process.run("crystal", ["sam.cr", "db:setup"])

Kemal.run
