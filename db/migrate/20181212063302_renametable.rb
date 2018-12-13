class Renametable < ActiveRecord::Migration[5.2]
  def change
    rename_table :posts_tags, :post_tags
  end
end
