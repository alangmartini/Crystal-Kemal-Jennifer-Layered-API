require "spec-kemal"
require "spec"
require "../config/config.cr"
require "../src/app"
require "./mocks/travel.mock.cr"

Process.run("crystal", ["sam.cr", "setup_test"])

Spec.before_each do
  Jennifer::Adapter.default_adapter.begin_transaction
end

Spec.after_each do
  Jennifer::Adapter.default_adapter.rollback_transaction
end


