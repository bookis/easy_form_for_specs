class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :name, :tagline, :theme
      t.text :body
      t.integer :country_id
      t.boolean :published
      t.datetime :published_at

      t.timestamps
    end
  end
end
