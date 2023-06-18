class CreateRelTravelPlansTravelStop < Jennifer::Migration::Base
  def up
    create_table :rel_travel_plans_travel_stops do |t|
      t.integer :id, { :primary => true, :auto_increment => true }
      t.integer :travel_plan_id
      t.integer :travel_stop_id

      # more info at:
      # https://imdrasil.github.io/jennifer.cr/v0.12.0/Jennifer/Migration/TableBuilder/CreateTable.html#foreign_key(to_table:String%7CSymbol,column=nil,primary_key=nil,name=nil,*,on_update:Symbol=DEFAULT_ON_EVENT_ACTION,on_delete:Symbol=DEFAULT_ON_EVENT_ACTION)-instance-method
      t.foreign_key :travel_plans,
                    :travel_plan_id,
                    primary_key: :id,
                    on_delete: :cascade,
                    on_update: :cascade
    end
  end

  def down
    drop_table :rel_travel_plans_travel_stops if table_exists? :rel_travel_plans_travel_stops
  end
end
