# This namespace contains some CSS color names.
module Colour::CSS
  # Returns the RGB color for name or +nil+ if the name is not valid.
  def self.[](name)
    Colour::RGB.by_name(name) { nil }
  end
end
