module Minitest
  class Colors
    # Stolen from https://github.com/tenderlove/purdytest/blob/master/lib/purdytest.rb#L8
    COLORS = {
      :black      => 30,   :on_black   => 40,
      :red        => 31,   :on_red     => 41,
      :green      => 32,   :on_green   => 42,
      :yellow     => 33,   :on_yellow  => 43,
      :blue       => 34,   :on_blue    => 44,
      :magenta    => 35,   :on_magenta => 45,
      :cyan       => 36,   :on_cyan    => 46,
      :white      => 37,   :on_white   => 47
    }

    attr_reader :io

    def initialize(io)
      @io = io
    end

    def colorize(color, o)
      "\e[#{COLORS.fetch(color)}m#{o}\e[0m"
    end

    def print o
      case o
      when "." then
        io.print colorize(:green, o)
      when "E", "F" then
        io.print colorize(:red, o)
      when "S" then
        io.print colorize(:yellow, o)
      else
        io.print o
      end
    end

    def method_missing(message, *args, &block)
      io.public_send(message, *args, &block)
    end
  end

  def self.plugin_colors_init(options)
    io = Colors.new(options[:io])

    self.reporter.reporters.grep(Minitest::Reporter).each do |rep|
      rep.io = io
    end
  end
end
