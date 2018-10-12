class AddActivityToBrewery < ActiveRecord::Migration[5.2]
  def change
    add_column :breweries, :active, :boolean
    Brewery.all.each{ |b| b.active=true; b.save }
  end
end
