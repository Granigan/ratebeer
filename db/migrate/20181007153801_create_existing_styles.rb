class CreateExistingStyles < ActiveRecord::Migration[5.2]
  def change
    Beer.all.map{|b| b['style']}.uniq.each do |s|
       Style.create(:name => s)
    end
  end
end
