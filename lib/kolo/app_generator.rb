# frozen_string_literal: true

module Kolo
  class AppGenerator
    FILE_PARSE_ERROR_MESSAGE = "error when attempting to parse configuration file: file is missing or invalid"
    INVALID_CONFIGURATION_ERROR_MESSAGE = "configuration file is invalid: configuration for '%s' is missing or invalid"

    def initialize(app_name:, config_file:, template_dir:)
      @app_name = app_name
      @config = validate_config(config_file)
      @template_dir = template_dir
    end

    def call
      # TODO: implement app generation
    end

    private
    def create_app_structure
      @config[:dirs].each do |d|
        FileUtils.mkdir_p("#{@app_name}/#{d}")
      end
    end

    def generate_template_files
      @config[:template_files].each do |f|
        template(relative_src: f[:src], relative_dest: f[:dest], params: f[:params])
      end
    end

    def generate_files
      @config[:files].each do |f|
        copy_file(f[:src], f[:dest])
      end
    end

    # TODO
    # def generate_keep_files

    def initialize_git
      FileUtils.cd(@app_name) do
        system("git init")
      end
    end

    def keep_file(relative_dest)
      FileUtils.touch("#{@app_name}/#{relative_dest}/.keep") if Dir.empty?(relative_dest)
    end

    def template(relative_src:, relative_dest:, params: {})
      Template.new(params).render("#{@template_dir}/#{relative_src}", "#{@app_name}/#{relative_dest}")
    end

    def copy_file(relative_src, relative_dest)
      FileUtils.cp("#{@template_dir}/#{relative_src}", "#{@app_name}/#{relative_dest}")
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

    # TODO: hanle template missing error
  end
end