require 'logger'

module Nodripa
  class Logger < ::Logger

    def initialize(log)
      super(log)
      self.datetime_format = '%Y-%m-%d %H:%M:%S'
      self.formatter = proc do |severity, datetime, progname, msg|
        "[#{datetime}] [#{severity}] #{msg}\n"
      end
    end
  end
end