# frozen_string_literal: true

module Kolo
  class Template
    def initialize(params={})
      # dynamically set instant variables to be used by ERB template
      params.each { |k, v| instance_variable_set("@#{k}", v) }
    end

    def render(relative_src, relative_dest)
      content = File.open(relative_src, "rb", &:read)
      template = ERB.new(content, nil, "-").result(binding)
      File.open(relative_dest, "w") { |f| f.write(template) }
    end

  end
end