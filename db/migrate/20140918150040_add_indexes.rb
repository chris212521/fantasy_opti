class AddIndexes < ActiveRecord::Migration
  def change
    add_index :projections, :position
    add_index :projections, [:week, :year]
    add_index :projections, [:position, :week, :year]
  end
end
