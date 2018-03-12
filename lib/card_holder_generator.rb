require "card_holder_generator/version"

class CardHolderGenerator

  attr_accessor :settings

  def initialize(settings = {})
    self.settings = settings
  end

  def to_scad
    <<-SCAD
#{comments}

#{header}

difference() {
  #{main_cube}
  #{main_hole}
  #{gaps}
}
    SCAD
  end

private

  %w(
    external_walls_depth
    floor_depth
    top_margin
    separators_width
    separators_depth
    cards_width
    cards_height
    gap_depths
  ).each do |setting_name|
    define_method(setting_name) do
      settings[setting_name]
    end
  end

  def external_x
    cards_height + external_walls_depth * 2
  end

  def external_y
    gap_depths.inject(&:+) + (gap_depths.size + 1) * separators_depth
  end

  def external_z
    cards_width + floor_depth + top_margin
  end

  def comments
    <<-COMMENTS
// Source: https://github.com/carlosparamio/card_holder_generator
// Settings: #{settings.inspect}
    COMMENTS
  end

  def header
    <<-HEADER
module roundedcube(xdim, ydim, zdim, rdim) {
  hull() {
    translate([rdim, rdim, 0]) cylinder(h = zdim, r = rdim);
    translate([xdim - rdim, rdim, 0]) cylinder(h = zdim, r = rdim);
    translate([rdim, ydim - rdim, 0]) cylinder(h = zdim, r = rdim);
    translate([xdim - rdim, ydim - rdim, 0]) cylinder(h = zdim, r = rdim);
  }
}
    HEADER
  end

  def main_cube
    "cube([#{external_x}, #{external_y}, #{external_z}]);"
  end

  def main_hole
    <<-MAINHOLE
translate([#{external_walls_depth + separators_width}, 0, #{floor_depth}]) mirror([0, 1, 0]) rotate([90, 0, 0]) roundedcube(#{cards_height - separators_width * 2}, #{external_z * 2}, #{external_y + 1}, 10);
    MAINHOLE
  end

  def gaps
    gaps = ""
    gap_subtotal = 0
    gap_depths.each_with_index do |gap_depth, index|
      gaps += "translate([#{external_walls_depth}, #{separators_depth * (index + 1) + gap_subtotal}, #{floor_depth}]) cube([#{cards_height}, #{gap_depth}, #{external_z}]); "
      gaps += "translate([#{external_walls_depth + separators_width}, #{separators_depth * (index + 1) + gap_subtotal}, 0]) cube([#{cards_height - separators_width * 2}, #{gap_depth}, #{external_z}]); "
      gap_subtotal += gap_depth
    end
    gaps
  end

end