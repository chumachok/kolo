# frozen_string_literal: true

module Kolo
  class Template

    def render(relative_src, relative_dest)
      content = File.open(relative_src, "rb", &:read)
      ERB.new(content, nil, "-").result(binding)
    end

  end
end