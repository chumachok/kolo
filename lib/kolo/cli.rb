# frozen_string_literal: true

module Kolo
  class CLI
    INVALID_APP_NAME_MESSAGE = "app name must contain lowercase letters or underscore character only"
    DEFAULT_TEMPLATE_DIR = File.join(File.dirname(__FILE__), "templates")
    DEFAULT_CONFIG_FILE = File.join(File.dirname(__FILE__), "configurations", "default_config.json")

    def initialize(command:, app_name:, options:, app_generator_class: AppGenerator)
      @command = command
      @app_name = app_name
      @options = options
      @app_generator_class = app_generator_class

      validate_input
    end

    def call
      case @command
      when "new"
        @options[:config_file] ||= DEFAULT_CONFIG_FILE
        @options[:template_dir] ||= DEFAULT_TEMPLATE_DIR

        @app_generator_class.new(app_name: @app_name, config_file: @options[:config_file], template_dir: @options[:template_dir]).call
      else
        raise InvalidCommandError
      end
    end

    private

    def validate_input
      raise InvalidInputError, INVALID_APP_NAME_MESSAGE unless @app_name =~ /^[a-z_]+$/
    end

  end
end