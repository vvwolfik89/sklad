module Registers
  class CarInspection < ApplicationRecord

    store_accessor :elements,  :inspect_lighting, :steering_check, :tire_condition, :body_condition, :checking_brake, :checking_windshield, :checking_termoking, :checking_termotrans, :checking_unitess

    belongs_to :car
    belongs_to :user

    has_paper_trail on: [:update]

    def inspect_lighting=(value)
      super(ActiveRecord::Type::Boolean.new.cast(value))
    end

    def inspect_lighting
      ActiveRecord::Type::Boolean.new.cast(super)
    end

    def steering_check=(value)
      super(ActiveRecord::Type::Boolean.new.cast(value))
    end

    def steering_check
      ActiveRecord::Type::Boolean.new.cast(super)
    end

    def tire_condition=(value)
      super(ActiveRecord::Type::Boolean.new.cast(value))
    end

    def tire_condition
      ActiveRecord::Type::Boolean.new.cast(super)
    end

    def body_condition=(value)
      super(ActiveRecord::Type::Boolean.new.cast(value))
    end

    def body_condition
      ActiveRecord::Type::Boolean.new.cast(super)
    end

    def checking_brake=(value)
      super(ActiveRecord::Type::Boolean.new.cast(value))
    end

    def checking_brake
      ActiveRecord::Type::Boolean.new.cast(super)
    end

    def checking_windshield=(value)
      super(ActiveRecord::Type::Boolean.new.cast(value))
    end

    def checking_windshield
      ActiveRecord::Type::Boolean.new.cast(super)
    end

    def checking_termoking=(value)
      super(ActiveRecord::Type::Boolean.new.cast(value))
    end

    def checking_termoking
      ActiveRecord::Type::Boolean.new.cast(super)
    end

    def checking_termotrans=(value)
      super(ActiveRecord::Type::Boolean.new.cast(value))
    end

    def checking_termotrans
      ActiveRecord::Type::Boolean.new.cast(super)
    end

    def checking_unitess=(value)
      super(ActiveRecord::Type::Boolean.new.cast(value))
    end

    def checking_unitess
      ActiveRecord::Type::Boolean.new.cast(super)
    end


  end
end

#Inspect lighting equipment and electrical outlets

#Steering check

#Tire condition inspection

#Body condition inspection

#Checking the brake system and parking brake

#Checking the performance of the windshield wiper system

#Checking the functionality of TermoKing

#Checking the functionality of Termotrans

#Checking the functionality of the Unitess system