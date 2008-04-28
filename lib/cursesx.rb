require "curses"

module CursesX
  VERSION = "002"
end

module Curses
  module_function

  alias :standout_orig :standout
  alias :standend_orig :standend

  # Standout within the block.
  def standout
    if block_given?
      standout_orig
      yield
      standend_orig
    else
      standout_orig
    end
  end

  # Standend within the block.
  def standend
    if block_given?
      standend_orig
      yield
      standout_orig
    else
      standend_orig
    end
  end

  alias :echo_orig :echo
  alias :noecho_orig :noecho

  module_function :echo_orig, :noecho_orig

  # Echo within the block.
  def echo
    if block_given?
      echo_orig
      res = yield
      noecho_orig
      return res
    else
      echo_orig
    end
  end

  # Noecho within the block.
  def noecho
    if block_given?
      noecho_orig
      res = yield
      echo_orig
      return res
    else
      noecho_orig
    end
  end

  def define_color(name, fg, bg)
    @@color ||= Hash.new
    val = @@color.values.sort.last || 0
    @@color[name] = val + 1
    fg = color_of(fg) if fg.kind_of?(Symbol)
    bg = color_of(bg) if bg.kind_of?(Symbol)
    init_pair(@@color[name], fg, bg)
  end

  def color(name)
    color_pair(@@color[name])
  end

  # Symbol to color.
  def color_of(name)
    case name
    when :black; COLOR_BLACK
    when :red; COLOR_RED
    when :green; COLOR_GREEN
    when :yellow; COLOR_YELLOW
    when :blue; COLOR_BLUE
    when :magenta; COLOR_MAGENTA
    when :cyan; COLOR_CYAN
    when :white; COLOR_WHITE
    else raise ArgumentError, name
    end
  end

  private :color_of

  class Window
    attr_reader :__children__
    attr_accessor :__parent__
    alias :children :__children__
    alias :parent :__parent__
    alias :parent= :__parent__=

    alias :subwin_orig :subwin
    def subwin(height, width, y, x, mod = nil)
      @__children__ ||= []
      win = subwin_orig(height, width, y, x)
      win.parent = self
      win.extend mod if mod
      @__children__ << win
      return win
    end

    alias :standout_orig :standout
    alias :standend_orig :standend

    # Standout within the block.
    def standout
      if block_given?
        standout_orig
        yield
        standend_orig
      else
        standout_orig
      end
    end

    # Standend within the block.
    def standend
      if block_given?
        standend_orig
        yield
        standout_orig
      else
        standend_orig
      end
    end

    # Echo within the block.
    def echo
      if block_given?
        Curses.echo
        res = yield
        Curses.noecho
        return res
      else
        Curses.echo
      end
    end

    # Noecho within the block.
    def noecho
      if block_given?
        Curses.noecho
        res = yield
        Curses.echo
        return res
      else
        Curses.noecho
      end
    end

    # Draw the window.
    def draw; warning "Not implemented"; end

    def color(name); Curses.color(name); end
  end
end
