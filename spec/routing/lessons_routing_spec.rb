describe LessonsController do
  describe "routing" do
    it "recognizes and generates #create" do
      expect(post: "/lessons/create").to route_to(controller: "lessons", action: "create")
    end 
    it "recognizes and generates #index" do
      expect(get: "/students/alllessons").to route_to(controller: "lessons", action: "index")
    end     
  end
end	