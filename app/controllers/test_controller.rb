class TestController < ApplicationController
  def index

  end

  def search
   return render json: [
     {
       name: "test item one"
     }
   ]
  end
end
