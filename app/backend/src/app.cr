require "kemal"
require "../config/config.cr"
require "./routes/travels.route.cr"

include UserRoutes

# Create and populate the database. This is done here
# instead of inside Dockerfile because it needs
# the db to be created and running.
Process.run("crystal", ["sam.cr", "db:create"])
Process.run("crystal", ["sam.cr", "db:migrate"])

Kemal.run
