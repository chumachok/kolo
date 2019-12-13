module Kolo
  require "fileutils"
  require "json"
  require "erb"

  require_relative "kolo/app_generator"
  require_relative "kolo/version"
  require_relative "kolo/cli"
  require_relative "kolo/template"
  require_relative "kolo/error"
end