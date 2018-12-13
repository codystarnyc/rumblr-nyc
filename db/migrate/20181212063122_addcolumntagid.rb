class Addcolumntagid < ActiveRecord::Migration[5.2]
  def change
    def change
      add_column :tags, :tag_type, :string 
    end
  end
end
