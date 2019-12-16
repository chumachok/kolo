# frozen_string_literal: true

module Kolo
  class AppGenerator
    APP_EXISTS_ERROR_MESSAGE = "error when generating application: application already exists at '%s'"
    FILE_PARSE_ERROR_MESSAGE = "error when attempting to parse configuration file: file is missing or invalid"
    INVALID_CONFIGURATION_ERROR_MESSAGE = "configuration file is invalid: configuration for '%s' is missing or invalid"
    TEMPLATE_ERROR_MESSAGE = "template error: %s"

    def initialize(app_name:, config_file:, template_dir:, template_class: Template)
      @app_name = app_name
      @config = validate_config(config_file)
      @template_dir = template_dir
      @template_class = template_class
    end

    def call
      raise AppExistsError, APP_EXISTS_ERROR_MESSAGE % File.join(File.dirname(__FILE__), @app_name) if app_exists?

      create_app_structure
      generate_files
      generate_template_files
      generate_keep_files
      initialize_git
    end

    private
    def create_app_structure
      @config[:dirs].each do |d|
        FileUtils.mkdir_p(File.join(@app_name, d))
      end
    end

    def generate_template_files
      @config[:template_files].each do |f|
        relative_src = File.join(@template_dir, f[:src])
        relative_dest = File.join(@app_name, f[:dest])
        template(relative_src, relative_dest, params: f[:params])
      end
    end

    def generate_files
      @config[:files].each do |f|
        relative_src = File.join(@template_dir, f[:src])
        relative_dest = File.join(@app_name, f[:dest])
        copy_file(relative_src, relative_dest)
      end
    end

    def generate_keep_files
      @config[:dirs].each do |d|
        dir = File.join(@app_name, d)
        FileUtils.touch(File.join(dir, ".keep")) if Dir.empty?(dir)
      end
    end

    def initialize_git
      FileUtils.cd(@app_name) do
        system("git init")
      end
    end

    # TODO: template error handling
    def template(relative_src, relative_dest, params: {})
      validate_template_presence(relative_src)
      @template_class.new(params).call(relative_src, relative_dest)
    end

    def copy_file(relative_src, relative_dest)
      validate_template_presence(relative_src)
      FileUtils.cp(relative_src, relative_dest)
    end

    def app_exists?
      File.exist?(@app_name)
    end

    def validate_config(config_file)
      begin
        config = JSON.parse(File.read(config_file), symbolize_names: true)
      rescue StandardError
        raise InvalidConfigurationError, FILE_PARSE_ERROR_MESSAGE
      end

      raise InvalidConfigurationError, INVALID_CONFIGURATION_ERROR_MESSAGE % "template files" unless config[:template_files] &&
        config[:template_files].all? { |h| h[:src] && h[:dest] && h[:params] }

      raise InvalidConfigurationError, INVALID_CONFIGURATION_ERROR_MESSAGE % "files" unless config[:files] &&
        config[:files].all? { |h| h[:src] && h[:dest] }

      raise InvalidConfigurationError, INVALID_CONFIGURATION_ERROR_MESSAGE % "dirs" unless config[:dirs]

      config
    end

    def validate_template_presence(path)
      raise TemplateError, TEMPLATE_ERROR_MESSAGE % "template is missing at #{path}" unless File.exist?(path)
    end
  end

end