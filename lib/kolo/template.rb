# frozen_string_literal: true

module Kolo

  ##
  # Template class is responsible for template rendering logic
  class Template

    ##
    # Initializes Template class
    #
    # @param [Hash] params
    # Contains a hash of parameters passed to ERB template
    def initialize(params={})
      # dynamically set instant variables to be used by ERB template
      params.each { |k, v| instance_variable_set("@#{k}", v) }
    end

    # +call+ method contains the logic for rendering the ERB template using the parameters passed to the +initialize+ method
    # @param [String] src
    # source of the template file
    # @param [String] dest
    # destination where the template will be rendered
    # See ./spec/lib/kolo/template_spec.rb for documentation of the expected behaviour.
    def call(src, dest)
      content = File.open(src, "rb", &:read)
      template = ERB.new(content, nil, "-").result(binding)
      File.open(dest, "w") { |f| f.write(template) }
    end

  end
end