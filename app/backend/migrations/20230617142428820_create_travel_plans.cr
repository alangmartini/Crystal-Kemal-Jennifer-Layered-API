class CreateTravelPlans < Jennifer::Migration::Base
  def up
    create_table :travel_plans do |t|
      t.integer :id
      t.integer :travel_stops
    end
  end

  def down
    drop_table :travel_plans if table_exists? :travel_plans
  end
end
