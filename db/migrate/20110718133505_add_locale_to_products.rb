class AddLocaleToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :locale, :string, :default => 'en'
  end

  def self.down
    remove_column :products, :locale
  end
end
