require "curses"

module CursesX
  VERSION = "001"
end

module Curses
  alias :standout_orig :standout
  alias :standend_orig :standend

  def standout
    if block_given?
      standout_orig
      yield
      standend_orig
    else
      standout_orig
    end
  end

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

  def echo
    if block_given?
      echo_orig
      yield
      noecho_orig
    else
      echo_orig
    end
  end

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
    attr_reader :children

    alias :subwin_orig :subwin
    def subwin(height, width, y, x)
      @children || = []
      @children << subwin_orig(height, width, y, x)
      return @children.last
    end

    alias :standout_orig :standout
    alias :standend_orig :standend

    def standout
      if block_given?
        standout_orig
        yield
        standend_orig
      else
        standout_orig
      end
    end

    def standend
      if block_given?
        standend_orig
        yield
        standout_orig
      else
        standend_orig
      end
    end
  end
end
