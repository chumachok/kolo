module Kolo
  class InvalidInputError < StandardError; end
  class InvalidCommandError < StandardError; end
  class InvalidConfigurationError < StandardError; end
  class TemplateError < StandardError; end
  class AppExistsError < StandardError; end
end