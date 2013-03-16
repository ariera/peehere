require 'spec_helper'

describe Rating do
  describe ".average_of" do
    it "should return 0 if not evaluated" do
      ratings = []
      Rating.average_of('overall', ratings).should == 0.0
    end

    describe "ratings should return" do
      it "0.0 if all of them are negative" do
        %w{pay wait crowded}.each do |kind|
          ratings = [Rating.new(kind:kind, value: true)]
          Rating.average_of(kind, ratings).should == 0.0
        end

        %w{paper hidden safe overall}.each do |kind|
          ratings = [Rating.new(kind:kind, value: false)]
          Rating.average_of(kind, ratings).should == 0.0
        end
      end
    end
  end
end
