class AddSliderTextToSlider < ActiveRecord::Migration
  def change
    add_column :sliders, :slider_text, :string
  end
end
