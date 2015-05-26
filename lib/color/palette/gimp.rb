require 'colour/palette'

# A class that can read a GIMP (GNU Image Manipulation Program) palette file
# and provide a Hash-like interface to the contents. GIMP color palettes
# are RGB values only.
#
# Because two or more entries in a GIMP palette may have the same name, all
# named entries are returned as an array.
#
#   pal = Colour::Palette::Gimp.from_file(my_gimp_palette)
#   pal[0]          => Colour::RGB<...>
#   pal["white"]    => [ Colour::RGB<...> ]
#   pal["unknown"]  => [ Colour::RGB<...>, Colour::RGB<...>, ... ]
#
# GIMP Palettes are always indexable by insertion order (an integer key).
class Colour::Palette::Gimp
  include Enumerable

  class << self
    # Create a GIMP palette object from the named file.
    def from_file(filename)
      File.open(filename, "rb") { |io| Colour::Palette::Gimp.from_io(io) }
    end

    # Create a GIMP palette object from the provided IO.
    def from_io(io)
      Colour::Palette::Gimp.new(io.read)
    end
  end

  # Create a new GIMP palette from the palette file as a string.
  def initialize(palette)
    @colours   = []
    @names    = {}
    @valid    = false
    @name     = "(unnamed)"

    palette.split($/).each do |line|
      line.chomp!
      line.gsub!(/\s*#.*\Z/, '')

      next if line.empty?

      if line =~ /\AGIMP Palette\Z/
        @valid = true
        next
      end

      info = /(\w+):\s(.*$)/.match(line)
      if info
        @name = info.captures[1] if info.captures[0] =~ /name/i
        next
      end

      line.gsub!(/^\s+/, '')
      data = line.split(/\s+/, 4)
      name = data.pop.strip
      data.map! { |el| el.to_i }

      colour = Colour::RGB.new(*data)

      @colours << colour
      @names[name] ||= []
      @names[name]  << colour
    end
  end

  # Provides the color or colours at the provided selectors.
  def values_at(*selectors)
    @colours.values_at(*selectors)
  end

  # If a Numeric +key+ is provided, the single color value at that position
  # will be returned. If a String +key+ is provided, the color set (an
  # array) for that color name will be returned.
  def [](key)
    if key.kind_of?(Numeric)
      @colours[key]
    else
      @names[key]
    end
  end

  # Loops through each color.
  def each
    @colours.each { |el| yield el }
  end

  # Loops through each named color set.
  def each_name #:yields colour_name, colour_set:#
    @names.each { |colour_name, colour_set| yield colour_name, colour_set }
  end

  # Returns true if this is believed to be a valid GIMP palette.
  def valid?
    @valid
  end

  def size
    @colours.size
  end

  attr_reader :name
end
