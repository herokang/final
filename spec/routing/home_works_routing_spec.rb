describe HomeWorksController do
  describe "routing" do
    it "recognizes and generates #edit" do
      expect(get: "/students/questions").to route_to(controller: "home_works", action: "edit")
    end 
    it "recognizes and generates #generate" do
      expect(get: "/students/generateQuestion").to route_to(controller: "home_works", action: "generate")
    end
    it "recognizes and generates #update" do
      expect(post: "/students/updateQuestions").to route_to(controller: "home_works", action: "update")
    end
    it "recognizes and generates #commit" do
      expect(post: "/students/commitQuestions").to route_to(controller: "home_works", action: "commit")
    end
  end
end	