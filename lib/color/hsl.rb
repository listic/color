# -*- ruby encoding: utf-8 -*-

# An HSL color object. Internally, the hue (#h), saturation (#s), and
# luminosity/lightness (#l) values are dealt with as fractional values in
# the range 0..1.
class Colour::HSL
  include Colour

  class << self
    # Creates an HSL color object from fractional values 0..1.
    def from_fraction(h = 0.0, s = 0.0, l = 0.0, &block)
      new(h, s, l, 1.0, 1.0, &block)
    end
  end

  # Coerces the other Colour object into HSL.
  def coerce(other)
    other.to_hsl
  end

  # Creates an HSL color object from the standard values of degrees and
  # percentages (e.g., 145 deg, 30%, 50%).
  def initialize(h = 0, s = 0, l = 0, radix1 = 360.0, radix2 = 100.0, &block) # :yields self:
    @h = Colour.normalize(h / radix1)
    @s = Colour.normalize(s / radix2)
    @l = Colour.normalize(l / radix2)
    block.call if block
  end

  # Present the color as an HTML/CSS color string.
  def html
    to_rgb.html
  end

  # Present the color as an RGB HTML/CSS color string (e.g., "rgb(0%, 50%,
  # 100%)"). Note that this will perform a #to_rgb operation using the
  # default conversion formula.
  def css_rgb
    to_rgb.css_rgb
  end

  # Present the color as an RGBA (with alpha) HTML/CSS color string (e.g.,
  # "rgb(0%, 50%, 100%, 1)"). Note that this will perform a #to_rgb
  # operation using the default conversion formula.
  def css_rgba
    to_rgb.css_rgba
  end

  # Present the color as an HSL HTML/CSS color string (e.g., "hsl(180,
  # 25%, 35%)").
  def css_hsl
    "hsl(%3.2f, %3.2f%%, %3.2f%%)" % [ hue, saturation, luminosity ]
  end

  # Present the color as an HSLA (with alpha) HTML/CSS color string (e.g.,
  # "hsla(180, 25%, 35%, 1)").
  def css_hsla
    "hsla(%3.2f, %3.2f%%, %3.2f%%, %3.2f)" % [ hue, saturation, luminosity, 1 ]
  end

  # Converting from HSL to RGB. As with all color conversions, this is
  # approximate at best. The code here is adapted from fvd and van Dam,
  # originally found at [1] (implemented similarly at [2]).
  #
  # This simplifies the calculations with the following assumptions:
  # - Luminance values <= 0 always translate to Colour::RGB::Black.
  # - Luminance values >= 1 always translate to Colour::RGB::White.
  # - Saturation values <= 0 always translate to a shade of gray using
  #   luminance as a percentage of gray.
  #
  # [1] http://bobpowell.net/RGBHSB.aspx
  # [2] http://support.microsoft.com/kb/29240
  def to_rgb(*)
    if Colour.near_zero_or_less?(l)
      Colour::RGB::Black
    elsif Colour.near_one_or_more?(l)
      Colour::RGB::White
    elsif Colour.near_zero?(s)
      Colour::RGB.from_grayscale_fraction(l)
    else
      # Only needed for Ruby 1.8. For Ruby 1.9+, we can do:
      # Colour::RGB.new(*compute_fvd_rgb, 1.0)
      Colour::RGB.new(*(compute_fvd_rgb + [ 1.0 ]))
    end
  end

  # Converts to RGB then YIQ.
  def to_yiq
    to_rgb.to_yiq
  end

  # Converts to RGB then CMYK.
  def to_cmyk
    to_rgb.to_cmyk
  end

  # Returns the luminosity (#l) of the color.
  def brightness
    @l
  end
  def to_greyscale
    Colour::GrayScale.from_fraction(@l)
  end
  alias to_grayscale to_greyscale

  # Returns the hue of the color in degrees.
  def hue
    @h * 360.0
  end
  # Returns the hue of the color in the range 0.0 .. 1.0.
  def h
    @h
  end
  # Sets the hue of the color in degrees. Colour is perceived as a wheel,
  # so values should be set properly even with negative degree values.
  def hue=(hh)
    hh = hh / 360.0

    hh += 1.0 if hh < 0.0
    hh -= 1.0 if hh > 1.0

    @h = Colour.normalize(hh)
  end
  # Sets the hue of the color in the range 0.0 .. 1.0.
  def h=(hh)
    @h = Colour.normalize(hh)
  end
  # Returns the percentage of saturation of the color.
  def saturation
    @s * 100.0
  end
  # Returns the saturation of the color in the range 0.0 .. 1.0.
  def s
    @s
  end
  # Sets the percentage of saturation of the color.
  def saturation=(ss)
    @s = Colour.normalize(ss / 100.0)
  end
  # Sets the saturation of the color in the ragne 0.0 .. 1.0.
  def s=(ss)
    @s = Colour.normalize(ss)
  end

  # Returns the percentage of luminosity of the color.
  def luminosity
    @l * 100.0
  end
  alias lightness luminosity
  # Returns the luminosity of the color in the range 0.0 .. 1.0.
  def l
    @l
  end
  # Sets the percentage of luminosity of the color.
  def luminosity=(ll)
    @l = Colour.normalize(ll / 100.0)
  end
  alias lightness= luminosity= ;
  # Sets the luminosity of the color in the ragne 0.0 .. 1.0.
  def l=(ll)
    @l = Colour.normalize(ll)
  end

  def to_hsl
    self
  end

  def inspect
    "HSL [%.2f deg, %.2f%%, %.2f%%]" % [ hue, saturation, luminosity ]
  end

  # Mix the mask color (which will be converted to an HSL color) with the
  # current color at the stated mix percentage as a decimal value.
  #
  # NOTE:: This differs from Colour::RGB#mix_with.
  def mix_with(colour, mix_percent = 0.5)
    v = to_a.zip(coerce(colour).to_a).map { |(x, y)|
      ((y - x) * mix_percent) + x
    }
    self.class.from_fraction(*v)
  end

  def to_a
    [ h, s, l ]
  end

  private

  # This algorithm calculates based on a mixture of the saturation and
  # luminance, and then takes the RGB values from the hue + 1/3, hue, and
  # hue - 1/3 positions in a circular representation of color divided into
  # four parts (confusing, I know, but it's the way that it works). See
  # #hue_to_rgb for more information.
  def compute_fvd_rgb
    t1, t2 = fvd_mix_sat_lum
    [ h + (1 / 3.0), h, h - (1 / 3.0) ].map { |v|
      hue_to_rgb(rotate_hue(v), t1, t2)
    }
  end

  # Mix saturation and luminance for use in hue_to_rgb. The base value is
  # different depending on whether luminance is <= 50% or > 50%.
  def fvd_mix_sat_lum
    t = if Colour.near_zero_or_less?(l - 0.5)
             l * (1.0 + s.to_f)
           else
             l + s - (l * s.to_f)
           end
    [ 2.0 * l - t, t ]
  end

  # In HSL, hues are referenced as degrees in a color circle. The flow
  # itself is endless; therefore, we can rotate around. The only thing our
  # implementation restricts is that you should not be > 1.0.
  def rotate_hue(h)
    h += 1.0 if Colour.near_zero_or_less?(h)
    h -= 1.0 if Colour.near_one_or_more?(h)
    h
  end

  # We calculate the interaction of the saturation/luminance mix (calculated
  # earlier) based on the position of the hue in the circular color space
  # divided into quadrants. Our hue range is [0, 1), not [0, 360º).
  #
  # - The first quadrant covers the first 60º [0, 60º].
  # - The second quadrant covers the next 120º (60º, 180º].
  # - The third quadrant covers the next 60º (180º, 240º].
  # - The fourth quadrant covers the final 120º (240º, 360º).
  def hue_to_rgb(h, t1, t2)
    if Colour.near_zero_or_less?((6.0 * h) - 1.0)
      t1 + ((t2 - t1) * h * 6.0)
    elsif Colour.near_zero_or_less?((2.0 * h) - 1.0)
      t2
    elsif Colour.near_zero_or_less?((3.0 * h) - 2.0)
      t1 + (t2 - t1) * ((2 / 3.0) - h) * 6.0
    else
      t1
    end
  end
end
