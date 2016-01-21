describe StudentsController do
  describe "routing" do
     it "recognizes and generates #attend" do
      expect(get: "/students/attend").to route_to(controller: "students", action: "attend")
    end 
  end
end	