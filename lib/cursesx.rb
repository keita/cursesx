require "curses"

module CursesX
  VERSION = "002"
end

module Curses
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

  # Echo within the block.
  def echo
    if block_given?
      echo_orig
      yield
      noecho_orig
    else
      echo_orig
    end
  end

  # Noecho within the block.
  def noecho
    if block_given?
      noecho_orig
      yield
      echo_orig
    else
      noecho_orig
    end
  end

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
      win.extend mod if mod
      win.parent = self
      @__children__ << win
      return win
    end

    # Standout within the block.
    def standout; ::Curses.standout; end

    # Standend within the block.
    def standend; ::Curses.standend; end

    # Draw the window.
    def draw; warning "Not implemented"; end
  end
end
