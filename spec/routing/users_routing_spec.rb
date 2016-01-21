describe UsersController do
  describe "routing" do
    it "recognizes and generates #create" do
      expect(post: "/index/register").to route_to(controller: "users", action: "create")
    end
    it "recognizes and generates #create" do
      expect(post: "/users/new").to route_to(controller: "users", action: "create")
    end  
  end
end	